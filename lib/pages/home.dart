import 'package:flutter/cupertino.dart';

import '../blocs/bloc_provider.dart';
import '../blocs/favorite_list_bloc.dart';
import '../blocs/home_bloc.dart';
import '../blocs/tab_bloc.dart';
import '../models/movie_card.dart';
import '../routes/router.dart';
import '../widgets/movie_item.dart';
import '../widgets/search_bar.dart';
import '../widgets/sliver_persistent_header_delegate.dart';
import '../widgets/tab_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _tabIndex;

  get _currentBloc {
    final _blocs = BlocProvider.of<HomeBloc>(context);
    return _blocs[_tabIndex + 2];
  }

  @override
  void initState() {
    _tabIndex = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _homeBlocs = BlocProvider.of<HomeBloc>(context);
    final _tabBloc = BlocProvider.of<TabBloc>(context).first;
    final _tabBar = MyTabBar(_tabBloc, _handleTap);

    final _ltbInsets = EdgeInsets.only(
      left: 8.0,
      top: 8.0,
      bottom: 8.0,
    );
    final _lbInsets = EdgeInsets.only(
      left: 8.0,
      bottom: 8.0,
    );
    final _lrtInsets = EdgeInsets.only(
      left: 8.0,
      right: 8.0,
      top: 8.0,
    );

    final _bigTextStyle = TextStyle(
      inherit: false,
      color: CupertinoColors.black,
      fontSize: 18.0,
    );

    return CupertinoPageScaffold(
      navigationBar: MySearchBar(
        onSubmitted: (text) {
          final _query = text.trim();
          if (_query.isEmpty) {
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
                    '请输入关键字',
                  ),
                  actions: [_confirmAction],
                );
              },
            );
          } else {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return Router.widget('/movie/search/$_query', context,
                  params: {'query': _query});
            }));
          }
        },
        onTapped: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return Router.widget('/movie/favorites', context, params: {});
          }));
        },
      ),
      child: CustomScrollView(
        slivers: [
          _buildTitleWidget(
            '正在热映',
            _ltbInsets,
            _bigTextStyle,
          ),
          _buildHeaderWidget(
            _buildHorizontalGridWidget(
              _homeBlocs[0],
              _lbInsets,
            ),
            180.0,
            false,
          ),
          _buildTitleWidget(
            '即将上映',
            _lbInsets,
            _bigTextStyle,
          ),
          _buildHeaderWidget(
            _buildHorizontalGridWidget(
              _homeBlocs[1],
              _lbInsets,
            ),
            180.0,
            false,
          ),
          _buildHeaderWidget(
            _tabBar,
            _tabBar.preferredSize.height,
            true,
          ),
          _buildVerticalGridWidget(
            _currentBloc,
            _lrtInsets,
          ),
        ],
      ),
    );
  }

  Widget _buildTitleWidget(String text, EdgeInsets insets, TextStyle style) {
    return SliverPadding(
      padding: insets,
      sliver: SliverToBoxAdapter(
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }

  Widget _buildHeaderWidget(Widget child, double height, bool pinned) {
    return SliverPersistentHeader(
      delegate: MySliverPersistentHeaderDelegate(
        child,
        height,
      ),
      pinned: pinned,
    );
  }

  Widget _buildHorizontalGridWidget(HomeBloc bloc, EdgeInsets insets) {
    return StreamBuilder<List<MovieCard>>(
        stream: bloc.rankingList,
        builder:
            (BuildContext context, AsyncSnapshot<List<MovieCard>> snapshot) {
          // 索引调整
          final _start = snapshot.data == null ? 0 : snapshot.data.length;
          bloc.add(_start);

          return GridView.builder(
            shrinkWrap: true,
            padding: insets,
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final _movieCard = snapshot.data == null
                  ? null
                  : _start > index ? snapshot.data[index] : MovieCard();

              return _buildRankingList(context, _movieCard);
            },
            itemCount: snapshot.data == null ? 3 : snapshot.data.length + 1,
          );
        });
  }

  Widget _buildVerticalGridWidget(HomeBloc bloc, EdgeInsets insets) {
    return SliverPadding(
      padding: insets,
      sliver: StreamBuilder<List<MovieCard>>(
          stream: bloc.rankingList,
          builder:
              (BuildContext context, AsyncSnapshot<List<MovieCard>> snapshot) {
            // 索引调整
            final _start = snapshot.data == null ? 0 : snapshot.data.length;
            bloc.add(_start);

            final _children = <Widget>[];

            for (int index = 0;
                index < (snapshot.data == null ? 4 : snapshot.data.length + 1);
                index++) {
              final _movieCard = snapshot.data == null
                  ? null
                  : _start > index ? snapshot.data[index] : MovieCard();
              _children.add(_buildRankingList(context, _movieCard));
            }

            return SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              children: _children,
            );
          }),
    );
  }

  Widget _buildRankingList(BuildContext context, MovieCard movieCard) {
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

  void _handleTap(int index) {
    if (index == _tabIndex) {
      return;
    }

    setState(() {
      _tabIndex = index;
    });
  }
}
