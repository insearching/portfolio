enum SocialInfo {
  linkedin(
    url: 'https://www.linkedin.com/in/serhii-hrabas/',
    icon: 'assets/img/linkedin.png',
  ),
  github(url: 'https://github.com/insearching', icon: 'assets/img/github.png'),
  medium(url: 'https://medium.com/@graser1305', icon: 'assets/img/medium.png');

  final String url;
  final String icon;

  const SocialInfo({required this.url, required this.icon});
}
