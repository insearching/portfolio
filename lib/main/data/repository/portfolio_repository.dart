import 'package:portfolio/main/data/local/static_data/repository.dart';
import 'package:portfolio/main/data/personal_info.dart';

/// Centralized repository for all portfolio static data
/// Provides access to local static data like personal info, skills, and resume tabs
class PortfolioRepository {
  const PortfolioRepository();

  // Personal Information
  PersonalInfo getPersonalInfo() => Repository.info;

  String getUserName() => Repository.info.title;

  String getUserEmail() => Repository.info.email;
}
