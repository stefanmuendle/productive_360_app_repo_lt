import 'dart:async';
import 'dart:js' as js;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MicrosoftAuthWeb {
  String? _msAccessToken;

  static const List<String> _scopes = [
    'openid',
    'email',
    'profile',
    'offline_access',
    'User.Read',
    'Calendars.Read',
  ];

  static const String _clientId =
      "5c71970a-e0cd-4cbf-a06c-9481264d8f18"; // Azure App Reg
  static const String _tenantId = "common"; // or your tenantId
  static const String _redirectUri =
      "http://localhost:1234"; // must match Azure

  js.JsObject? _msalInstance;

  Future<void> _initMsal() async {
    final config = js.JsObject.jsify({
      "auth": {
        "clientId": _clientId,
        "authority": "https://login.microsoftonline.com/$_tenantId",
        "redirectUri": _redirectUri,
      },
    });

    final msalConstructor = js.context['msal']['PublicClientApplication'];
    _msalInstance = js.JsObject(msalConstructor, [config]);
  }

  Future<String?> signIn() async {
    if (_msalInstance == null) {
      await _initMsal();
    }

    final completer = Completer<String?>();

    _msalInstance!
        .callMethod("loginPopup", [
          js.JsObject.jsify({"scopes": _scopes}),
        ])
        .callMethod("then", [
          (result) {
            final account = result["account"];
            if (account != null) {
              _msalInstance!.callMethod("setActiveAccount", [account]);
            }
            final token = result["accessToken"];
            completer.complete(token);
          },
        ])
        .callMethod("catch", [
          (error) {
            completer.completeError(error.toString());
          },
        ]);

    try {
      final token = await completer.future;
      _msAccessToken = token;
      debugPrint("✅ Got access token (Web): $token");

      // test Microsoft Graph
      final resp = await http.get(
        Uri.parse("https://graph.microsoft.com/v1.0/me"),
        headers: {"Authorization": "Bearer $token"},
      );
      debugPrint("Graph API response: ${resp.body}");
    } catch (e) {
      debugPrint("❌ Login failed: $e");
    }
    return _msAccessToken;
  }
}
