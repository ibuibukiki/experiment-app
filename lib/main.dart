import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'screen/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<List<int>> selectedList = useState([]);
    final selectedCount = useState(0);
    final isMoving = useState(false);

    return MaterialApp(
      title: '俺のアプリ メモ',
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xffaec6f5),
          selectionColor: Color(0xffaec6f5),
          selectionHandleColor: Color(0xffaec6f5),
        ),
        fontFamily: 'Noto Sans JP',
      ),
      home: MainScreen(),
    );
  }
}
