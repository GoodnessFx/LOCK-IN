import React, { useState, useRef } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  RefreshControl,
  Alert,
  Modal,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import HapticFeedback from 'react-native-haptic-feedback';

import CustomIcon from '../components/CustomIcon';
import CustomImage from '../components/CustomImage';
import BatteryProgressIndicator from '../components/BatteryProgressIndicator';
import CountdownTimer from '../components/CountdownTimer';
import { Colors, Typography, Spacing, BorderRadius, responsiveWidth, responsiveHeight } from '../theme/AppTheme';

const DashboardHome = () => {
  const navigation = useNavigation();
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [showQuickLogModal, setShowQuickLogModal] = useState(false);

  // Mock user data
  const userData = {
    name: "Alex Chen",
    igPoints: 2847,
    streak: 12,
    primarySkill: "Flutter Development",
    skillProgress: 68.5,
    avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
  };

  // Mock achievements data
  const achievements = [
    {
      title: "First Steps",
      description: "Complete first task",
      icon: "emoji-events",
      isUnlocked: true,
      color: Colors.accentLight,
    },
    {
      title: "Streak Master",
      description: "7 day streak",
      icon: "flash-on",
      isUnlocked: true,
      color: Colors.secondaryLight,
    },
    {
      title: "Code Warrior",
      description: "100 commits",
      icon: "star",
      isUnlocked: false,
      color: "#8B5CF6",
    },
  ];

  // Mock progress cards data
  const progressCards = [
    {
      title: "Flutter Widget Mastery",
      description: "Built 15 custom widgets this week, focusing on state management and performance optimization.",
      imageUrl: "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=300&fit=crop",
      progressText: "Week 3/6",
      progressValue: 0.75,
      tags: ["Flutter", "Widgets", "State Management"],
    },
    {
      title: "API Integration Challenge",
      description: "Successfully integrated 5 REST APIs with proper error handling and caching mechanisms.",
      imageUrl: "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400&h=300&fit=crop",
      progressText: "Day 4/7",
      progressValue: 0.57,
      tags: ["API", "REST", "Networking"],
    },
  ];

  // Mock community highlights
  const communityHighlights = [
    {
      userName: "Sarah Kim",
      userAvatar: "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      content: "Just deployed my first Flutter app to the Play Store! The journey from zero to published app took exactly 4 months. Thanks to the Lock In community for all the support! 🚀",
      timeAgo: "2h ago",
      likes: 24,
      comments: 8,
      isLiked: false,
    },
    {
      userName: "Mike Rodriguez",
      userAvatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      content: "Completed my 30-day coding challenge today! Built 30 different Flutter widgets from scratch. The progress tracking in Lock In kept me motivated throughout. 💪",
      timeAgo: "4h ago",
      likes: 31,
      comments: 12,
      isLiked: true,
    },
  ];

  // Mock today's focus tasks
  const todayTasks = [
    {
      title: "Complete State Management Tutorial",
      description: "Learn Provider pattern implementation",
      igPoints: 150,
      difficulty: "Medium",
      isCompleted: false,
      estimatedTime: "45 min",
    },
    {
      title: "Build Custom Animation Widget",
      description: "Create reusable animation component",
      igPoints: 200,
      difficulty: "Hard",
      isCompleted: false,
      estimatedTime: "1.5 hours",
    },
    {
      title: "Review Code with Mentor",
      description: "Get feedback on recent projects",
      igPoints: 100,
      difficulty: "Easy",
      isCompleted: true,
      estimatedTime: "30 min",
    },
  ];

  const onRefresh = async () => {
    setIsRefreshing(true);
    await new Promise(resolve => setTimeout(resolve, 2000));
    setIsRefreshing(false);
    HapticFeedback.trigger('impactLight');
  };

  const getGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  };

  const targetDate = new Date();
  targetDate.setDate(targetDate.getDate() + 180);

  const showAchievementDetails = (achievement) => {
    HapticFeedback.trigger('impactMedium');
    Alert.alert(
      achievement.title,
      achievement.description,
      [{ text: 'Close', style: 'default' }]
    );
  };

  const openCamera = () => {
    HapticFeedback.trigger('impactLight');
    Alert.alert('Camera', 'Opening camera for progress documentation...');
  };

  const openMentors = () => {
    HapticFeedback.trigger('impactLight');
    Alert.alert('Mentors', 'Opening mentor marketplace...');
  };

  const shareProgress = (card) => {
    HapticFeedback.trigger('impactMedium');
    Alert.alert('Share', `Sharing progress: ${card.title}`);
  };

  const viewProgressDetails = (card) => {
    navigation.navigate('ProgressTracking');
  };

  const toggleLike = (highlight) => {
    HapticFeedback.trigger('impactLight');
    // In a real app, this would update the state
  };

  const openComments = (highlight) => {
    navigation.navigate('CommunityFeed');
  };

  const viewPost = (highlight) => {
    navigation.navigate('CommunityFeed');
  };

  const quickProgressLog = () => {
    HapticFeedback.trigger('impactMedium');
    setShowQuickLogModal(true);
  };

  const buildQuickLogOption = (label, iconName, onPress) => (
    <TouchableOpacity style={styles.quickLogOption} onPress={onPress}>
      <View style={styles.quickLogIconContainer}>
        <CustomIcon name={iconName} size={responsiveWidth(6)} color={Colors.primaryLight} />
      </View>
      <Text style={[styles.quickLogLabel, Typography.labelSmall, { color: Colors.textSecondaryLight }]}>
        {label}
      </Text>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <ScrollView
        style={styles.scrollView}
        refreshControl={
          <RefreshControl refreshing={isRefreshing} onRefresh={onRefresh} />
        }
        showsVerticalScrollIndicator={false}
      >
        {/* Custom App Bar with countdown timer */}
        <View style={styles.appBar}>
          <View style={styles.greetingContainer}>
            <Text style={[styles.greeting, Typography.titleLarge, { color: Colors.textPrimaryLight }]}>
              Good {getGreeting()}, {userData.name}!
            </Text>
            <View style={styles.statsContainer}>
              <View style={styles.statItem}>
                <CustomIcon name="stars" size={16} color={Colors.accentLight} />
                <Text style={[styles.statText, Typography.bodyMedium, { color: Colors.accentLight }]}>
                  {userData.igPoints} IG Points
                </Text>
              </View>
              <View style={styles.statItem}>
                <CustomIcon name="local-fire-department" size={16} color={Colors.warningLight} />
                <Text style={[styles.statText, Typography.bodyMedium, { color: Colors.warningLight }]}>
                  {userData.streak} day streak
                </Text>
              </View>
            </View>
          </View>
          <CountdownTimer targetDate={targetDate} />
        </View>

        {/* Hero progress card */}
        <View style={styles.heroProgressContainer}>
          <BatteryProgressIndicator
            progress={userData.skillProgress / 100}
            width={responsiveWidth(30)}
            height={responsiveHeight(15)}
            batteryColor={Colors.secondaryLight}
          />
          <View style={styles.heroProgressText}>
            <Text style={[styles.skillName, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
              {userData.primarySkill}
            </Text>
            <Text style={[styles.progressPercentage, Typography.headlineSmall, { color: Colors.secondaryLight }]}>
              {Math.round(userData.skillProgress)}%
            </Text>
            <Text style={[styles.progressLabel, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
              Complete
            </Text>
          </View>
        </View>

        {/* Recent achievements section */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
            Recent Achievements
          </Text>
          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.achievementsScroll}>
            {achievements.map((achievement, index) => (
              <TouchableOpacity
                key={index}
                style={[styles.achievementCard, { opacity: achievement.isUnlocked ? 1 : 0.5 }]}
                onPress={() => showAchievementDetails(achievement)}
              >
                <View style={[styles.achievementIcon, { backgroundColor: achievement.color + '20' }]}>
                  <CustomIcon name={achievement.icon} size={24} color={achievement.color} />
                </View>
                <Text style={[styles.achievementTitle, Typography.labelMedium, { color: Colors.textPrimaryLight }]}>
                  {achievement.title}
                </Text>
                <Text style={[styles.achievementDescription, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                  {achievement.description}
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        {/* Quick actions */}
        <View style={styles.quickActionsContainer}>
          <TouchableOpacity style={styles.quickActionButton} onPress={openCamera}>
            <CustomIcon name="camera-alt" size={24} color="white" />
            <Text style={[styles.quickActionText, Typography.labelMedium, { color: 'white' }]}>
              Document Progress
            </Text>
          </TouchableOpacity>
          <TouchableOpacity style={[styles.quickActionButton, { backgroundColor: Colors.secondaryLight }]} onPress={openMentors}>
            <CustomIcon name="chat" size={24} color="white" />
            <Text style={[styles.quickActionText, Typography.labelMedium, { color: 'white' }]}>
              Find Mentors
            </Text>
            <View style={styles.badge}>
              <Text style={[styles.badgeText, Typography.labelSmall, { color: 'white' }]}>3</Text>
            </View>
          </TouchableOpacity>
        </View>

        {/* Today's Focus */}
        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <Text style={[styles.sectionTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
              Today's Focus
            </Text>
            <TouchableOpacity onPress={() => navigation.navigate('ProgressTracking')}>
              <Text style={[styles.viewAllText, Typography.labelMedium, { color: Colors.primaryLight }]}>
                View All
              </Text>
            </TouchableOpacity>
          </View>
          {todayTasks.map((task, index) => (
            <View key={index} style={styles.taskCard}>
              <View style={styles.taskInfo}>
                <Text style={[styles.taskTitle, Typography.titleSmall, { color: Colors.textPrimaryLight }]}>
                  {task.title}
                </Text>
                <Text style={[styles.taskDescription, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                  {task.description}
                </Text>
                <View style={styles.taskMeta}>
                  <Text style={[styles.taskPoints, Typography.labelSmall, { color: Colors.accentLight }]}>
                    {task.igPoints} IG Points
                  </Text>
                  <Text style={[styles.taskTime, Typography.labelSmall, { color: Colors.textSecondaryLight }]}>
                    {task.estimatedTime}
                  </Text>
                </View>
              </View>
              <View style={[styles.taskStatus, { backgroundColor: task.isCompleted ? Colors.successLight : Colors.borderSubtleLight }]}>
                <CustomIcon 
                  name={task.isCompleted ? "check" : "radio-button-unchecked"} 
                  size={20} 
                  color={task.isCompleted ? "white" : Colors.textSecondaryLight} 
                />
              </View>
            </View>
          ))}
        </View>

        {/* AI-generated progress cards */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
            Share Your Progress
          </Text>
          {progressCards.map((card, index) => (
            <TouchableOpacity key={index} style={styles.progressCard} onPress={() => viewProgressDetails(card)}>
              <CustomImage
                source={card.imageUrl}
                width={responsiveWidth(100)}
                height={responsiveHeight(25)}
                style={styles.progressCardImage}
              />
              <View style={styles.progressCardOverlay}>
                <TouchableOpacity style={styles.shareButton} onPress={() => shareProgress(card)}>
                  <CustomIcon name="share" size={16} color="white" />
                </TouchableOpacity>
                <View style={styles.progressBadge}>
                  <Text style={[styles.progressBadgeText, Typography.labelSmall, { color: 'white' }]}>
                    {card.progressText}
                  </Text>
                </View>
              </View>
              <View style={styles.progressCardContent}>
                <Text style={[styles.progressCardTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
                  {card.title}
                </Text>
                <Text style={[styles.progressCardDescription, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                  {card.description}
                </Text>
                <View style={styles.progressBarContainer}>
                  <View style={styles.progressBarHeader}>
                    <Text style={[Typography.labelMedium, { color: Colors.textPrimaryLight }]}>Progress</Text>
                    <Text style={[Typography.labelMedium, { color: Colors.primaryLight }]}>
                      {Math.round(card.progressValue * 100)}%
                    </Text>
                  </View>
                  <View style={styles.progressBar}>
                    <View style={[styles.progressBarFill, { width: `${card.progressValue * 100}%` }]} />
                  </View>
                </View>
                <View style={styles.tagsContainer}>
                  {card.tags.slice(0, 3).map((tag, tagIndex) => (
                    <View key={tagIndex} style={styles.tag}>
                      <Text style={[styles.tagText, Typography.labelSmall, { color: Colors.primaryLight }]}>
                        {tag}
                      </Text>
                    </View>
                  ))}
                </View>
              </View>
            </TouchableOpacity>
          ))}
        </View>

        {/* Community highlights */}
        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <Text style={[styles.sectionTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
              Community Highlights
            </Text>
            <TouchableOpacity onPress={() => navigation.navigate('CommunityFeed')}>
              <Text style={[styles.viewAllText, Typography.labelMedium, { color: Colors.primaryLight }]}>
                View All
              </Text>
            </TouchableOpacity>
          </View>
          {communityHighlights.map((highlight, index) => (
            <TouchableOpacity key={index} style={styles.communityCard} onPress={() => viewPost(highlight)}>
              <View style={styles.communityHeader}>
                <CustomImage
                  source={highlight.userAvatar}
                  width={40}
                  height={40}
                  style={styles.communityAvatar}
                />
                <View style={styles.communityUserInfo}>
                  <Text style={[styles.communityUserName, Typography.labelMedium, { color: Colors.textPrimaryLight }]}>
                    {highlight.userName}
                  </Text>
                  <Text style={[styles.communityTime, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                    {highlight.timeAgo}
                  </Text>
                </View>
              </View>
              <Text style={[styles.communityContent, Typography.bodyMedium, { color: Colors.textPrimaryLight }]}>
                {highlight.content}
              </Text>
              <View style={styles.communityActions}>
                <TouchableOpacity style={styles.communityAction} onPress={() => toggleLike(highlight)}>
                  <CustomIcon 
                    name={highlight.isLiked ? "favorite" : "favorite-border"} 
                    size={20} 
                    color={highlight.isLiked ? Colors.warningLight : Colors.textSecondaryLight} 
                  />
                  <Text style={[styles.communityActionText, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                    {highlight.likes}
                  </Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.communityAction} onPress={() => openComments(highlight)}>
                  <CustomIcon name="comment" size={20} color={Colors.textSecondaryLight} />
                  <Text style={[styles.communityActionText, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                    {highlight.comments}
                  </Text>
                </TouchableOpacity>
              </View>
            </TouchableOpacity>
          ))}
        </View>

        <View style={styles.bottomPadding} />
      </ScrollView>

      {/* Floating Action Button */}
      <TouchableOpacity style={styles.fab} onPress={quickProgressLog}>
        <CustomIcon name="add" size={28} color="white" />
      </TouchableOpacity>

      {/* Quick Progress Log Modal */}
      <Modal
        visible={showQuickLogModal}
        transparent
        animationType="slide"
        onRequestClose={() => setShowQuickLogModal(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <View style={styles.modalHandle} />
            <Text style={[styles.modalTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
              Quick Progress Log
            </Text>
            <View style={styles.quickLogOptions}>
              {buildQuickLogOption('Photo', 'camera-alt', () => {
                setShowQuickLogModal(false);
                openCamera();
              })}
              {buildQuickLogOption('Note', 'edit', () => {
                setShowQuickLogModal(false);
                // Handle note creation
              })}
              {buildQuickLogOption('Achievement', 'emoji-events', () => {
                setShowQuickLogModal(false);
                // Handle achievement logging
              })}
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
  scrollView: {
    flex: 1,
  },
  appBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: responsiveWidth(4),
    paddingVertical: responsiveHeight(2),
  },
  greetingContainer: {
    flex: 1,
  },
  greeting: {
    fontWeight: '600',
    marginBottom: responsiveHeight(0.5),
  },
  statsContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  statItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: responsiveWidth(3),
  },
  statText: {
    marginLeft: responsiveWidth(1),
    fontWeight: '600',
  },
  heroProgressContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: responsiveWidth(4),
    marginBottom: responsiveHeight(4),
  },
  heroProgressText: {
    marginLeft: responsiveWidth(4),
  },
  skillName: {
    fontWeight: '600',
    marginBottom: responsiveHeight(2),
  },
  progressPercentage: {
    fontWeight: '700',
    marginBottom: responsiveHeight(0.5),
  },
  progressLabel: {
    // Styles already defined in Typography
  },
  section: {
    marginBottom: responsiveHeight(4),
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: responsiveWidth(4),
    marginBottom: responsiveHeight(2),
  },
  sectionTitle: {
    fontWeight: '600',
  },
  viewAllText: {
    fontWeight: '500',
  },
  achievementsScroll: {
    paddingLeft: responsiveWidth(4),
  },
  achievementCard: {
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    marginRight: responsiveWidth(3),
    alignItems: 'center',
    minWidth: responsiveWidth(30),
    ...Colors.shadowMediumLight,
  },
  achievementIcon: {
    width: 48,
    height: 48,
    borderRadius: 24,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: Spacing.md,
  },
  achievementTitle: {
    fontWeight: '600',
    textAlign: 'center',
    marginBottom: Spacing.xs,
  },
  achievementDescription: {
    textAlign: 'center',
  },
  quickActionsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-evenly',
    paddingHorizontal: responsiveWidth(4),
    marginBottom: responsiveHeight(4),
  },
  quickActionButton: {
    backgroundColor: Colors.primaryLight,
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.lg,
    borderRadius: BorderRadius.lg,
    alignItems: 'center',
    justifyContent: 'center',
    minWidth: responsiveWidth(35),
    position: 'relative',
  },
  quickActionText: {
    marginTop: Spacing.sm,
    fontWeight: '500',
  },
  badge: {
    position: 'absolute',
    top: -8,
    right: -8,
    backgroundColor: Colors.warningLight,
    borderRadius: 10,
    width: 20,
    height: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  badgeText: {
    fontWeight: '600',
  },
  taskCard: {
    flexDirection: 'row',
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    marginHorizontal: responsiveWidth(4),
    marginBottom: Spacing.md,
    alignItems: 'center',
    ...Colors.shadowMediumLight,
  },
  taskInfo: {
    flex: 1,
  },
  taskTitle: {
    fontWeight: '600',
    marginBottom: Spacing.xs,
  },
  taskDescription: {
    marginBottom: Spacing.sm,
  },
  taskMeta: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  taskPoints: {
    fontWeight: '500',
  },
  taskTime: {
    // Styles already defined in Typography
  },
  taskStatus: {
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
    marginLeft: Spacing.lg,
  },
  progressCard: {
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    marginHorizontal: responsiveWidth(4),
    marginBottom: Spacing.lg,
    overflow: 'hidden',
    ...Colors.shadowMediumLight,
  },
  progressCardImage: {
    width: '100%',
  },
  progressCardOverlay: {
    position: 'absolute',
    top: responsiveHeight(2),
    left: responsiveWidth(3),
    right: responsiveWidth(3),
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
  },
  shareButton: {
    backgroundColor: 'rgba(0, 0, 0, 0.7)',
    borderRadius: 20,
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
  },
  progressBadge: {
    backgroundColor: 'rgba(0, 0, 0, 0.7)',
    paddingHorizontal: responsiveWidth(2),
    paddingVertical: responsiveHeight(0.5),
    borderRadius: BorderRadius.md,
  },
  progressBadgeText: {
    fontWeight: '600',
  },
  progressCardContent: {
    padding: Spacing.lg,
  },
  progressCardTitle: {
    fontWeight: '600',
    marginBottom: Spacing.sm,
  },
  progressCardDescription: {
    marginBottom: Spacing.lg,
  },
  progressBarContainer: {
    marginBottom: Spacing.lg,
  },
  progressBarHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: Spacing.sm,
  },
  progressBar: {
    height: 4,
    backgroundColor: Colors.borderSubtleLight,
    borderRadius: 2,
    overflow: 'hidden',
  },
  progressBarFill: {
    height: '100%',
    backgroundColor: Colors.primaryLight,
  },
  tagsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  tag: {
    backgroundColor: Colors.primaryLight + '1A',
    paddingHorizontal: responsiveWidth(2),
    paddingVertical: responsiveHeight(0.5),
    borderRadius: BorderRadius.sm,
    marginRight: responsiveWidth(2),
    marginBottom: responsiveHeight(0.5),
  },
  tagText: {
    fontWeight: '500',
  },
  communityCard: {
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    marginHorizontal: responsiveWidth(4),
    marginBottom: Spacing.lg,
    ...Colors.shadowMediumLight,
  },
  communityHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: Spacing.md,
  },
  communityAvatar: {
    borderRadius: 20,
    marginRight: Spacing.md,
  },
  communityUserInfo: {
    flex: 1,
  },
  communityUserName: {
    fontWeight: '600',
    marginBottom: 2,
  },
  communityTime: {
    // Styles already defined in Typography
  },
  communityContent: {
    marginBottom: Spacing.lg,
    lineHeight: 20,
  },
  communityActions: {
    flexDirection: 'row',
  },
  communityAction: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: Spacing.xl,
  },
  communityActionText: {
    marginLeft: Spacing.xs,
  },
  bottomPadding: {
    height: responsiveHeight(10),
  },
  fab: {
    position: 'absolute',
    bottom: responsiveHeight(8),
    right: responsiveWidth(4),
    backgroundColor: Colors.primaryLight,
    width: 56,
    height: 56,
    borderRadius: 28,
    justifyContent: 'center',
    alignItems: 'center',
    ...Colors.shadowStrongLight,
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
    padding: responsiveWidth(6),
    paddingBottom: responsiveHeight(4),
  },
  modalHandle: {
    width: responsiveWidth(12),
    height: 4,
    backgroundColor: Colors.borderSubtleLight,
    borderRadius: 2,
    alignSelf: 'center',
    marginBottom: responsiveHeight(3),
  },
  modalTitle: {
    fontWeight: '600',
    textAlign: 'center',
    marginBottom: responsiveHeight(3),
  },
  quickLogOptions: {
    flexDirection: 'row',
    justifyContent: 'space-evenly',
  },
  quickLogOption: {
    alignItems: 'center',
  },
  quickLogIconContainer: {
    width: responsiveWidth(15),
    height: responsiveWidth(15),
    backgroundColor: Colors.primaryLight + '1A',
    borderRadius: responsiveWidth(7.5),
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: responsiveHeight(1),
  },
  quickLogLabel: {
    // Styles already defined in Typography
  },
});

export default DashboardHome;
