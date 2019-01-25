import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/list_result.dart';
import '../models/movie.dart';
import '../models/ranking_list_type.dart';
import '../models/ranking_result.dart';
import '../models/works_result.dart';

class DoubanAPI {
  static const String baseUrl = 'api.douban.com';

  static const String apiKey = '0b2bdeda43b5688921839c8ecb20399b';

  final _httpClient = HttpClient();

  /// 获取排行榜数据
  ///
  /// [type] 排行榜类型, 默认`RankingListType.inTheaters`
  /// [start] 起始索引, 默认`0`
  /// [count] 单页大小, 默认`20`
  Future<dynamic> rankingList(
      {RankingListType type: RankingListType.inTheaters,
      int start: 0,
      int count: 20}) async {
    final _typeString = _rankingListTypeString(type);

    final _uri = Uri.https(
      baseUrl,
      'v2/movie/$_typeString',
      {
        'apikey': apiKey,
        'start': '$start',
        'count': '$count',
      },
    );

    final _response = await _getRequest(_uri);

    final _list =
        (type == RankingListType.weekly || type == RankingListType.usBox)
            ? RankingResult.fromJSON(json.decode(_response))
            : ListResult.fromJSON(json.decode(_response));

    return _list;
  }

  /// 获取影片详情
  ///
  /// [id] 影片ID
  Future<Movie> movie(String id) async {
    final _uri = Uri.https(
      baseUrl,
      'v2/movie/subject/$id',
      {
        'apikey': apiKey,
      },
    );

    final _response = await _getRequest(_uri);
    final _movie = Movie.fromJSON(json.decode(_response));

    return _movie;
  }

  /// 获取影人作品
  ///
  /// [id] 影人ID
  /// [start] 起始索引, 默认`0`
  /// [count] 单页大小, 默认`20`
  Future<WorksResult> worksList(String id,
      {int start: 0, int count: 20}) async {
    final _uri = Uri.https(
      baseUrl,
      'v2/movie/celebrity/$id/works',
      {
        'apikey': apiKey,
        'start': '$start',
        'count': '$count',
      },
    );

    final _response = await _getRequest(_uri);
    final _list = WorksResult.fromJSON(json.decode(_response));

    return _list;
  }

  /// 获取搜索结果列表
  ///
  /// [query] 查询关键字
  /// [start] 起始索引, 默认`0`
  /// [count] 单页大小, 默认`20`
  Future<ListResult> searchList(String query,
      {int start: 0, int count: 20}) async {
    final _uri = Uri.https(
      baseUrl,
      'v2/movie/search',
      {
        'apikey': apiKey,
        'q': '$query',
        'start': '$start',
        'count': '$count',
      },
    );

    final _response = await _getRequest(_uri);
    final _list = ListResult.fromJSON(json.decode(_response));

    return _list;
  }

  String _rankingListTypeString(RankingListType type) {
    String _typeString;

    switch (type) {
      case RankingListType.inTheaters:
        _typeString = 'in_theaters';
        break;
      case RankingListType.comingSoon:
        _typeString = 'coming_soon';
        break;
      case RankingListType.top250:
        _typeString = 'top250';
        break;
      case RankingListType.weekly:
        _typeString = 'weekly';
        break;
      case RankingListType.usBox:
        _typeString = 'us_box';
        break;
      case RankingListType.newMovies:
        _typeString = 'new_movies';
        break;
    }

    return _typeString;
  }

  Future<String> _getRequest(Uri uri) async {
    final _request = await _httpClient.getUrl(uri);
    final _response = await _request.close();

    return _response.transform(utf8.decoder).join();
  }
}

DoubanAPI api = DoubanAPI();
