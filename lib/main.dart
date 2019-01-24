import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'blocs/bloc_provider.dart';
import 'blocs/favorite_bloc.dart';
import 'blocs/home_bloc.dart';
import 'blocs/tab_bloc.dart';
import 'models/ranking_list_type.dart';
import 'pages/home.dart';
import 'routes/routes.dart';

Future<void> main() async {
  Routes.configRoutes();

  return runApp(
    BlocProvider<FavoriteBloc>(
      child: MyApp(),
      blocs: [
        FavoriteBloc(),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: BlocProvider<TabBloc>(
        child: BlocProvider<HomeBloc>(
          child: HomePage(),
          blocs: [
            HomeBloc(RankingListType.inTheaters, 20),
            HomeBloc(RankingListType.comingSoon, 20),
            HomeBloc(RankingListType.top250, 20),
            HomeBloc(RankingListType.weekly, 20),
            HomeBloc(RankingListType.usBox, 20),
            HomeBloc(RankingListType.newMovies, 20),
          ],
        ),
        blocs: [
          TabBloc([
            'TOP250',
            '口碑榜',
            '北美榜',
            '新片榜',
          ])
        ],
      ),
    );
  }
}
