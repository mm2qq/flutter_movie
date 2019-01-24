import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocs/bloc_provider.dart';
import '../blocs/favorite_bloc.dart';
import '../blocs/search_list_bloc.dart';
import '../models/movie.dart';
import '../routes/router.dart';
import '../widgets/movie_item.dart';
import '../widgets/navigation_bar.dart';

class SearchListPage extends StatefulWidget {
  SearchListPage({
    Key key,
    @required this.query,
  }) : super(key: key);

  final String query;

  @override
  _SearchListPageState createState() =>
      _SearchListPageState(SearchListBloc(query, 20));
}

class _SearchListPageState extends State<SearchListPage>
    with SingleTickerProviderStateMixin {
  _SearchListPageState(this.bloc);

  final SearchListBloc bloc;

  int _total;

  get _favoriteBloc => BlocProvider.of<FavoriteBloc>(context).first;

  @override
  void initState() {
    _total = 0;
    bloc.total.listen((total) {
      setState(() {
        _total = total;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: MyNavigationBar(
        middle: Text('$_total条相关结果'),
        trailing: GestureDetector(
          child: Icon(Icons.favorite_border),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return Router.widget('/movie/favorites', context, params: {});
            }));
          },
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return StreamBuilder<List<Movie>>(
              stream: bloc.searchList,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
                // 索引调整
                final _start = snapshot.data == null ? 0 : snapshot.data.length;
                bloc.add(_start);

                final _children = <Widget>[];

                for (int index = 0;
                    index <
                        (snapshot.data == null ? 18 : snapshot.data.length + 1);
                    index++) {
                  final _movie = snapshot.data == null
                      ? null
                      : _start > index ? snapshot.data[index] : Movie();
                  _children.add(_buildSearchList(context, _movie));
                }

                return GridView.extent(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(
                    8.0,
                  ),
                  maxCrossAxisExtent: 180.0,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  children: _children,
                );
              });
        },
      ),
    );
  }

  Widget _buildSearchList(BuildContext context, Movie movie) {
    return movie == null
        ? Container(
            color: CupertinoColors.lightBackgroundGray,
            child: CupertinoActivityIndicator(),
          )
        : movie.id == null
            ? Center(
                child: Text(
                  '_(:з」∠)_\n没有数据了',
                  style: TextStyle(
                    inherit: false,
                    color: CupertinoColors.inactiveGray,
                    fontSize: 15.0,
                  ),
                ),
              )
            : StreamBuilder<List<String>>(
                stream: _favoriteBloc.favoriteList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  bool _isFavorite = false;

                  if (snapshot.data != null &&
                      snapshot.data.contains('${movie.id}-${movie.title}')) {
                    _isFavorite = true;
                  }

                  return MovieItemWidget(
                    movie: movie,
                    isFavorite: _isFavorite,
                    onTapped: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return Router.widget(
                          '/movie/${movie.id}',
                          context,
                          params: {'id': movie.id},
                        );
                      }));
                    },
                    onTappedFavorite: () {
                      _favoriteBloc
                          .update('${movie.id}-${movie.title}')
                          .then((info) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            final _confirmAction = CupertinoDialogAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                '确定',
                              ),
                            );

                            return CupertinoAlertDialog(
                              title: Text(
                                '提示',
                              ),
                              content: Text(
                                info.values.first,
                              ),
                              actions: [_confirmAction],
                            );
                          },
                        );
                      });
                    },
                  );
                });
  }
}
