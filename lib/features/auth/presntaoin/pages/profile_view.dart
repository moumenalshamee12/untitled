import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/core/utils/api_service.dart';
import 'package:untitled/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:untitled/features/auth/data/repo/auth_repp_imp.dart';
import 'package:untitled/features/auth/domain/usecases/get_profile_case.dart';
import 'package:untitled/features/auth/domain/entites/user_entity.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final GetProfileUseCase _getProfileUseCase;
  bool _isLoading = true;
  String? _error;
  UserEntity? _user;

  @override
  void initState() {
    super.initState();
    _getProfileUseCase = GetProfileUseCase(
      authRepo: AuthReppImp(
        authRemoteDataSource: AuthRemoteDataSourceimp(
          apiService: ApiService(dio: Dio()),
        ),
      ),
    );
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await _getProfileUseCase.call();
      result.fold(
        (failure) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
        },
        (user) {
          setState(() {
            _user = user;
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColor().primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor().primaryColor,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : _user == null
            ? const Center(child: Text('No profile data'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${_user!.name ?? '-'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Username: ${_user!.username ?? '-'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${_user!.email ?? '-'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone: ${_user!.phone ?? '-'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}
