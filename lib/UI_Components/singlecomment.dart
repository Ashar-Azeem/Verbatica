import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:verbatica/model/comment.dart';

class SingleCommentUI extends StatefulWidget {
  const SingleCommentUI({
    required this.comment,
    required this.parentComment,
    super.key,
  });
  final Comment comment;
  final Comment? parentComment;

  @override
  State<SingleCommentUI> createState() => _SingleCommentUIState();
}

class _SingleCommentUIState extends State<SingleCommentUI> {
  bool _showFullParent = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 79, 78, 78),
      child: Container(
        decoration: BoxDecoration(
          border:
              widget.parentComment != null
                  ? Border.all(color: Colors.grey[700]!, width: 0.5)
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parent comment preview (subtle and compact)
            if (widget.parentComment != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[700]!, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage(
                            'assets/Avatars/avatar${widget.parentComment!.profile}.jpg',
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.parentComment!.author,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          timeago.format(widget.parentComment!.uploadTime),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _showFullParent
                          ? widget.parentComment!.text
                          : '${widget.parentComment!.text.substring(0, widget.parentComment!.text.length.clamp(0, 100))}${widget.parentComment!.text.length > 100 ? '...' : ''}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      maxLines: _showFullParent ? null : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.parentComment!.text.length > 100) ...[
                      const SizedBox(height: 4),
                      Text(
                        _showFullParent ? 'Show less' : 'Show more',
                        style: TextStyle(color: Colors.blue[300], fontSize: 10),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Main comment (clean and focused)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.parentComment != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 8),
                      child: Text(
                        '→ Replying to ${widget.parentComment!.author}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  // Comment header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: AssetImage(
                          'assets/Avatars/avatar${widget.comment.profile}.jpg',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.comment.author,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              timeago.format(widget.comment.uploadTime),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          size: 18,
                          color: Colors.grey[500],
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Comment content
                  ExpandableText(
                    widget.comment.text,
                    expandOnTextTap: true,
                    collapseOnTextTap: true,
                    maxLines: 3,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    expandText: 'Show more',
                    collapseText: 'Show less',
                    linkColor: Colors.blue[300],
                  ),
                  const SizedBox(height: 8),
                  // Action buttons
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_upward, size: 18),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                      Text(
                        '${widget.comment.totalUpVotes - widget.comment.totalDownVotes}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward, size: 18),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.reply,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... keep your existing _showCommentMenu, _upvoteComment, etc methods ...
}
