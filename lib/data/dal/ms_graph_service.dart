// lib/data/graph_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'token_repository.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class MsGraphService {
  final MsTokenRepository _tokenRepository;

  MsGraphService(this._tokenRepository);

  static const String _graphBaseUrl = "https://graph.microsoft.com/v1.0";

  Future<Map<String, String>> _buildHeaders() async {
    final accessToken = await _tokenRepository.getValidAccessToken();
    if (accessToken == null) {
      throw Exception("No valid Microsoft access token available.");
    }
    return {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };
  }

  /// Fetch events between a given start and end DateTime
  Future<List<Event>> fetchEventsInRange(DateTime start, DateTime end) async {
    final headers = await _buildHeaders();

    final startIso = start.toUtc().toIso8601String();
    final endIso = end.toUtc().toIso8601String();

    final url = Uri.parse(
      "$_graphBaseUrl/me/calendarView?startDateTime=$startIso&endDateTime=$endIso&\$orderby=start/dateTime",
    );

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> rawEvents = data['value'] ?? [];
      return rawEvents.map<Event>((e) => _parseGraphEvent(e)).toList();
    } else {
      throw Exception("Failed to fetch events: ${response.body}");
    }
  }

  /// Create a new calendar event
  Future<Map<String, dynamic>> createEvent(
    Map<String, dynamic> eventData,
  ) async {
    final headers = await _buildHeaders();
    final url = Uri.parse("$_graphBaseUrl/me/events");

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(eventData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create event: ${response.body}");
    }
  }

  /// Update an existing event by ID
  Future<Map<String, dynamic>> updateEvent(
    String eventId,
    Map<String, dynamic> updatedData,
  ) async {
    final headers = await _buildHeaders();
    final url = Uri.parse("$_graphBaseUrl/me/events/$eventId");

    final response = await http.patch(
      url,
      headers: headers,
      body: jsonEncode(updatedData),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update event: ${response.body}");
    }
  }

  /// Delete an event by ID
  Future<void> deleteEvent(String eventId) async {
    final headers = await _buildHeaders();
    final url = Uri.parse("$_graphBaseUrl/me/events/$eventId");

    final response = await http.delete(url, headers: headers);
    if (response.statusCode != 204) {
      throw Exception("Failed to delete event: ${response.body}");
    }
  }

  /// Parse Microsoft Graph API event JSON into Event object
  Event _parseGraphEvent(Map<String, dynamic> json) {
    final start = DateTime.parse(json['start']['dateTime']).toLocal();
    final end = DateTime.parse(json['end']['dateTime']).toLocal();

    return Event(
      startTime: start,
      endTime: end,
      //isFullDay: json['isAllDay'] ?? false,
      title: json['subject'] ?? "Untitled",
      description: json['bodyPreview'] ?? "",
      //data: json, // keep raw graph event if you need it later
      //eventType: defaultType,
      color: Colors.blue,
      //textColor: Colors.white,
    );
  }
}
