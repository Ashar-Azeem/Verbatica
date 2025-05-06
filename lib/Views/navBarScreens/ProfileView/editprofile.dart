import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/model/user.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return _EditProfileContent(user: state.user);
      },
    );
  }
}

class _EditProfileContent extends StatefulWidget {
  final User user;

  const _EditProfileContent({required this.user});

  @override
  State<_EditProfileContent> createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<_EditProfileContent> {
  late int _selectedAvatarId;
  late TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _selectedAvatarId = widget.user.avatarId;
    _aboutController = TextEditingController(text: widget.user.about);
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

  void _showAvatarSelection() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text('Choose Avatar', style: TextStyle(color: Colors.white)),
            content: SizedBox(
              width: double.maxFinite,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 7,
                itemBuilder: (context, index) {
                  final avatarId = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedAvatarId = avatarId);
                      context.read<UserBloc>().add(UpdateAvatar(avatarId));
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          _selectedAvatarId == avatarId
                              ? primaryColor.withOpacity(0.3)
                              : Colors.transparent,
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(
                          'assets/Avatars/avatar$avatarId.jpg',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _saveChanges() {
    context.read<UserBloc>().add(UpdateAbout(_aboutController.text));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),

          // Avatar Section
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _showAvatarSelection,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          'assets/Avatars/avatar$_selectedAvatarId.jpg',
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _showAvatarSelection,
                  child: const Text('Change Avatar'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          Text(
            'About you',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _aboutController,
            maxLines: 4,
            style: TextStyle(color: Colors.grey),
            maxLength: 200,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Tell others about yourself...',
            ),
          ),
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
