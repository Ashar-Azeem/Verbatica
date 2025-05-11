// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Comments%20Bloc/comments_bloc.dart';
import 'package:verbatica/UI_Components/Comment%20Componenets/CommentBlock.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/model/Post.dart';

class ViewDiscussion extends StatefulWidget {
  final Post post;
  final int index;
  final String category;
  const ViewDiscussion({
    super.key,
    required this.post,
    required this.index,
    required this.category,
  });

  @override
  State<ViewDiscussion> createState() => _ViewDiscussionState();
}

class _ViewDiscussionState extends State<ViewDiscussion> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentsBloc(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,

                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 1.5.w,
                      bottom: 2.w,
                      top: 2.w,
                    ),
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 13, 18, 21).withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 5.w,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
                PostWidget(
                  post: widget.post,
                  index: widget.index,
                  category: widget.category,
                  onFullView: true,
                ),

                BlocBuilder<CommentsBloc, CommentsState>(
                  builder: (context, state) {
                    context.read<CommentsBloc>().add(
                      LoadInitialComments(postId: widget.post.id),
                    );
                    return state.initialLoader
                        ? Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Center(
                            child: LoadingAnimationWidget.dotsTriangle(
                              color: primaryColor,
                              size: 10.w,
                            ),
                          ),
                        )
                        : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.comments.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 0.6.h),
                              child: Column(
                                children: [
                                  Divider(
                                    color: Color.fromARGB(255, 22, 28, 33),
                                    thickness: 0.5,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: 100.w,
                                      child: CommentsBlock(
                                        level: 1,
                                        comment: state.comments[index],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Color.fromARGB(255, 22, 28, 33),
                                    thickness: 0.5,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
