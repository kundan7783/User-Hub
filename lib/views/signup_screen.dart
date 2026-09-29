import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_hub/views/user_list_screen.dart';

import '../repositories/user_repository.dart';
import '../services/api_service.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff8B5CF6), Color(0xff5B3DF5)],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 10,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// ICON
                          const Icon(
                            Icons.person_add_alt_1,
                            size: 70,
                            color: Color(0xff4F46E5),
                          ),

                          const SizedBox(height: 10),

                          /// TITLE
                          Text(
                            "Create Account",

                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            "Create your account to continue",
                            style: TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 25),

                          /// NAME FIELD
                          TextFormField(
                            controller: nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              hintText: "Enter your name",
                              prefixIcon: const Icon(Icons.person_outline),
                              filled: true,
                              fillColor: const Color(0xffF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: BorderSide.none,
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: BorderSide.none,
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: const BorderSide(
                                  color: Color(0xff4F46E5),

                                  width: 1.8,
                                ),
                              ),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Name is required";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 18),
                          /// EMAIL FIELD
                          TextFormField(
                            controller: emailController,

                            keyboardType: TextInputType.emailAddress,

                            autofillHints: const [AutofillHints.email],

                            decoration: InputDecoration(
                              hintText: "Enter your email",

                              prefixIcon: const Icon(Icons.email_outlined),

                              filled: true,

                              fillColor: const Color(0xffF8FAFC),

                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: BorderSide.none,
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: BorderSide.none,
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: const BorderSide(
                                  color: Color(0xff4F46E5),

                                  width: 1.8,
                                ),
                              ),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          /// PASSWORD FIELD
                          Consumer<AuthViewmodel>(
                            builder: (context, authViewModel, child) {
                              return TextFormField(
                                controller: passwordController,
                                obscureText: !authViewModel.isPasswordVisible,

                                decoration: InputDecoration(
                                  hintText: "Enter password",

                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                  ),

                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      authViewModel.togglePasswordVisibility();
                                    },
                                    icon: Icon(
                                      authViewModel.isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),

                                  filled: true,
                                  fillColor: const Color(0xffF8FAFC),

                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 25),

                          /// BUTTON
                          Consumer<AuthViewmodel>(
                            builder: (context, authViewModel, child) {
                              return SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff4F46E5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: authViewModel.isSignupLoading
                                      ? null
                                      : () async {
                                    if (formKey.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();

                                      final success = await authViewModel.signup(
                                        nameController.text.trim(),
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );

                                      if (!context.mounted) return;

                                      if (success) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Account Created Successfully"),
                                          ),
                                        );

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ChangeNotifierProvider(
                                                create: (_) => UserViewModel(
                                                  UserRepository(
                                                    ApiService(),
                                                  ),
                                                )..fetchUsers(),
                                                child: const UserListScreen(),
                                              );
                                            },
                                          ),
                                              (route) => false,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              authViewModel.errorMessage ?? "Signup Failed",
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: authViewModel.isSignupLoading
                                      ? const SpinKitCircle(
                                    color: Colors.white,
                                    size: 28,
                                  )
                                      : const Text(
                                    "Create Account",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 20),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account ?",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Color(0xff4F46E5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
