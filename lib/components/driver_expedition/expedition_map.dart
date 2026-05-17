import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../database.dart';
import '../../models/expedition_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../ui/cards/expedition_card.dart';
import '../../utils/get_city_coordinates.dart';

class ExpeditionMap extends StatefulWidget {
  String? city;
  final Function onPointerDown;
  final Function onPointerUp;
  final Function setExpedition;
  final Function changePage;
  ExpeditionMap({super.key, this.city, required this.onPointerDown, required this.onPointerUp, required this.setExpedition, required this.changePage});

  @override
  State<ExpeditionMap> createState() => _ExpeditionMapState();
}

class _ExpeditionMapState extends State<ExpeditionMap> {
  GoogleMapController? _mapController;
  double _currentZoom = 5.0;
  Set<Marker> _allMarkers = {};
  Set<Marker> _visibleMarkers = {};
  LatLng actualPosition = LatLng(45.4642, 9.1900);
  ExpeditionModel? selectedExpedition;

  @override
  void initState() {
    super.initState();
    getExpeditions();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if(widget.city != null){
      final coords = await getCityCoordinates(widget.city!);
      if (coords == null) return;

      LatLng newPosition = LatLng(coords['lat']!, coords['lng']!);

      setState(() {
        actualPosition = newPosition;
        _currentZoom = 10.0;
      });

      if (_mapController != null) {
        // Aspetta un frame per assicurarti che la mappa sia creata
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: newPosition,
                zoom: 10.0,
              ),
            ),
          );
        });
      }
    }

  }

  void getExpeditions() async {
    List<ExpeditionModel> expeditions =
    await FirebaseDatabase().getExpeditions();
    Provider.of<AppState>(context, listen: false)
        .fetchExpeditions(expeditions);
    _createMarkers(expeditions);
  }

  Future<void> _createMarkers(List<ExpeditionModel> expeditions) async {
    Set<Marker> markers = {};

    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(22, 22)), // Dimensione suggerita
      'assets/BOX.png',
    );

    List<ExpeditionModel> notAcceptedExpedition = expeditions.where((expedition) => expedition.accepted == false).toList();
    for (var ex in notAcceptedExpedition) {
      String fullAddress =
          '${ex.retireAddress.street}, ${ex.retireAddress.civicNumber}, ${ex.retireAddress.city}, Italia';
      final coords = await getAddressCoordinates(fullAddress);

      markers.add(
        Marker(
          markerId: MarkerId(ex.id),
          position: LatLng(coords!['lat']!, coords['lng']!),
          icon: customIcon,
          infoWindow: InfoWindow(
            onTap: () {
              if(selectedExpedition != null){
                setState(() {
                  selectedExpedition = null;
                });
              } else {
                setState(() {
                  selectedExpedition = ex;
                });
              }
            },
            title: ex.id,
            snippet: 'Indirizzo: $fullAddress',
          ),
        ),
      );
    }

    setState(() {
      _allMarkers = markers;
      _updateVisibleMarkers();
    });
  }

  void _updateVisibleMarkers() {
    setState(() {
      _visibleMarkers =
      _currentZoom >= 10 ? _allMarkers : {}; // Mostra solo se zoom >= 10
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        selectedExpedition != null ? ExpeditionCard(
          setExpedition: widget.setExpedition,
          isDriver: true,
          expedition: selectedExpedition!,
          changePage: widget.changePage,
          selectedExpedition: selectedExpedition,
          engage: true,
        ) : SizedBox(
         height:MediaQuery.of(context).size.height / 2,
          child: Listener(
            onPointerDown: (_) {
              widget.onPointerDown();
            },
            onPointerUp: (_) {
              widget.onPointerUp();
            },
            child: AbsorbPointer(
              absorbing: false, // per sicurezza, la mappa deve ricevere i tocchi
              child: GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: actualPosition,
                  zoom: _currentZoom,
                ),
                onCameraMove: (position) {
                  setState(() {
                    _currentZoom = position.zoom;
                  });
                  _updateVisibleMarkers();
                },
                markers: _visibleMarkers,
                gestureRecognizers: <
                    Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer()),
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}