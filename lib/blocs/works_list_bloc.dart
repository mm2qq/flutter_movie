import 'package:rxdart/rxdart.dart';

import '../api/douban_api.dart';
import '../models/movie_card.dart';
import '../models/works_result.dart';
import 'bloc_provider.dart';

class WorksListBloc implements BlocBase {
  WorksListBloc(
    this.id,
    this.countPerPage,
  ) {
    _startController.stream
        .bufferTime(Duration(microseconds: 500))
        .where((batch) => batch.isNotEmpty)
        .distinct()
        .listen(_handleStarts);
  }

  /// 影人ID
  final String id;

  /// 单页大小
  final int countPerPage;

  /// 已拉取列表
  final _fetchedList = <MovieCard>[];

  /// 已拉取位置索引
  final _fetchedStarts = Set<int>();

  final _worksController = PublishSubject<List<MovieCard>>();

  get _worksList => _worksController.sink;

  get worksList => _worksController.stream;

  final _startController = PublishSubject<int>();

  final _totalController = ReplaySubject<int>(maxSize: 1);

  get total => _totalController.stream;

  void add(int start) {
    _startController.sink.add(start);
  }

  void dispose() {
    _worksController.close();
    _startController.close();
    _totalController.close();
  }

  void _handleStarts(List<int> starts) {
    starts.forEach((int start) {
      if (!_fetchedStarts.contains(start)) {
        _fetchedStarts.add(start);

        api
            .worksList(id, start: start, count: countPerPage)
            .then((WorksResult result) => _handleWorksList(result, start));
      }
    });
  }

  void _handleWorksList(WorksResult result, int start) {
    if (result.worksList.length > 0) {
      _totalController.add(result.total);
      result.worksList.forEach((works) {
        _fetchedList.add(works.subject);
      });
      _worksList.add(_fetchedList);
    }
  }
}
