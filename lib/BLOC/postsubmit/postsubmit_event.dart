import 'package:equatable/equatable.dart';
import 'package:verbatica/model/Post.dart'; // Your Post model

// Events
abstract class PostEvent extends Equatable {
  const PostEvent();
}

class SubmitPostEvent extends PostEvent {
  final Post post; // Already contains clusters/media/etc.
  const SubmitPostEvent(this.post);

  @override
  List<Object> get props => [post];
}
