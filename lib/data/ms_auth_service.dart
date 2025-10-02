import 'package:flutter/foundation.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:productive_360_app/data/dal/token_repository.dart';
import 'package:productive_360_app/data/navigation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ms_auth_stub.dart' if (dart.library.js) 'ms_auth_web.dart';

class MicrosoftAuthService {
  String? _msAccessToken;
  String? getMicrosoftAccessToken() => _msAccessToken;

  // Shared scopes for Microsoft Graph
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
  static const List<String> _scopes2 = ["openid", "profile", "User.Read"];

  /// Web sign-in using Firebase OAuth provider
  Future<String?> signInWeb() async {
    _msAccessToken = await MicrosoftAuthWeb().signIn();
    return _msAccessToken;
  }

  /// Mobile sign-in using AadOAuth
  Future<String?> signInMobile() async {
    final config = Config(
      tenant: "common",
      clientId: _clientId,
      scope: _scopes.join(" "),
      redirectUri:
          "msauth://com.example.productive_360_app/TOReg%2F1CSxuQPZDyBLlSyVVYFQw%3D",
      navigatorKey: navigatorKey,
    );

    final oauth = AadOAuth(config);
    final result = await oauth.login();

    return await result.fold(
      (failure) {
        print("❌ Mobile login failed: $failure");
        return null;
      },
      (token) async {
        _msAccessToken = token.accessToken;

        final refreshToken = token.refreshToken;

        final expiry = DateTime.now().add(
          Duration(seconds: token.expiresIn ?? 3600),
        );
        final msTokenRepository = MsTokenRepository();
        await msTokenRepository.saveTokens(
          accessToken: token.accessToken,
          refreshToken: token.refreshToken ?? "",
          expiry: expiry,
        );
        print("✅ Stored Microsoft tokens");
        print("🔄 Refresh token: ${token.refreshToken}");
        print("⏳ Token expiry: $expiry");

        return _msAccessToken;
        //"refreshToken": refreshToken,
      },
    );
  }

  /// Unified method for web and mobile
  Future<String?> signInWithMicrosoft() async {
    if (kIsWeb) {
      return await signInWeb();
    } else {
      return await signInMobile();
    }
  }
}
