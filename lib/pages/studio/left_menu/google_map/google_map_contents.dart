import 'dart:convert';

import 'package:creta03/design_system/text_field/creta_search_bar.dart';
import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';

class GoogleMapContents extends StatefulWidget {
  const GoogleMapContents({super.key});

  @override
  State<GoogleMapContents> createState() => _GoogleMapContentsState();
}

class _GoogleMapContentsState extends State<GoogleMapContents> {
  List<String> searchResults = [];
  // final String apiKey = 'AIzaSyDSeug7mmQCQ3zSeo9rgkYognnV5B_A86g';
  // final String apiKey = 'AIzaSyA_xU26875gqM-muwZ5H7KYyLhoNgySAW0';
  final String apiKey = 'AIzaSyBiPFiDRpywm06KftPPDu0T7d1eowrHYEE';

  Future<void> _handleSearchResultTap(String selectedResult) async {
    try {
      String addressDetails = await _getAddressDetails(selectedResult);
      print('Selected result: $selectedResult\nAddress details: $addressDetails');
    } catch (error) {
      if (error is http.ClientException) {
        print('HTTP Client Exception!!!!!!!!!!!!!: $error');
      } else {
        print('Error in _handleSearchResultTap: $error');
      }
    }
  }

  Future<String> _getAddressDetails(String query) async {
    final String encodedQuery = Uri.encodeQueryComponent(query);
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=formatted_address,name,rating,opening_hours,geometry&input=$encodedQuery&inputtype=textquery&key=$apiKey';
    http.Client client = http.Client();
    if (client is BrowserClient) {
      client.withCredentials = true;
    }
    final response = await client.get(Uri.parse(apiUrl));

    try {
      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);
        if (jsonResult['status'] == 'OK') {
          final results = jsonResult['candidates'];
          print('search result is $results-------------');
          return results['formatted_address'][0];
        } else if (jsonResult['status'] == 'ZERO_RESULTS') {
          return 'No address details found for $query';
        } else {
          return 'Error: ${jsonResult['status']} - ${jsonResult['error_message']}';
        }
      } else {
        print('Error 1: ${response.statusCode}');
        print('Response: ${response.body}');
        return 'Error fetching address details (HTTP ${response.statusCode})';
      }
    } catch (error) {
      print('API URL: $apiUrl');
      print('Error 2: $error');
      return 'Error fetching address details: $error';
    }
  }

  Future<void> _updateSearchResults(String query) async {
    setState(() {
      searchResults.add(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchBar(),
        SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return FutureBuilder<String>(
                future: _getAddressDetails(searchResults[index]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      // Handle error case
                      return ListTile(
                        title: Text(searchResults[index]),
                        subtitle: Text('Error: ${snapshot.error}'),
                        onTap: () async {
                          _handleSearchResultTap(searchResults[index]);
                        },
                      );
                    } else {
                      // Display the result with address details
                      return ListTile(
                        title: Text(searchResults[index]),
                        subtitle: Text('Address: ${snapshot.data}'),
                        onTap: () async {
                          _handleSearchResultTap(searchResults[index]);
                        },
                      );
                    }
                  } else {
                    // Loading state
                    return ListTile(
                      title: Text(searchResults[index]),
                      subtitle: const CircularProgressIndicator(),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CretaSearchBar(
        width: double.infinity,
        hintText: CretaStudioLang.queryHintText,
        onSearch: (value) async {
          _updateSearchResults(value);
        },
      ),
    );
  }
}
