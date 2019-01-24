import 'package:flutter/widgets.dart';

Type _typeOf<T>() => T;

abstract class BlocBase {
  @protected
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.blocs,
  }) : super(
          key: key,
        );

  final Widget child;

  final List<T> blocs;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static List<T> of<T extends BlocBase>(BuildContext context) {
    final _type = _typeOf<_BlocProviderInherited<T>>();
    _BlocProviderInherited<T> _provider =
        context.ancestorInheritedElementForWidgetOfExactType(_type)?.widget;
    return _provider?.blocs;
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return _BlocProviderInherited<T>(
      blocs: widget.blocs,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.blocs.map((bloc) {
      bloc.dispose();
    });
    super.dispose();
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.blocs,
  }) : super(
          key: key,
          child: child,
        );

  final List<T> blocs;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}
