import 'package:rxdart/rxdart.dart';

import '../api/douban_api.dart';
import '../models/list_result.dart';
import '../models/movie_card.dart';
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
  final _fetchedList = <MovieCard>[];

  /// 已拉取位置索引
  final _fetchedStarts = Set<int>();

  /// 总条数
  int total = 0;

  final _rankingController = PublishSubject<List<MovieCard>>();

  get _rankingList => _rankingController.sink;

  get rankingList => _rankingController.stream;

  final _startController = PublishSubject<int>();

  void add(int start) {
    if (start < total) {
      _startController.sink.add(start);
    } else {
      _startController.sink.add(0);
    }
  }

  void dispose() {
    _rankingController.close();
    _startController.close();
  }

  void _handleStarts(List<int> starts) {
    starts.forEach((int start) {
      if (_fetchedStarts.contains(start)) {
        _rankingList.add(_fetchedList);
      } else {
        _fetchedStarts.add(start);

        api.rankingList(type: type, start: start, count: countPerPage).then(
            (dynamic result) => (type == RankingListType.weekly ||
                    type == RankingListType.usBox)
                ? _handleRankingList(result, start)
                : _handleList(result, start));
      }
    });
  }

  void _handleRankingList(RankingResult result, int start) {
    if (result.subjects.length > 0) {
      total = result.subjects.length;
      result.subjects.forEach((movieRanking) {
        _fetchedList.add(movieRanking.subject);
      });
      _rankingList.add(_fetchedList);
    }
  }

  void _handleList(ListResult result, int start) {
    if (result.subjects.length > 0) {
      total = type == RankingListType.newMovies
          ? result.subjects.length
          : result.total;
      _fetchedList.addAll(result.subjects);
      _rankingList.add(_fetchedList);
    }
  }
}
