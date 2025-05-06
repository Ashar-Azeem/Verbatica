// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/Utilities/dateformat.dart';
import 'package:verbatica/Views/navBarScreens/ProfileView/editprofile.dart';
import 'package:verbatica/Views/navBarScreens/ProfileView/settingscreen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedAvatar = '1';
  String aboutText =
      '32jfdbskudfbakduvfawudfvsdjvs cshbdhubhjcvbuvbvusdb dfswbdfjsbjvsbjfvswjsdjhvswl wibwsbvhuj';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Profile Page'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 3, 49, 119),
                  Colors.black, // Deep Blue
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 40,
                right: 20, // This will now work
                left: 20, // Add left for symmetry
              ),
              child: Container(
                width:
                    MediaQuery.of(context).size.width - 40, // Constrain width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SettingsScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.settings),
                        ),
                      ],
                    ),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        return CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            'assets/Avatars/avatar${state.user.avatarId}.jpg',
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),

                    OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder:
                              (context) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.95,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: BlocProvider.value(
                                  value: BlocProvider.of<UserBloc>(context),
                                  child: const EditProfileScreen(),
                                ),
                              ),
                        );
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      ),
                    ),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        return Text(
                          state.user.username,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          return _buildStatItem(
                            'Karma/Achievement',
                            state.user.karma
                                .toString(), // Convert to string if needed
                          );
                        },
                      ),
                    ),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        return _buildInfoItem(
                          Icons.date_range,
                          formatJoinedDate(state.user.joinedDate),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Posts'),
              Tab(text: 'Comments'),
              Tab(text: 'About'),
            ],
            labelColor: Colors.white,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.0, color: Colors.blue),
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Posts Tab
                const Center(
                  child: Text(
                    'Posts Content',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // Comments Tab
                const Center(
                  child: Text(
                    'Comments Content',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // About Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.user.about ?? 'Nothing here',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                              return _buildInfoItem(
                                Icons.date_range,
                                formatJoinedDate(state.user.joinedDate),
                              );
                            },
                          ),

                          BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                              return _buildInfoItem(
                                Icons.location_on,
                                state.user.country,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Row(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
