enum DeviceType {
  desktop,
  tablet,
  phone;

  bool get isDesktop => this == DeviceType.desktop;

  bool get isTablet => this == DeviceType.tablet;

  bool get isPhone => this == DeviceType.phone;

  bool get isSmallDevice =>
      this == DeviceType.phone || this == DeviceType.tablet;
}
