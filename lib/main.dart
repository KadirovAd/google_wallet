import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoyaltyProgramScreen(),
    );
  }
}

class LoyaltyProgramScreen extends StatefulWidget {
  const LoyaltyProgramScreen({super.key});

  @override
  State<LoyaltyProgramScreen> createState() => _LoyaltyProgramScreenState();
}

class _LoyaltyProgramScreenState extends State<LoyaltyProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _cardId = '';

  Future<void> _registerLoyaltyCard() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final response = await http.post(
        Uri.parse('YOUR_BACKEND_ENDPOINT/createLoyaltyCard'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'username': _username}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _cardId = responseData['cardId'];
        });
        _addCardToGoogleWallet(_cardId);
      } else {
        // Handle error
        print('Failed to create loyalty card');
      }
    }
  }

  Future<void> _addCardToGoogleWallet(String cardId) async {
    final response = await http.post(
      Uri.parse(
          'https://walletobjects.googleapis.com/walletobjects/v1/loyaltyObject'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
      },
      body: json.encode({
        "id": "loyaltyObjectId",
        "classId": "YOUR_CLASS_ID",
        "state": "active",
        "accountId": cardId,
        "accountName": _username,
        // Add other required fields for the loyalty card
      }),
    );

    if (response.statusCode == 200) {
      // Successfully added to Google Wallet
      print('Card added to Google Wallet');
    } else {
      // Handle error
      print('Failed to add card to Google Wallet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loyalty Program'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerLoyaltyCard,
                child: const Text('Register Loyalty Card'),
              ),
              if (_cardId.isNotEmpty) Text('Card ID: $_cardId'),
            ],
          ),
        ),
      ),
    );
  }
}
