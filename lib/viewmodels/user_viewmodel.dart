import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  UserViewModel(this._userRepository);

  final List<UserModel> _users = [];

  List<UserModel> get users => _users;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  int _currentPage = 1;
  int _totalPages = 1;

  bool get hasMorePages => _currentPage < _totalPages;

  /// FIRST PAGE

  Future<void> fetchUsers({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _totalPages = 1;
      _users.clear();
      _errorMessage = null;
      notifyListeners();
    }

    // Duplicate API call prevent
    if (_isLoading || _isLoadingMore) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userRepository.getUsers(page: 1, perPage: 5);
      _currentPage = 1;
      _totalPages = response.totalPages;
      _users.clear();
      _users.addAll(response.users);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// LOAD NEXT PAGE

  Future<void> loadNextPage() async {
    // Already loading
    if (_isLoading || _isLoadingMore) {
      return;
    }

    // No more pages
    if (!hasMorePages) {
      return;
    }

    _isLoadingMore = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final nextPage = _currentPage + 1;

      debugPrint('Loading page: $nextPage');

      final response = await _userRepository.getUsers(
        page: nextPage,
        perPage: 5,
      );

      // Page successfully loaded
      _currentPage = nextPage;
      _totalPages = response.totalPages;

      // Add new users
      _users.addAll(response.users);

      debugPrint('Page $nextPage loaded. Total users: ${_users.length}');
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint('Pagination error: $e');
    } finally {
      _isLoadingMore = false;

      notifyListeners();
    }
  }

  /// REFRESH

  Future<void> refreshUsers() async {
    await fetchUsers(refresh: true);
  }
}
