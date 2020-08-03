import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/app/model/user.dart';
import 'package:rxdart/rxdart.dart';

import 'geo_cms_api_interactor.dart';

class UserInteractor {
  final GeoCmsApiInteractor apiInteractor;

  final BehaviorSubject<Response<User>> _currentUser = BehaviorSubject.seeded(null);

  UserInteractor(this.apiInteractor);

  void init() {
    refreshUser();
  }

  void dispose() {
    _currentUser.close();
  }

  Future<void> refreshUser() async {
    // TODO user
    final result = await apiInteractor.getUser("");
    if (result.isValue) {
      _currentUser.add(Response.completed(result.asValue.value));
    }
  }

  Stream<Response<User>> getCurrentUser() => _currentUser;

}