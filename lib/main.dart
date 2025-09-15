
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/Appointment_Provider.dart';
import 'Provider/AuthProvider.dart';
import 'Provider/Booking_Provider.dart';
import 'Provider/EmergencyProvider.dart';
import 'Provider/Home_Provider.dart';
import 'Provider/InfoProvider.dart';
import 'Provider/Login_Provider.dart';
import 'Provider/MedDeliveryProvider.dart';
import 'Provider/News_Provider.dart';
import 'Provider/Profile_Provider.dart';
import 'Provider/ReBooking_Provider.dart';
import 'Provider/Splash_Provider.dart';
import 'Provider/SwitchUser_Provider.dart';
import 'Views/ForStaffs.dart';
import 'Views/Home.dart';
import 'Views/Login.dart';
import 'Views/Splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => RebookingProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => InfoProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
        ChangeNotifierProvider(create: (_) => StaffHomeProvider()),
        ChangeNotifierProvider(create: (_) => PackageProvider()),
        // ChangeNotifierProvider(create: (_) => OnlineProvider()),
        // ChangeNotifierProvider(create: (_) => OfflineProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KDCH',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (ctx) => SplashPage(),
          '/login': (ctx) => LoginPage(),
          '/home': (ctx) => HomePage(),
        },
      ),
    );
  }
}












