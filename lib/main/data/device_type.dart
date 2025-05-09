enum DeviceType {
  desktop,
  tablet,
  phone;

  bool get isLargeScreen => this == DeviceType.desktop || this == DeviceType.tablet;
}

