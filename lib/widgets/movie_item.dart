import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/movie.dart';

class MovieItemWidget extends StatelessWidget {
  MovieItemWidget({
    Key key,
    @required this.movie,
    @required this.isFavorite,
    @required this.onTapped,
    @required this.onTappedFavorite,
  }) : super(key: key);

  final Movie movie;

  final bool isFavorite;

  final VoidCallback onTapped;

  final VoidCallback onTappedFavorite;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Material(
        color: Colors.grey,
        child: InkWell(
          onTap: onTapped,
          child: Stack(children: [
            Positioned.fill(
              child: FadeInImage.memoryNetwork(
                image: movie.images['small'],
                fadeInDuration: Duration(milliseconds: 200),
                placeholder: kTransparentImage,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fromRect(
              rect: Rect.fromLTWH(0, 0, 30, 18),
              child: Container(
                  alignment: Alignment.center,
                  color: Colors.green,
                  child: Text(
                    '${movie.rating.average}',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Positioned.fill(
                left: 0,
                top: constraints.maxHeight - 60,
                child: Container(
                    color: Colors.black87,
                    child: Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    movie.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: onTappedFavorite,
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 20,
                                    color:
                                        isFavorite ? Colors.red : Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              movie.casts.map((actor) => actor.name).join("/"),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                          ]),
                    ))),
          ]),
        ),
      );
    });
  }
}
