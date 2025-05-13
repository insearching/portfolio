import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/data/responsibility.dart';
import 'package:portfolio/main/data/skill.dart';

class Repository {
  static const List<Responsibility> responsibilities = [
    Responsibility(
      icon: 'assets/img/android.png',
      title: 'Android development',
      description: 'I’m an Android developer with over 10 years of hands-on '
          'experience building apps that are not only functional but truly '
          'enjoyable to use. I’ve worked across a range of industries—from '
          'automotive to healthcare to e-commerce—and each project has pushed '
          'me to grow, adapt, and keep learning.\n\n'
          'One of the highlights of my career was leading the development of '
          'the LoroPlay SST solution. It started from scratch, and I was there '
          'for every step—designing the architecture, writing the core code, '
          'and making sure the final product was solid, smooth, and ready for '
          'real users. I’ve also contributed to large-scale projects like '
          'Daimler Mercedes PRO B2B and Medtronic, where attention to detail, '
          'clean architecture, and long-term maintainability were essential.\n\n'
          'I’m most comfortable working with Kotlin and Java, using Jetpack '
          'Compose and modern architectures like MVVM and MVI. I care deeply '
          'about clean code, smart design patterns, and writing tests that '
          'actually catch problems before users do. I’m also a big believer '
          'in collaboration—I enjoy working closely with designers, product '
          'managers, and fellow developers to bring ideas to life.\n\n'
          'Beyond the tech, I’m someone who takes initiative, communicates '
          'clearly, and genuinely enjoys solving problems. Whether it\'s '
          'mentoring a teammate, untangling a tricky bug, or refining a feature '
          'until it feels just right, I’m always up for the challenge.',
    ),
    Responsibility(
      icon: 'assets/img/flutter.png',
      title: 'Flutter development',
      description: ' I’ve been focused on building cross-platform apps using '
          'Flutter. What drew me to Flutter was the ability to create beautiful, '
          'high-performance applications from a single codebase—without '
          'compromising on user experience or responsiveness.'
          'I’ve had the chance to work on several real-world Flutter projects '
          'where I was involved in everything from setting up the app architecture '
          'to refining animations and optimizing performance. I follow best '
          'practices like BLoC and clean architecture, and I’m confident working '
          'with REST APIs, local databases, state management, and testing. '
          'I also enjoy integrating native platform features when needed, '
          'making sure each app feels smooth and native on both Android and iOS.\n\n'
          'What I enjoy most about Flutter is how quickly it lets me bring ideas '
          'to life—and how it pushes me to think creatively about UI and UX. '
          'I take pride in writing maintainable, well-tested code and '
          'collaborating closely with designers, backend developers, and product '
          'teams to make sure the final product delivers real value.\n\n'
          'I’m proactive, detail-oriented, and always curious about new tools '
          'and techniques that can make apps better. Whether I’m leading a new '
          'project or jumping in to help polish the last 10%, I bring the same '
          'energy and care to every line of code. By the way, this portfolio was'
          'create with Flutter as well.',
    ),
    Responsibility(
      icon: 'assets/img/kmp.png',
      title: 'KMP development',
      description: 'I’ve been focused on building cross-platform apps and '
          'recently shifted my attention to Kotlin Multiplatform (KMP). '
          'What excites me about KMP is its ability to share core business '
          'logic across Android, iOS, and even backend platforms—while still '
          'allowing for platform-specific UI and native performance. It offers '
          'the flexibility and power I value as a developer, especially when '
          'building scalable and maintainable solutions.\n\n'
          'Currently, I\'m working on a personal pet project that parses RSS '
          'feeds using KMP. This project has been a great opportunity to deepen '
          'my understanding of shared code architecture, asynchronous data '
          'handling with coroutines, and modular app design. I\'m really enjoying'
          'the challenge and am eager to leverage this knowledge in a real production'
          'environment.\n\n'
          'In my previous cross-platform work, I built several Flutter '
          'applications where I handled everything from setting up architecture '
          'to optimizing animations and performance. That experience taught me '
          'the importance of clean architecture, solid state management, and '
          'writing testable, maintainable code—skills I now bring into my work '
          'with KMP.\n\n'
          'I’m proactive, detail-oriented, and always looking to explore tools '
          'and practices that improve development efficiency and product'
          'quality. Whether I’m starting a new feature or helping refine the '
          'final polish, I bring the same care and commitment to every line '
          'of code.',
    )
  ];
  static const List<Project> projects = [
    Project(
      image: 'assets/img/loro-sst.jpeg',
      title: 'LoroPlay SST',
      role: 'Architect Android developer',
      description:
          'Architected and developed a comprehensive Android betting application '
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
      description:
          'Managed a live production betting application used by thousands of '
          'users in Switzerland for online betting. Significantly increased the number of '
          'crash-free users, improving the app\'s overall stability.',
      link: 'https://jeux.loro.ch/apps',
    ),
    Project(
      image: 'assets/img/sbb-app.jpg',
      title: 'Kontrolle app for SBB trains',
      role: 'Senior Android developer',
      description:
          'The SBB Controller Android app is designed for validating and managing '
          'tickets and passes for various modes of transport, including trains, buses, '
          'and boats in Switzerland. It enables conductors and ticket inspectors to'
          ' quickly and efficiently verify passenger tickets, ensuring compliance '
          'and enhancing the travel experience.',
    ),
    Project(
      image: 'assets/img/sumex.png',
      title: 'Sumex Insurance app',
      role: 'Senior Android developer',
      description:
          'The Android SDK library for an insurance company is designed to be '
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
        description:
            'Medically Home is a healthcare technology company that provides '
            'solutions to enable patients to receive hospital-level care in the comfort '
            'of their homes. By leveraging a combination of advanced technology, clinical '
            'protocols, and a distributed care team model, Medically Home allows '
            'healthcare systems to extend care beyond traditional hospital settings.'),
    Project(
      image: 'assets/img/cashplus.jpg',
      title: 'Cashplus. Banking App',
      role: 'Senior Android developer',
      description:
          'The Cashplus Android app allows users to manage their prepaid cards '
          'and banking services. Users can view account balances, track transactions, '
          'transfer money, and pay bills. It provides secure login with biometric options, '
          'delivers a smooth and responsive interface, and integrates with APIs for '
          'real-time data. The app is designed for reliable performance across different '
          'devices while ensuring user data privacy and security.',
      link:
          'https://play.google.com/store/apps/details?id=co.uk.mycashplus.maapp',
    ),
    Project(
      image: 'assets/img/daimler-app.png',
      title: 'Daimler app',
      role: 'Senior Android developer',
      description:
          'The Daimler Mercedes PRO B2B project is a digital platform focused on '
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
      description:
          'The main purpose of the app is to rent a bike through the service in '
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
      title: 'Master\'s degree in Software engineering.',
      description: 'Ternopil State Ivan Pul\'uj Technical University',
      type: EducationType.college,
      text:
          'Advanced studies with a strong focus on research and innovation in software '
          'development, system architecture, and engineering methodologies. Key areas of '
          'research included optimization of algorithms, data structures, and scalable '
          'system design. The program fostered a deep understanding of emerging '
          'technologies and problem-solving through hands-on projects and academic '
          'research, preparing for leadership roles in both research and complex '
          'software development environments.',
    ),
    Education(
      title: 'Kotlin for Java Developers',
      description: 'Jetbrains',
      type: EducationType.certification,
      link: 'https://coursera.org/verify/SS7W8VWU974B',
      imageUrl: 'assets/certificates/coursera_kotlin.jpeg',
    ),
    Education(
      title: 'Java Data Structures & Algorithms + LEETCODE Exercises',
      description: 'Scott Barrett',
      type: EducationType.certification,
      link:
          'https://www.udemy.com/certificate/UC-1e9be320-0ebd-459f-b1a5-79575071d3fb/',
      imageUrl: 'assets/certificates/java_data_structures.jpg',
    ),
    Education(
      title: 'Kotlin Coroutines and Flow for Android Development',
      description: 'Lukas Lechner',
      type: EducationType.certification,
      link:
          'https://www.udemy.com/certificate/UC-402b01ca-893f-45fb-b7de-cfce5b71e977/',
      imageUrl: 'assets/certificates/kotlin_coroutines.jpg',
    ),
    Education(
      title: 'Mastering the System Design Interview',
      description: 'Sundog Education',
      type: EducationType.certification,
      link:
          'https://www.udemy.com/certificate/UC-83f2362d-56eb-4d62-b063-0176417cb3c5/',
      imageUrl: 'assets/certificates/mastering_system_design_interview.jpg',
    ),
    Education(
      title: 'Software Architecture & Design of Modern Large Scale Systems',
      description: 'Top Developer Academy LLC',
      type: EducationType.certification,
      link:
          'https://www.udemy.com/certificate/UC-b6267e86-54cd-4e56-a085-fdc3824e6b0e/',
      imageUrl: 'assets/certificates/software_architecture.jpg',
    ),
  ];

  static const List<String> tabs = ['Education', 'Professional Skills'];

  static const List<Post> posts = [
    Post(
      title: 'Creating a Cupertino-Style Switch in Jetpack Compose',
      description:
          'When designing apps for Android, it\'s sometimes necessary to replicate iOS UI components for a seamless cross platform...',
      imageLink:
          'https://miro.medium.com/v2/resize:fit:1392/format:webp/0*8_8fgmB_uqCur6UN.jpg',
      link:
          'https://medium.com/@graser1305/creating-a-cupertino-style-switch-in-jetpack-compose-521621814a60',
    ),
    Post(
      title: 'Custom Kotlinx Serializer: Handling JSON Like a Pro',
      description:
          'Handling JSON in Kotlin is usually straightforward with kotlinx.serialization. But what happens when the JSON data you...',
      imageLink:
          'https://miro.medium.com/v2/resize:fit:1400/format:webp/1*xDFfab8Phjxculprdq0efA.jpeg',
      link:
          'https://medium.com/@graser1305/custom-kotlinx-serializer-handling-json-like-a-pro-c8165d121546',
    ),
    Post(
      title: 'How to Observe Real Internet Connectivity in Android',
      description:
          'Hey there, fellow Android developer! 👨‍💻 Let\'s talk about something that\'s often overlooked yet super important: real...',
      imageLink:
          'https://miro.medium.com/v2/resize:fit:1400/format:webp/0*6DXUbYFYP2NSPUQI',
      link:
          'https://medium.com/@graser1305/how-to-observe-real-internet-connectivity-in-android-fb6ebd2e3e00',
    ),
    Post(
      title: 'Creating Interactive HTML Content in Jetpack Compose',
      description:
          'Displaying HTML content in Android Compose, particularly with clickable links, might seem challenging at first. However, with...',
      imageLink:
          'https://miro.medium.com/v2/resize:fit:1400/format:webp/0*U0mJ2ny6PFjPKM77',
      link:
          'https://medium.com/@graser1305/creating-interactive-html-content-in-jetpack-compose-7f7e929152f3',
    ),
  ];
}
