import 'package:collection/collection.dart';

enum NavigationMenu {
  home(position: 0, name: 'Home', icon: 'assets/img/home.png'),
  features(position: 1, name: 'Features', icon: 'assets/img/features.png'),
  portfolio(position: 2, name: 'Portfolio', icon: 'assets/img/home.png'),
  resume(position: 3, name: 'Resume', icon: 'assets/img/home.png'),
  // clients(name: 'Clients', icon: 'assets/img/home.png'),
  // pricing(name: 'pricing', icon: 'assets/img/home.png'),
  // blog(name: 'blog', icon: 'assets/img/home.png'),
  contact(position: 4, name: 'Contacts', icon: 'assets/img/home.png');

  final int position;
  final String name;
  final String icon;

  const NavigationMenu({
    required this.position,
    required this.name,
    required this.icon
  });

  static NavigationMenu? keyByPosition(int position) {
    return NavigationMenu.values.firstWhereOrNull((key) => key.position == position);
  }
}