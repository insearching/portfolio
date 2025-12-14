import 'package:portfolio/main/data/personal_info.dart';

class Repository {
  static const info = PersonalInfo(
    image: 'assets/img/development.jpg',
    title: 'Serhii Hrabas',
    description: 'Senior Android developer \n'
        'I am available for freelance work. Connect with me via email or socials.\n'
        'Email: hrabas.serhii@gmail.com\n'
        'Connect with me\n',
    email: 'hrabas.serhii@gmail.com',
    socials: SocialInfo.values,
  );
}
