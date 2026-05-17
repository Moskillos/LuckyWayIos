import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TomTomAutocomplete extends StatefulWidget {
  final String apiKey;
  const TomTomAutocomplete({required this.apiKey, super.key});

  @override
  State<TomTomAutocomplete> createState() => _TomTomAutocompleteState();
}

class _TomTomAutocompleteState extends State<TomTomAutocomplete> {
  final TextEditingController _controller = TextEditingController();

  Future<List<String>> _getSuggestions(String query) async {
    final url = Uri.parse(
        'https://api.tomtom.com/search/2/search/$query.json?'
            'key=${widget.apiKey}&countrySet=IT&language=it-IT&limit=5');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map<String>((result) => result['address']['freeformAddress']).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      suggestionsCallback: (pattern) async {
        return await _getSuggestions(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSelected: (suggestion) {
        _controller.text = suggestion;
      },
    );
  }
}
