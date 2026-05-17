import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();

    // Forza l'orientamento orizzontale
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  Future<void> _saveSignature() async {
    if (_controller.isNotEmpty) {
      final signatureImage = await _controller.toPngBytes();
      if (signatureImage != null) {
        // Qui puoi salvare l'immagine in locale o usarla per un PDF
        // Esempio: salvala come file temporaneo
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/firma.png';
        final file = File(imagePath);
        await file.writeAsBytes(signatureImage);
        print('Firma salvata in $imagePath');

        // Oppure torna alla schermata precedente con il path
        Navigator.pop(context, file);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firma')),
      body: Column(
        children: [
          Signature(
            controller: _controller,
            height: 300,
            backgroundColor: Colors.grey[200]!,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _controller.clear(),
                child: const Text('Cancella'),
              ),
              ElevatedButton(
                onPressed: _saveSignature,
                child: const Text('Salva'),
              ),
            ],
          )
        ],
      ),
    );
  }
}