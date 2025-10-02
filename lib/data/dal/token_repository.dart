import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productive_360_app/data/navigation.dart';

class MsTokenRepository {
  final AadOAuth _oauth;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _ms_key_access_token = "ms_access_token";
  static const _ms_key_refresh_token = "ms_refresh_token";
  static const _ms_key_expiry = "ms_token_expiry";

  MsTokenRepository()
    : _oauth = AadOAuth(
        Config(
          tenant: "common",
          clientId: "5c71970a-e0cd-4cbf-a06c-9481264d8f18",
          scope: "openid email profile offline_access User.Read Calendars.Read",
          redirectUri:
              "msauth://com.example.productive_360_app/TOReg%2F1CSxuQPZDyBLlSyVVYFQw%3D",
          navigatorKey: navigatorKey,
        ),
      );

  Future<void> saveTokens({
    required String? accessToken,
    required String refreshToken,
    required DateTime expiry,
  }) async {
    await _storage.write(key: _ms_key_access_token, value: accessToken);
    await _storage.write(key: _ms_key_refresh_token, value: refreshToken);
    await _storage.write(key: _ms_key_expiry, value: expiry.toIso8601String());
  }

  Future<Map<String, String?>> loadTokens() async {
    final accessToken = await _storage.read(key: _ms_key_access_token);
    final refreshToken = await _storage.read(key: _ms_key_refresh_token);
    final expiry = await _storage.read(key: _ms_key_expiry);

    return {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "expiry": expiry,
    };
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _ms_key_access_token);
    await _storage.delete(key: _ms_key_refresh_token);
    await _storage.delete(key: _ms_key_expiry);
  }

  Future<String?> getValidAccessToken() async {
    final tokens = await loadTokens();
    final accessToken = tokens["accessToken"];
    final refreshToken = tokens["refreshToken"];
    final expiryStr = tokens["expiry"];

    if (accessToken == null || refreshToken == null || expiryStr == null) {
      return null; // no tokens stored
    }

    final expiry = DateTime.tryParse(expiryStr);
    if (expiry == null || DateTime.now().isAfter(expiry)) {
      // expired -> refresh
      final refreshed = await _oauth.refreshToken();
      return refreshed.fold(
        (failure) {
          print("❌ Token refresh failed: $failure");
          return null;
        },
        (token) async {
          final newExpiry = DateTime.now().add(
            Duration(seconds: token.expiresIn ?? 3600),
          );
          await saveTokens(
            accessToken: token.accessToken,
            refreshToken: token.refreshToken ?? refreshToken,
            expiry: newExpiry,
          );
          return token.accessToken;
        },
      );
    } else {
      // still valid
      return accessToken;
    }
  }
}
