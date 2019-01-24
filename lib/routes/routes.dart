import 'package:flutter/widgets.dart';

import '../pages/favorite_list.dart';
import '../pages/home.dart';
import '../pages/movie_details.dart';
import '../pages/search_list.dart';
import '../pages/works_list.dart';
import 'router.dart';

class Routes {
  static const String home = '/';
  static const String details = '/movie/{movieId}';
  static const String works = '/{celebrityId}/works';
  static const String search = '/movie/search/{query}';
  static const String favorites = '/movie/favorites';

  static configRoutes() {
    Router.register(home, (BuildContext context, {Map params}) {
      return HomePage();
    });

    Router.register(details, (BuildContext context, {Map params}) {
      return MovieDetailsPage(
        id: params == null ? null : params['id'],
      );
    });

    Router.register(works, (BuildContext context, {Map params}) {
      return WorksListPage(
        id: params == null ? null : params['id'],
      );
    });

    Router.register(search, (BuildContext context, {Map params}) {
      return SearchListPage(
        query: params == null ? null : params['query'],
      );
    });

    Router.register(favorites, (BuildContext context, {Map params}) {
      return FavoriteListPage();
    });
  }
}
