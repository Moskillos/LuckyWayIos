import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lucky_way_ios/layout/lucky_way_layout.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/ui/cards/expedition_card_notification.dart';

import '../app_localizations.dart';
import '../database.dart';
import '../models/expedition_model.dart';

class NotificationScreen extends StatefulWidget {
  final String data;

  const NotificationScreen({
    super.key,
    required this.data,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ExpeditionModel? expedition;
  TrackModel? track;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadExpedition();
  }

  Future<void> _loadExpedition() async {
    try {
      if (widget.data.isEmpty) {
        setState(() {
          error = "ID spedizione non valido";
          isLoading = false;
        });
        return;
      }

      print("Caricamento spedizione: ${widget.data}");

      final Map<String, dynamic> data = jsonDecode(widget.data);

      String? expeditionId = data['expeditionId'];
      String? trackId = data['trackId'];

      final ExpeditionModel expe =
      await FirebaseDatabase().getExpedition(expeditionId!, null);
      final TrackModel t =
      await FirebaseDatabase().getTrack(trackId!);
      print("expe");
      print(expe);
      if (!mounted) return;

      setState(() {
        expedition = expe;
        track = t;
        isLoading = false;
      });
    } catch (e) {
      print("Errore caricamento spedizione: $e");

      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("erewerw 3");
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 50,
              ),
              const SizedBox(height: 15),
              Text(
                "Errore nel caricamento della spedizione",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    error = null;
                  });

                  _loadExpedition();
                },
                child: const Text("Riprova"),
              ),
            ],
          ),
        ),
      );
    }

    if (expedition == null) {
      return const Scaffold(
        body: Center(
          child: Text("Spedizione non trovata"),
        ),
      );
    }

    return LuckyWayLayout(title: AppLocalizations.of(context).translate("expeditionRequestTitle"), button: SizedBox(), content: ExpeditionCardNotification(
      expedition: expedition!,
      selectedExpedition: expedition,isDriver: true, track: track!,
    ), showHeader: false, isNavigate: false,

    );
  }
}