import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

String generatePassword() {
  final Random random = Random();
  const String chars = 'AaBbCcDdEeFfGgHh1234567890';
  return List.generate(8, (index) => chars[random.nextInt(chars.length)])
      .join();
}

Future<void> sendEmail(String email, String password) async {
  final response = await http.post(
    Uri.parse('https://api.sendgrid.com/v3/mail/send'),
    headers: {
      'Authorization': 'Bearer YOUR_SENDGRID_API_KEY',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'personalizations': [
        {
          'to': [
            {'email': email}
          ],
        }
      ],
      'from': {'email': 'no-reply@yourdomain.com'},
      'subject': 'Your Login Credentials',
      'content': [
        {
          'type': 'text/plain',
          'value': 'Your password is $password',
        }
      ],
    }),
  );

  if (response.statusCode != 202) {
    throw Exception('Failed to send email');
  }
}
