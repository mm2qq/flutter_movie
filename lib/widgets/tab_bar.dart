import 'package:flutter/cupertino.dart';

import '../blocs/tab_bloc.dart';

const double _kTabHeight = 54.0;

typedef TapCallback = void Function(int index);

class MyTabBar extends StatefulWidget implements PreferredSizeWidget {
  MyTabBar(
    this.bloc,
    this.onTapped, {
    Key key,
  }) : super(key: key);

  final TabBloc bloc;

  final TapCallback onTapped;

  @override
  _MyTabBarState createState() => _MyTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(_kTabHeight);
}

class _MyTabBarState extends State<MyTabBar>
    with SingleTickerProviderStateMixin {
  int _currentIndex;

  @override
  void initState() {
    _currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _items = <Widget>[];

    return Container(
      color: CupertinoColors.lightBackgroundGray,
      child: StreamBuilder<List<String>>(
        stream: widget.bloc.tabList,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.data != null) {
            for (int idx = 0; idx < snapshot.data.length; idx++) {
              _items.add(GestureDetector(
                child: Text(
                  snapshot.data[idx],
                  style: _textStyle(idx),
                ),
                onTap: () {
                  _handleTapped(idx);
                },
              ));
            }
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items,
          );
        },
      ),
    );
  }

  void _handleTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onTapped(index);
  }

  TextStyle _textStyle(int index) {
    final Color _color = _currentIndex == index
        ? CupertinoColors.activeBlue
        : CupertinoColors.inactiveGray;
    return TextStyle(
      inherit: false,
      color: _color,
      fontSize: 16.0,
    );
  }
}
