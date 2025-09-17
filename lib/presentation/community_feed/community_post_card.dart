import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class CommunityPostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final VoidCallback? onTap;

  const CommunityPostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
    this.onTap,
  });

  @override
  State<CommunityPostCard> createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard>
    with TickerProviderStateMixin {
  bool _isLiked = false;
  late AnimationController _likeAnimationController;
  late Animation<double> _likeAnimation;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post['isLiked'] ?? false;
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _likeAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (!_isLiked) {
      setState(() {
        _isLiked = true;
      });
      _likeAnimationController.forward().then((_) {
        _likeAnimationController.reverse();
      });
      widget.onLike?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: _handleDoubleTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: brightness == Brightness.light
              ? AppTheme.surfaceLight
              : AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: brightness == Brightness.light
                  ? AppTheme.shadowMediumLight
                  : AppTheme.shadowMediumDark,
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(context, brightness),
            _buildPostContent(context, brightness),
            _buildPostImage(context),
            _buildEngagementSection(context, brightness),
            _buildActionButtons(context, brightness),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(BuildContext context, Brightness brightness) {
    final user = widget.post['user'] as Map<String, dynamic>;
    final skill = widget.post['skill'] as Map<String, dynamic>?;

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.getPrimaryColor(context),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: user['avatar'] as String,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 3.w),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user['name'] as String,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (user['isVerified'] == true) ...[
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'verified',
                        color: AppTheme.getPrimaryColor(context),
                        size: 16,
                      ),
                    ],
                  ],
                ),
                if (skill != null)
                  Container(
                    margin: EdgeInsets.only(top: 0.5.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.getSecondaryColor(context)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      skill['name'] as String,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.getSecondaryColor(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Timestamp and Menu
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTimestamp(widget.post['timestamp'] as DateTime),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.getTextColor(context, secondary: true),
                ),
              ),
              SizedBox(height: 0.5.h),
              GestureDetector(
                onTap: () => _showPostMenu(context),
                child: CustomIconWidget(
                  iconName: 'more_horiz',
                  color: AppTheme.getTextColor(context, secondary: true),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(BuildContext context, Brightness brightness) {
    final content = widget.post['content'] as String?;
    if (content == null || content.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPostImage(BuildContext context) {
    final imageUrl = widget.post['imageUrl'] as String?;
    if (imageUrl == null || imageUrl.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      width: double.infinity,
      height: 50.w,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImageWidget(
              imageUrl: imageUrl,
              width: double.infinity,
              height: 50.w,
              fit: BoxFit.cover,
            ),
          ),

          // Like animation overlay
          if (_likeAnimationController.isAnimating)
            Center(
              child: AnimatedBuilder(
                animation: _likeAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _likeAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'favorite',
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEngagementSection(BuildContext context, Brightness brightness) {
    final likes = widget.post['likes'] as int? ?? 0;
    final comments = widget.post['comments'] as int? ?? 0;
    final shares = widget.post['shares'] as int? ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          _buildEngagementItem(
            context,
            CustomIconWidget(
              iconName: 'favorite',
              color: Colors.red,
              size: 16,
            ),
            '$likes',
          ),
          SizedBox(width: 4.w),
          _buildEngagementItem(
            context,
            CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: AppTheme.getTextColor(context, secondary: true),
              size: 16,
            ),
            '$comments',
          ),
          SizedBox(width: 4.w),
          _buildEngagementItem(
            context,
            CustomIconWidget(
              iconName: 'share',
              color: AppTheme.getTextColor(context, secondary: true),
              size: 16,
            ),
            '$shares',
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementItem(BuildContext context, Widget icon, String count) {
    return Row(
      children: [
        icon,
        SizedBox(width: 1.w),
        Text(
          count,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.getTextColor(context, secondary: true),
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Brightness brightness) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: brightness == Brightness.light
                ? AppTheme.borderSubtleLight
                : AppTheme.borderSubtleDark,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            context,
            _isLiked ? 'favorite' : 'favorite_border',
            'Like',
            _isLiked ? Colors.red : null,
            () {
              setState(() {
                _isLiked = !_isLiked;
              });
              widget.onLike?.call();
            },
          ),
          _buildActionButton(
            context,
            'chat_bubble_outline',
            'Comment',
            null,
            widget.onComment,
          ),
          _buildActionButton(
            context,
            'share',
            'Share',
            null,
            widget.onShare,
          ),
          _buildActionButton(
            context,
            'bookmark_border',
            'Save',
            null,
            widget.onSave,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String iconName,
    String label,
    Color? iconColor,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color:
                  iconColor ?? AppTheme.getTextColor(context, secondary: true),
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.getTextColor(context, secondary: true),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _showPostMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.getTextColor(context, secondary: true),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.getTextColor(context),
                size: 24,
              ),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/user-profile');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.getTextColor(context),
                size: 24,
              ),
              title: const Text('Send Message'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: Colors.red,
                size: 24,
              ),
              title: const Text('Report Post'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}