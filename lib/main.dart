// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/pages/studio/sample_data.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hycop/hycop.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:logging/logging.dart';
import 'common/creta_constant.dart';
import 'common/cross_common_job.dart';
import 'routes.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  setupLogger();
  Logger.root.level = Level.FINER;
  HycopFactory.serverType = ServerType.firebase;
  await HycopFactory.initAll();

  SampleData.initSample();

  runApp(const ProviderScope(child: MainRouteApp()));
  //runApp(const ProviderScope(child: MainRouteApp()));
  //runApp(MyApp());
}

class MainRouteApp extends ConsumerStatefulWidget {
  const MainRouteApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainRouteAppState();
}

class _MainRouteAppState extends ConsumerState<MainRouteApp> {
  @override
  void initState() {
    super.initState();
    CrossCommonJob ccj = CrossCommonJob();
    CretaVariables.isCanvaskit = ccj.isInUsingCanvaskit();

    HycopFactory.realtime!.start();
    HycopFactory.realtime!.setPrefix('creta');

    saveManagerHolder = SaveManager();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Creta creates',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        //useMaterial3: true,
        //primaryColor: CretaColor.primary,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: CretaColor.primary,
          onPrimary: CretaColor.text[100]!,
          secondary: CretaColor.secondary,
          onSecondary: CretaColor.text[100]!,
          error: CretaColor.stateCritical,
          onError: CretaColor.text,
          background: Colors.white,
          onBackground: CretaColor.text,
          surface: Colors.yellow,
          onSurface: CretaColor.text,
        ),
        // sliderTheme: SliderThemeData(
        //   activeTickMarkColor: Colors.amber,
        //   showValueIndicator: ShowValueIndicator.never,
        // ),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(CretaColor.primary),
        ),
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        return routesLoggedOut;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}



/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.text_increase),
            onTap: () {
              Routemaster.of(context).push(AppRoutes.databaseExample);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.smart_button),
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.house),
            onTap: () {},
          ),
        ],
      ),
      // FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'not defined',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
