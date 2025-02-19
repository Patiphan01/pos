import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './fucntion/tableprovider.dart';
import 'page/login.dart';
import './fucntion/staffprovider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const MyApp());
  }).catchError((error) {
    debugPrint("Error setting preferred orientations: $error");
  });

  FlutterError.onError = (details) {
    FlutterError.presentError(details);

    debugPrint("Flutter Error: ${details.exceptionAsString()}");
  };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TableProvider(),
        ),
        ChangeNotifierProvider(create: (context) => StaffProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'inter',
          primarySwatch: Colors.red,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
