import 'package:flutter/cupertino.dart';

class MyNavigationBar extends CupertinoNavigationBar {
  MyNavigationBar({
    Key key,
    Widget middle,
    Widget trailing,
  }) : super(
          key: key,
          middle: middle,
          trailing: trailing,
        );

  @override
  bool get fullObstruction => true;
}
