import 'package:flutter/cupertino.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/movie_card.dart';

class MemberItemWidget extends StatelessWidget {
  MemberItemWidget({
    Key key,
    @required this.movieMember,
    @required this.onTap,
  }) : super(key: key);

  final MovieMember movieMember;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          child: Column(
            children: [
              FadeInImage.memoryNetwork(
                image: movieMember.avatars == null
                    ? ''
                    : movieMember.avatars['small'],
                fadeInDuration: Duration(milliseconds: 200),
                placeholder: kTransparentImage,
                fit: BoxFit.cover,
                width: 135.0,
              ),
              Text(
                movieMember.name,
                style: TextStyle(
                  inherit: false,
                  color: CupertinoColors.black,
                  fontSize: 11.0,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                movieMember.originName,
                style: TextStyle(
                  inherit: false,
                  color: CupertinoColors.inactiveGray,
                  fontSize: 11.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          onTap: onTap,
        );
      },
    );
  }
}
