import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_bloc.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_event.dart';
import 'package:verbatica/model/Post.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // Add this in your state class
  List<String> clusterNames = ['', '']; // Start with 2 empty fields
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for initial fields
    for (int i = 0; i < clusterNames.length; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  File? croppedImage;
  String polarity = '';
  File? _trimmedVideo;

  Future<void> _pickMedia(bool isVideo) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {}
  }

  void _handlePostSubmission() {
    // Get all non-empty clusters
    final validClusters =
        clusterNames.where((name) => name.trim().isNotEmpty).toList();

    // Validate required fields
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade900,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Title is required",
                  style: TextStyle(
                    color: Colors.white,
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

    if (polarity == 'polarize' && validClusters.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade900,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "At least 2 clusters are required for polarize posts",
                  style: TextStyle(
                    color: Colors.white,
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
          backgroundColor: Colors.red.shade900,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Select tag of post",
                  style: TextStyle(
                    color: Colors.white,
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
      final user = context.read<UserBloc>().state.user;

      Post post = Post(
        name: user.username,
        avatar: user.avatarId,
        title: _titleController.text,
        description: _descriptionController.text,
        isDebate: polarity == 'polarize',
        upvotes: 0,
        downvotes: 0,
        isUpVote: false,
        isDownVote: false,
        comments: 0,
        uploadTime: DateTime.now(),
        id: '999',
      );
      context.read<PostBloc>().add(SubmitPostEvent(post));
    }
  }

  Future<File?> pickAndCropImage(BuildContext context) async {
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
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: true,
            hideBottomControls: true,
            showCropGrid: false,
            statusBarColor: Colors.black,
            backgroundColor: Colors.black,
          ),
        ],
      );

      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      debugPrint('Image processing error: $e');
      return null;
    }
  }

  Future<String?> showPolarizationDialog(BuildContext context) async {
    String? selectedOption;
    bool isPolarized = false;

    return await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              "Select Type of Post",
              style: TextStyle(
                color: Colors.white,
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
                      polarity = "polarize";
                    });
                    isPolarized = true;
                    Navigator.pop(context, selectedOption);
                  },
                ),
                const Divider(height: 24, thickness: 1),
                _buildDialogOption(
                  icon: Icons.person,
                  iconColor: Colors.green,
                  title: "Non-Polarize",
                  subtitle:
                      "This is normal feedback/fact checking/advice seeking post",
                  onTap: () {
                    setState(() {
                      polarity = "non_polarize";
                    });
                    isPolarized = false;
                    Navigator.pop(context, selectedOption);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
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

  void _showDialog() async {
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Create Post',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: _handlePostSubmission,
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                'Post',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Card Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Field
                      TextField(
                        controller: _titleController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const Divider(color: Colors.white24, height: 24),

                      // Description Field
                      TextField(
                        controller: _descriptionController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Description (optional)',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),

                      // Image Preview
                      if (croppedImage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.file(
                                croppedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Content',
                        style: TextStyle(
                          color: Colors.white,
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
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 24),

                      // Tag Selection
                      Row(
                        children: [
                          const Text(
                            'Post Type:',
                            style: TextStyle(
                              color: Colors.white,
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
                                        ? Colors.grey[800]
                                        : (polarity == 'polarize'
                                            ? Colors.blue.withOpacity(0.2)
                                            : Colors.green.withOpacity(0.2)),
                                foregroundColor:
                                    polarity == ''
                                        ? Colors.white
                                        : (polarity == 'polarize'
                                            ? Colors.blue
                                            : Colors.green),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (polarity != '')
                                    Icon(
                                      polarity == 'polarize'
                                          ? Icons.people
                                          : Icons.person,
                                      size: 18,
                                    ),
                                  if (polarity != '') const SizedBox(width: 8),
                                  Text(
                                    polarity == '' ? 'Select Tag' : polarity,
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
              if (polarity == 'polarize')
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.people,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Add Cluster Names",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
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
                          ...List.generate(clusterNames.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.blue.withOpacity(
                                      0.2,
                                    ),
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
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      controller: _controllers[index],
                                      decoration: InputDecoration(
                                        hintText: "Enter cluster name",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                        filled: true,
                                        fillColor: Colors.grey[800],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onChanged:
                                          (value) =>
                                              clusterNames[index] = value,
                                    ),
                                  ),
                                  if (index >=
                                      2) // Show remove button only for extra fields
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                          size: 22,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            clusterNames.removeAt(index);
                                            _controllers
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
                                  _controllers.add(TextEditingController());
                                });
                              },
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 18,
                              ),
                              label: const Text("Add Another Cluster"),
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
    );
  }

  void _pickAndCropImage() async {
    final image = await pickAndCropImage(context);
    setState(() {
      croppedImage = image;
    });
  }

  Widget _buildAttachmentOption(IconData icon, String label, int formatid) {
    return InkWell(
      onTap: () {
        if (formatid == 1) {
          _pickAndCropImage();
        } else if (formatid == 2) {
          // _pickVideo();
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[700]!, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class VideoTrimmerBottomSheet extends StatefulWidget {
//   final Trimmer trimmer;

//   const VideoTrimmerBottomSheet({super.key, required this.trimmer});

//   @override
//   State<VideoTrimmerBottomSheet> createState() =>
//       _VideoTrimmerBottomSheetState();
// }

// class _VideoTrimmerBottomSheetState extends State<VideoTrimmerBottomSheet> {
//   double _startValue = 0.0;
//   double _endValue = 1.0;
//   bool _isPlaying = false;
//   bool _isTrimming = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           SizedBox(height: 50),
//           const Text(
//             'Trim Video (Max 1 minute)',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 16),
//           VideoViewer(trimmer: widget.trimmer),
//           const SizedBox(height: 16),
//           TrimViewer(
//             trimmer: widget.trimmer,
//             viewerHeight: 50,
//             maxVideoLength: const Duration(minutes: 1),
//             onChangeStart: (value) => setState(() => _startValue = value),
//             onChangeEnd: (value) => setState(() => _endValue = value),
//             onChangePlaybackState: (playing) {
//               setState(() => _isPlaying = playing);
//             },
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                 onPressed: () async {
//                   final playbackState = await widget.trimmer
//                       .videoPlaybackControl(
//                         startValue: _startValue,
//                         endValue: _endValue,
//                       );
//                   setState(() => _isPlaying = playbackState);
//                 },
//               ),
//               const Spacer(),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed:
//                       _isTrimming
//                           ? null
//                           : () async {
//                             // setState(() => _isTrimming = true);
//                             // final outputPath = await widget.trimmer.saveTrimmedVideo(
//                             //   startValue: _startValue,
//                             //   endValue: _endValue, onSave: (String? outputPath) {  },
//                             // );
//                             // if (!mounted) return;
//                             // // // ignore: use_build_context_synchronously
//                             // // Navigator.pop(context, File(outputPath!));
//                           },
//                   child:
//                       _isTrimming
//                           ? const CircularProgressIndicator()
//                           : const Text('save video'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
