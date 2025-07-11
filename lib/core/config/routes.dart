import 'package:get/get.dart';

import '../../view/screen/details/details.dart';
import '../../view/screen/home/home.dart';
import '../../view/screen/note.dart';
import '../../view/screen/search.dart';
import '../bindings/details_bindings.dart';
import '../bindings/home_bindings.dart';
import '../bindings/note_bindings.dart';

class AppRoutes {
  static GetPage home = GetPage(
    name: '/home',
    page: () => Home(),
    binding: HomeBindings(),
  );
  static GetPage details = GetPage(
    name: '/details',
    page: () => Details(),
    binding: DetailsBindings(),
  );

  static GetPage search = GetPage(
    name: '/search',
    page: () => SearchPage(),
  );

  static GetPage note = GetPage(
    name: '/note',
    page: () => Note(),
    binding: NoteBindings(),
  );
}
