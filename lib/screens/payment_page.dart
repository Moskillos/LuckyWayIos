import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPaymentPage extends StatefulWidget {
  final int offer;
  const PaypalPaymentPage({super.key, required this.offer, });
  @override
  State<PaypalPaymentPage> createState() => _PaypalPaymentPageState();
}

class _PaypalPaymentPageState extends State<PaypalPaymentPage> {
  late final WebViewController _webViewController;
  bool _loading = true;
  String? orderId;

  final String firebaseCreateOrderUrl = "https://createpaypalorder-5hlqch2ypq-uc.a.run.app";
  final String firebaseCaptureOrderUrl = "https://capturepaypalorder-5hlqch2ypq-uc.a.run.app";

  @override
  void initState() {
    super.initState();
    _initWebView();
    _createPaypalOrder();
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

            if (url.contains("yourapp.com/paypal-success")) {
              _capturePaypalOrder();
              return NavigationDecision.prevent;
            }

            if (url.contains("yourapp.com/paypal-cancel")) {
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageStarted: (_) => setState(() => _loading = true),
          onPageFinished: (_) => setState(() => _loading = false),
        ),
      );
  }

  Future<void> _createPaypalOrder() async {
    final response = await http.post(
        Uri.parse(firebaseCreateOrderUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "amount": widget.offer,
        }));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List links = data['links'];
      final approveLink = links.firstWhere((link) => link['rel'] == 'approve');
      final approvalUrl = approveLink['href'];

      orderId = data['id'];
      _webViewController.loadRequest(Uri.parse(approvalUrl));
    } else {
      print("Errore ordine PayPal: ${response.body}");
    }
  }

  Future<void> _capturePaypalOrder() async {
    final response = await http.post(
      Uri.parse(firebaseCaptureOrderUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'orderID': orderId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Pagamento riuscito: $data");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pagamento completato con successo!")),
        );
        Navigator.pop(context);
      }
    } else {
      print("Errore cattura pagamento: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pagamento con PayPal")),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_loading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
