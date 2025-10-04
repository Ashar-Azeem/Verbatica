// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_bloc.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_event.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_state.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/UI_Components/PostComponents/VideoPlayer.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Utilities/ErrorSnackBar.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/user.dart';
import 'package:video_compress/video_compress.dart';

class CreatePostScreen extends StatefulWidget {
  final String? newsId;
  final String screenType;
  const CreatePostScreen({
    super.key,
    required this.newsId,
    required this.screenType,
  });

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // Add this in your state class
  List<String> clusterNames = ['', ''];
  List<String> validCluster = [];
  List<TextEditingController> controllers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for initial fields
    for (int i = 0; i < clusterNames.length; i++) {
      controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  File? croppedImage;
  File? videoFile;
  String polarity = '';

  Future<File?> pickAndCropImage(BuildContext context) async {
    closeKeyboard(context);

    try {
      // 1. Pick image from gallery
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile == null) return null;

      // 2. Crop the image with 16:9 aspect ratio
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 10),
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Theme.of(context).cardColor,
            toolbarWidgetColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true,
            showCropGrid: false,
            statusBarColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ],
      );

      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      debugPrint('Image processing error: $e');
      return null;
    }
  }

  Future<void> _pickVideo() async {
    closeKeyboard(context);
    setState(() {
      isLoading = true;
    });
    final XFile? pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    setState(() {
      isLoading = false;
    });
    if (pickedFile != null) {
      final mediaInfo = await VideoCompress.getMediaInfo(pickedFile.path);
      final durationSeconds = mediaInfo.duration ?? 0;
      if (durationSeconds / 1000 > 120) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Video too long: ${(durationSeconds / 1000 / 60).toInt()} minutes, maximum of 2 mins video is allowed",
            ),
          ),
        );
      } else {
        setState(() {
          videoFile = File(pickedFile.path);
          croppedImage = null;
        });
      }
    }
  }

  Future<String?> showPolarizationDialog(BuildContext context) async {
    String? selectedOption;
    // bool isPolarized = false;
    closeKeyboard(context);
    return await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            title: Text(
              "Select Type of Post",
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontWeight: FontWeight.bold,
              ),
            ),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogOption(
                  icon: Icons.people,
                  iconColor: Colors.blue,
                  title: "Polarize",
                  subtitle: "There will be divided opinion on this post",
                  onTap: () {
                    setState(() {
                      polarity = "Polarize";
                    });
                    // isPolarized = true;
                    Navigator.pop(context, selectedOption);
                  },
                ),
                Divider(
                  height: 24,
                  thickness: 1,
                  color: Theme.of(context).dividerColor,
                ),
                _buildDialogOption(
                  icon: Icons.person,
                  iconColor: Colors.green,
                  title: "Non Polarize",
                  subtitle:
                      "This is normal feedback/fact checking/advice seeking post",
                  onTap: () {
                    setState(() {
                      polarity = "Non Polarize";
                    });
                    // isPolarized = false;
                    Navigator.pop(context, selectedOption);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
          ),
    );
  }

  Widget _buildDialogOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withOpacity(0.7),
                        fontSize: 12,
                      ),
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

  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _showDialog() async {
    closeKeyboard(context);
    final result = await showPolarizationDialog(context);
    if (result != null) {
      // Save the selection
      setState(() {
        // _polarizationChoice = result;
      });
    }
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<PostBloc, PostState>(
          buildWhen: (previous, current) => previous.loading != current.loading,
          builder: (context, state) {
            return BlocListener<PostBloc, PostState>(
              listenWhen:
                  (previous, current) =>
                      previous.loading != current.loading &&
                      state.currentScreen == widget.screenType,
              listener: (context, state) {
                if (state.status == PostStatus.error) {
                  CustomSnackbar.showError(context, state.error!);
                } else if (state.status == PostStatus.done) {
                  setState(() {
                    croppedImage = null;
                    videoFile = null;
                    _titleController.text = "";
                    _descriptionController.text = "";
                    validCluster = [];
                    clusterNames = ['', ''];
                    controllers = [];
                    for (int i = 0; i < clusterNames.length; i++) {
                      controllers.add(TextEditingController());
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text("Post created successfully"),
                    ),
                  );
                } else if (state.status == PostStatus.checkingDuplicates &&
                    state.loading != true) {
                  if (state.similarPosts.isEmpty) {
                    //Adding the logic of moving to the upload logic as there are no similar posts available
                    User user = context.read<UserBloc>().state.user!;
                    Post post = Post(
                      name: user.userName,
                      avatar: user.avatarId,
                      title: _titleController.text,
                      userId: user.id,
                      description: _descriptionController.text,
                      isDebate: polarity == 'Polarize',
                      upvotes: 0,
                      downvotes: 0,
                      isUpVote: false,
                      isDownVote: false,
                      comments: 0,
                      uploadTime: DateTime.now(),
                      id: '999',
                      clusters: validCluster,
                    );

                    context.read<PostBloc>().add(
                      SubmitPostEvent(
                        post,
                        croppedImage,
                        videoFile,
                        context,
                        widget.newsId,
                        widget.screenType,
                      ),
                    );
                  } else {
                    if (!mounted) return;
                    final rootContext =
                        Navigator.of(context, rootNavigator: true).context;
                    closeKeyboard(context);

                    showModalBottomSheet(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return SizedBox(
                          height: 90.h,
                          child: Scaffold(
                            floatingActionButton: FloatingActionButton.extended(
                              onPressed: () {
                                User user =
                                    rootContext.read<UserBloc>().state.user!;
                                Post post = Post(
                                  name: user.userName,
                                  avatar: user.avatarId,
                                  title: _titleController.text,
                                  userId: user.id,
                                  description: _descriptionController.text,
                                  isDebate: polarity == 'Polarize',
                                  upvotes: 0,
                                  downvotes: 0,
                                  isUpVote: false,
                                  isDownVote: false,
                                  comments: 0,
                                  uploadTime: DateTime.now(),
                                  id: '999',

                                  clusters: validCluster,
                                );

                                rootContext.read<PostBloc>().add(
                                  SubmitPostEvent(
                                    post,
                                    croppedImage,
                                    videoFile,
                                    rootContext,
                                    widget.newsId,
                                    widget.screenType,
                                  ),
                                );
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                }
                              },
                              label: Text("Post anyway"),
                              icon: Icon(Icons.upload_outlined),
                            ),
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 🔹 Title
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(
                                    state.similarPosts.length > 1
                                        ? "Similar posts found"
                                        : "Similar post found",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Divider(color: Theme.of(context).dividerColor),

                                // 🔹 ListView inside Expanded
                                BlocBuilder<PostBloc, PostState>(
                                  builder: (context, state) {
                                    return Expanded(
                                      child: ListView.builder(
                                        itemCount: state.similarPosts.length,
                                        itemBuilder: (context, index) {
                                          return PostWidget(
                                            post: state.similarPosts[index],
                                            index: index,
                                            category: 'similarPosts',
                                            onFullView: false,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              },
              child: Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Theme.of(context).cardColor,
                  title: Text(
                    'Create Post',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    BlocBuilder<PostBloc, PostState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              // Get all non-empty clusters
                              validCluster =
                                  clusterNames
                                      .where((name) => name.trim().isNotEmpty)
                                      .toList();

                              // Validate required fields
                              if (_titleController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onError,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            "Title is required",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onError,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (polarity == 'Polarize' &&
                                  validCluster.length < 2) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onError,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            "At least 2 clusters are required for Polarize posts",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onError,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                return;
                              } else if (polarity == '') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onError,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            "Select tag of post",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onError,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                return;
                              } else {
                                final user =
                                    context.read<UserBloc>().state.user;

                                context.read<PostBloc>().add(
                                  CheckSimilar(
                                    userId: user!.id,
                                    title: _titleController.text,
                                    description: _descriptionController.text,

                                    currentScreen: widget.screenType,
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            child: const Text(
                              'Post',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                body: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Post Card Container
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image Preview
                                  if (croppedImage != null)
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(10),
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 2.w),
                                        child: Dismissible(
                                          key: ValueKey(croppedImage!.path),
                                          direction:
                                              DismissDirection
                                                  .startToEnd, // Swipe from left to right
                                          onDismissed: (direction) {
                                            setState(() {
                                              croppedImage =
                                                  null; // Or remove from a list if multiple images
                                            });
                                          },
                                          background: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 20),
                                            color: Colors.redAccent,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),

                                          child: Image.file(
                                            croppedImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),

                                  if (videoFile != null)
                                    SizedBox(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 2.w),
                                          child: Dismissible(
                                            key: ValueKey(videoFile!.path),
                                            direction:
                                                DismissDirection
                                                    .startToEnd, // Swipe from left to right
                                            onDismissed: (direction) {
                                              setState(() {
                                                videoFile =
                                                    null; // Or remove from a list if multiple images
                                              });
                                            },
                                            background: Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                left: 20,
                                              ),
                                              color: Colors.redAccent,
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),

                                            child: BetterCacheVideoPlayer(
                                              videoFileLocation: videoFile,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  // Title Field
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                    ),
                                    child: Column(
                                      children: [
                                        TextField(
                                          autofocus:
                                              false, // 👈 remove this or set false

                                          controller: _titleController,
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleLarge?.color,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Title',
                                            hintStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color
                                                  ?.withOpacity(0.6),
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),

                                        Divider(
                                          color: Theme.of(context).dividerColor,
                                          height: 24,
                                        ),

                                        // Description Field
                                        TextField(
                                          autofocus:
                                              false, // 👈 remove this or set false

                                          controller: _descriptionController,
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge?.color,
                                          ),
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                            hintText: 'Description ',
                                            hintStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color
                                                  ?.withOpacity(0.6),
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Post Options Section
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add Content',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withOpacity(0.6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Media Options
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildAttachmentOption(
                                          Icons.photo_library,
                                          'Gallery',
                                          1,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildAttachmentOption(
                                          Icons.video_library,
                                          'Video',
                                          2,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),
                                  Divider(
                                    color: Theme.of(context).dividerColor,
                                    height: 1,
                                  ),
                                  const SizedBox(height: 24),

                                  // Tag Selection
                                  Row(
                                    children: [
                                      Text(
                                        'Post Type:',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.6),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _showDialog,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                polarity == ''
                                                    ? Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                    : (polarity == 'Polarize'
                                                        ? Colors.blue
                                                            .withOpacity(0.5)
                                                        : Colors.green
                                                            .withOpacity(0.5)),
                                            foregroundColor:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (polarity != '')
                                                Icon(
                                                  polarity == 'Polarize'
                                                      ? Icons.people
                                                      : Icons.person,
                                                  size: 18,
                                                ),
                                              if (polarity != '')
                                                const SizedBox(width: 8),
                                              Text(
                                                polarity == ''
                                                    ? 'Select Tag'
                                                    : polarity,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Polarize Clusters Section
                          if (polarity == 'Polarize')
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.people,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Add Cluster Names",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color
                                                  ?.withOpacity(0.6),
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              "Min. 2 required",
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Cluster input fields
                                      ...List.generate(clusterNames.length, (
                                        index,
                                      ) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundColor: Colors.blue
                                                    .withOpacity(0.2),
                                                child: Text(
                                                  "${index + 1}",
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: TextField(
                                                  autofocus:
                                                      false, // 👈 remove this or set false

                                                  style: TextStyle(
                                                    color:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                  ),
                                                  controller:
                                                      controllers[index],
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Enter cluster name",
                                                    hintStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color
                                                          ?.withOpacity(0.6),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 12,
                                                        ),
                                                    filled: true,
                                                    fillColor:
                                                        Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.dark
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .surface
                                                                .withOpacity(
                                                                  0.3,
                                                                )
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .surfaceContainerHighest
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                  onChanged:
                                                      (value) =>
                                                          clusterNames[index] =
                                                              value,
                                                ),
                                              ),
                                              if (index >=
                                                  2) // Show remove button only for extra fields
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 8.0,
                                                      ),
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                      size: 22,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        clusterNames.removeAt(
                                                          index,
                                                        );
                                                        controllers
                                                            .removeAt(index)
                                                            .dispose();
                                                      });
                                                    },
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      }),

                                      const SizedBox(height: 16),

                                      // Add more clusters button
                                      Center(
                                        child: TextButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              clusterNames.add('');
                                              controllers.add(
                                                TextEditingController(),
                                              );
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                            size: 18,
                                          ),
                                          label: const Text(
                                            "Add Another Cluster",
                                          ),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.blue,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            return state.loading
                ? Positioned.fill(
                  child: Scaffold(
                    backgroundColor: Colors.black.withOpacity(0.8),
                    body: Center(
                      child: Column(
                        children: [
                          Spacer(),
                          LoadingAnimationWidget.dotsTriangle(
                            color: primaryColor,
                            size: 12.w,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            postStatusText(state.status, state.progress),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                )
                : SizedBox.shrink();
          },
        ),

        isLoading
            ? Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Column(
                    children: [
                      Spacer(),
                      LoadingAnimationWidget.dotsTriangle(
                        color: primaryColor,
                        size: 12.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Importing your video…',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      Spacer(),
                    ],
                  ),
                ),
              ),
            )
            : SizedBox.shrink(),
      ],
    );
  }

  String postStatusText(PostStatus status, String? progress) {
    switch (status) {
      case PostStatus.checkingDuplicates:
        return "Checking for similar posts...";
      case PostStatus.preparingVideo:
        return progress == null
            ? "Preparing your video... 0% complete"
            : "Preparing your video... $progress% complete";
      case PostStatus.preparingImage:
        return "Preparing your image...";
      case PostStatus.uploadingToTheServer:
        return "Uploading to the server...";

      case PostStatus.encrypting:
        return "Encrypting your post...";
      default:
        return "";
    }
  }

  void _pickAndCropImage() async {
    final image = await pickAndCropImage(context);
    setState(() {
      croppedImage = image;
      videoFile = null;
    });
  }

  Widget _buildAttachmentOption(IconData icon, String label, int formatid) {
    return InkWell(
      onTap: () {
        if (formatid == 1) {
          _pickAndCropImage();
        } else if (formatid == 2) {
          _pickVideo();
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.6),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
