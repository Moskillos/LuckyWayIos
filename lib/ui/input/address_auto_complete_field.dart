import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';

class AddressAutocompleteField extends StatefulWidget {
  final String apiKey;
  String? selectedCity;
  String? selectedStreet;
  String? selectedNumber;
  String? selectedPostalCode;
  String? selectedProvince;
  final Function setCity;
  final Function setProvince;
  final Function setStreet;
  final Function setCivicNumber;
  final Function setPostalCode;
  String? label;
  AddressAutocompleteField({super.key, required this.apiKey, required this.setCity, required this.setProvince, required this.setStreet, required this.setCivicNumber, required this.setPostalCode, this.selectedCity, this.selectedStreet, this.selectedNumber, this.selectedPostalCode, this.selectedProvince, this.label});

  @override
  State<AddressAutocompleteField> createState() => _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  final TextEditingController _controller = TextEditingController();
  List<String> missingFields = [];
  bool manualAddress = false;

  Future<List<Prediction>> _getSuggestions(String query) async {
    if (query.length < 3) return [];

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
            '?input=$query'
            '&key=${widget.apiKey}'
            '&language=${AppLocalizations.of(context).translate("lang")}'
            // '&components=country:${AppLocalizations.of(context).translate("lang")}'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return (data['predictions'] as List)
            .map((p) => Prediction.fromJson(p))
            .toList();
      }
    }
    return [];
  }

  Future<PlaceDetails> _getPlaceDetails(String placeId) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
            '?place_id=$placeId'
            '&key=${widget.apiKey}'
            '&language=${AppLocalizations.of(context).translate("lang")}'
            '&fields=address_component'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return PlaceDetails.fromJson(data['result']);
      }
    }
    throw Exception('Failed to load place details');
  }

  String? _extractComponent(List<AddressComponent> components, String type) {
    try {
      return components
          .firstWhere((c) => c.types.contains(type))
          .longName;
    } catch (e) {
      return null;
    }
  }

  void _parseAddressComponents(List<AddressComponent> components) {
    final missing = <String>[];

    if (_extractComponent(components, 'route') == null) {
      missing.add(AppLocalizations.of(context).translate("street"));
    }

    if (_extractComponent(components, 'street_number') == null) {
      missing.add(AppLocalizations.of(context).translate("civicNumber"));
    }

    if (_extractComponent(components, 'locality') == null &&
        _extractComponent(components, 'administrative_area_level_3') == null &&
        _extractComponent(components, 'administrative_area_level_2') == null) {
      missing.add(AppLocalizations.of(context).translate("city"));
    }

    if (_extractComponent(components, 'administrative_area_level_2') == null) {
      missing.add(AppLocalizations.of(context).translate("province"));
    }

    setState(() {
      missingFields = missing;
    });
    widget.setCity(_extractComponent(components, 'locality') ??
        _extractComponent(components, 'administrative_area_level_3') ??
        _extractComponent(components, 'administrative_area_level_2'));

    widget.setStreet(_extractComponent(components, 'route'));
    widget.setCivicNumber(_extractComponent(components, 'street_number'));
    widget.setPostalCode(_extractComponent(components, 'postal_code'));
    widget.setProvince(_extractComponent(components, 'administrative_area_level_2'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (missingFields.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 30.0),
            child: Text(
              '${AppLocalizations.of(context).translate("miss")} ${missingFields.join(', ')}',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        if(widget.label != null)Row(
          children: [
            SizedBox(width: 30,),
            Text(widget.label!, style: blackText14w700,),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: primaryBlue, width: 1),
              borderRadius: BorderRadius.circular(50),
              color: Colors.white
          ),
          width: MediaQuery.of(context).size.width - 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeAheadField<Prediction>(
              controller: _controller,
              debounceDuration: const Duration(milliseconds: 300),
              suggestionsCallback: (pattern) async {
                return await _getSuggestions(pattern);
              },
              itemBuilder: (context, Prediction suggestion) {
                return ListTile(
                    title: Text(
                    suggestion.description,
                    style: const TextStyle(fontSize: 16),
                ));
              },
              loadingBuilder: (context) => const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
              ),
              errorBuilder: (context, error) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Errore: ${error.toString()}'),
              ),
              hideOnEmpty: true,
              hideOnError: false,
              hideOnLoading: false,
              onSelected: (Prediction value) async {
                _controller.text = value.description; // Aggiorna il testo qui

                try {
                  final details = await _getPlaceDetails(value.placeId);
                  if (details.addressComponents != null) {
                    _parseAddressComponents(details.addressComponents!);
                  }
                } catch (e) {
                  return;
                }
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    border: InputBorder.none, // Rimuove la linea
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    hintText: AppLocalizations.of(context).translate("findAddress"),
                  ),
                  style: blueText14w700,
                );
              },
            ),
          ),
        ),
        // const SizedBox(height: 20),
        // if (widget.selectedCity != null || widget.selectedStreet != null || widget.selectedNumber != null)
        //   _buildAddressDetails(),
      ],
    );
  }

  Widget _buildAddressDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.selectedCity != null)
            _buildDetailRow(AppLocalizations.of(context).translate("city"), widget.selectedCity!),
          if (widget.selectedStreet != null)
            _buildDetailRow(AppLocalizations.of(context).translate("street"), widget.selectedStreet!),
          if (widget.selectedNumber != null)
            _buildDetailRow(AppLocalizations.of(context).translate("civicNumber"), widget.selectedNumber!),
          if (widget.selectedPostalCode != null)
            _buildDetailRow(AppLocalizations.of(context).translate("postalCode"), widget.selectedPostalCode!),
          if (widget.selectedProvince != null)
            _buildDetailRow(AppLocalizations.of(context).translate("province"), widget.selectedProvince!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class Prediction {
  final String description;
  final String placeId;

  Prediction({required this.description, required this.placeId});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}

class PlaceDetails {
  final List<AddressComponent>? addressComponents;

  PlaceDetails({this.addressComponents});

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final components = (json['address_components'] as List?)
        ?.map((ac) => AddressComponent.fromJson(ac))
        .toList();

    return PlaceDetails(addressComponents: components);
  }
}

class AddressComponent {
  final String longName;
  final List<String> types;

  AddressComponent({required this.longName, required this.types});

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      longName: json['long_name'],
      types: List<String>.from(json['types']),
    );
  }
}