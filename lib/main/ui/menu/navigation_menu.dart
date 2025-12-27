import 'package:collection/collection.dart';

enum NavigationMenu {
  home(position: 0, name: 'Home', icon: 'assets/icons/home.png'),
  blog(position: 1, name: 'Blog', icon: 'assets/icons/blog.png'),
  features(position: 2, name: 'Features', icon: 'assets/icons/features.png'),
  portfolio(position: 3, name: 'Portfolio', icon: 'assets/icons/portfolio.png'),
  resume(position: 4, name: 'Resume', icon: 'assets/icons/resume.png'),
  contact(position: 5, name: 'Contacts', icon: 'assets/icons/contact.png');

  final int position;
  final String name;
  final String icon;

  const NavigationMenu({
    required this.position,
    required this.name,
    required this.icon,
  });

  static NavigationMenu? keyByPosition(int position) {
    return NavigationMenu.values
        .firstWhereOrNull((key) => key.position == position);
  }
}
