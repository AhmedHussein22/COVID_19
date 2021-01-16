
import 'package:covid_19/models/data_repository.dart';
import 'package:covid_19/providers/theme.dart';
import 'package:covid_19/services/api.dart';
import 'package:covid_19/services/api_service.dart';
import 'package:covid_19/services/data_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/homepage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, @required this.sharedPreferences}) : super(key: key);
  final SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkMode>(create: (_) => DarkMode()),
        Provider<DataRepository>(
            create: (_) => DataRepository(
        apiService: APIService(API.sandbox()),
        dataCacheService: DataCacheService(
          sharedPreferences: sharedPreferences,
        ),),)
      ],
      child: Consumer<DarkMode>(
        builder: (_, darkMode, child) => MaterialApp(
          title: 'Covid-19',
          darkTheme: darkMode.isdark ? ThemeData.dark() : ThemeData.light(),
          // theme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        ),
      ),
    );
  }
}
