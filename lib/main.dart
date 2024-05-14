import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'helper/cubit_delegate.dart';
import 'home_page/cubit/home_page_cubit.dart';
import 'my_app.dart';

void main() {
  runApp(
    ChangeNotifierProvider<HomePageCubit>(
    create: (context) => HomePageCubit()..init(), // Create a single instance
    child: MyApp(),
  ),);
  Bloc.observer = EchoCubitDelegate();
}
