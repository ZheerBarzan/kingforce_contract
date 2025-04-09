import 'package:flutter/material.dart';
import '../services/navigation_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Start the animation
    _controller.forward();

    // Navigate to main screen after 3 seconds
    Future.delayed(const Duration(seconds: 4), () {
      NavigationService.navigateTo('/generate');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Stack(
            children: [
              // Background image
              Image.asset(
                'assets/images/guard.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              // Replace this with your actual logo
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                 
                  children: [
                    const Text(
                      'King Force Security',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 