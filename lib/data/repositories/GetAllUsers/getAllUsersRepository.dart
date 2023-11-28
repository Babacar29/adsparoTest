// ignore_for_file: file_names

import 'getAllUsersDataSource.dart';

class GetAllUsersRepository {
  static final GetAllUsersRepository _getUsersRepository = GetAllUsersRepository._internal();

  late GetAllUsersRemoteDataSource _getUsersRemoteDataSource;

  factory GetAllUsersRepository() {
    _getUsersRepository._getUsersRemoteDataSource = GetAllUsersRemoteDataSource();
    return _getUsersRepository;
  }

  GetAllUsersRepository._internal();

  getUsers() {
    final result =  _getUsersRemoteDataSource.getUsers();
    return result;
  }
}
