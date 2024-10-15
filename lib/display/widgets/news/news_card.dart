import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.image, required this.title});

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding (
        padding: const EdgeInsets.symmetric(vertical: 8.5),
        child: Card ( color: const Color.fromRGBO(210, 224, 237, 100),
            child: Column (
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.5, horizontal: 12),
                      child: Text(title)
                  )
                ]
            )
        )
    );
  }
}