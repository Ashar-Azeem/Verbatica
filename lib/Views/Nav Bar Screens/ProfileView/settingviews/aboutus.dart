import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('About Us'), elevation: 0),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Hero section
            SizedBox(
              width: double.infinity,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 24,
                  ),
                  child: Column(
                    children: [
                      // Logo container with gradient border
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Colors.blue,
                              Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/Logo.png',
                            width: 20.w,
                            height: 20.w,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Welcome text with animated underline
                      const _AnimatedHeadline(text: 'Welcome to Verbatica!'),
                    ],
                  ),
                ),
              ),
            ),

            // Content sections
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContentSection(
                    context,
                    icon: Icons.lightbulb_outline,
                    title: 'Our Mission',
                    content:
                        'We are dedicated to creating a modern and engaging platform that connects users with content they care about. Our goal is to deliver a seamless experience where you can explore, share, and interact with posts tailored to your interests.',
                  ),
                  const SizedBox(height: 32),
                  _buildContentSection(
                    context,
                    icon: Icons.explore_outlined,
                    title: 'The Experience',
                    content:
                        'Whether you\'re here to discover new ideas, connect with others, or simply scroll through trending content, we\'ve built this app with you in mind.',
                  ),
                  const SizedBox(height: 32),
                  _buildContentSection(
                    context,
                    icon: Icons.star_outline,
                    title: 'Our Values',
                    content:
                        'We believe in simplicity, personalization, and giving every user a voice.',
                  ),
                  const SizedBox(height: 40),

                  // Thank you message with highlighting
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 32,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            Theme.of(
                              context,
                            ).colorScheme.secondary.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Theme.of(context).colorScheme.primary,
                            size: 36,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Thank you for being a part of our growing community.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Social links
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(context, Icons.facebook_outlined),
                  const SizedBox(width: 24),
                  _buildSocialButton(context, Icons.flutter_dash),
                  const SizedBox(width: 24),
                  _buildSocialButton(context, Icons.alternate_email),
                ],
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Theme.of(context).cardColor,
              child: Text(
                '© ${DateTime.now().year} Verbatica. All rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineSmall?.color,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: TextStyle(
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withOpacity(0.8),
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(BuildContext context, IconData icon) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        ),
        child: Icon(icon, color: Theme.of(context).iconTheme.color, size: 20),
      ),
    );
  }
}

// Animated headline component with underline effect
class _AnimatedHeadline extends StatefulWidget {
  final String text;

  const _AnimatedHeadline({required this.text});

  @override
  State<_AnimatedHeadline> createState() => _AnimatedHeadlineState();
}

class _AnimatedHeadlineState extends State<_AnimatedHeadline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _widthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start animation after a delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineLarge?.color,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 100 * _widthAnimation.value,
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        ),
      ],
    );
  }
}
