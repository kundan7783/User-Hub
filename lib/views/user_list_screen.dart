import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';
import '../widgets/user_card.dart';
import 'login_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserViewModel>().fetchUsers();
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final vm = context.read<UserViewModel>();
    final position = _scrollController.position;

    if (position.pixels < position.maxScrollExtent - 300) return;

    if (vm.hasMorePages && !vm.isLoading && !vm.isLoadingMore) {
      vm.loadNextPage();
    }
  }

  Future<void> _logout() async {
    final authViewModel = context.read<AuthViewmodel>();

    if (authViewModel.isLogoutLoading) return;

    final success = await authViewModel.logout();

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'User List',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          Consumer<AuthViewmodel>(
            builder: (context, auth, _) {
              return IconButton(
                tooltip: 'Logout',
                onPressed: auth.isLogoutLoading ? null : _logout,
                icon: auth.isLogoutLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout_rounded),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Consumer<UserViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.errorMessage != null && vm.users.isEmpty) {
            return _buildErrorView(vm);
          }
          if (vm.users.isEmpty) {
            return RefreshIndicator(
              onRefresh: vm.refreshUsers,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 300,
                    child: Center(
                      child: Text(
                        'No users found',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: vm.refreshUsers,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: vm.users.length + (vm.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == vm.users.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return UserCard(user: vm.users[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(UserViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 12),
            Text(vm.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => vm.fetchUsers(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
