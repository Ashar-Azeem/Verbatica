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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parent comment preview
            if (widget.parentComment != null) ...[_buildParentComment()],

            // Main comment
            _buildMainComment(),
          ],
        ),
      ),
    );
  }

  Widget _buildParentComment() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showFullParent = !_showFullParent;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade800, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage(
                        'assets/Avatars/avatar${widget.parentComment!.profile}.jpg',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF43768A),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF2A2A2A),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.parentComment!.author,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    timeago.format(widget.parentComment!.uploadTime),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _showFullParent
                  ? widget.parentComment!.text
                  : '${widget.parentComment!.text.substring(0, widget.parentComment!.text.length.clamp(0, 100))}${widget.parentComment!.text.length > 100 ? '...' : ''}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                height: 1.4,
              ),
              maxLines: _showFullParent ? null : 2,
              overflow:
                  _showFullParent
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
            ),
            if (widget.parentComment!.text.length > 100) ...[
              const SizedBox(height: 6),
              Text(
                _showFullParent ? 'Show less' : 'Show more',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMainComment() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Replying indicator
          if (widget.parentComment != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF43768A).withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(0xFF43768A).withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.reply, size: 12, color: Color(0xFF43768A)),
                  const SizedBox(width: 4),
                  Text(
                    'Replying to ${widget.parentComment!.author}',
                    style: const TextStyle(
                      color: Color(0xFF43768A),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // User info row
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF43768A),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(
                        'assets/Avatars/avatar${widget.comment.profile}.jpg',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1E1E1E),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.comment.author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeago.format(widget.comment.uploadTime),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          // Content
          Container(
            margin: const EdgeInsets.only(top: 14, bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ExpandableText(
              widget.comment.text,
              expandOnTextTap: true,
              collapseOnTextTap: true,
              maxLines: 3,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
                letterSpacing: 0.2,
              ),
              expandText: 'Show more',
              collapseText: 'Show less',
              linkColor: const Color(0xFF43768A),
              linkStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              prefixText: '',
              prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
              animation: true,
              animationDuration: const Duration(milliseconds: 300),
              animationCurve: Curves.easeOut,
            ),
          ),

          // Action buttons
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.arrow_upward_rounded,
                  color: const Color(0xFF43768A),
                  onPressed: () {},
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.comment.totalUpVotes - widget.comment.totalDownVotes}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                _buildActionButton(
                  icon: Icons.arrow_downward_rounded,
                  color: Colors.grey,
                  onPressed: () {},
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.reply_rounded,
                  color: Colors.grey.shade400,
                  label: 'Reply',
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.bookmark_border_rounded,
                  color: Colors.grey.shade400,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    String? label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
