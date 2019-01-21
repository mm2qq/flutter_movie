import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocs/bloc_provider.dart';
import '../blocs/favorite_list_bloc.dart';
import '../blocs/works_list_bloc.dart';
import '../models/movie_card.dart';
import '../routes/router.dart';
import '../widgets/movie_item.dart';
import '../widgets/navigation_bar.dart';

class WorksListPage extends StatefulWidget {
  WorksListPage({
    Key key,
    @required this.id,
  }) : super(key: key);

  final String id;

  @override
  _WorksListPageState createState() =>
      _WorksListPageState(WorksListBloc(id, 20));
}

class _WorksListPageState extends State<WorksListPage>
    with SingleTickerProviderStateMixin {
  _WorksListPageState(this.bloc);

  final WorksListBloc bloc;

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
        middle: Text('$total部相关作品'),
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
              stream: bloc.worksList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<MovieCard>> snapshot) {
                // 索引调整
                final _start = snapshot.data == null ? 0 : snapshot.data.length;
                bloc.add(_start);

                final _children = <Widget>[];

                for (int index = 0;
                    index <
                        (snapshot.data == null ? 18 : snapshot.data.length + 1);
                    index++) {
                  final _movieCard = snapshot.data == null
                      ? null
                      : _start > index ? snapshot.data[index] : MovieCard();
                  _children.add(_buildWorksList(context, _movieCard));
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

  Widget _buildWorksList(BuildContext context, MovieCard movieCard) {
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
