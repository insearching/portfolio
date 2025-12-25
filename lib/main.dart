import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/data/repository/portfolio_repository.dart';
import 'package:portfolio/main/domain/usecases/get_education_stream.dart';
import 'package:portfolio/main/domain/usecases/get_personal_info_stream.dart';
import 'package:portfolio/main/domain/usecases/get_positions_stream.dart';
import 'package:portfolio/main/domain/usecases/get_posts_stream.dart';
import 'package:portfolio/main/domain/usecases/get_projects_stream.dart';
import 'package:portfolio/main/domain/usecases/get_skills_stream.dart';
import 'package:portfolio/main/domain/usecases/refresh_all.dart';
import 'package:portfolio/main/ui/admin/admin_page.dart';
import 'package:portfolio/main/ui/portfolio/portfolio_bloc.dart';
import 'package:portfolio/main/ui/portfolio/portfolio_event.dart';
import 'package:portfolio/main/ui/responsive/desktop/desktop_scaffold.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_scaffold.dart';
import 'package:portfolio/main/ui/responsive/responsive_layout.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_scaffold.dart';
import 'package:portfolio/utils/theme.dart';
import 'package:portfolio/utils/theme_provider.dart';
import 'package:provider/provider.dart';

import 'core/platform/platform_config_factory.dart';
import 'firebase_options.dart';
import 'main/di/service_locator.dart';
import 'main/domain/model/device_info.dart';
import 'main/domain/model/device_type.dart';
import 'main/ui/components/app_error_widget.dart';
import 'utils/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize platform-specific configuration (e.g., URL strategy for web)
  final platformConfig = PlatformConfigFactory.create();
  await platformConfig.initialize();

  await EnvConfig.load();
  await setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get the logger instance
  final logger = locator<AppLogger>();

  // Set up global error handlers
  _setupErrorHandlers(logger);

  runApp(const RootProvider());
}

/// Sets up global error handlers for Flutter framework and rendering errors
void _setupErrorHandlers(AppLogger logger) {
  // Handle Flutter framework errors (including rendering errors)
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log the error with full details
    logger.error(
      _formatFlutterError(details),
      details.exception,
      details.stack,
      'FlutterError',
    );
  };

  // Replace the default error widget with our custom one
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const AppErrorWidget();
  };

  // Handle errors outside Flutter framework (async errors, etc.)
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error(
      'Uncaught platform error',
      error,
      stack,
      'PlatformError',
    );
    return true; // Indicates we handled the error
  };
}

/// Formats FlutterError details into a readable message
String _formatFlutterError(FlutterErrorDetails details) {
  final buffer = StringBuffer();

  // Add error summary
  buffer.write(details.exceptionAsString());

  // Add context information if available
  if (details.context != null) {
    buffer.write('\n');
    buffer.write(details.context!.toDescription());
  }

  // Add informationCollector details (like the widget that caused the error)
  if (details.informationCollector != null) {
    final information = details.informationCollector!();
    if (information.isNotEmpty) {
      buffer.write('\n');
      for (final info in information) {
        buffer.write(info.toDescription());
        buffer.write('\n');
      }
    }
  }

  return buffer.toString().trim();
}

DeviceType _getDeviceType(BuildContext context) {
  final size = MediaQuery.of(context).size;
  if (size.width > 1000) return DeviceType.desktop;
  if (size.width > 600) return DeviceType.tablet;
  return DeviceType.phone;
}

class RootProvider extends StatelessWidget {
  const RootProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final deviceType = _getDeviceType(context);

          // Initialize DeviceInfo in service locator
          setupDeviceInfo(deviceType);

          return Provider<DeviceInfo>(
            create: (_) => DeviceInfo(deviceType),
            child: const PortfolioApplication(),
          );
        },
      ),
    );
  }
}

class PortfolioApplication extends StatefulWidget {
  const PortfolioApplication({super.key});

  @override
  State<PortfolioApplication> createState() => _PortfolioApplicationState();
}

class _PortfolioApplicationState extends State<PortfolioApplication> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Create router once during initialization
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            final userName = context.select(
                    (PortfolioBloc bloc) => bloc.state.personalInfo?.title) ??
                'Portfolio';
            return ResponsiveLayout(
              mobileScaffold: MobileScaffold(
                name: userName,
                onMessageSend: (form) {},
              ),
              tabletScaffold: TabletScaffold(
                name: userName,
                onMessageSend: (form) {},
              ),
              desktopScaffold: DesktopScaffold(
                name: userName,
                onMessageSend: (form) {},
              ),
            );
          },
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminPage(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceInfo = Provider.of<DeviceInfo>(context);
    final isSmallDevice = deviceInfo.deviceType == DeviceType.phone;

    // Create the PortfolioBloc - it automatically loads data via streams
    // On web, force refresh to get the latest data from remote
    return BlocProvider(
      create: (context) {
        final bloc = PortfolioBloc(
          portfolioRepository: locator<PortfolioRepository>(),
          getEducationStream: locator<GetEducationStream>(),
          getProjectsStream: locator<GetProjectsStream>(),
          getPostsStream: locator<GetPostsStream>(),
          getPositionsStream: locator<GetPositionsStream>(),
          getSkillsStream: locator<GetSkillsStream>(),
          getPersonalInfoStream: locator<GetPersonalInfoStream>(),
          refreshAll: locator<RefreshAll>(),
          logger: locator<AppLogger>(),
        );
        // On web, force a refresh to bypass all caches
        if (kIsWeb) {
          bloc.add(const RefreshPortfolioData());
        }
        return bloc;
      },
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Select themes based on device type
          final darkTheme = isSmallDevice
              ? PortfolioTheme.phoneDarkTheme
              : PortfolioTheme.desktopDarkTheme;

          final lightTheme = isSmallDevice
              ? PortfolioTheme.phoneLightTheme
              : PortfolioTheme.desktopLightTheme;

          final isDark = themeProvider.themeMode == ThemeMode.dark ||
              (themeProvider.themeMode == ThemeMode.system &&
                  MediaQuery.platformBrightnessOf(context) == Brightness.dark);

          final currentTheme = isDark ? darkTheme : lightTheme;

          // Get userName from the bloc state or use a default
          final userName = context.select(
                  (PortfolioBloc bloc) => bloc.state.personalInfo?.title) ??
              'Portfolio';

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: currentTheme.scaffoldBackgroundColor,
              statusBarIconBrightness:
                  isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            ),
            child: MaterialApp.router(
              title: userName,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeProvider.themeMode,
              routerConfig: _router,
            ),
          );
        },
      ),
    );
  }
}
