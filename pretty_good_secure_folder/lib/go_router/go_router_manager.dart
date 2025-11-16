import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/view/create_item_view.dart';
import 'package:pretty_good_secure_folder/view/main_view.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainView(),
      ),
      GoRoute(
        path: '/create/:name',
        builder: (context, state) => CreateItemView(name: state.pathParameters['name']!),
      ),
      GoRoute(
        path: '/edit/:id',
        builder: (context, state) => CreateItemView(id: state.pathParameters['id']!),
      ),
    ],
  );
});
