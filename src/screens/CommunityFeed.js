import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  TextInput,
  Modal,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';

import CustomIcon from '../components/CustomIcon';
import CustomImage from '../components/CustomImage';
import { Colors, Typography, Spacing, BorderRadius, responsiveWidth, responsiveHeight } from '../theme/AppTheme';

const CommunityFeed = () => {
  const navigation = useNavigation();
  const [selectedFilter, setSelectedFilter] = useState('All');
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [newPost, setNewPost] = useState({ content: '', category: 'General' });

  const filters = ['All', 'General', 'Development', 'Design', 'Business', 'Personal'];

  // Mock community posts
  const communityPosts = [
    {
      id: 1,
      userName: 'Sarah Kim',
      userAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      content: 'Just deployed my first Flutter app to the Play Store! The journey from zero to published app took exactly 4 months. Thanks to the Lock In community for all the support! 🚀',
      timeAgo: '2h ago',
      likes: 24,
      comments: 8,
      isLiked: false,
      category: 'Development',
      tags: ['Flutter', 'Mobile', 'Deployment'],
    },
    {
      id: 2,
      userName: 'Mike Rodriguez',
      userAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      content: 'Completed my 30-day coding challenge today! Built 30 different Flutter widgets from scratch. The progress tracking in Lock In kept me motivated throughout. 💪',
      timeAgo: '4h ago',
      likes: 31,
      comments: 12,
      isLiked: true,
      category: 'Development',
      tags: ['Challenge', 'Widgets', 'Motivation'],
    },
    {
      id: 3,
      userName: 'Emma Chen',
      userAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      content: 'Design system update: Created a comprehensive component library for our React Native app. Consistency is key! 🎨',
      timeAgo: '6h ago',
      likes: 18,
      comments: 5,
      isLiked: false,
      category: 'Design',
      tags: ['Design System', 'Components', 'React Native'],
    },
    {
      id: 4,
      userName: 'Alex Johnson',
      userAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      content: 'Business milestone: Reached 1000 users on our platform! The gamification features really helped with user engagement. 📈',
      timeAgo: '8h ago',
      likes: 42,
      comments: 15,
      isLiked: true,
      category: 'Business',
      tags: ['Milestone', 'Users', 'Gamification'],
    },
  ];

  const filteredPosts = selectedFilter === 'All' 
    ? communityPosts 
    : communityPosts.filter(post => post.category === selectedFilter);

  const createPost = () => {
    // In a real app, this would save to a database
    setShowCreateModal(false);
    setNewPost({ content: '', category: 'General' });
  };

  const toggleLike = (postId) => {
    // In a real app, this would update the database
    console.log('Toggle like for post:', postId);
  };

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <CustomIcon name="arrow-back" size={24} color={Colors.textPrimaryLight} />
        </TouchableOpacity>
        <Text style={[styles.headerTitle, Typography.titleLarge, { color: Colors.textPrimaryLight }]}>
          Community
        </Text>
        <TouchableOpacity onPress={() => setShowCreateModal(true)}>
          <CustomIcon name="add" size={24} color={Colors.primaryLight} />
        </TouchableOpacity>
      </View>

      {/* Search Bar */}
      <View style={styles.searchContainer}>
        <View style={styles.searchBar}>
          <CustomIcon name="search" size={20} color={Colors.textSecondaryLight} />
          <TextInput
            style={[styles.searchInput, Typography.bodyMedium]}
            placeholder="Search posts, users, or topics..."
            placeholderTextColor={Colors.textSecondaryLight}
          />
        </View>
      </View>

      {/* Filter Chips */}
      <ScrollView 
        horizontal 
        showsHorizontalScrollIndicator={false} 
        style={styles.filterContainer}
        contentContainerStyle={styles.filterContent}
      >
        {filters.map((filter) => (
          <TouchableOpacity
            key={filter}
            style={[
              styles.filterChip,
              selectedFilter === filter && styles.filterChipActive
            ]}
            onPress={() => setSelectedFilter(filter)}
          >
            <Text style={[
              styles.filterChipText,
              Typography.labelMedium,
              { 
                color: selectedFilter === filter ? 'white' : Colors.textSecondaryLight,
                fontWeight: selectedFilter === filter ? '600' : '400'
              }
            ]}>
              {filter}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      {/* Community Stats */}
      <View style={styles.statsContainer}>
        <View style={styles.statCard}>
          <Text style={[styles.statValue, Typography.headlineSmall, { color: Colors.primaryLight }]}>
            15.4K
          </Text>
          <Text style={[styles.statLabel, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
            Active Users
          </Text>
        </View>
        <View style={styles.statCard}>
          <Text style={[styles.statValue, Typography.headlineSmall, { color: Colors.secondaryLight }]}>
            3
          </Text>
          <Text style={[styles.statLabel, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
            Daily Challenges
          </Text>
        </View>
        <View style={styles.statCard}>
          <Text style={[styles.statValue, Typography.headlineSmall, { color: Colors.accentLight }]}>
            12
          </Text>
          <Text style={[styles.statLabel, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
            Featured Mentors
          </Text>
        </View>
      </View>

      {/* Posts Feed */}
      <ScrollView style={styles.feedContainer} showsVerticalScrollIndicator={false}>
        {filteredPosts.map((post) => (
          <View key={post.id} style={styles.postCard}>
            {/* Post Header */}
            <View style={styles.postHeader}>
              <CustomImage
                source={post.userAvatar}
                width={40}
                height={40}
                style={styles.userAvatar}
              />
              <View style={styles.userInfo}>
                <Text style={[styles.userName, Typography.labelMedium, { color: Colors.textPrimaryLight }]}>
                  {post.userName}
                </Text>
                <Text style={[styles.postTime, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                  {post.timeAgo}
                </Text>
              </View>
              <View style={[styles.categoryBadge, { backgroundColor: Colors.primaryLight + '20' }]}>
                <Text style={[styles.categoryText, Typography.labelSmall, { color: Colors.primaryLight }]}>
                  {post.category}
                </Text>
              </View>
            </View>

            {/* Post Content */}
            <Text style={[styles.postContent, Typography.bodyMedium, { color: Colors.textPrimaryLight }]}>
              {post.content}
            </Text>

            {/* Post Tags */}
            <View style={styles.tagsContainer}>
              {post.tags.map((tag, index) => (
                <View key={index} style={styles.tag}>
                  <Text style={[styles.tagText, Typography.labelSmall, { color: Colors.primaryLight }]}>
                    #{tag}
                  </Text>
                </View>
              ))}
            </View>

            {/* Post Actions */}
            <View style={styles.postActions}>
              <TouchableOpacity 
                style={styles.actionButton}
                onPress={() => toggleLike(post.id)}
              >
                <CustomIcon 
                  name={post.isLiked ? "favorite" : "favorite-border"} 
                  size={20} 
                  color={post.isLiked ? Colors.warningLight : Colors.textSecondaryLight} 
                />
                <Text style={[
                  styles.actionText,
                  Typography.bodySmall,
                  { color: post.isLiked ? Colors.warningLight : Colors.textSecondaryLight }
                ]}>
                  {post.likes}
                </Text>
              </TouchableOpacity>

              <TouchableOpacity style={styles.actionButton}>
                <CustomIcon name="comment" size={20} color={Colors.textSecondaryLight} />
                <Text style={[styles.actionText, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                  {post.comments}
                </Text>
              </TouchableOpacity>

              <TouchableOpacity style={styles.actionButton}>
                <CustomIcon name="share" size={20} color={Colors.textSecondaryLight} />
                <Text style={[styles.actionText, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                  Share
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        ))}
      </ScrollView>

      {/* Create Post Modal */}
      <Modal
        visible={showCreateModal}
        transparent
        animationType="slide"
        onRequestClose={() => setShowCreateModal(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <View style={styles.modalHeader}>
              <Text style={[styles.modalTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
                Create Post
              </Text>
              <TouchableOpacity onPress={() => setShowCreateModal(false)}>
                <CustomIcon name="close" size={24} color={Colors.textSecondaryLight} />
              </TouchableOpacity>
            </View>
            
            <View style={styles.formContainer}>
              <View style={styles.inputGroup}>
                <Text style={[styles.inputLabel, Typography.labelMedium, { color: Colors.textSecondaryLight }]}>
                  What's on your mind?
                </Text>
                <TextInput
                  style={[styles.input, styles.textArea, Typography.bodyMedium]}
                  placeholder="Share your progress, ask questions, or inspire others..."
                  placeholderTextColor={Colors.textSecondaryLight}
                  value={newPost.content}
                  onChangeText={(text) => setNewPost({...newPost, content: text})}
                  multiline
                  numberOfLines={6}
                />
              </View>

              <View style={styles.inputGroup}>
                <Text style={[styles.inputLabel, Typography.labelMedium, { color: Colors.textSecondaryLight }]}>
                  Category
                </Text>
                <View style={styles.categoryOptions}>
                  {['General', 'Development', 'Design', 'Business', 'Personal'].map((category) => (
                    <TouchableOpacity
                      key={category}
                      style={[
                        styles.categoryOption,
                        newPost.category === category && styles.categoryOptionActive
                      ]}
                      onPress={() => setNewPost({...newPost, category})}
                    >
                      <Text style={[
                        styles.categoryOptionText,
                        Typography.labelMedium,
                        { 
                          color: newPost.category === category ? 'white' : Colors.textSecondaryLight,
                          fontWeight: newPost.category === category ? '600' : '400'
                        }
                      ]}>
                        {category}
                      </Text>
                    </TouchableOpacity>
                  ))}
                </View>
              </View>
            </View>

            <View style={styles.modalActions}>
              <TouchableOpacity 
                style={[styles.modalButton, styles.cancelButton]}
                onPress={() => setShowCreateModal(false)}
              >
                <Text style={[styles.modalButtonText, Typography.labelLarge, { color: Colors.textSecondaryLight }]}>
                  Cancel
                </Text>
              </TouchableOpacity>
              <TouchableOpacity 
                style={[styles.modalButton, styles.postButton]}
                onPress={createPost}
              >
                <Text style={[styles.modalButtonText, Typography.labelLarge, { color: 'white' }]}>
                  Post
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.backgroundLight,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: responsiveWidth(4),
    paddingVertical: responsiveHeight(2),
    borderBottomWidth: 1,
    borderBottomColor: Colors.borderSubtleLight,
  },
  headerTitle: {
    fontWeight: '600',
  },
  searchContainer: {
    paddingHorizontal: responsiveWidth(4),
    paddingVertical: responsiveHeight(1),
  },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.md,
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
  },
  searchInput: {
    flex: 1,
    marginLeft: Spacing.sm,
    color: Colors.textPrimaryLight,
  },
  filterContainer: {
    marginBottom: responsiveHeight(2),
  },
  filterContent: {
    paddingHorizontal: responsiveWidth(4),
  },
  filterChip: {
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.md,
    borderRadius: BorderRadius.lg,
    backgroundColor: Colors.surfaceLight,
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
    marginRight: Spacing.md,
  },
  filterChipActive: {
    backgroundColor: Colors.primaryLight,
    borderColor: Colors.primaryLight,
  },
  filterChipText: {
    // Styles applied inline
  },
  statsContainer: {
    flexDirection: 'row',
    paddingHorizontal: responsiveWidth(4),
    marginBottom: responsiveHeight(2),
  },
  statCard: {
    flex: 1,
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    alignItems: 'center',
    marginHorizontal: Spacing.xs,
    ...Colors.shadowMediumLight,
  },
  statValue: {
    fontWeight: '700',
    marginBottom: Spacing.xs,
  },
  statLabel: {
    textAlign: 'center',
  },
  feedContainer: {
    flex: 1,
    paddingHorizontal: responsiveWidth(4),
  },
  postCard: {
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    marginBottom: Spacing.lg,
    ...Colors.shadowMediumLight,
  },
  postHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: Spacing.md,
  },
  userAvatar: {
    borderRadius: 20,
    marginRight: Spacing.md,
  },
  userInfo: {
    flex: 1,
  },
  userName: {
    fontWeight: '600',
    marginBottom: 2,
  },
  postTime: {
    // Styles already defined in Typography
  },
  categoryBadge: {
    paddingHorizontal: Spacing.sm,
    paddingVertical: Spacing.xs,
    borderRadius: BorderRadius.sm,
  },
  categoryText: {
    fontWeight: '500',
  },
  postContent: {
    lineHeight: 22,
    marginBottom: Spacing.md,
  },
  tagsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginBottom: Spacing.md,
  },
  tag: {
    backgroundColor: Colors.primaryLight + '1A',
    paddingHorizontal: Spacing.sm,
    paddingVertical: Spacing.xs,
    borderRadius: BorderRadius.sm,
    marginRight: Spacing.sm,
    marginBottom: Spacing.xs,
  },
  tagText: {
    fontWeight: '500',
  },
  postActions: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    paddingTop: Spacing.md,
    borderTopWidth: 1,
    borderTopColor: Colors.borderSubtleLight,
  },
  actionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: Spacing.sm,
  },
  actionText: {
    marginLeft: Spacing.xs,
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'flex-end',
  },
  modalContent: {
    backgroundColor: Colors.surfaceLight,
    borderTopLeftRadius: BorderRadius.xl,
    borderTopRightRadius: BorderRadius.xl,
    padding: Spacing.lg,
    maxHeight: '80%',
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: Spacing.lg,
  },
  modalTitle: {
    fontWeight: '600',
  },
  formContainer: {
    marginBottom: Spacing.lg,
  },
  inputGroup: {
    marginBottom: Spacing.lg,
  },
  inputLabel: {
    marginBottom: Spacing.sm,
  },
  input: {
    backgroundColor: Colors.backgroundLight,
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
    borderRadius: BorderRadius.lg,
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.lg,
    color: Colors.textPrimaryLight,
  },
  textArea: {
    height: 120,
    textAlignVertical: 'top',
  },
  categoryOptions: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  categoryOption: {
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.md,
    borderRadius: BorderRadius.lg,
    backgroundColor: Colors.backgroundLight,
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
    marginRight: Spacing.sm,
    marginBottom: Spacing.sm,
  },
  categoryOptionActive: {
    backgroundColor: Colors.primaryLight,
    borderColor: Colors.primaryLight,
  },
  categoryOptionText: {
    // Styles applied inline
  },
  modalActions: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  modalButton: {
    flex: 1,
    paddingVertical: Spacing.lg,
    borderRadius: BorderRadius.lg,
    alignItems: 'center',
    marginHorizontal: Spacing.sm,
  },
  cancelButton: {
    backgroundColor: Colors.backgroundLight,
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
  },
  postButton: {
    backgroundColor: Colors.primaryLight,
  },
  modalButtonText: {
    fontWeight: '600',
  },
});

export default CommunityFeed;
