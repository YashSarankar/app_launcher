import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> with ChangeNotifier{

  List<Application> apps = [];
  List<Application> filteredApps = [];
  HomePageCubit() : super(HomePageInitialState());

  void init() {
    getAppsFromDevice();
    return;
  }
  void getAppsFromDevice() async {
    emit(HomePageLoadingState());
    try {
      apps = await DeviceApps.getInstalledApplications(
          onlyAppsWithLaunchIntent: true,
          includeSystemApps: true);
      filteredApps.addAll(apps);
      emit(HomePageLoadedState(apps));
    } catch (e) {
      emit(HomePageErrorState(e.toString()));
    }
  }

  void openAppSettings(Application application) async {
    await DeviceApps.openAppSettings(application.packageName);
  }

  void openApp(Application application) {
    DeviceApps.openApp(application.packageName);
  }


  void onSearch(String value) {
    filteredApps.clear();
    for (Application application in apps) {
      if (application.appName.toLowerCase().contains(value.toLowerCase())) {
        filteredApps.add(application);
      }
    }
    emit(HomePageLoadedState(
        filteredApps.isEmpty ? apps : filteredApps
    ));
  }

}