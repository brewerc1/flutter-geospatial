import 'package:flutter/cupertino.dart';
import 'package:jacobspears/app/interactors/checkin_interactor.dart';
import 'package:jacobspears/app/interactors/user_interactor.dart';
import 'package:jacobspears/app/model/check_in_result.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/app/model/user.dart';
import 'package:provider/provider.dart';

class UserSettingsViewModel {

  static UserSettingsViewModel of(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  factory UserSettingsViewModel.fromContext(BuildContext context) {
    return UserSettingsViewModel(
        Provider.of(context, listen: false),
        Provider.of(context, listen: false)
    );
  }

  final UserInteractor userInteractor;
  final CheckInInteractor checkInInteractor;

  UserSettingsViewModel(this.checkInInteractor, this.userInteractor);

  init() {
    userInteractor.init();
    checkInInteractor.init();
  }

  void dispose() {}

  Stream<Response<List<CheckInResult>>> getHistory() => checkInInteractor.getAllCheckIns();
  Stream<Response<User>> getUser() => userInteractor.getCurrentUser();

}