import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final int postIndex;
  final String postType;
  final Color backgroundColor;

  const PostWidget({
    required this.postIndex,
    required this.postType,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 30, 33, 35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Post header
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[700],
                  child: Icon(Icons.person, color: Colors.grey[300]),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User $postIndex',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '@username$postIndex',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Post content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'This is a sample post from the $postType feed. Post content goes here...',
              style: TextStyle(color: Colors.white),
            ),
          ),

          // Post image placeholder
          Container(
            margin: EdgeInsets.only(top: 12),
            height: 200,
            color: Colors.grey[800],
            child: Center(
              child: Text(
                'Post Image $postIndex',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ),

          // Post actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.favorite_border, '24'),
                _buildActionButton(Icons.comment, '5'),
                _buildActionButton(Icons.share, 'Share'),
                _buildActionButton(Icons.bookmark_border, ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return TextButton.icon(
      onPressed: () {},
      style: TextButton.styleFrom(backgroundColor: Colors.grey[400]),
      icon: Icon(icon, size: 20),
      label: Text(label, style: TextStyle(fontSize: 12)),
    );
  }
}
