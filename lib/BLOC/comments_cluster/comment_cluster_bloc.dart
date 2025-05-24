import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:verbatica/model/comment.dart';
part 'comment_cluster_event.dart';
part 'comment_cluster_state.dart';

class CommentClusterBloc
    extends Bloc<CommentClusterEvent, CommentClusterState> {
  CommentClusterBloc() : super(CommentClusterInitial()) {
    on<LoadInitialComments>((event, emit) {
      final now = DateTime.now();
      final clusters = ['Technology', 'Science', 'Politics', 'Sports'];
      final authors = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve', 'Frank'];
      final comments = <Comment>[];

      for (int i = 0; i < 10; i++) {
        comments.add(
          Comment(
            id: 'p$i',
            postId: 'post1',
            text:
                'This is parent comment #$i about ${clusters[i % clusters.length]}',
            author: authors[i % authors.length],
            profile: '${i % 5 + 1}',
            parentId: null,
            allReplies: [],
            uploadTime: now.subtract(Duration(hours: i)),
            upVoteUserIds: i % 2 == 0 ? ["1"] : [],
            downVoteUserIds: i % 2 != 0 ? ["1"] : [],
            cluster: clusters[i % clusters.length],
          ),
        );
      }

      for (int i = 0; i < 10; i++) {
        final parentIndex = i % 5;
        comments.add(
          Comment(
            id: 'r$i',
            postId: 'post1',
            text: 'This is reply #$i to parent comment #$parentIndex',
            author: authors[(i + 2) % authors.length],
            profile: '${(i + 1) % 5 + 1}',
            parentId: 'p$parentIndex',
            allReplies: [],
            uploadTime: now.subtract(Duration(hours: i + 12)),
            upVoteUserIds: i % 2 == 0 ? ["1"] : [],
            downVoteUserIds: i % 2 != 0 ? ["1"] : [],
            cluster: clusters[(i + 1) % clusters.length],
          ),
        );
      }
      emit(state.copyWith(comments: comments));
    });
  }
}
