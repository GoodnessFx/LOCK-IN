import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressEntryCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback? onEdit;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ProgressEntryCard({
    super.key,
    required this.entry,
    this.onEdit,
    this.onShare,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final date = entry['date'] as DateTime? ?? DateTime.now();
    final activity = entry['activity'] as String? ?? '';
    final igPoints = entry['igPoints'] as int? ?? 0;
    final mediaUrl = entry['mediaUrl'] as String?;
    final hasValidation = entry['hasValidation'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(entry['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit?.call(),
              backgroundColor: AppTheme.getPrimaryColor(context),
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: 'Edit',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            SlidableAction(
              onPressed: (_) => onShare?.call(),
              backgroundColor: AppTheme.getSecondaryColor(context),
              foregroundColor: Colors.white,
              icon: Icons.share_rounded,
              label: 'Share',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: AppTheme.warningLight,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Delete',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: brightness == Brightness.light
                  ? AppTheme.surfaceLight
                  : AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: brightness == Brightness.light
                    ? AppTheme.borderSubtleLight
                    : AppTheme.borderSubtleDark,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with date and validation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                AppTheme.getTextColor(context, secondary: true),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Row(
                      children: [
                        if (hasValidation) ...[
                          CustomIconWidget(
                            iconName: 'verified',
                            color: AppTheme.getSecondaryColor(context),
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                        ],
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.getAccentColor(context)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'bolt',
                                color: AppTheme.getAccentColor(context),
                                size: 12,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '+$igPoints',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppTheme.getAccentColor(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Activity description
                Text(
                  activity,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.getTextColor(context),
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                if (mediaUrl != null) ...[
                  SizedBox(height: 2.h),
                  // Media preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: mediaUrl,
                      width: double.infinity,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],

                SizedBox(height: 2.h),

                // Timeline indicator
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.getPrimaryColor(context),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: brightness == Brightness.light
                            ? AppTheme.borderSubtleLight
                            : AppTheme.borderSubtleDark,
                      ),
                    ),
                    Text(
                      _formatTime(date),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                AppTheme.getTextColor(context, secondary: true),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : hour;
    final minute = date.minute.toString().padLeft(2, '0');

    return '$displayHour:$minute $period';
  }
}
