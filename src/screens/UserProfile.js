import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Modal,
  Switch,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';

import CustomIcon from '../components/CustomIcon';
import CustomImage from '../components/CustomImage';
import BatteryProgressIndicator from '../components/BatteryProgressIndicator';
import { Colors, Typography, Spacing, BorderRadius, responsiveWidth, responsiveHeight } from '../theme/AppTheme';

const UserProfile = () => {
  const navigation = useNavigation();
  const [showEditModal, setShowEditModal] = useState(false);
  const [isDarkMode, setIsDarkMode] = useState(false);
  const [notificationsEnabled, setNotificationsEnabled] = useState(true);

  // Mock user data
  const userData = {
    name: "Alex Chen",
    email: "alex.chen@example.com",
    bio: "Flutter developer passionate about creating beautiful mobile experiences. Currently learning React Native and exploring the world of cross-platform development.",
    avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    joinDate: "January 2024",
    totalPoints: 2847,
    currentStreak: 12,
    longestStreak: 28,
    completedChallenges: 15,
    level: "Advanced",
    rank: "#1,247",
  };

  // Mock achievements
  const achievements = [
    {
      id: 1,
      title: "First Steps",
      description: "Complete your first task",
      icon: "emoji-events",
      isUnlocked: true,
      unlockedDate: "2024-01-15",
      color: Colors.accentLight,
    },
    {
      id: 2,
      title: "Streak Master",
      description: "Maintain a 7-day streak",
      icon: "local-fire-department",
      isUnlocked: true,
      unlockedDate: "2024-01-20",
      color: Colors.warningLight,
    },
    {
      id: 3,
      title: "Code Warrior",
      description: "Complete 100 coding tasks",
      icon: "code",
      isUnlocked: true,
      unlockedDate: "2024-01-25",
      color: Colors.primaryLight,
    },
    {
      id: 4,
      title: "Community Helper",
      description: "Help 10 community members",
      icon: "people",
      isUnlocked: false,
      unlockedDate: null,
      color: Colors.secondaryLight,
    },
    {
      id: 5,
      title: "Design Master",
      description: "Complete 50 design challenges",
      icon: "palette",
      isUnlocked: false,
      unlockedDate: null,
      color: "#8B5CF6",
    },
    {
      id: 6,
      title: "Business Guru",
      description: "Complete 25 business tasks",
      icon: "business",
      isUnlocked: false,
      unlockedDate: null,
      color: "#10B981",
    },
  ];

  // Mock skill progress
  const skillProgress = [
    {
      skill: "Flutter Development",
      progress: 0.85,
      level: "Advanced",
      color: Colors.primaryLight,
    },
    {
      skill: "React Native",
      progress: 0.45,
      level: "Intermediate",
      color: Colors.secondaryLight,
    },
    {
      skill: "UI/UX Design",
      progress: 0.65,
      level: "Intermediate",
      color: Colors.accentLight,
    },
    {
      skill: "Business Strategy",
      progress: 0.25,
      level: "Beginner",
      color: "#8B5CF6",
    },
  ];

  const menuItems = [
    {
      title: "Edit Profile",
      icon: "edit",
      onPress: () => setShowEditModal(true),
    },
    {
      title: "Achievements",
      icon: "emoji-events",
      onPress: () => console.log("View achievements"),
    },
    {
      title: "Progress History",
      icon: "timeline",
      onPress: () => navigation.navigate('ProgressTracking'),
    },
    {
      title: "Settings",
      icon: "settings",
      onPress: () => console.log("Open settings"),
    },
    {
      title: "Help & Support",
      icon: "help",
      onPress: () => console.log("Open help"),
    },
    {
      title: "About",
      icon: "info",
      onPress: () => console.log("Open about"),
    },
  ];

  const unlockedAchievements = achievements.filter(achievement => achievement.isUnlocked);
  const lockedAchievements = achievements.filter(achievement => !achievement.isUnlocked);

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <CustomIcon name="arrow-back" size={24} color={Colors.textPrimaryLight} />
        </TouchableOpacity>
        <Text style={[styles.headerTitle, Typography.titleLarge, { color: Colors.textPrimaryLight }]}>
          Profile
        </Text>
        <TouchableOpacity onPress={() => setShowEditModal(true)}>
          <CustomIcon name="edit" size={24} color={Colors.primaryLight} />
        </TouchableOpacity>
      </View>

      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Profile Header */}
        <View style={styles.profileHeader}>
          <CustomImage
            source={userData.avatar}
            width={responsiveWidth(25)}
            height={responsiveWidth(25)}
            style={styles.avatar}
          />
          <Text style={[styles.userName, Typography.headlineSmall, { color: Colors.textPrimaryLight }]}>
            {userData.name}
          </Text>
          <Text style={[styles.userEmail, Typography.bodyMedium, { color: Colors.textSecondaryLight }]}>
            {userData.email}
          </Text>
          <Text style={[styles.userBio, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
            {userData.bio}
          </Text>
          <Text style={[styles.joinDate, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
            Member since {userData.joinDate}
          </Text>
        </View>

        {/* Stats Overview */}
        <View style={styles.statsContainer}>
          <View style={styles.statCard}>
            <Text style={[styles.statValue, Typography.headlineSmall, { color: Colors.primaryLight }]}>
              {userData.totalPoints}
            </Text>
            <Text style={[styles.statLabel, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
              Total Points
            </Text>
          </View>
          <View style={styles.statCard}>
            <Text style={[styles.statValue, Typography.headlineSmall, { color: Colors.warningLight }]}>
              {userData.currentStreak}
            </Text>
            <Text style={[styles.statLabel, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
              Day Streak
            </Text>
          </View>
          <View style={styles.statCard}>
            <Text style={[styles.statValue, Typography.headlineSmall, { color: Colors.secondaryLight }]}>
              {userData.completedChallenges}
            </Text>
            <Text style={[styles.statLabel, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
              Challenges
            </Text>
          </View>
        </View>

        {/* Level & Rank */}
        <View style={styles.levelContainer}>
          <View style={styles.levelCard}>
            <View style={styles.levelInfo}>
              <Text style={[styles.levelTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
                Current Level
              </Text>
              <Text style={[styles.levelName, Typography.headlineSmall, { color: Colors.primaryLight }]}>
                {userData.level}
              </Text>
              <Text style={[styles.rankText, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                Ranked {userData.rank} globally
              </Text>
            </View>
            <BatteryProgressIndicator
              progress={0.75}
              width={responsiveWidth(20)}
              height={responsiveHeight(10)}
              batteryColor={Colors.primaryLight}
            />
          </View>
        </View>

        {/* Skill Progress */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
            Skill Progress
          </Text>
          {skillProgress.map((skill, index) => (
            <View key={index} style={styles.skillCard}>
              <View style={styles.skillInfo}>
                <Text style={[styles.skillName, Typography.titleSmall, { color: Colors.textPrimaryLight }]}>
                  {skill.skill}
                </Text>
                <Text style={[styles.skillLevel, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                  {skill.level}
                </Text>
              </View>
              <View style={styles.skillProgressContainer}>
                <View style={styles.skillProgressBar}>
                  <View 
                    style={[
                      styles.skillProgressFill, 
                      { 
                        width: `${skill.progress * 100}%`,
                        backgroundColor: skill.color
                      }
                    ]} 
                  />
                </View>
                <Text style={[styles.skillProgressText, Typography.labelSmall, { color: skill.color }]}>
                  {Math.round(skill.progress * 100)}%
                </Text>
              </View>
            </View>
          ))}
        </View>

        {/* Achievements */}
        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <Text style={[styles.sectionTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
              Achievements
            </Text>
            <Text style={[styles.achievementCount, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
              {unlockedAchievements.length}/{achievements.length}
            </Text>
          </View>
          
          {/* Unlocked Achievements */}
          <View style={styles.achievementsGrid}>
            {unlockedAchievements.map((achievement) => (
              <TouchableOpacity key={achievement.id} style={styles.achievementCard}>
                <View style={[styles.achievementIcon, { backgroundColor: achievement.color + '20' }]}>
                  <CustomIcon name={achievement.icon} size={24} color={achievement.color} />
                </View>
                <Text style={[styles.achievementTitle, Typography.labelMedium, { color: Colors.textPrimaryLight }]}>
                  {achievement.title}
                </Text>
                <Text style={[styles.achievementDescription, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                  {achievement.description}
                </Text>
                <Text style={[styles.achievementDate, Typography.labelSmall, { color: achievement.color }]}>
                  {achievement.unlockedDate}
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          {/* Locked Achievements */}
          <View style={styles.lockedAchievementsContainer}>
            <Text style={[styles.lockedTitle, Typography.titleSmall, { color: Colors.textSecondaryLight }]}>
              Locked Achievements
            </Text>
            <View style={styles.achievementsGrid}>
              {lockedAchievements.map((achievement) => (
                <View key={achievement.id} style={[styles.achievementCard, styles.lockedAchievementCard]}>
                  <View style={[styles.achievementIcon, { backgroundColor: Colors.borderSubtleLight }]}>
                    <CustomIcon name={achievement.icon} size={24} color={Colors.textSecondaryLight} />
                  </View>
                  <Text style={[styles.achievementTitle, Typography.labelMedium, { color: Colors.textSecondaryLight }]}>
                    {achievement.title}
                  </Text>
                  <Text style={[styles.achievementDescription, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                    {achievement.description}
                  </Text>
                </View>
              ))}
            </View>
          </View>
        </View>

        {/* Menu Items */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
            Account
          </Text>
          {menuItems.map((item, index) => (
            <TouchableOpacity key={index} style={styles.menuItem} onPress={item.onPress}>
              <View style={styles.menuItemLeft}>
                <View style={styles.menuItemIcon}>
                  <CustomIcon name={item.icon} size={20} color={Colors.textSecondaryLight} />
                </View>
                <Text style={[styles.menuItemText, Typography.bodyMedium, { color: Colors.textPrimaryLight }]}>
                  {item.title}
                </Text>
              </View>
              <CustomIcon name="chevron-right" size={20} color={Colors.textSecondaryLight} />
            </TouchableOpacity>
          ))}
        </View>

        {/* Settings */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
            Preferences
          </Text>
          
          <View style={styles.settingItem}>
            <View style={styles.settingLeft}>
              <CustomIcon name="dark-mode" size={20} color={Colors.textSecondaryLight} />
              <Text style={[styles.settingText, Typography.bodyMedium, { color: Colors.textPrimaryLight }]}>
                Dark Mode
              </Text>
            </View>
            <Switch
              value={isDarkMode}
              onValueChange={setIsDarkMode}
              trackColor={{ false: Colors.borderSubtleLight, true: Colors.primaryLight }}
              thumbColor={isDarkMode ? 'white' : Colors.textSecondaryLight}
            />
          </View>

          <View style={styles.settingItem}>
            <View style={styles.settingLeft}>
              <CustomIcon name="notifications" size={20} color={Colors.textSecondaryLight} />
              <Text style={[styles.settingText, Typography.bodyMedium, { color: Colors.textPrimaryLight }]}>
                Notifications
              </Text>
            </View>
            <Switch
              value={notificationsEnabled}
              onValueChange={setNotificationsEnabled}
              trackColor={{ false: Colors.borderSubtleLight, true: Colors.primaryLight }}
              thumbColor={notificationsEnabled ? 'white' : Colors.textSecondaryLight}
            />
          </View>
        </View>

        <View style={styles.bottomPadding} />
      </ScrollView>

      {/* Edit Profile Modal */}
      <Modal
        visible={showEditModal}
        transparent
        animationType="slide"
        onRequestClose={() => setShowEditModal(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <View style={styles.modalHeader}>
              <Text style={[styles.modalTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
                Edit Profile
              </Text>
              <TouchableOpacity onPress={() => setShowEditModal(false)}>
                <CustomIcon name="close" size={24} color={Colors.textSecondaryLight} />
              </TouchableOpacity>
            </View>
            
            <View style={styles.editForm}>
              <Text style={[styles.editLabel, Typography.labelMedium, { color: Colors.textSecondaryLight }]}>
                This feature is coming soon!
              </Text>
              <Text style={[styles.editDescription, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                You'll be able to update your profile information, change your avatar, and customize your preferences.
              </Text>
            </View>

            <TouchableOpacity 
              style={styles.modalButton}
              onPress={() => setShowEditModal(false)}
            >
              <Text style={[styles.modalButtonText, Typography.labelLarge, { color: 'white' }]}>
                Got it
              </Text>
            </TouchableOpacity>
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
  scrollView: {
    flex: 1,
  },
  profileHeader: {
    alignItems: 'center',
    paddingVertical: responsiveHeight(4),
    paddingHorizontal: responsiveWidth(4),
  },
  avatar: {
    borderRadius: responsiveWidth(12.5),
    marginBottom: Spacing.lg,
  },
  userName: {
    fontWeight: '700',
    marginBottom: Spacing.xs,
  },
  userEmail: {
    marginBottom: Spacing.sm,
  },
  userBio: {
    textAlign: 'center',
    lineHeight: 20,
    marginBottom: Spacing.sm,
  },
  joinDate: {
    // Styles already defined in Typography
  },
  statsContainer: {
    flexDirection: 'row',
    paddingHorizontal: responsiveWidth(4),
    marginBottom: responsiveHeight(3),
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
  levelContainer: {
    paddingHorizontal: responsiveWidth(4),
    marginBottom: responsiveHeight(3),
  },
  levelCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    ...Colors.shadowMediumLight,
  },
  levelInfo: {
    flex: 1,
  },
  levelTitle: {
    fontWeight: '600',
    marginBottom: Spacing.xs,
  },
  levelName: {
    fontWeight: '700',
    marginBottom: Spacing.xs,
  },
  rankText: {
    // Styles already defined in Typography
  },
  section: {
    marginBottom: responsiveHeight(3),
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: responsiveWidth(4),
    marginBottom: Spacing.lg,
  },
  sectionTitle: {
    fontWeight: '600',
  },
  achievementCount: {
    // Styles already defined in Typography
  },
  skillCard: {
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    marginHorizontal: responsiveWidth(4),
    marginBottom: Spacing.md,
    ...Colors.shadowMediumLight,
  },
  skillInfo: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: Spacing.md,
  },
  skillName: {
    fontWeight: '600',
  },
  skillLevel: {
    // Styles already defined in Typography
  },
  skillProgressContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  skillProgressBar: {
    flex: 1,
    height: 8,
    backgroundColor: Colors.borderSubtleLight,
    borderRadius: 4,
    overflow: 'hidden',
    marginRight: Spacing.md,
  },
  skillProgressFill: {
    height: '100%',
    borderRadius: 4,
  },
  skillProgressText: {
    fontWeight: '600',
    minWidth: 40,
    textAlign: 'right',
  },
  achievementsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: responsiveWidth(4),
    justifyContent: 'space-between',
  },
  achievementCard: {
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    alignItems: 'center',
    width: responsiveWidth(45),
    marginBottom: Spacing.lg,
    ...Colors.shadowMediumLight,
  },
  lockedAchievementCard: {
    opacity: 0.6,
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
    marginBottom: Spacing.sm,
  },
  achievementDate: {
    fontWeight: '500',
  },
  lockedAchievementsContainer: {
    marginTop: Spacing.lg,
  },
  lockedTitle: {
    fontWeight: '600',
    paddingHorizontal: responsiveWidth(4),
    marginBottom: Spacing.lg,
  },
  menuItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    marginHorizontal: responsiveWidth(4),
    marginBottom: Spacing.sm,
    ...Colors.shadowMediumLight,
  },
  menuItemLeft: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  menuItemIcon: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: Colors.backgroundLight,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: Spacing.md,
  },
  menuItemText: {
    fontWeight: '500',
  },
  settingItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    marginHorizontal: responsiveWidth(4),
    marginBottom: Spacing.sm,
    ...Colors.shadowMediumLight,
  },
  settingLeft: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  settingText: {
    marginLeft: Spacing.md,
    fontWeight: '500',
  },
  bottomPadding: {
    height: responsiveHeight(4),
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalContent: {
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.xl,
    padding: Spacing.lg,
    marginHorizontal: responsiveWidth(8),
    alignItems: 'center',
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    width: '100%',
    marginBottom: Spacing.lg,
  },
  modalTitle: {
    fontWeight: '600',
  },
  editForm: {
    alignItems: 'center',
    marginBottom: Spacing.lg,
  },
  editLabel: {
    fontWeight: '600',
    marginBottom: Spacing.sm,
  },
  editDescription: {
    textAlign: 'center',
    lineHeight: 20,
  },
  modalButton: {
    backgroundColor: Colors.primaryLight,
    paddingHorizontal: Spacing.xl,
    paddingVertical: Spacing.lg,
    borderRadius: BorderRadius.lg,
    width: '100%',
    alignItems: 'center',
  },
  modalButtonText: {
    fontWeight: '600',
  },
});

export default UserProfile;
