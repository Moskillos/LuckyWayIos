import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> uploadImageToFirebase(String image) async {
  try {
    File file = File(image);

    if (!file.existsSync()) {
      print("Il file non esiste!");
      return null;
    }

    final Reference storageRef = FirebaseStorage.instance.ref().child("maps/static_map_${DateTime.now().millisecondsSinceEpoch}.png");

    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot snapshot = await uploadTask;

    // Ottieni l'URL pubblico dell'immagine
    return await snapshot.ref.getDownloadURL();
  } catch (e) {
    print("Errore durante l'upload: $e");
    return null;
  }
}

Future<String?> uploadImageProfileToFirebase(XFile image) async {
  try {
    // Ottieni il riferimento a Firebase Storage
    final Reference storageRef = FirebaseStorage.instance.ref().child("profile_images/${image.name}");

    // Carica l'immagine
    UploadTask uploadTask = storageRef.putFile(File(image.path));

    // Aspetta che il caricamento sia completato
    TaskSnapshot snapshot = await uploadTask;

    // Ottieni l'URL del file caricato
    return await snapshot.ref.getDownloadURL();
  } catch (e) {
    print("Errore durante l'upload: $e");
    return null;
  }
}