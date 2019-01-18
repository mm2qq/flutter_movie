import 'package:rxdart/rxdart.dart';

import '../api/douban_api.dart';
import '../models/list_result.dart';
import '../models/movie_card.dart';
import 'bloc_provider.dart';

class SearchListBloc implements BlocBase {
  SearchListBloc(
    this.query,
    this.countPerPage,
  ) {
    _startController.stream
        .bufferTime(Duration(microseconds: 500))
        .where((batch) => batch.isNotEmpty)
        .distinct()
        .listen(_handleStarts);
  }

  /// 查询关键字
  final String query;

  /// 单页大小
  final int countPerPage;

  /// 已拉取列表
  final _fetchedList = <MovieCard>[];

  /// 已拉取位置索引
  final _fetchedStarts = Set<int>();

  final _searchController = PublishSubject<List<MovieCard>>();

  get _searchList => _searchController.sink;

  get searchList => _searchController.stream;

  final _startController = PublishSubject<int>();

  final _totalController = ReplaySubject<int>(maxSize: 1);

  get total => _totalController.stream;

  void add(int start) {
    _startController.sink.add(start);
  }

  void dispose() {
    _searchController.close();
    _startController.close();
    _totalController.close();
  }

  void _handleStarts(List<int> starts) {
    starts.forEach((int start) {
      if (!_fetchedStarts.contains(start)) {
        _fetchedStarts.add(start);

        api
            .searchList(query, start: start, count: countPerPage)
            .then((ListResult result) => _handleSearchList(result, start));
      }
    });
  }

  void _handleSearchList(ListResult result, int start) {
    if (result.subjects.length > 0) {
      _totalController.add(result.total);
      _fetchedList.addAll(result.subjects);
      _searchList.add(_fetchedList);
    }
  }
}
