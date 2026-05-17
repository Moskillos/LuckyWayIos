import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lucky_way_ios/components/tracks/addresses_selection.dart';
import 'package:lucky_way_ios/components/tracks/date_selection.dart';
import 'package:lucky_way_ios/components/tracks/hours_selection.dart';
import 'package:lucky_way_ios/components/tracks/load_selection.dart';
import 'package:lucky_way_ios/components/tracks/track_deviation.dart';
import 'package:lucky_way_ios/components/tracks/track_summary.dart';
import 'package:lucky_way_ios/components/tracks/truck_selection.dart';
import 'package:lucky_way_ios/costants/loading_equipments.dart';
import 'package:lucky_way_ios/costants/text_style.dart';
import 'package:lucky_way_ios/layout/lucky_way_layout.dart';
import 'package:lucky_way_ios/layout/page_view_builder_layout.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/screens/success_page.dart';
import 'package:lucky_way_ios/screens/success_screen.dart';
import 'package:lucky_way_ios/utils/date_format.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../components/home/main_screen.dart';
import '../../models/merchandise_model.dart';
import '../../models/truck_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';

import '../../ui/buttons/luckyway_btn.dart';
import '../../upload_image.dart';
import '../../utils/get_city_coordinates.dart';

class NewTrackScreen extends StatefulWidget {
  ExpeditionModel? expedition;
  int? offer;
  NewTrackScreen({super.key, this.expedition, this.offer});

  @override
  State<NewTrackScreen> createState() => _NewTrackScreenState();
}

class _NewTrackScreenState extends State<NewTrackScreen> with WidgetsBindingObserver{
  PageController _pageController = PageController();
  String? selectedCity;
  String? selectedStreet;
  String? selectedNumber;
  String? selectedPostalCode;
  String? selectedProvince;
  String senderPhone = '';
  String senderEmail = '';

  // indirizzo di destinazione
  String? selectedDestinationCity;
  String? selectedDestinationStreet;
  String? selectedDestinationNumber;
  String? selectedDestinationPostalCode;
  String? selectedDestinationProvince;
  int step = 0;
  TruckModel? truckSelected;
  String _selectedArriveDate = '';
  String _selectedDepartureDate = '';
  String? departureTime;
  String? arriveTime;
  String? truckId;
  final _formSignInKey = GlobalKey<FormState>();
  String? origin;
  String? destination;
  String? distance;
  String? duration;
  String? imagePath;
  List<LatLng>? coordinates;
  String _apiKey = "AIzaSyDVkK7x-ABKGCaMEVWyzuhbAe_jklIJo-U";
  GoogleMapController? mapController;
  final GlobalKey mapKey = GlobalKey();
  Set<Polyline> _polylines = {};
  String choose = 'Si';
  String equip = '';
  String deviation = 'Si';
  String km = "0";
  TextEditingController equipController = TextEditingController();
  TextEditingController kmController = TextEditingController();
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  String truckChoosen = '';
  int placeNumber = 0;
  int availableLength = 0;
  int availableWeight = 0;
  String merchant = "Footboard";

  MerchandiseModel? merchandSelected;

  bool loader = false;
  AnimationController? localAnimationController;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ora possiamo accedere a context in sicurezza
    setState(() {
      equip = loadingEquipments(context)[0];
    });
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;

    if (newValue != isKeyboardVisible) {
      setState(() {
        isKeyboardVisible = newValue;
      });
      print('Keyboard is ${isKeyboardVisible ? "open" : "closed"}');
    }
  }


  void changePage() {
    TruckDriverModel driver =
    Provider.of<AppState>(context, listen: false).user as TruckDriverModel;
    if (step == 0) {
      if(selectedCity == null){
        return;
      }
      if(selectedStreet == null){
        return;
      }
      if(selectedNumber == null){
        return;
      }
      if(selectedProvince == null){
        return;
      }
      if(selectedDestinationCity == null){
        return;
      }
      if(selectedDestinationNumber == null){
        return;
      }
      if(selectedDestinationStreet == null){
        return;
      }
      if(selectedDestinationProvince == null){
        return;
      } else {
        _getPolyline();
      }

    }
    if(step == 1){
      if(_selectedDepartureDate.isEmpty){
        return;
      }
      if(_selectedArriveDate.isEmpty){
        return;
      }
    }
    if(step == 2){
      if(arriveTime == null){
        return;
      }
      if(departureTime == null){
        return;
      }
    }
    if (step == 3) {
      if (truckId == null) {
        return;
      }
      if (truckSelected == null) {
        return;
      }
    }
    if(step == 6){
      var uuid = Uuid();
      String trackId = 'T${uuid.v4().substring(0, 8)}';
      OwnerExModel truckDriver = OwnerExModel(
          driver.id, '${driver.name} ${driver.lastName}', driver.email, driver.phone, driver.token, driver.userView, driver.profileImage, vatNumber: driver.vatNumber, evaluations: driver.evaluations
      );
      TrackModel trackModel = TrackModel(
          trackId,
          dateFormat(DateTime.now()),
          _selectedDepartureDate,
          departureTime!,
          duration!,
          distance!,
          selectedCity!,
          selectedDestinationCity!,
          coordinates!,
          imagePath!,
          truckSelected!,
          truckDriver,
          [],
          1,
          availableWeight,
          availableLength,
          TrackStates.CREATED,
          'auto',
          []
      );
      Provider.of<AppState>(context, listen: false).addTrack(trackModel, context);
    }
    setState(() {
      step = step + 1;
    });
    _pageController.jumpToPage(step);
  }

  void setCity(String value) {
    setState(() {
      selectedCity = value;
    });
  }

  void setStreet(String value) {
    setState(() {
      selectedStreet = value;
    });
  }

  void setCivicNumber(String value) {
    setState(() {
      selectedNumber = value;
    });
  }

  void setPostalCode(String value) {
    setState(() {
      selectedPostalCode = value;
    });
  }

  void setProvince(String value) {
    setState(() {
      selectedProvince = value;
    });
  }

  void setDestinationCity(String value) {
    setState(() {
      selectedDestinationCity = value;
    });
  }

  void setDestinationStreet(String value) {
    setState(() {
      selectedDestinationStreet = value;
    });
  }

  void setDestinationCivicNumber(String value) {
    setState(() {
      selectedDestinationNumber = value;
    });
  }

  void setDestinationPostalCode(String value) {
    setState(() {
      selectedDestinationPostalCode = value;
    });
  }

  void setDestinationProvince(String value) {
    setState(() {
      selectedDestinationProvince = value;
    });
  }

  void updateOrigin(String value) {
    setState(() {
      origin = value;
    });
  }

  void updateDestination(String value) {
    setState(() {
      destination = value;
    });
  }

  void setLeavingTime(String value) {
    setState(() {
      departureTime = value;
    });
  }

  void setArriveTime(String value) {
    setState(() {
      arriveTime = value;
    });
  }

  void setLeavingDate(String value) {
    setState(() {
      _selectedDepartureDate = value;
    });
  }

  void setArriveDate(String value) {
    setState(() {
      _selectedArriveDate = value;
    });
  }

  void setHasEquip(String value) {
    if(value == AppLocalizations.of(context).translate("no")){
      setState(() {
        equip = '';
        equipController.text = '';
      });
    }
    setState(() {
      choose = value;
    });
  }

  void setEquip(String value){
    setState(() {
      equip = value;
    });
  }

  void setDeviation(String value) {
    if(value == AppLocalizations.of(context).translate("no")){
      setState(() {
        km = '';
        kmController.text = '';
      });
    }
    setState(() {
      deviation = value;
    });
  }

  void setKm(String value) {
    setState(() {
      km = value;
    });
  }



  String encodePolyline(List<LatLng> points) {
    List<int> result = [];

    void encode(int value) {
      value = (value < 0 ? ~(value << 1) : value << 1);
      while (value >= 0x20) {
        result.add((0x20 | (value & 0x1f)) + 63);
        value >>= 5;
      }
      result.add(value + 63);
    }

    int prevLat = 0;
    int prevLng = 0;

    for (final point in points) {
      final int lat = (point.latitude * 1e5).round();
      final int lng = (point.longitude * 1e5).round();

      encode(lat - prevLat);
      encode(lng - prevLng);

      prevLat = lat;
      prevLng = lng;
    }

    return String.fromCharCodes(result);
  }

  void convertPolylinesToEncodedPath(Set<Polyline> polylines) {
    for (Polyline polyline in polylines) {
      final encodedPath = encodePolyline(polyline.points);
      print('Encoded Path: $encodedPath');
    }
  }

  String generateStaticMapUrl(String encodedPolyline) {
    return 'https://maps.googleapis.com/maps/api/staticmap'
        '?size=600x400'
        '&path=color:blue|weight:3|enc:$encodedPolyline'
        '&key=$_apiKey';
  }

  Future<void> downloadStaticMap(String url, String filePath) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
    } else {
      print('Errore nel download della mappa: ${response.statusCode}');
    }
  }

  Future<void> saveMapWithPolylines(Set<Polyline> polylines) async {
    try {
      if (polylines.isNotEmpty) {
        final Polyline polyline = polylines.first;
        final encodedPath = encodePolyline(polyline.points);

        final url = generateStaticMapUrl(encodedPath);

        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/static_map_with_polylines.png';

        await downloadStaticMap(url, path);

        String? updatedImage = await uploadImageToFirebase(path);

        if(updatedImage != null){
          setState(() {
            imagePath = updatedImage;
          });
        }

      } else {
        print('Nessuna polyline disponibile per generare la mappa.');
      }
    } catch (e) {
      print('Errore: $e');
    }
  }

  void setController(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<void> _getPolyline() async {
    final originResponse = await getAddressCoordinates(
        '${selectedStreet} ${selectedNumber}, ${selectedCity}');
    final destinationResponse = await getAddressCoordinates(
        '${selectedDestinationStreet} ${selectedDestinationNumber}, ${selectedDestinationCity}');
    LatLng origin = LatLng(originResponse!['lat']!, originResponse!['lng']!);
    LatLng destination =
        LatLng(destinationResponse!['lat']!, destinationResponse!['lng']!);
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json"
        "?origin=${origin.latitude},${origin.longitude}"
        "&destination=${destination.latitude},${destination.longitude}"
        "&key=$_apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Estrarre i dettagli utili
      final route = data["routes"][0]["overview_polyline"]["points"];

      int seconds = data["routes"][0]["legs"][0]["duration"]["value"];
      int hours = seconds ~/ 3600;
      int minutes = (seconds % 3600) ~/ 60;
      setState(() {
        distance =
            "${data["routes"][0]["legs"][0]["distance"]["value"].toString().substring(0, 3)} km";
      });
      setState(() {
        duration = "$hours ore e $minutes minuti";
      });

      _addPolyline(route);
      await saveMapWithPolylines(_polylines);
    } else {
      throw Exception("Errore nel caricamento del percorso");
    }
  }

  void _addPolyline(String encodedPolyline) {
    final List<PointLatLng> points = _decodePolyline(encodedPolyline);
    final List<LatLng> polylineCoordinates =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();
    setState(() {
      coordinates = polylineCoordinates;
      _polylines.add(Polyline(
        polylineId: PolylineId("route"),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ));
    });
    // _fitPolylineBounds();
  }

  List<PointLatLng> _decodePolyline(String polyline) {
    List<PointLatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(PointLatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void onTruckSelected(String id) {
    if(truckId != null && truckId == id){
      setState(() {
        truckId = null;
      });
    } else {
      setState(() {
        truckId = id;
      });
    }

  }

  void setTruckSelected(TruckModel t) {
    if(truckSelected != null && t.id == truckSelected!.id){
      setState(() {
        truckSelected = null;
      });
    } else {
      setState(() {
        truckSelected = t;
      });
    }

  }

  void onMerchandSelected(MerchandiseModel merchand) {
    setState(() {
      merchandSelected = merchand;
    });
  }

  double lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    equipController.dispose();
    _pageController.dispose();
    kmController.dispose();
  }

  @override
  Widget build(BuildContext context) {


    List<Widget> pages = [
      AddressesSelection(
          setCity: setCity,
          setProvince: setProvince,
          setStreet: setStreet,
          setCivicNumber: setCivicNumber,
          setPostalCode: setPostalCode,
          setDestinationCity: setDestinationCity,
          setDestinationProvince: setDestinationProvince,
          setDestinationStreet: setDestinationStreet,
          setDestinationCivicNumber: setDestinationCivicNumber,
          setDestinationPostalCode: setDestinationPostalCode),
      DateSelection(
        leavingDate: _selectedDepartureDate,
        arriveDate: _selectedArriveDate,
        setArriveDate: setArriveDate,
        setLeavingDate: setLeavingDate,
      ),
      HoursSelection(
          setLeavingTime: setLeavingTime,
          setArriveTime: setArriveTime,
          arriveTime: arriveTime,
          leavingTime: departureTime),
      TruckSelection(
          setTruckId: onTruckSelected,
          truck: truckId,
          setTruckSelected: setTruckSelected,
          truckSelected: truckSelected,
          changePage: changePage
      ),
      LoadSelection(
        value: choose,
        changeValue: setHasEquip,
        setEquip: setEquip,
        equipController: equipController
      ),
      TrackDeviation(value: deviation, changeValue: setDeviation, setKm: setKm, kmController: kmController),
      TrackSummary(
          selectedCity: selectedCity ?? '',
          selectedStreet: selectedStreet ?? '',
          selectedNumber: selectedNumber ?? '',
          selectedPostalCode: selectedPostalCode ?? '',
          selectedProvince: selectedProvince ?? '',
          // indirizzo di destinazione
          selectedDestinationCity: selectedDestinationCity ?? '',
          selectedDestinationStreet: selectedDestinationStreet ?? '',
          selectedDestinationNumber: selectedDestinationNumber ?? '',
          selectedDestinationPostalCode: selectedDestinationPostalCode ?? '',
          selectedDestinationProvince: selectedDestinationProvince ?? '',
          changePage: changePage,
          truckSelected: truckSelected,
          departureTime: departureTime,
          arriveTime: arriveTime,
          image: imagePath),
      SuccessScreen(title: AppLocalizations.of(context).translate("trackPublished"), description: AppLocalizations.of(context).translate("prepareToAVoyage"),)
    ];
    print("isKeyboardVisible");
    print(isKeyboardVisible);
    print("step");
    print(step);

    return LuckyWayLayout(
      hideTitle: step == 7 ? true : null,
        title: AppLocalizations.of(context).translate("newTrack"),
        button: (step == 3 || step == 6) ? SizedBox() : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
            ),
            LuckywayBtn(
                text: AppLocalizations.of(context).translate("goOn"),
                backgroundColor: Colors.black,
                textStyle: whiteText14w700,
                onPressed: () {
                  if(step == 0){
                    if(selectedCity == null || selectedCity!.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate("insertCity"))));
                      return;
                    }
                    if(selectedStreet == null || selectedStreet!.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate("insertStreet"))));
                      return;
                    }
                    if(selectedPostalCode == null || selectedPostalCode!.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate("insertPostalCode"))));
                      return;
                    }
                    if(selectedNumber == null || selectedNumber!.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate("insertNumber"))));
                      return;
                    }
                    if(selectedProvince == null || selectedProvince!.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate("insertProvince"))));
                      return;
                    }
                    if(selectedDestinationCity == null || selectedDestinationCity!.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate("insertDestinationCity"))));
                      return;
                    }
                    if(selectedDestinationStreet == null || selectedDestinationStreet!.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate("insertDestinationStreet"))));
                      return;
                    }
                    if(selectedDestinationPostalCode == null || selectedDestinationPostalCode!.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate("insertDestinationPostalCode"))));
                      return;
                    }
                    if(selectedDestinationNumber == null || selectedDestinationNumber!.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate("insertDestinationNumber"))));
                      return;
                    }
                    if(selectedDestinationProvince == null || selectedDestinationProvince!.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate("insertDestinationProvince"))));
                      return;
                    }
                  }
                  if(step == 7){
                    Navigator.popUntil(context, (route) => route.isFirst);
                  } else {
                    changePage();
                  }

                }),
          ],
        ),
        content: PageViewBuilderLayout(
            pageController: _pageController, pages: pages),
        showHeader: true,
        isNavigate: true);
  }
}