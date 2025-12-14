import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/bloc/portfolio_bloc.dart';
import 'package:portfolio/main/bloc/portfolio_event.dart';
import 'package:portfolio/main/data/repository/portfolio_repository.dart';
import 'package:portfolio/main/domain/usecases/get_education_stream.dart';
import 'package:portfolio/main/domain/usecases/get_positions_stream.dart';
import 'package:portfolio/main/domain/usecases/get_posts_stream.dart';
import 'package:portfolio/main/domain/usecases/get_projects_stream.dart';
import 'package:portfolio/main/domain/usecases/get_skills_stream.dart';
import 'package:portfolio/main/domain/usecases/refresh_all.dart';
import 'package:portfolio/main/ui/responsive/desktop/desktop_scaffold.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_scaffold.dart';
import 'package:portfolio/main/ui/responsive/responsive_layout.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_scaffold.dart';
import 'package:portfolio/utils/theme.dart';
import 'package:portfolio/utils/theme_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'main/data/device_info.dart';
import 'main/data/device_type.dart';
import 'main/service_locator.dart';
import 'main/ui/components/app_error_widget.dart';
import 'utils/env_config.dart';

void main() async {
  ErrorWidget.builder = (_) => const AppErrorWidget();
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.load();
  await setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const RootProvider());
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

          return Provider<DeviceInfo>(
            create: (_) => DeviceInfo(deviceType),
            child: const PortfolioApplication(),
          );
        },
      ),
    );
  }
}

class PortfolioApplication extends StatelessWidget {
  const PortfolioApplication({super.key});

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
          refreshAll: locator<RefreshAll>(),
        );
        // On web, force a refresh to bypass all caches
        if (kIsWeb) {
          bloc.add(const RefreshPortfolioData());
        }
        return bloc;
      },
      child: Builder(
        builder: (context) {
          // Get userName from the bloc state or use a default
          final userName = context.select(
                  (PortfolioBloc bloc) => bloc.state.personalInfo?.title) ??
              'Portfolio';

          return Consumer<ThemeProvider>(
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
                      MediaQuery.platformBrightnessOf(context) ==
                          Brightness.dark);

              final currentTheme = isDark ? darkTheme : lightTheme;

              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: currentTheme.scaffoldBackgroundColor,
                  statusBarIconBrightness:
                      isDark ? Brightness.light : Brightness.dark,
                  statusBarBrightness:
                      isDark ? Brightness.dark : Brightness.light,
                ),
                child: MaterialApp(
                  title: userName,
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: themeProvider.themeMode,
                  home: ResponsiveLayout(
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
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
