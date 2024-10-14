import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/data/skill.dart';

class Repository {
  static const List<Project> projects = [
    Project(
      image: 'assets/img/loro-sst.jpeg',
      title: 'LoroPlay SST',
      role: 'Architect Android developer',
      description: 'Architected and developed a comprehensive Android betting application '
          'for Self-Service Terminals, enabling real-time game observation and online betting. '
          'The app integrates with external hardware via an external SDK, ensuring seamless '
          'communication between the terminal and peripheral devices, while maintaining a '
          'scalable and high-performance architecture.',
      link: 'https://www.loro.ch/fr',
    ),
    Project(
      image: 'assets/img/loro-retail.jpeg',
      title: 'Loterie Romande Retail app',
      role: 'Architect Android developer',
      description: 'Managed a live production betting application used by thousands of '
          'users in Switzerland for online betting. Significantly increased the number of '
          'crash-free users, improving the app\'s overall stability.',
      link: 'https://jeux.loro.ch/apps',
    ),
    Project(
      image: 'assets/img/sbb-app.jpg',
      title: 'Kontrolle app for SBB trains',
      role: 'Senior Android developer',
      description: 'The SBB Controller Android app is designed for validating and managing '
          'tickets and passes for various modes of transport, including trains, buses, '
          'and boats in Switzerland. It enables conductors and ticket inspectors to'
          ' quickly and efficiently verify passenger tickets, ensuring compliance '
          'and enhancing the travel experience.',
    ),
    Project(
      image: 'assets/img/sumex.png',
      title: 'Sumex Insurance app',
      role: 'Senior Android developer',
      description: 'The Android SDK library for an insurance company is designed to be '
          'easily configurable through a configuration file and can be installed from '
          'the Maven repository. Its main feature is the ability to scan insurance '
          'documents and upload them to a configured API server, streamlining the '
          'management of policies, claims, and user data for other apps.',
      link: 'https://play.google.com/store/apps/details?id=ch.oekk2.dip',
    ),
    Project(
        image: 'assets/img/medically-home.png',
        title: 'Medically Home',
        role: 'Senior Flutter developer',
        description: 'Medically Home is a healthcare technology company that provides '
            'solutions to enable patients to receive hospital-level care in the comfort '
            'of their homes. By leveraging a combination of advanced technology, clinical '
            'protocols, and a distributed care team model, Medically Home allows '
            'healthcare systems to extend care beyond traditional hospital settings.'),
    Project(
      image: 'assets/img/cashplus.jpg',
      title: 'Cashplus. Banking App',
      role: 'Senior Android developer',
      description: 'The Cashplus Android app allows users to manage their prepaid cards '
          'and banking services. Users can view account balances, track transactions, '
          'transfer money, and pay bills. It provides secure login with biometric options, '
          'delivers a smooth and responsive interface, and integrates with APIs for '
          'real-time data. The app is designed for reliable performance across different '
          'devices while ensuring user data privacy and security.',
      link: 'https://play.google.com/store/apps/details?id=co.uk.mycashplus.maapp',
    ),
    Project(
      image: 'assets/img/daimler-app.png',
      title: 'Daimler app',
      role: 'Senior Android developer',
      description: 'The Daimler Mercedes PRO B2B project is a digital platform focused on '
          'optimizing fleet management for businesses. It provides real-time vehicle tracking, '
          'predictive maintenance, fuel monitoring, and driver behavior analysis, '
          'helping companies reduce downtime, cut costs, and improve overall efficiency. '
          'The platform ensures compliance with safety standards and offers fleet managers '
          'valuable insights for making data-driven decisions. The Android app plays a crucial '
          'role by acting as a mobile interface for fleet managers and drivers, allowing '
          'them to access vehicle data, receive notifications, and manage operations on '
          'the go. It enhances connectivity and enables real-time monitoring, making fleet '
          'management more accessible and efficient.',
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

  static List<Skill> skills = [
    Skill.hard("Android SDK", 90),
    Skill.hard("Java", 80),
    Skill.hard("Kotlin", 85),
    Skill.hard("Android Jetpack Component", 65),
    Skill.hard("REST", 70),
    Skill.hard("BLE", 50),

    Skill.soft("English", 75),
    Skill.soft("Spanish", 23),
    Skill.soft("Communication", 80),
    Skill.soft("Problem Solving", 76),
    Skill.soft("Time management", 73),
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

  static const List<Education> educationInfo = [
    Education(
      title: 'Bachelor\'s degree in Software engineering.',
      description: 'Ternopil State Ivan Pul\'uj Technical University',
      type: EducationType.college,
      text: 'A solid foundation in computer science and software development with a focus '
          'on programming languages, algorithms, data structures, object-oriented design (OOD), '
          'software design, and engineering principles. This education provided expertise '
          'in building scalable, efficient, and well-structured software solutions, '
          'equipping the learner with the skills to tackle real-world development challenges.',),
    Education(
      title: 'Master\'s degree in Software engineering.',
      description: 'Ternopil State Ivan Pul\'uj Technical University',
      type: EducationType.college,
      text: 'Advanced studies with a strong focus on research and innovation in software '
          'development, system architecture, and engineering methodologies. Key areas of '
          'research included optimization of algorithms, data structures, and scalable '
          'system design. The program fostered a deep understanding of emerging '
          'technologies and problem-solving through hands-on projects and academic '
          'research, preparing for leadership roles in both research and complex '
          'software development environments.',),
    Education(
      title: 'Software Architecture & Design of Modern Large Scale Systems',
      description: 'Top Developer Academy LLC',
      type: EducationType.certification,
      link: 'https://www.udemy.com/certificate/UC-b6267e86-54cd-4e56-a085-fdc3824e6b0e/',
      imageUrl: 'https://udemy-certificate.s3.amazonaws.com/image/UC-b6267e86-54cd-4e56-a085-fdc3824e6b0e.jpg?v=1726160655000',
    ),
  ];
}
