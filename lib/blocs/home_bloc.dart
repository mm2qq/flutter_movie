import 'package:rxdart/rxdart.dart';

import '../api/douban_api.dart';
import '../models/list_result.dart';
import '../models/movie.dart';
import '../models/ranking_list_type.dart';
import '../models/ranking_result.dart';
import 'bloc_provider.dart';

class HomeBloc implements BlocBase {
  HomeBloc(
    this.type,
    this.countPerPage,
  ) {
    _startController.stream
        .bufferTime(Duration(microseconds: 500))
        .where((batch) => batch.isNotEmpty)
        .distinct()
        .listen(_handleStarts);
  }

  /// 排行榜类型
  final RankingListType type;

  /// 单页大小
  final int countPerPage;

  /// 已拉取列表
  final _fetchedList = <Movie>[];

  /// 已拉取位置索引
  final _fetchedStarts = Set<int>();

  /// 总条数
  int total = 0;

  final _rankingController = PublishSubject<List<Movie>>();

  final _startController = PublishSubject<int>();

  get _rankingList => _rankingController.sink;

  get rankingList => _rankingController.stream;

  void add(int start) {
    if (start < total) {
      _startController.sink.add(start);
    } else {
      _startController.sink.add(0);
    }
  }

  void _handleStarts(List<int> starts) {
    starts.forEach((int start) {
      if (_fetchedStarts.contains(start)) {
        _rankingList.add(_fetchedList);
      } else {
        _fetchedStarts.add(start);

        api.rankingList(type: type, start: start, count: countPerPage).then(
            (result) => result is RankingResult
                ? _handleRankingList(result, start)
                : _handleList(result, start));
      }
    });
  }

  void _handleRankingList(RankingResult result, int start) {
    if (result.rankings.length > 0) {
      total = result.rankings.length;
      result.rankings.forEach((movieRanking) {
        _fetchedList.add(movieRanking.subject);
      });
      _rankingList.add(_fetchedList);
    }
  }

  void _handleList(ListResult result, int start) {
    if (result.movies.length > 0) {
      total = type == RankingListType.newMovies
          ? result.movies.length
          : result.total;
      _fetchedList.addAll(result.movies);
      _rankingList.add(_fetchedList);
    }
  }

  @override
  void dispose() {
    _rankingController.close();
    _startController.close();
  }
}
