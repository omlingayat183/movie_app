import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/pages/bottom_navbar.dart';
import 'package:movie_app/utils/app_colors.dart';
import '../blocs/authentication/auth_cubit.dart';
import '../blocs/authentication/auth_state.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedLanguage = 'English';
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _attemptRegister() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final language = _selectedLanguage;

    context.read<AuthCubit>().register(
          name: name,
          email: email,
          password: password,
          language: language,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/yellow_bg.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: AppColors.goldAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.goldAccent),
                    ),
                    child: BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthAuthenticated) {
                          
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const BottomNavPage()),
                            (route) => false,
                          );
                        } else if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.message,
                                style: const TextStyle(fontFamily: 'Inter'),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.goldAccent),
                          );
                        }
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              
                              TextFormField(
                                cursorColor: AppColors.goldAccent,
                                controller: _nameController,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontFamily: 'Inter',
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.white,
                                  hintText: 'Name',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Inter',
                                  ),
                                  prefixIcon: const Icon(Icons.person_outline,
                                      color: Colors.black54),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              TextFormField(
                                cursorColor: AppColors.goldAccent,
                                controller: _emailController,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontFamily: 'Inter',
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.white,
                                  hintText: 'Email / Phone',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Inter',
                                  ),
                                  prefixIcon: const Icon(Icons.email_outlined,
                                      color: Colors.black54),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Please enter email or phone';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              
                              TextFormField(
                                cursorColor: AppColors.goldAccent,
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontFamily: 'Inter',
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.white,
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Inter',
                                  ),
                                  prefixIcon: const Icon(Icons.lock_outline,
                                      color: Colors.black54),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty || v.length < 4) {
                                    return 'Password must be ≥ 4 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: AppColors.white,
                                  value: _selectedLanguage,
                                  icon: const Icon(Icons.language,
                                      color: Colors.black54),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  items: _languages
                                      .map(
                                        (lang) => DropdownMenuItem(
                                          value: lang,
                                          child: Text(
                                            lang,
                                            style: const TextStyle(
                                              color: AppColors.black,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedLanguage = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(217, 49),
                                  padding: const EdgeInsets.all(10),

                                  backgroundColor:
                                      AppColors.goldAccent, 
                                  foregroundColor:
                                      AppColors.black, 
                                  elevation: 0, 

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                onPressed: _attemptRegister,
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account?',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) => const LoginPage()),
                                      );
                                    },
                                    child: const Text(
                                      'Log in',
                                      style: TextStyle(
                                          color: AppColors.brightBlue,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Image.network(
                                      'https://upload.wikimedia.org/wikipedia/commons/4/4a/Logo_2013_Google.png',
                                      width: 32,
                                      height: 32,
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Google Sign‐in tapped',
                                            style:
                                                TextStyle(fontFamily: 'Inter'),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    icon: Image.network(
                                      'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
                                      width: 32,
                                      height: 32,
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Facebook Sign‐in tapped',
                                            style:
                                                TextStyle(fontFamily: 'Inter'),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              
                              const Text(
                                'By clicking Register, you agree to our Terms and Privacy Policy.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
