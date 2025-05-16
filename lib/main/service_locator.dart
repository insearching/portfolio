import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:portfolio/main/data/repository/blog_repository.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DatabaseReference>(
      () => FirebaseDatabase.instance.ref());
  locator.registerLazySingleton<BlogRepository>(
      () => BlogRepository(databaseReference: locator<DatabaseReference>()));
}
