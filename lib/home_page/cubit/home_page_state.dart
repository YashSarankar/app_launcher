import 'package:device_apps/device_apps.dart';

import '../../helper/base_equatable.dart';

class HomePageState extends BaseEquatable {}

class HomePageInitialState extends HomePageState {}

class HomePageErrorState extends HomePageState {
  final String error;

  HomePageErrorState(this.error);
}

class HomePageLoadingState extends HomePageState {}

class HomePageLoadedState extends HomePageState{
  bool operator ==(Object other) => false;
  final List<Application> apps;
  HomePageLoadedState(this.apps);
}
