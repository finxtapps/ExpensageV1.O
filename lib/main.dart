import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expensag/providerListner/DashboardProvider.dart';
import 'package:expensag/providerListner/addTransactionProvider.dart';
import 'package:expensag/providerListner/profile_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'Api_Services/notification_storage.dart';
import 'Screens/GuestHomeScreen.dart';
import 'providerListner/theme_notifier.dart';
import 'providerListner/currency_notifier.dart';
import 'component/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Screens
import 'Screens/splash_Screen.dart';
import 'Screens/Landing_page.dart';
import 'Screens/wrapper.dart';
import 'Screens/notification_Screen.dart';
import 'Screens/expense_analysis_screen.dart';
import 'Screens/personal_information.dart';
import 'Screens/profile_Information.dart';
import 'Screens/setting_Screen.dart';
import 'Screens/SignIn_Screen.dart';
import 'Screens/SignUpScreen.dart';
import 'Screens/currency_select_Screen.dart';
import 'Screens/create_Pin_Screen.dart';
import 'Screens/set_pin_and_fingerprint_Screen.dart';
import 'Screens/Select_Location_Screen.dart';
import 'Screens/scan_Fingerprint_screen.dart';
import 'Screens/incomeTax&Expenses_help_Screen.dart';
import 'Screens/IncomeTaxHelpForm.dart';
import 'Screens/ExpenseHelpForm.dart';
import 'Screens/FingerprintVerifyUIScreen.dart';
import 'Screens/PinVerifyUIScreen.dart';
import 'Screens/chnagePinScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';










Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();

  String title = message.notification?.title ?? message.data['title'] ?? "Notification";
  String body = message.notification?.body ?? message.data['body'] ?? "";

  await NotificationStorage.saveNotification(
    title: title,
    body: body,
  );

  print("Background Message: $title");

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      channelKey: 'basic_channel',
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,
      // background handle me data use karna better hota hai
      payload: Map<String, String>.from(message.data),
    ),
  );
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    print("Notification Action Received: ${receivedAction.title}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  // Background notification
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // Awesome Notification
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel',
        importance: NotificationImportance.Max,
        defaultColor: const Color(0xFFD44D5C),
        ledColor: Colors.white,
        channelShowBadge: true,
      ),
    ],
  );

  // Set Awesome Notification listeners
  await AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
    onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
    onDismissActionReceivedMethod: NotificationController.onDismissActionMethod,
  );

  // Awesome permission
  bool isAllowed =
  await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowed) {
    await AwesomeNotifications()
        .requestPermissionToSendNotifications();
  }

  // Firebase notification permission
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // FCM Token
  String? token =
  await FirebaseMessaging.instance.getToken();

  print("FCM TOKEN => $token");

  // Foreground notification
  FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {

      print(
          "Foreground Message => ${message.notification?.title}");

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          channelKey: 'basic_channel',
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
        ),
      );
    },
  );

  // Notification Click
  FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
      print("Notification Clicked");
    },
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('ar'),
        Locale('fr'),
        Locale('de'),
        Locale('es'),
        Locale('zh'),
        Locale('ja'),
      ],
      path: 'assets/translation',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [

          ChangeNotifierProvider(
            create: (_) => DashboardProvider(),
          ),

          ChangeNotifierProvider(
              create: (_) => TransactionProvider()),
          ChangeNotifierProvider(
            create: (_) {
              final themeProvider = ThemeProvider();
              themeProvider.init();
              return themeProvider;
            },
          ),
          ChangeNotifierProvider(
            create: (_) {
              final currencyNotifier =
              CurrencyNotifier();
              currencyNotifier.init();
              return currencyNotifier;
            },
          ),
          ChangeNotifierProvider(
              create: (_) => ProfileNotifier()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) {
        return MaterialApp(
          navigatorObservers: [routeObserver],
          debugShowCheckedModeBanner: false,

          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,

          theme: context.watch<ThemeProvider>().themeData,

          routes: {
            '/': (_) => SplashScreen(),
            '/landingpage': (_) => LandingPage(),
            '/home': (_) => MainScreenWrapper(),
            '/notification': (_) => NotificationsScreen(),
            '/analytics': (_) => ExpenseAnalysisScreen(),
            '/personal': (_) => PersonalInformation(),
            '/profile': (_) => ProfileInfoScreen(),
            '/settings': (_) => SettingsScreen(),
            '/signin': (_) => SignInScreen(),
            '/signup': (_) => SignUpScreen(),
            '/currency_select': (_) => CurrencySelectScreen(),
            '/pin': (_) => MpinScreen(),
            '/set_pin_and_fingerprint': (_) => SetPinAndFingerprintScreen(),
            '/location': (_) => LocationScreen(),
            '/fingerprint': (_) => ScanFingerprintScreen(),
            '/incomeTaxHelp': (_) => Money_Help_Option_screen(),
            '/incomeTaxForm': (_) => IncomeTextHelpForm(),
            '/expenseHelp': (_) => HelpInManageExpenseForm(),
            '/varifyFingerPrint': (_) => FingerprintVerifyUIScreen(),
            '/varifyPin': (_) => PinVerifyUIScreen(),
            '/changePin': (_) => ChangeMpinScreen(),
            '/guestHomeScreen': (_) => GuestHomeScreen(),
            // 'addTransaction': (_) => AddTransactionScreen(),'
          },
        );
      },
    );
  }
}

