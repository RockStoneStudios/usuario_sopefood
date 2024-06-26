import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/firebase_options.dart';
import 'package:sopefoodusuario/models/environment.dart';
import 'package:sopefoodusuario/services/notification_service.dart';
import 'package:sopefoodusuario/views/auth/verification_page.dart';
import 'package:sopefoodusuario/views/entrypoint.dart';
import 'package:sopefoodusuario/views/orders/order_details_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sopefoodusuario/dialogs/location_permission_dialog.dart';

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print(
      "onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Widget defaultHome = MainScreen();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: Environment.fileName);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  await NotificationService().initialize(flutterLocalNotificationsPlugin);

  runApp(const BetterFeedback(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');
    bool? verification = box.read("verification");

    if (token != null && verification == false) {
      defaultHome = const VerificationPage();
    } else if (token != null && verification == true) {
      defaultHome = MainScreen();
    }
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 825),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Foodly Delivery App',
            theme: ThemeData(
              scaffoldBackgroundColor: Color(kOffWhite.value),
              iconTheme: IconThemeData(color: Color(kDark.value)),
              primarySwatch: Colors.grey,
            ),
            home: FutureBuilder<PermissionStatus>(
              future: Permission.locationWhenInUse.status,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasData) {
                  final permissionStatus = snapshot.data!;
                  if (permissionStatus.isDenied) {
                    return LocationPermissionDialog(defaultHome: defaultHome);
                  } else {
                    return defaultHome;
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
            navigatorKey: navigatorKey,
            routes: {
              '/order_details_page': (context) => const OrderDetailsPage(),
            },
          );
        });
  }
}
