import 'package:rxdart/rxdart.dart';

import '../api/douban_api.dart';
import '../models/movie.dart';
import 'bloc_provider.dart';

class MovieDetailsBloc extends BlocBase {
  MovieDetailsBloc(
    this.id,
  ) {
    api.movie(id).then((Movie details) {
      _detailsController.add(details);
    });
  }

  final String id;

  final _detailsController = ReplaySubject<Movie>(maxSize: 1);

  get details => _detailsController.stream;

  @override
  void dispose() {
    _detailsController.close();
  }
}
