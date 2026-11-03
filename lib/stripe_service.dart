import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripePaymentService {
  final String createPayment = 'https://createpaymentintent-5hlqch2ypq-uc.a.run.app';

  Future<Map<String, dynamic>> createPaymentIntent(int amount, String currency) async {
    print("create");
    try {
      final response = await http.post(
        Uri.parse(createPayment),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': "email",
          'name': "name",
          'amount': amount * 100,
          "driverId": "driverId"
        }),
      );
      print("response");
      print(response.body);
      print("create dfdsfs");
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  Future<String> initPaymentSheet(int amount, String currency) async {
    try {
      final paymentIntentData = await createPaymentIntent(amount, currency);
      print("paymentIntentData");
      print(paymentIntentData);
      // Setup Payment Sheet
      final res = await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['clientSecret'],
          merchantDisplayName: 'Lucky Way',
          style: ThemeMode.light,
        ),
      );
      print("res");
      print(res);
      final r = await Stripe.instance.presentPaymentSheet();
      print("r");
      print(r);
      String paymentIntentId = paymentIntentData['paymentIntentId'];
      return paymentIntentId;
    } on StripeException catch (e) {
      print('================ STRIPE ERROR ================');
      print('code: ${e.error.code}');
      print('message: ${e.error.message}');
      print('localizedMessage: ${e.error.localizedMessage}');
      print('==============================================');
      rethrow;
    } catch (e, stackTrace) {
      print('ERROR: $e');
      print(stackTrace);
      rethrow;
    }
  }


}