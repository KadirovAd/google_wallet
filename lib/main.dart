import 'package:add_to_google_wallet/widgets/add_to_google_wallet_button.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: AddToGoogleWalletButton(
            pass: _examplePass,
            onSuccess: () => _showSnackBar(context, 'Success!'),
            onCanceled: () => _showSnackBar(context, 'Action canceled.'),
            onError: (Object error) => _showSnackBar(context, error.toString()),
            locale: const Locale.fromSubtags(
              languageCode: 'en',
              countryCode: 'US', // Corrected country code
            ),
          ),
        ),
      );

  void _showSnackBar(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

final String _passId = const Uuid().v4();
const String _passClass = 'coffestore';
const String _issuerId = '3388000000022289137';
const String _issuerEmail =
    'kadirovmuhammadaziz79@gmail.com'; // Consider using a placeholder

final String _examplePass = """
    {
      "iss": "$_issuerEmail",
      "aud": "google",
      "typ": "savetowallet",
      "origins": [],
      "payload": {
        "genericObjects": [
          {
            "id": "$_issuerId.$_passId",
            "classId": "$_issuerId.$_passClass",
            "genericType": "GENERIC_TYPE_UNSPECIFIED",
            "hexBackgroundColor": "#ffffff",
            "logo": {
              "sourceUri": {
                "uri": "https://github.com/KadirovAd/google_wallet/blob/main/assets/logo.png?raw=true"
              }
            },
            "cardTitle": {
              "defaultValue": {
                "language": "en",
                "value": "Coffe store"
              }
            },
            "subheader": {
              "defaultValue": {
                "language": "en",
                "value": "Attdddddendee"
              }
            },
            "header": {
              "defaultValue": {
                "language": "en",
                "value": "Alex dddddd McJacobs"
              }
            },
            "barcode": {
              "type": "QR_CODE",
              "value": "$_passId"
            },
            "heroImage": {
              "sourceUri": {
                "uri": "https://i.pinimg.com/564x/e5/53/49/e553499143a89278217792a4d1147047.jpg"
              }
            },
            "textModulesData": [
              {
                "header": "POINTS",
                "body": "1234",
                "id": "points"
              }
            ]
          }
        ]
      }
    }
""";
// const String _examplePass = """
//     {
//       "iss": "$_issuerEmail",
//       "aud": "google",
//       "typ": "savetowallet",
//       "origins": [],
//       "payload": {
//       "loyaltyObjects": [
//           {
//           "barcode": {
//             "alternateText": "12345",
//             "type": "qrCode",
//             "value": "28343E3"
//           },
//         "id": "123456789_LoyaltyObject",
//           "loyaltyPoints": {
//             "balance": {
//               "string": "500"
//             },
//           "label": "Points"
//         },
//           "accountId": "1234567890",
//           "classId": "123456789.LoyaltyClass",
//           "accountName": "Jane Doe",
//           "state": "active",
//           "version": 1
//           }
//         ]
//       }
//     }
// """;
