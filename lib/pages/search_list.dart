import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocs/bloc_provider.dart';
import '../blocs/favorite_list_bloc.dart';
import '../blocs/search_list_bloc.dart';
import '../models/movie_card.dart';
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

  int total;

  @override
  void initState() {
    total = 0;
    bloc.total.listen((_total) {
      setState(() {
        total = _total;
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
        middle: Text('$total条相关结果'),
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
          return StreamBuilder<List<MovieCard>>(
              stream: bloc.searchList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<MovieCard>> snapshot) {
                // 索引调整
                final _start = snapshot.data == null ? 0 : snapshot.data.length;
                bloc.add(_start);

                return GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(
                    8.0,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final _movieCard = snapshot.data == null
                        ? null
                        : _start > index ? snapshot.data[index] : MovieCard();

                    return _buildSearchList(context, _movieCard);
                  },
                  itemCount:
                      snapshot.data == null ? 8 : snapshot.data.length + 1,
                );
              });
        },
      ),
    );
  }

  Widget _buildSearchList(BuildContext context, MovieCard movieCard) {
    final _bloc = BlocProvider.of<FavoriteListBloc>(context).first;

    return movieCard == null
        ? Container(
            color: CupertinoColors.lightBackgroundGray,
            child: CupertinoActivityIndicator(),
          )
        : movieCard.id == null
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
                stream: _bloc.favoriteList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  bool _isFavorite = false;

                  if (snapshot.data != null &&
                      snapshot.data
                          .contains('${movieCard.id}-${movieCard.title}')) {
                    _isFavorite = true;
                  }

                  return MovieItemWidget(
                    movieCard: movieCard,
                    isFavorite: _isFavorite,
                    onTapped: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return Router.widget(
                          '/movie/${movieCard.id}',
                          context,
                          params: {'id': movieCard.id},
                        );
                      }));
                    },
                    onTappedFavorite: () {
                      _bloc
                          .add('${movieCard.id}-${movieCard.title}')
                          .then((code) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            var _content = '';
                            switch (code) {
                              case FavoriteOperationCode.addSuccess:
                                _content = '收藏成功';
                                break;
                              case FavoriteOperationCode.addFailure:
                                _content = '收藏失败';
                                break;
                              case FavoriteOperationCode.removeSuccess:
                                _content = '取消收藏成功';
                                break;
                              case FavoriteOperationCode.removeFailure:
                                _content = '取消收藏失败';
                                break;
                            }

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
                                _content,
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
