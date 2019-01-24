import 'package:flutter/widgets.dart';

typedef Widget WidgetBuilder(BuildContext context, {Map params});

class _Router {
  _Router({this.name, this.widgetBuilder});

  final String name;

  WidgetBuilder widgetBuilder;

  List<_Router> _children = [];

  List<_Router> get children => List.unmodifiable(_children);

  addChild(_Router child) {
    _children.add(child);
  }
}

class Router {
  static final _routerEntry = _Router(name: '');

  // param should wrap with {}, eg: /movie/{id}
  static register(String pattern, WidgetBuilder widgetBuilder) {
    final _patterns = pattern.split('/');

    for (String _pattern in _patterns) {
      if (!_pattern.startsWith('{')) {
        final _router = _Router(name: _pattern);
        _router.widgetBuilder = widgetBuilder;
        _routerEntry.addChild(_router);
      }
    }
  }

  static Widget widget(String url, BuildContext context, {Map params}) {
    final _urlSections = url.split('/');
    Widget _widget;

    for (String _urlSection in _urlSections) {
      for (_Router _router in _routerEntry.children) {
        if (_router.name == _urlSection && _router.widgetBuilder != null) {
          _widget = _router.widgetBuilder(context, params: params);
          break;
        }
      }
    }

    return _widget;
  }
}
