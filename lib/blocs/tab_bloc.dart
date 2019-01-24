import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class TabBloc implements BlocBase {
  TabBloc(
    this.tabs,
  ) {
    _tabController.add(tabs);
  }

  final List<String> tabs;

  final _tabController = ReplaySubject<List<String>>(maxSize: 1);

  get tabList => _tabController.stream;

  @override
  void dispose() {
    _tabController.close();
  }
}
