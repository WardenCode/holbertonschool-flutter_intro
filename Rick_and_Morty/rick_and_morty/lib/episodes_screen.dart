import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> fetchEpisodeNameWithCharacterId(url) async {
  final response = await http.get(Uri.parse(url));
  return json.decode(response.body)['name'];
}

Future<List<dynamic>> fetchEpisodes(id) async {
  String url = 'https://rickandmortyapi.com/api/character/$id';
  final response = await http.get(Uri.parse(url));
  List<dynamic> episodes = json.decode(response.body)['episode'];
  List<dynamic> episodesNames = [];

  episodes.forEach((episode) async =>
      episodesNames.add(await fetchEpisodeNameWithCharacterId(episode)));

  return Future.delayed(const Duration(seconds: 3), () => episodesNames);
}

class EpisodesScreen extends StatelessWidget {
  final int id;
  const EpisodesScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rick and Morty Episodes'),
          backgroundColor: const Color.fromARGB(192, 6, 1, 85),
        ),
        body: FutureBuilder(
            future: fetchEpisodes(id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(
                      '* ${snapshot.data[index]}',
                      style: const TextStyle(
                          color: Colors.black,
                          height: 2.0,
                          letterSpacing: 0.3,
                          fontSize: 25),
                    );
                  },
                );
              }
              throw ('Error');
            }));
  }
}
