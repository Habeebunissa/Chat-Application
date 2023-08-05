import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import 'package:googleapis_auth/googleapis_auth.dart';

class FCMController {



  static const _SCOPES = [
    //'https://www.googleapis.com/auth/cloud-platform.read-only',
    'https://www.googleapis.com/auth/firebase.messaging',
  ];
  Future<String> getAccessToken() async {
    String accessToken = "";
    ServiceAccountCredentials credentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "flutter-chat-91763",
      "private_key_id": "e14450bc69e142264ef67c7123983c46fa597c6c",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCpvNfpRbhgYPrq\ne6rdMSqzZeX90WSOJj0Au1BQqfdaA0q6rnF3dnSyhAN+iIOFT6w+MdchBg01ZP8W\n/iAzmygamAk6seSZtai39p45Hx6+S7YxGgB3+k3uq/QGeXDts2KcvaxgnmzKhqV9\nqd3O5vmgrqRShNigsI9yLJD+UF/d7gEbEz+0I5B4W7UtKtIy7wHizGY1WmLDAKXt\nEu6HafcTpj95u6bsS/J1xqQB74L6fQixM5r1lN0qrPLasrGjIM3p9enFuZIjYN9a\nyD3k4D77PfNU+uMxqcUGVs6dpBMkNh17IAN9p3r+9UDOsXEJnIHQpkmLuM6mnrtx\nkzFVfCDTAgMBAAECggEAAjz3Zd/hpK0IB06BJsXZXSCOA1D0WqbTbW6K371rVw2t\nub9yHJP8dEbRsE9G2LD/wZmGT4JVFev9LHBGZsJ4KWhG0DYnSwWTsh/3ic5IvqlL\nP44rDRSeXB7QABkwLYTiMH8/G3kLUIes/UwKR4pRJqwW25sH1jqYcaDNJU//APNM\neI1f+sG2QP6YoWiuBjDNIa4nyvdgPHzJGiAe9Rx2AQJmXI8Hj9EBpv27nhwZRUzb\n5+qS7og55Zx0MeXznIzYnbNrx86kcyFq9SjkO8egFEUfzsUtjoQtL+l3yeP82+ks\nPxcie+rmGlpuECPirXwLwFQjQs2654hLTajbHtA2kQKBgQDUI4mmKAoSEJcGg6dg\nOVU6KeJZH503yqQmKnbRGCI/Ry5VYSPrhtLWWwHV4PLBuMBGslbN22HiRXODGohe\nmHr96m5L2ObwagT6lEnG3GUbyGhN65YqoH3kOlZzbiP/yCDT3qPweumRrnfSrYUn\nz390+vVXNOnIJaDmWfnwYE1NsQKBgQDM1QWdp9cIyV/Gm00Bo9d//RAgNKVb/STg\n2q/wPSQimgmahM03hE+lQ5XFCptHPHchQO4HLuOb5nQZlr9HyLKZrHkbUJRYbDpX\n11/75R9LtzF1DqZW/1pHK7CoZdPjAQeQiC2ZJGZRODzsmlmdfwWHK1ZR/gnRDb67\nlHczuZbjwwKBgQCXORYgyh4TrpvaWvNv1q74nW7rVWv/n4bQZij4+RlAvn87AdpX\nRW76uzldu9ORYSA/xVW3vZHTeOrVJI7d0Bis9PbXPrGx5AHUluzYw7eXzI7+LNiJ\nXosfrK5/7p3e8kzke6ul/BiQbyyflG59aJ9VRqiqF+Anextt2eof/qZcoQKBgAGi\ndZADheDJEp2YIa4wq4iW8WkAYo1wYLn2pM7K/h3Ukt0L0ENwJ96OwoQ3CHQyFFVM\nmlmuUxysYyLNJCuje2FkkfbY1sY53uFSk66D7pMBHEDt4//vu72zqI4/echm+rN5\nkruVIcfmJf5RYQOzvsyMWP0AhP2JGYuPrL/Z7E1XAoGAVIxG11htp6lriDGERmEY\nR+2gb78DbpXBtcJT9hI5b/RCxBiXDNkksPEb4ubj06877hX+1Q4IMhNjy6jHCFrf\n5ey2YS4AkelxEElAi3Ly4aIWkTnCveYsNJ95sAn83JL85aL6+cRZ1rb1n7r2yMHU\nlF/fB73P1JxdNgCOHBLucL4=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-l94hk@flutter-chat-91763.iam.gserviceaccount.com",
      "client_id": "100672563258952418984",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-l94hk%40flutter-chat-91763.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });
    final accessCredentials = await obtainAccessCredentialsViaServiceAccount(
      credentials,
      _SCOPES,
      http.Client(),
    );
    accessToken = accessCredentials.accessToken.data;

    return accessToken;
  }

  Future<void> sendNotification(String fcmToken, String title, String body,
      {String? imageUrl}) async {
    await getAccessToken().then((accessToken) async {
      var headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/flutter-chat-91763/messages:send'));
      request.body = json.encode({
        "message": {
          "token": fcmToken,
          "notification": {"title": title, "body": body}
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
      } else {}
    });
  }

  FCMController();
}
