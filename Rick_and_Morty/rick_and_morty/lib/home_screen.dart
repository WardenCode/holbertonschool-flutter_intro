import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rick_and_morty/episodes_screen.dart';

Future<List<dynamic>> fetchBbCharacters() async {
  String url = 'https://rickandmortyapi.com/api/character';

  final response = await http.get(Uri.parse(url));
  List<dynamic> characters = json.decode(response.body)['results'];

  return characters;
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _data = fetchBbCharacters();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty"),
        backgroundColor: const Color.fromARGB(192, 6, 1, 85),
      ),
      body: FutureBuilder(
          future: _data,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(child: Text('Error'));
              }

              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  padding: const EdgeInsets.all(13),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EpisodesScreen(
                                    id: snapshot.data[index]['id'])));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data[index]["image"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '${snapshot.data[index]["name"]}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 35),
                          ),
                        ),
                      ),
                    );
                  });
            }

            throw ('Error');
          }),
    );
  }
}
