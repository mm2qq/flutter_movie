import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc_provider.dart';

/// 收藏回调码
enum FavoriteOperationCode {
  /// 收藏成功
  addSuccess,

  /// 收藏失败
  addFailure,

  /// 取消收藏成功
  removeSuccess,

  /// 取消收藏失败
  removeFailure,
}

class FavoriteListBloc extends BlocBase {
  FavoriteListBloc() {
    SharedPreferences.getInstance().then((preferences) {
      final _list = preferences.getStringList(favoriteListKey);

      _totalController.add(_list.length);
      _favoriteController.add(_list);
    });
  }

  static String favoriteListKey = 'kFavoriteListKey';

  final _favoriteController = ReplaySubject<List<String>>(maxSize: 1);

  get favoriteList => _favoriteController.stream;

  final _totalController = ReplaySubject<int>(maxSize: 1);

  get total => _totalController.stream;

  Future<FavoriteOperationCode> add(String info) async {
    if (info.isEmpty) {
      return FavoriteOperationCode.addFailure;
    }

    final _preferences = await SharedPreferences.getInstance();

    var _list = _preferences.getStringList(favoriteListKey);

    if (_list == null) {
      _list = [];
    }

    final contains = _list.contains(info);

    if (contains) {
      _list.remove(info);
    } else {
      _list.add(info);
    }

    final _success = await _preferences.setStringList(favoriteListKey, _list);

    if (_success) {
      _reload();
    }

    return contains
        ? (_success
            ? FavoriteOperationCode.removeSuccess
            : FavoriteOperationCode.removeFailure)
        : (_success
            ? FavoriteOperationCode.addSuccess
            : FavoriteOperationCode.addFailure);
  }

  Future _reload() async {
    final _preferences = await SharedPreferences.getInstance();
    final _list = _preferences.getStringList(favoriteListKey);

    _totalController.add(_list.length);
    _favoriteController.add(_list);
  }

  void dispose() {
    _favoriteController.close();
    _totalController.close();
  }
}
