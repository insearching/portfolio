class PersonalInfo {
  final String image;
  final String title;
  final String description;
  final String email;
  final List<SocialInfo> socials;

  const PersonalInfo({
    required this.image,
    required this.title,
    required this.description,
    required this.email,
    required this.socials,
  });
}

enum SocialInfo {
  linkedin(url: 'https://www.linkedin.com/in/serhii-hrabas/', icon: 'assets/img/linkedin.png'),
  facebook(url: 'https://www.facebook.com/insearching1234', icon: 'assets/img/facebook.png'),
  twitter(url: 'https://twitter.com/HrabasSerhii', icon: 'assets/img/twitter.png');

  final String url;
  final String icon;

  const SocialInfo({required this.url, required this.icon});
}