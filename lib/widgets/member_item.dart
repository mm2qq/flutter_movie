import 'package:flutter/cupertino.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/movie.dart';

class MemberItemWidget extends StatelessWidget {
  MemberItemWidget({
    Key key,
    @required this.member,
    @required this.onTap,
  }) : super(key: key);

  final MovieMember member;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          child: Column(
            children: [
              FadeInImage.memoryNetwork(
                image: member.avatars == null ? '' : member.avatars['small'],
                fadeInDuration: Duration(milliseconds: 200),
                placeholder: kTransparentImage,
                fit: BoxFit.cover,
                width: 135.0,
              ),
              Text(
                member.name,
                style: TextStyle(
                  inherit: false,
                  color: CupertinoColors.black,
                  fontSize: 11.0,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                member.originName,
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
