import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/data/skill.dart';

class Repository {
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
        'Email: hrabas.serhii@gmail.com\n'
        'Connect with me\n',
    email: 'hrabas.serhii@gmail.com',
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
          'research included optimization of algorithms, static_data structures, and scalable '
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
}
