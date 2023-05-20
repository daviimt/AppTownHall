import 'package:townhall/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:townhall/providers/report_form_provider.dart';
import 'package:townhall/screens/manager_screen.dart';
import 'package:townhall/screens/newAppointmentScreen.dart';
import 'package:townhall/screens/newReportScreen.dart';
import 'package:townhall/screens/prueba.dart';
import 'package:townhall/screens/report_screen.dart';

import 'package:townhall/screens/screens.dart';
import 'package:townhall/screens/update_screen.dart';
import 'package:townhall/services/appointmentService.dart';
import 'package:townhall/services/services.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => UserService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => VerifyService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => AppointmentService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ReportFormProvider(),
          lazy: false,
        ),
        // ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      offline: LoadingScreen(),
      // ignore: avoid_print
      whenOffline: () => LoadingScreen,
      // ignore: avoid_print
      whenOnline: () => print('Connected to internet'),
      loadingWidget: Center(child: Text('Loading')),
      online: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'townhall',
        initialRoute: 'login',
        onGenerateRoute: (settings) {
          if (settings.name == 'newreportscreen') {
            final int id = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => NewReportScreen(idAppointment: id),
            );
          }
          return null;
        },
        routes: {
          'home': (_) => const HomeScreen(),
          'login': (_) => LoginScreen(),
          'register': (_) => RegisterScreen(),
          'updatescreen': (_) => const UpdateScreen(),
          'userscreen': (_) => const UserScreen(),
          'managerscreen': (_) => const ManagerScreen(),
          'newappointmentscreen': (_) => const NewAppointmentScreen(),
          'reportscreen': (_) => const ReportScreen(),
        },
        scaffoldMessengerKey: NotificationsService.messengerKey,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey[300],
            appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.indigo, elevation: 0)),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'townhall',
//       initialRoute: 'login',
//       routes: {
//         'checking': (_) => CheckAuthScreen(),
//         'home': (_) => HomeScreen(),
//         'login': (_) => LoginScreen(),
//         'register': (_) => RegisterScreen(),
//         'admin': (_) => AdminScreen(),
//       },
//       scaffoldMessengerKey: NotificationsService.messengerKey,
//       theme: ThemeData.light().copyWith(
//           scaffoldBackgroundColor: Colors.grey[300],
//           appBarTheme: AppBarTheme(elevation: 0, color: Colors.indigo),
//           floatingActionButtonTheme: FloatingActionButtonThemeData(
//               backgroundColor: Colors.indigo, elevation: 0)),
//     );
//   }
// }
