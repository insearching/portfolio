enum DeviceType {
  desktop,
  tablet,
  phone;

  bool get isLargeScreen =>
      this == DeviceType.desktop || this == DeviceType.tablet;

  bool get isSmallDevice =>
      this == DeviceType.phone || this == DeviceType.tablet;
}
