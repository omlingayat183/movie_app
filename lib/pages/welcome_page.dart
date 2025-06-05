import 'package:flutter/material.dart';
import 'package:movie_app/utils/app_colors.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SizedBox(
          width: 393,
          height: 852,
          child: Stack(
            children: [
             
              Positioned(
                left: 6,
                top: 133,
                width: 387,
                height: 29,
                child: const Text(
                  'Search & Discover Movies',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    height: 29 / 24,
                    color: AppColors.goldAccent,
                  ),
                ),
              ),

              Positioned(
                left: 19,
                top: 192,
                width: 349,
                height: 349,
                child: Image.asset(
                  'assets/welcome.png',
                  fit: BoxFit.contain,
                ),
              ),

              Positioned(
                left: 48,
                top: 572,
                width: 297,
                height: 57,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    foregroundColor: AppColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                      side: const BorderSide(color: AppColors.black, width: 1),
                    ),
                    minimumSize: const Size(297, 57),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 20 / 16,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 48,
                top: 638,
                width: 297,
                height: 57,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.goldAccent,
                    side:
                        const BorderSide(color: AppColors.goldAccent, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    minimumSize: const Size(297, 57),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 20 / 16,
                        color: AppColors.goldAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
