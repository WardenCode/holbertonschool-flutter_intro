import 'package:flutter/material.dart';
import 'package:rick_and_morty/models.dart';

class CharacterTile extends StatelessWidget {
  final Character character;

  const CharacterTile({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(character.img),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    character.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }));
  }

  gridViewBuilder(
      {required SliverGridDelegateWithFixedCrossAxisCount gridDelegate,
      required Container Function(BuildContext context, int index)
          itemBuilder}) {}
}
