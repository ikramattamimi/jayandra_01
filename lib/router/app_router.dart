import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/screens/add_device_screen.dart';
import 'package:jayandra_01/screens/main_screen.dart';

class AppRouter {
  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        builder: (BuildContext context, GoRouterState state) =>
            const MainScreen(),
        routes: <GoRoute>[
          GoRoute(
            path: "page2",
            name: "add_device",
            builder: (BuildContext context, GoRouterState state) =>
                const AddDevice(),
          ),
        ],
      ),
    ],
  );
}
