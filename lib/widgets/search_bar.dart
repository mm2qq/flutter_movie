import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySearchBar extends CupertinoNavigationBar {
  MySearchBar({
    Key key,
    @required this.onSubmitted,
    @required this.onTapped,
  }) : super(key: key);

  final ValueChanged<String> onSubmitted;

  final VoidCallback onTapped;

  @override
  bool get fullObstruction => true;

  @override
  Widget get middle => _SearchBar(
        onSubmitted: onSubmitted,
      );

  @override
  Widget get trailing => GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.0,
          ),
          child: Icon(Icons.favorite_border),
        ),
        onTap: onTapped,
      );
}

class _SearchBar extends StatefulWidget {
  _SearchBar({
    Key key,
    @required this.onSubmitted,
  }) : super(key: key);

  final ValueChanged<String> onSubmitted;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar>
    with SingleTickerProviderStateMixin {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const BorderSide _kDefaultRoundedBorderSide = BorderSide(
      color: CupertinoColors.lightBackgroundGray,
      style: BorderStyle.solid,
      width: 0.0,
    );

    const Border _kDefaultRoundedBorder = Border(
      top: _kDefaultRoundedBorderSide,
      bottom: _kDefaultRoundedBorderSide,
      left: _kDefaultRoundedBorderSide,
      right: _kDefaultRoundedBorderSide,
    );

    const BoxDecoration _kDefaultRoundedBorderDecoration = BoxDecoration(
      border: _kDefaultRoundedBorder,
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
      color: CupertinoColors.white,
    );

    return CupertinoTextField(
      clearButtonMode: OverlayVisibilityMode.editing,
      controller: _controller,
      decoration: _kDefaultRoundedBorderDecoration,
      onSubmitted: widget.onSubmitted,
      placeholder: '请输入关键字',
      textInputAction: TextInputAction.search,
    );
  }
}
