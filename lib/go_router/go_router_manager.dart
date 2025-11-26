import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/view/main/create_item_view.dart';
import 'package:pretty_good_secure_folder/view/main/edit_item_view.dart';
import 'package:pretty_good_secure_folder/view/main/main_view.dart';
import 'package:pretty_good_secure_folder/view/splash/splash.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainView(),
      ),
      GoRoute(
        path: '/create/:name',
        builder: (context, state) {
          final name = state.pathParameters['name'] ?? "";
          return CreateItemView(name: name,);
        },
      ),
      GoRoute(
        path: '/edit/:id',
        builder: (context, state) {
          final idString = state.pathParameters['id'] ?? "0";
          final id = int.parse(idString);
          return EditItemView(id: id,);
        },
      ),
    ],
  );
});
