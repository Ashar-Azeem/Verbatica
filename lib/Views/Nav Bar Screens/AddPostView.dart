import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/model/Post.dart';

// Your PostBloc

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

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

  // final _formKey = GlobalKey<FormState>();
  File? croppedImage;
  String? polarity;
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
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Title is required",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    if (polarity == 'polarize' && validClusters.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "At least 2 clusters are required for polarize posts",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    } else {
      final user = context.read<UserBloc>().state.user;

      // Post post =new Post(id: , name: user.username, avatar: user.avatarId, title: _titleController.text, description: _descriptionController.text, isDebate: polarity=='polarize', upvotes: 0, downvotes: 0, comments: 0, uploadTime:DateTime.now());
    }

    // // Create post object
    // final post = Post(
    //   title: _titleController.text.trim(),
    //   description: _descriptionController.text.trim(),

    //   polarity: polarity,
    //   clusters: polarity == 'polarize' ? validClusters : null,
    //   createdAt: DateTime.now(),
    // );

    // Here you would typically:
    // 1. Save to database
    // 2. Upload media if needed
    // 3. Navigate away or show success message

    // debugPrint("Post created: ${post.toJson()}");
    // Example: context.read<PostBloc>().add(SubmitPost(post));
  }

  Future<File?> pickAndCropImage(BuildContext context) async {
    try {
      // 1. Pick image from gallery
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile == null) return null;

      // // 2. Crop the image with 16:9 aspect ratio
      // final CroppedFile? croppedFile = await ImageCropper().cropImage(
      //   sourcePath: pickedFile.path,
      //   aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      //   compressQuality: 85,
      //   uiSettings: [
      //     AndroidUiSettings(
      //       toolbarTitle: 'Crop Image',
      //       toolbarColor: Colors.black,
      //       toolbarWidgetColor: Colors.white,
      //       initAspectRatio: CropAspectRatioPreset.ratio16x9,
      //       lockAspectRatio: true,
      //       hideBottomControls: true,
      //       showCropGrid: false,
      //       statusBarColor: Colors.black,
      //       backgroundColor: Colors.black,
      //     ),
      //     IOSUiSettings(
      //       title: 'Crop Image',
      //       aspectRatioLockEnabled: true,
      //       resetButtonHidden: true,
      //       rotateButtonsHidden: true,
      //     ),
      //   ],
      // );

      // return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      debugPrint('Image processing error: $e');
      return null;
    }
  }

  // Future<File?> pickAndTrimVideo(BuildContext context) async {
  //   try {
  //     // 1. Pick video file
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.video,
  //       allowMultiple: false,
  //     );

  //     if (result == null || result.files.isEmpty) return null;

  //     final file = File(result.files.single.path!);

  //     // 2. Initialize trimmer
  //     final Trimmer trimmer = Trimmer();
  //     await trimmer.loadVideo(videoFile: file);

  //     // 3. Show trimming dialog
  //     final File? trimmedFile = await showModalBottomSheet<File>(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) => VideoTrimmerBottomSheet(trimmer: trimmer),
  //     );

  //     trimmer.dispose();
  //     return trimmedFile;
  //   } catch (e) {
  //     debugPrint('Video picker/trimmer error: $e');
  //     return null;
  //   }
  // }
  Future<String?> showPolarizationDialog(BuildContext context) async {
    String? selectedOption;
    bool isPolarized = false;

    return await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              "Select Type of Post",
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.people, color: Colors.blue),
                  title: const Text("Polarize"),
                  subtitle: const Text(
                    "There will be Divided opinion on this post",
                  ),
                  onTap: () {
                    setState(() {
                      polarity = "polarize";
                    });

                    isPolarized = true;
                    Navigator.pop(context, selectedOption);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.green),
                  title: const Text("Non-Polarize"),
                  subtitle: const Text(
                    "This is normal feedback/fact checking/advice seeking post",
                  ),
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
  } // Call this when you need the selection

  void _showDialog() async {
    final result = await showPolarizationDialog(context);
    if (result != null) {
      // Save the selection
      setState(() {
        // _polarizationChoice = result;
      });

      // Or use directly
      if (result == "polarize") {
        // Apply polarize effect
      } else {
        // Apply non-polarize effect
      }
    }
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Create Post', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                _handlePostSubmission();
              },
              child: Text('Post', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
                const Divider(color: Colors.white24),
                TextField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Description (optional)',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
                // To display the image:
                if (croppedImage != null)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.file(croppedImage!, fit: BoxFit.cover),
                  ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildAttachmentOption(Icons.photo_library, 'Gallery', 1),
                    const SizedBox(width: 20),
                    _buildAttachmentOption(Icons.video_library, 'Video', 2),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      _showDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 83, 149),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      polarity == null ? 'tag' : polarity!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // SizedBox(height: 20),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child:
                //   ),
                // ),
                SizedBox(height: 40),
                if (polarity == 'polarize')
                  ////////////////////////////
                  ///
                  // The UI Widget
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Add Cluster Names",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Minimum 2 clusters required",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      // Cluster input fields
                      ...List.generate(clusterNames.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: _controllers[index],
                                  decoration: InputDecoration(
                                    labelText: "Cluster ${index + 1}",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onChanged:
                                      (value) => clusterNames[index] = value,
                                ),
                              ),
                              if (index >=
                                  2) // Show remove button only for extra fields
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      clusterNames.removeAt(index);
                                      _controllers.removeAt(index).dispose();
                                    });
                                  },
                                ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 10),

                      // Add more clusters button
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            clusterNames.add('');
                            _controllers.add(TextEditingController());
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: Colors.blue),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.blue, size: 20),
                            SizedBox(width: 5),
                            Text(
                              "Add Cluster",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Submit button
                      SizedBox(height: 10.h),
                    ],
                  ),
              ],
            ),
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

  // void _pickVideo() async {
  //   final video = await pickAndTrimVideo(context);
  //   if (video != null) {
  //     setState(() => _trimmedVideo = video);
  //   }
  // }

  Widget _buildAttachmentOption(IconData icon, String label, int formatid) {
    return GestureDetector(
      onTap: () {
        if (formatid == 1) {
          _pickAndCropImage();
        } else if (formatid == 2) {
          // _pickVideo();
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
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
