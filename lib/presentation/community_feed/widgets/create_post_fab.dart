import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreatePostFAB extends StatefulWidget {
  final VoidCallback? onPostCreated;

  const CreatePostFAB({
    super.key,
    this.onPostCreated,
  });

  @override
  State<CreatePostFAB> createState() => _CreatePostFABState();
}

class _CreatePostFABState extends State<CreatePostFAB> {
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  XFile? _capturedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          final camera = kIsWeb
              ? _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.front,
                  orElse: () => _cameras.first)
              : _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.back,
                  orElse: () => _cameras.first);

          _cameraController = CameraController(
              camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);
          await _cameraController!.initialize();
          await _applySettings();
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }
    } catch (e) {
      debugPrint('Camera settings error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = photo;
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Gallery picker error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreatePostModal(context),
      tooltip: 'Create Post',
      child: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 24,
      ),
    );
  }

  void _showCreatePostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: _buildCreatePostContent(context, scrollController),
        ),
      ),
    );
  }

  Widget _buildCreatePostContent(
      BuildContext context, ScrollController scrollController) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Handle bar
        Container(
          width: 12.w,
          height: 0.5.h,
          margin: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color: AppTheme.getTextColor(context, secondary: true),
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.getTextColor(context),
                  size: 24,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'Create Post',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onPostCreated?.call();
                },
                child: const Text('Share'),
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Content
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPostTypeSelector(context),
                SizedBox(height: 3.h),
                _buildTextInput(context),
                SizedBox(height: 3.h),
                _buildMediaSection(context),
                SizedBox(height: 3.h),
                _buildProgressCardTemplates(context),
                SizedBox(height: 10.h), // Bottom padding for keyboard
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostTypeSelector(BuildContext context) {
    final postTypes = [
      'Progress Update',
      'Milestone',
      'Discussion',
      'Achievement'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Post Type',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: postTypes
              .map((type) => _buildPostTypeChip(context, type))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPostTypeChip(BuildContext context, String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.getPrimaryColor(context),
          width: 1,
        ),
      ),
      child: Text(
        type,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.getPrimaryColor(context),
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Widget _buildTextInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s on your mind?',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Share your progress, thoughts, or achievements...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Media',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            _buildMediaButton(
              context,
              'camera_alt',
              'Camera',
              _capturePhoto,
            ),
            SizedBox(width: 4.w),
            _buildMediaButton(
              context,
              'photo_library',
              'Gallery',
              _pickFromGallery,
            ),
          ],
        ),
        if (_capturedImage != null) ...[
          SizedBox(height: 2.h),
          _buildImagePreview(context),
        ],
      ],
    );
  }

  Widget _buildMediaButton(
    BuildContext context,
    String iconName,
    String label,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color: AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.getPrimaryColor(context).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.getPrimaryColor(context),
                size: 32,
              ),
              SizedBox(height: 1.h),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.getPrimaryColor(context),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderSubtleLight,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: kIsWeb
                ? Image.network(
                    _capturedImage!.path,
                    width: double.infinity,
                    height: 40.w,
                    fit: BoxFit.cover,
                  )
                : CustomImageWidget(
                    imageUrl: _capturedImage!.path,
                    width: double.infinity,
                    height: 40.w,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: 2.w,
            right: 2.w,
            child: GestureDetector(
              onTap: () => setState(() => _capturedImage = null),
              child: Container(
                padding: EdgeInsets.all(1.w),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCardTemplates(BuildContext context) {
    final templates = [
      {'name': 'Daily Progress', 'icon': 'today'},
      {'name': 'Weekly Summary', 'icon': 'date_range'},
      {'name': 'Skill Milestone', 'icon': 'emoji_events'},
      {'name': 'Learning Goal', 'icon': 'flag'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Card Templates',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2.w,
            mainAxisSpacing: 1.h,
            childAspectRatio: 2.5,
          ),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            return GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.getSecondaryColor(context)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.getSecondaryColor(context)
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: template['icon'] as String,
                      color: AppTheme.getSecondaryColor(context),
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        template['name'] as String,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.getSecondaryColor(context),
                              fontWeight: FontWeight.w500,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
