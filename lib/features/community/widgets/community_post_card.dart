import 'package:flutter/material.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/community/models/community_post_model.dart';

class CommunityPostCard extends StatelessWidget {
  final CommunityPostModel post;
  final VoidCallback onTap;

  const CommunityPostCard({super.key, required this.post, required this.onTap});

  String _formatDate(DateTime dt) {
    return '${dt.year}년 ${dt.month.toString().padLeft(2, '0')}월 ${dt.day.toString().padLeft(2, '0')}일';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.size20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Sizes.size14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.authorName,
              style: const TextStyle(
                fontSize: Sizes.size14,
                color: Color(0xff747474),
              ),
            ),
            Gaps.v10,
            Text(
              post.title,
              style: const TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Gaps.v8,
            Text(
              post.content,
              style: const TextStyle(
                fontSize: Sizes.size14,
                color: Color(0xff444444),
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Gaps.v16,
            Row(
              children: [
                Text(
                  _formatDate(post.createdAt),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff9EA7B2),
                  ),
                ),
                const Spacer(),
                Icon(Icons.favorite,
                    size: 16,
                    color: post.isLiked
                        ? const Color(0xffE53935)
                        : const Color(0xff9EA7B2)),
                Gaps.h4,
                Text(
                  '${post.likesCount}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff9EA7B2),
                  ),
                ),
                Gaps.h12,
                const Icon(Icons.chat_bubble_outline,
                    size: 16, color: Color(0xff9EA7B2)),
                Gaps.h4,
                Text(
                  '${post.commentsCount}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff9EA7B2),
                  ),
                ),
                Gaps.h12,
                const Icon(Icons.remove_red_eye_outlined,
                    size: 16, color: Color(0xff9EA7B2)),
                Gaps.h4,
                Text(
                  '${post.viewCount}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff9EA7B2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
