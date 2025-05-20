import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {},
        ),
      ),
      body: const SafeArea(child: PrivacyPolicyContent()),
    );
  }
}

class PrivacyPolicyContent extends StatelessWidget {
  const PrivacyPolicyContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.background,
            const Color(0xFF0A101D),
          ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeaderCard(context),
          const SizedBox(height: 20),
          _buildSection(
            context,
            title: '1. Information We Collect',
            content: [
              _buildBulletPoint(
                context,
                title: 'Personal Information: ',
                content:
                    'When you create an account, we may collect your name, email, and other details you provide.',
              ),
              _buildBulletPoint(
                context,
                title: 'Usage Data: ',
                content:
                    'We collect data on how you interact with the app to improve your experience (e.g., what features you use, device type, and app performance).',
              ),
              _buildBulletPoint(
                context,
                title: 'Content Data: ',
                content:
                    'If you upload or interact with posts, we may store that content as part of your profile.',
              ),
            ],
          ),
          _buildSection(
            context,
            title: '2. How We Use Your Information',
            content: [
              _buildBulletPoint(
                context,
                content: 'To personalize your feed and content.',
              ),
              _buildBulletPoint(
                context,
                content: 'To improve app performance and user experience.',
              ),
              _buildBulletPoint(
                context,
                content: 'To provide customer support.',
              ),
              _buildBulletPoint(
                context,
                content: 'To send important updates and notifications.',
              ),
            ],
          ),
          _buildSection(
            context,
            title: '3. How We Protect Your Data',
            content: [
              _buildParagraph(
                context,
                'We use secure technologies and practices to protect your data from unauthorized access, loss, or misuse. Your information is stored safely and shared only when necessary to provide our services.',
              ),
            ],
          ),
          _buildSection(
            context,
            title: '4. Sharing of Information',
            content: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.5,
                      fontSize: 13,
                    ),
                    children: [
                      const TextSpan(text: 'We do '),
                      const TextSpan(
                        text: 'not ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const TextSpan(
                        text:
                            'sell your personal data. We may share limited information with trusted partners who help us operate the app—under strict confidentiality agreements.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildSection(
            context,
            title: '5. Your Rights',
            content: [
              _buildBulletPoint(
                context,
                content: 'You can update or delete your account at any time.',
              ),
              _buildBulletPoint(
                context,
                content:
                    'You can contact us to request access to your data or to ask questions about how your information is used.',
              ),
            ],
          ),
          _buildSection(
            context,
            title: '6. Changes to This Policy',
            content: [
              _buildParagraph(
                context,
                'We may update this Privacy Policy from time to time. Any major changes will be notified in the app.',
              ),
            ],
          ),
          _buildSection(
            context,
            title: '7. Contact Us',
            content: [
              _buildParagraph(
                context,
                'If you have any questions or concerns about this Privacy Policy, please contact us at:',
              ),
              const SizedBox(height: 10),
              Material(
                child: Text(
                  'Abdullahzh2003@email.com',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildAcceptButton(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: 10,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              Icons.shield,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 15),
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'We value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our app.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                height: 1.5,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),
            const Text(
              'Last Updated: May 20, 2025',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(
    BuildContext context, {
    String title = '',
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 10),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  if (title.isNotEmpty)
                    TextSpan(
                      text: title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  TextSpan(
                    text: content,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
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

  Widget _buildParagraph(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white70,
            height: 1.5,
            fontSize: 13 * MediaQuery.of(context).textScaleFactor,
          ),
        ),
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Privacy Policy Accepted'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            // Optional: set duration for clarity
          ),
        );

        // Wait 2 seconds before popping the screen
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
      ),
      child: const Text(
        'I Accept',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
