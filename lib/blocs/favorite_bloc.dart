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

class FavoriteBloc extends BlocBase {
  FavoriteBloc() {
    SharedPreferences.getInstance().then((preferences) {
      final _list = preferences.getStringList(favoriteListKey);

      _totalController.add(_list.length);
      _favoriteController.add(_list);
    });
  }

  static const String favoriteListKey = 'kFavoriteListKey';

  final _favoriteController = ReplaySubject<List<String>>(maxSize: 1);

  final _totalController = ReplaySubject<int>(maxSize: 1);

  get favoriteList => _favoriteController.stream;

  get total => _totalController.stream;

  Future<Map<FavoriteOperationCode, String>> update(String info) async {
    if (info.isEmpty) {
      return {
        FavoriteOperationCode.addFailure:
            _operationCodeString(FavoriteOperationCode.addFailure),
      };
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
            ? {
                FavoriteOperationCode.removeSuccess:
                    _operationCodeString(FavoriteOperationCode.removeSuccess),
              }
            : {
                FavoriteOperationCode.removeFailure:
                    _operationCodeString(FavoriteOperationCode.removeFailure),
              })
        : (_success
            ? {
                FavoriteOperationCode.addSuccess:
                    _operationCodeString(FavoriteOperationCode.addSuccess),
              }
            : {
                FavoriteOperationCode.addFailure:
                    _operationCodeString(FavoriteOperationCode.addFailure),
              });
  }

  Future _reload() async {
    final _preferences = await SharedPreferences.getInstance();
    final _list = _preferences.getStringList(favoriteListKey);

    _totalController.add(_list.length);
    _favoriteController.add(_list);
  }

  String _operationCodeString(FavoriteOperationCode code) {
    String _codeString;

    switch (code) {
      case FavoriteOperationCode.addSuccess:
        _codeString = '收藏成功';
        break;
      case FavoriteOperationCode.addFailure:
        _codeString = '收藏失败';
        break;
      case FavoriteOperationCode.removeSuccess:
        _codeString = '取消收藏成功';
        break;
      case FavoriteOperationCode.removeFailure:
        _codeString = '取消收藏失败';
        break;
    }

    return _codeString;
  }

  @override
  void dispose() {
    _favoriteController.close();
    _totalController.close();
  }
}
