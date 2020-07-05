import 'package:flutter/widgets.dart';
import 'package:jacobspears/app/interactors/point_interactor.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:provider/provider.dart';


class PointListViewModel {

  static PointListViewModel of(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  factory PointListViewModel.fromContext(BuildContext context) {
    return PointListViewModel(Provider.of(context, listen: false));
  }

  final PointInteractor pointInteractor;

  PointListViewModel(this.pointInteractor);

  init() {
    pointInteractor.refreshPoints();
  }

  Stream<List<Point>> getPoints() => pointInteractor.getAllPoints();
}