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
import BatteryProgressIndicator from '../components/BatteryProgressIndicator';
import { Colors, Typography, Spacing, BorderRadius, responsiveWidth, responsiveHeight } from '../theme/AppTheme';

const ProgressTracking = () => {
  const navigation = useNavigation();
  const [selectedFilter, setSelectedFilter] = useState('All');
  const [showAddModal, setShowAddModal] = useState(false);
  const [newEntry, setNewEntry] = useState({ title: '', description: '', category: 'Development' });

  const filters = ['All', 'Development', 'Design', 'Business', 'Personal'];

  // Mock progress entries
  const progressEntries = [
    {
      id: 1,
      title: 'Flutter Widget Development',
      description: 'Created 5 custom widgets for the mobile app',
      category: 'Development',
      date: '2024-01-15',
      timeSpent: '2h 30m',
      igPoints: 150,
      imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=300&fit=crop',
      tags: ['Flutter', 'Widgets', 'Mobile'],
    },
    {
      id: 2,
      title: 'UI/UX Design System',
      description: 'Designed comprehensive design system for the app',
      category: 'Design',
      date: '2024-01-14',
      timeSpent: '4h 15m',
      igPoints: 200,
      imageUrl: 'https://images.unsplash.com/photo-1558655146-d09347e92766?w=400&h=300&fit=crop',
      tags: ['Design', 'UI/UX', 'System'],
    },
    {
      id: 3,
      title: 'API Integration',
      description: 'Integrated REST API with proper error handling',
      category: 'Development',
      date: '2024-01-13',
      timeSpent: '3h 45m',
      igPoints: 180,
      imageUrl: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400&h=300&fit=crop',
      tags: ['API', 'REST', 'Integration'],
    },
  ];

  const filteredEntries = selectedFilter === 'All' 
    ? progressEntries 
    : progressEntries.filter(entry => entry.category === selectedFilter);

  const addNewEntry = () => {
    // In a real app, this would save to a database
    setShowAddModal(false);
    setNewEntry({ title: '', description: '', category: 'Development' });
  };

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <CustomIcon name="arrow-back" size={24} color={Colors.textPrimaryLight} />
        </TouchableOpacity>
        <Text style={[styles.headerTitle, Typography.titleLarge, { color: Colors.textPrimaryLight }]}>
          Progress Tracking
        </Text>
        <TouchableOpacity onPress={() => setShowAddModal(true)}>
          <CustomIcon name="add" size={24} color={Colors.primaryLight} />
        </TouchableOpacity>
      </View>

      {/* Progress Overview */}
      <View style={styles.overviewContainer}>
        <View style={styles.overviewCard}>
          <Text style={[styles.overviewTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
            This Week
          </Text>
          <View style={styles.overviewStats}>
            <View style={styles.statItem}>
              <Text style={[styles.statValue, Typography.headlineSmall, { color: Colors.primaryLight }]}>
                12h
              </Text>
              <Text style={[styles.statLabel, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                Time Spent
              </Text>
            </View>
            <View style={styles.statItem}>
              <Text style={[styles.statValue, Typography.headlineSmall, { color: Colors.secondaryLight }]}>
                1,250
              </Text>
              <Text style={[styles.statLabel, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                IG Points
              </Text>
            </View>
            <View style={styles.statItem}>
              <Text style={[styles.statValue, Typography.headlineSmall, { color: Colors.accentLight }]}>
                8
              </Text>
              <Text style={[styles.statLabel, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                Entries
              </Text>
            </View>
          </View>
        </View>
      </View>

      {/* Skill Progress */}
      <View style={styles.skillProgressContainer}>
        <Text style={[styles.sectionTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
          Skill Progress
        </Text>
        <View style={styles.skillProgressCard}>
          <BatteryProgressIndicator
            progress={0.75}
            width={responsiveWidth(25)}
            height={responsiveHeight(12)}
            batteryColor={Colors.secondaryLight}
          />
          <View style={styles.skillInfo}>
            <Text style={[styles.skillName, Typography.titleSmall, { color: Colors.textPrimaryLight }]}>
              Flutter Development
            </Text>
            <Text style={[styles.skillProgress, Typography.headlineSmall, { color: Colors.secondaryLight }]}>
              75%
            </Text>
            <Text style={[styles.skillDescription, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
              Advanced level achieved
            </Text>
          </View>
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

      {/* Progress Entries */}
      <ScrollView style={styles.entriesContainer} showsVerticalScrollIndicator={false}>
        {filteredEntries.map((entry) => (
          <TouchableOpacity key={entry.id} style={styles.entryCard}>
            <CustomImage
              source={entry.imageUrl}
              width={responsiveWidth(25)}
              height={responsiveHeight(15)}
              style={styles.entryImage}
            />
            <View style={styles.entryContent}>
              <View style={styles.entryHeader}>
                <Text style={[styles.entryTitle, Typography.titleSmall, { color: Colors.textPrimaryLight }]}>
                  {entry.title}
                </Text>
                <View style={[styles.categoryBadge, { backgroundColor: Colors.primaryLight + '20' }]}>
                  <Text style={[styles.categoryText, Typography.labelSmall, { color: Colors.primaryLight }]}>
                    {entry.category}
                  </Text>
                </View>
              </View>
              <Text style={[styles.entryDescription, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                {entry.description}
              </Text>
              <View style={styles.entryMeta}>
                <View style={styles.metaItem}>
                  <CustomIcon name="schedule" size={16} color={Colors.textSecondaryLight} />
                  <Text style={[styles.metaText, Typography.labelSmall, { color: Colors.textSecondaryLight }]}>
                    {entry.timeSpent}
                  </Text>
                </View>
                <View style={styles.metaItem}>
                  <CustomIcon name="stars" size={16} color={Colors.accentLight} />
                  <Text style={[styles.metaText, Typography.labelSmall, { color: Colors.accentLight }]}>
                    {entry.igPoints} pts
                  </Text>
                </View>
                <View style={styles.metaItem}>
                  <CustomIcon name="calendar-today" size={16} color={Colors.textSecondaryLight} />
                  <Text style={[styles.metaText, Typography.labelSmall, { color: Colors.textSecondaryLight }]}>
                    {entry.date}
                  </Text>
                </View>
              </View>
              <View style={styles.tagsContainer}>
                {entry.tags.map((tag, index) => (
                  <View key={index} style={styles.tag}>
                    <Text style={[styles.tagText, Typography.labelSmall, { color: Colors.primaryLight }]}>
                      {tag}
                    </Text>
                  </View>
                ))}
              </View>
            </View>
          </TouchableOpacity>
        ))}
      </ScrollView>

      {/* Add Entry Modal */}
      <Modal
        visible={showAddModal}
        transparent
        animationType="slide"
        onRequestClose={() => setShowAddModal(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <View style={styles.modalHeader}>
              <Text style={[styles.modalTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>
                Add Progress Entry
              </Text>
              <TouchableOpacity onPress={() => setShowAddModal(false)}>
                <CustomIcon name="close" size={24} color={Colors.textSecondaryLight} />
              </TouchableOpacity>
            </View>
            
            <View style={styles.formContainer}>
              <View style={styles.inputGroup}>
                <Text style={[styles.inputLabel, Typography.labelMedium, { color: Colors.textSecondaryLight }]}>
                  Title
                </Text>
                <TextInput
                  style={[styles.input, Typography.bodyMedium]}
                  placeholder="Enter entry title"
                  placeholderTextColor={Colors.textSecondaryLight}
                  value={newEntry.title}
                  onChangeText={(text) => setNewEntry({...newEntry, title: text})}
                />
              </View>

              <View style={styles.inputGroup}>
                <Text style={[styles.inputLabel, Typography.labelMedium, { color: Colors.textSecondaryLight }]}>
                  Description
                </Text>
                <TextInput
                  style={[styles.input, styles.textArea, Typography.bodyMedium]}
                  placeholder="Describe your progress"
                  placeholderTextColor={Colors.textSecondaryLight}
                  value={newEntry.description}
                  onChangeText={(text) => setNewEntry({...newEntry, description: text})}
                  multiline
                  numberOfLines={4}
                />
              </View>

              <View style={styles.inputGroup}>
                <Text style={[styles.inputLabel, Typography.labelMedium, { color: Colors.textSecondaryLight }]}>
                  Category
                </Text>
                <View style={styles.categoryOptions}>
                  {['Development', 'Design', 'Business', 'Personal'].map((category) => (
                    <TouchableOpacity
                      key={category}
                      style={[
                        styles.categoryOption,
                        newEntry.category === category && styles.categoryOptionActive
                      ]}
                      onPress={() => setNewEntry({...newEntry, category})}
                    >
                      <Text style={[
                        styles.categoryOptionText,
                        Typography.labelMedium,
                        { 
                          color: newEntry.category === category ? 'white' : Colors.textSecondaryLight,
                          fontWeight: newEntry.category === category ? '600' : '400'
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
                onPress={() => setShowAddModal(false)}
              >
                <Text style={[styles.modalButtonText, Typography.labelLarge, { color: Colors.textSecondaryLight }]}>
                  Cancel
                </Text>
              </TouchableOpacity>
              <TouchableOpacity 
                style={[styles.modalButton, styles.saveButton]}
                onPress={addNewEntry}
              >
                <Text style={[styles.modalButtonText, Typography.labelLarge, { color: 'white' }]}>
                  Save Entry
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
  overviewContainer: {
    paddingHorizontal: responsiveWidth(4),
    paddingVertical: responsiveHeight(2),
  },
  overviewCard: {
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    ...Colors.shadowMediumLight,
  },
  overviewTitle: {
    fontWeight: '600',
    marginBottom: Spacing.lg,
  },
  overviewStats: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  statItem: {
    alignItems: 'center',
  },
  statValue: {
    fontWeight: '700',
    marginBottom: Spacing.xs,
  },
  statLabel: {
    // Styles already defined in Typography
  },
  skillProgressContainer: {
    paddingHorizontal: responsiveWidth(4),
    marginBottom: responsiveHeight(2),
  },
  sectionTitle: {
    fontWeight: '600',
    marginBottom: Spacing.lg,
  },
  skillProgressCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    ...Colors.shadowMediumLight,
  },
  skillInfo: {
    marginLeft: Spacing.lg,
    flex: 1,
  },
  skillName: {
    fontWeight: '600',
    marginBottom: Spacing.xs,
  },
  skillProgress: {
    fontWeight: '700',
    marginBottom: Spacing.xs,
  },
  skillDescription: {
    // Styles already defined in Typography
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
  entriesContainer: {
    flex: 1,
    paddingHorizontal: responsiveWidth(4),
  },
  entryCard: {
    flexDirection: 'row',
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    marginBottom: Spacing.lg,
    ...Colors.shadowMediumLight,
  },
  entryImage: {
    borderRadius: BorderRadius.md,
  },
  entryContent: {
    flex: 1,
    marginLeft: Spacing.lg,
  },
  entryHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: Spacing.sm,
  },
  entryTitle: {
    fontWeight: '600',
    flex: 1,
    marginRight: Spacing.sm,
  },
  categoryBadge: {
    paddingHorizontal: Spacing.sm,
    paddingVertical: Spacing.xs,
    borderRadius: BorderRadius.sm,
  },
  categoryText: {
    fontWeight: '500',
  },
  entryDescription: {
    marginBottom: Spacing.md,
    lineHeight: 18,
  },
  entryMeta: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: Spacing.md,
  },
  metaItem: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  metaText: {
    marginLeft: Spacing.xs,
  },
  tagsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
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
    height: 100,
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
  saveButton: {
    backgroundColor: Colors.primaryLight,
  },
  modalButtonText: {
    fontWeight: '600',
  },
});

export default ProgressTracking;
