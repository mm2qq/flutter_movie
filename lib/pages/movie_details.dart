import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../blocs/bloc_provider.dart';
import '../blocs/movie_details_bloc.dart';
import '../models/movie_card.dart';
import '../routes/router.dart';
import '../widgets/member_item.dart';
import '../widgets/navigation_bar.dart';

class MovieDetailsPage extends StatefulWidget {
  MovieDetailsPage({
    Key key,
    @required this.id,
  }) : super(key: key);

  final String id;

  @override
  _MovieDetailsPageState createState() =>
      _MovieDetailsPageState(MovieDetailsBloc(id));
}

class _MovieDetailsPageState extends State<MovieDetailsPage>
    with SingleTickerProviderStateMixin {
  _MovieDetailsPageState(this.bloc);

  final MovieDetailsBloc bloc;

  MovieCard movie;

  int _summaryLines;

  @override
  void initState() {
    _summaryLines = 5;
    bloc.details.listen((_movie) {
      setState(() {
        movie = _movie;
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
    final _bigTextStyle = TextStyle(
      inherit: false,
      color: CupertinoColors.black,
      fontSize: 15.0,
    );
    final _smallTextStyle = TextStyle(
      inherit: false,
      color: CupertinoColors.inactiveGray,
      fontSize: 12.0,
    );

    return CupertinoPageScaffold(
      navigationBar: MyNavigationBar(
        middle: Text('影片详情'),
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
          return movie == null
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      top: 8.0,
                      right: 8.0,
                    ),
                    child: BlocProvider(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeInImage.memoryNetwork(
                                  image: movie.images['small'],
                                  fadeInDuration: Duration(milliseconds: 200),
                                  placeholder: kTransparentImage,
                                  fit: BoxFit.cover,
                                  width: 135.0,
                                  height: 189.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: constraints.maxWidth - 159.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildTextWidget(
                                            movie.title, _bigTextStyle),
                                        _buildTextWidget(
                                            movie.originTitle, _smallTextStyle),
                                        _buildTextWidget(movie.genres.join('，'),
                                            _smallTextStyle),
                                        _buildTextWidget(
                                            '${movie.pubDates.join('，')} | ${movie.durations.join('，')}',
                                            _smallTextStyle),
                                        _buildRatingWidget(movie.rating),
                                        _buildCountWidget(movie.rating.details),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              child: Text(
                                '剧情简介',
                                style: _bigTextStyle,
                              ),
                            ),
                            _buildSummaryWidget(movie.summary, _smallTextStyle),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              child: Text(
                                '演员表',
                                style: _bigTextStyle,
                              ),
                            ),
                            _buildGridWidget(movie.casts, _smallTextStyle),
                          ],
                        ),
                        blocs: [bloc]),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildTextWidget(String text, TextStyle style,
      {TextOverflow overflow = TextOverflow.ellipsis, int maxLines = 3}) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.0,
      ),
      child: Text(
        text,
        style: style,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildRatingWidget(MovieRating rating) {
    final num _rate = rating.average / rating.max;
    List<Widget> _icons = <Widget>[];

    for (int idx = 1; idx < 10; idx += 2) {
      Widget _icon = Icon(
        _rate < idx / 10.0
            ? Icons.star_border
            : _rate < (idx + 1) / 10.0 ? Icons.star_half : Icons.star,
        color: Colors.amber,
      );
      _icons.add(_icon);
    }

    _icons.add(Text(
      '${rating.average}分',
      style: TextStyle(
        inherit: false,
        color: Colors.amber,
        fontSize: 15.0,
      ),
    ));

    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.0,
      ),
      child: Row(
        children: _icons,
      ),
    );
  }

  Widget _buildCountWidget(Map<String, num> details) {
    num _count = 0;
    details.forEach((key, value) {
      _count += value;
    });

    return Text(
      '${_count.toInt()}人评分',
      style: TextStyle(
        inherit: false,
        color: Colors.red,
        fontSize: 15.0,
      ),
    );
  }

  Widget _buildSummaryWidget(String summary, TextStyle style) {
    return (summary == null || summary.isEmpty)
        ? Text(
            '暂无数据',
            style: style,
          )
        : GestureDetector(
            child: Column(
              children: [
                Text(
                  summary,
                  style: style,
                  maxLines: _summaryLines,
                  overflow: TextOverflow.fade,
                ),
                Icon(
                  _summaryLines == 5
                      ? Icons.arrow_drop_down
                      : Icons.arrow_drop_up,
                  color: style.color,
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _summaryLines = _summaryLines == 5 ? 100 : 5;
              });
            },
          );
  }

  Widget _buildGridWidget(List<MovieMember> members, TextStyle style) {
    return Container(
      child: (members == null || members.isEmpty)
          ? Text(
              '暂无数据',
              style: style,
            )
          : GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 5.0,
                childAspectRatio: 2.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return MemberItemWidget(
                  movieMember: members[index],
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return Router.widget(
                          '/${members[index].id}/works', context,
                          params: {'id': members[index].id});
                    }));
                  },
                );
              },
              itemCount: members.length,
            ),
      height: 200.0,
    );
  }
}
