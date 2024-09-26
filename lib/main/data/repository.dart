import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/data/skill.dart';
import 'package:portfolio/main/ui/socials.dart';

class Repository {
  static const List<Project> projects = [
    Project(
      image: 'assets/img/sbb-app.jpg',
      title: 'Kontrolle app for SBB trains',
      role: 'Senior Android developer',
      description: 'Сotroller app for one of the largest train companies in '
          'Switzerland. Developing app that allows to validate and control'
          'tickets and passes in trains, buses and boats.',
    ),
    Project(
      image: 'assets/img/sumex.png',
      title: 'Sumex Insurance app',
      role: 'Senior Android developer',
      description: 'Android SDK library for Insurances company. Created project from '
          'scratch starting from architecture decision up to discussing some of the '
          'basics of integrated SDK. Implemented all BL and design and made'
          'SDK fully configurable from outside.',
      link: 'https://play.google.com/store/apps/details?id=ch.oekk2.dip',
    ),
    Project(
        image: 'assets/img/medically-home.png',
        title: 'Medically Home',
        role: 'Senior Flutter developer',
        description: 'Medically Home app for treating patients online. Allows to '
            'communicate patients with doctor and nurses via online '
            'appointments, track vital signs with the help of BLE devices and '
            'schedule series of appointments for a laboratory tests.',
        link: 'https://medicallyhome.com/landing/'),
    Project(
      image: 'assets/img/cashplus.jpg',
      title: 'Cashplus. Banking App',
      role: 'Senior Android developer',
      description: 'Fintech project. Banking application for UK users. '
          'Banking app which allows to open a business or personal bank '
          'account in a minutes.',
      link: 'https://play.google.com/store/apps/details?id=co.uk.mycashplus.maapp',
    ),
    Project(
      image: 'assets/img/daimler-app.png',
      title: 'Daimler app',
      role: 'Senior Android developer',
      description: 'Senior Android developer',
    ),
    Project(
      image: 'assets/img/minimed.jpg',
      title: 'MiniMed medical app',
      role: 'Middle Android developer',
      description: 'MiniMed - Medical project targeted on diabetes people. '
          'With the MiniMed Mobile app, it is possible to display key insulin pump '
          'and CGM data right on the smartphone. The app transfers data from '
          'insulin pump as well as CGM data to better understand glucose levels '
          'and review its history. App allows to see how levels are trending. '
          'Automatic data uploads to the server make sharing of data with care '
          'partners as easy as it can be.',
      link:
          'https://play.google.com/store/apps/details?id=com.medtronic.diabetes.minimedmobile.eu&hl=en',
    ),
    Project(
      image: 'assets/img/mechanic-advisor.jpg',
      title: 'Mechanic Advisor',
      role: 'Android developer',
      description: 'My Mechanic from Mechanic Advisor helps monitor, '
          'fix and maintain vehicle’s health in real-time, '
          'right from the smartphone. '
          'In tandem with an OBD-II telematics device, '
          'My Mechanic keeps track of scheduled maintenance, '
          'diagnoses check engine lights for you, and if you need one, '
          'finds a great mechanic in your area. Every time you open the app, '
          'you’ll have immediate knowledge of your vehicle’s health, '
          'and what you can do to improve it',
      link:
          'https://play.google.com/store/apps/details?id=com.mechanicadvisor.mymechanic&hl=en',
    ),
    Project(
      image: 'assets/img/unlimited-biking.jpg',
      title: 'Unlimited Biking',
      role: 'Android developer',
      description: 'The main purpose of the app is to rent a bike through the service in '
          'any point of the desired city. After user completes registration and '
          'chose payment method he is able to chose one of the few available '
          'plans for renting bicycle. Plans include different hour rates. Then user '
          'choose departing point, arrival point and amount of hours to rent so '
          'that his bike would be available for ride.',
      link:
          'https://play.google.com/store/apps/details?id=com.unlimitedbiking.android&hl=en',
    ),
  ];

  static const List<Skill> skills = [
    Skill(title: "Android SDK", value: 90),
    Skill(title: "Java", value: 90),
    Skill(title: "Kotlin", value: 90),
    Skill(title: "Android Jetpack Component", value: 56),
    Skill(title: "Android", value: 56),
    Skill(title: "Android", value: 56),
    Skill(title: "Android", value: 56),
  ];

  static const info = PersonalInfo(
    image: 'assets/img/development.jpg',
    title: 'Serhii Hrabas',
    description: 'Senior Android developer \n'
        'I am available for freelance work. Connect with me via email or socials.\n'
        'Email: kerboserhii@gmail.com\n'
        'Connect with me\n',
    email: 'kerboserhii@gmail.com',
    socials: SocialInfo.values,
  );
}
