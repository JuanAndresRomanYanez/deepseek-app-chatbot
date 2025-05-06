import 'package:deepseek_app/presentation/views/views.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/chats',
  routes: [
    // Shell con solo 5 ramas (excluimos settings)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => HomeView(currentChild: navigationShell),
      branches: [
        // Chats
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/chats', 
              builder: (context, state) => const ChatbotView()
            ),
          ]
        ),
        // Offline
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/offline', 
              builder: (context, state) => const OfflineSearchView()
            ),
        ]),
        // Audio
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/audio', 
              builder: (context, state) => const AudioRecordView()
            ),
        ]),
        // Multimedia
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/multimedia', 
              builder: (context, state) => const MultimediaView()
            ),
        ]),
        // Papelera
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/recycle', 
              builder: (context, state) => const RecycleBinView()
            ),
        ]),
      ],
    ),

    // Ruta independiente para Settings
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsView(),
    ),
  ],
);
