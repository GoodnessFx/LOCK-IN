import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import CustomIcon from '../components/CustomIcon';
import CustomImage from '../components/CustomImage';
import { Colors, Typography, Spacing, BorderRadius, responsiveWidth, responsiveHeight } from '../theme/AppTheme';

const categories = [
  { key: 'tech', label: 'Tech', color: Colors.primaryLight, icon: 'memory' },
  { key: 'trading', label: 'Trading', color: '#22C55E', icon: 'show-chart' },
  { key: 'photography', label: 'Photography', color: '#F59E0B', icon: 'photo-camera' },
  { key: 'writing', label: 'Writing', color: '#8B5CF6', icon: 'edit' },
  { key: 'building', label: 'Building', color: '#06B6D4', icon: 'construction' },
];

const courseCatalog = {
  tech: [
    { title: 'React Native Foundations', level: 'Beginner', duration: '6h', image: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=300&fit=crop' },
    { title: 'API Integration & State', level: 'Intermediate', duration: '5h', image: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=400&h=300&fit=crop' },
    { title: 'Animations & UX', level: 'Advanced', duration: '4h', image: 'https://images.unsplash.com/photo-1518779578993-ec3579fee39f?w=400&h=300&fit=crop' },
  ],
  trading: [
    { title: 'Market Basics', level: 'Beginner', duration: '3h', image: 'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?w=400&h=300&fit=crop' },
    { title: 'Technical Analysis', level: 'Intermediate', duration: '5h', image: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=300&fit=crop' },
  ],
  photography: [
    { title: 'Mobile Photography', level: 'Beginner', duration: '2h', image: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400&h=300&fit=crop' },
    { title: 'Lighting & Composition', level: 'Intermediate', duration: '4h', image: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400&h=300&fit=crop' },
  ],
  writing: [
    { title: 'Story Craft 101', level: 'Beginner', duration: '3h', image: 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0ea?w=400&h=300&fit=crop' },
    { title: 'Persuasive Writing', level: 'Intermediate', duration: '3h', image: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=400&h=300&fit=crop' },
  ],
  building: [
    { title: 'No-Code MVP', level: 'Beginner', duration: '5h', image: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=400&h=300&fit=crop' },
    { title: 'Product Strategy', level: 'Intermediate', duration: '4h', image: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400&h=300&fit=crop' },
  ],
};

export default function LockInLearn() {
  const [active, setActive] = useState('tech');

  const courses = courseCatalog[active] || [];

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={[styles.headerTitle, Typography.titleLarge, { color: Colors.textPrimaryLight }]}>Learn</Text>
        <View style={styles.headerRight}>
          <CustomIcon name="search" size={22} color={Colors.textSecondaryLight} />
        </View>
      </View>

      {/* Categories */}
      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.categories} contentContainerStyle={styles.categoriesContent}>
        {categories.map(cat => (
          <TouchableOpacity
            key={cat.key}
            style={[styles.categoryChip, active === cat.key && { backgroundColor: cat.color }]}
            onPress={() => setActive(cat.key)}
          >
            <CustomIcon name={cat.icon} size={18} color={active === cat.key ? 'white' : cat.color} />
            <Text style={[styles.categoryText, Typography.labelMedium, { color: active === cat.key ? 'white' : Colors.textSecondaryLight }]}>
              {cat.label}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      {/* Featured track */}
      <View style={styles.featuredCard}>
        <View style={styles.featuredLeft}>
          <Text style={[styles.featuredTitle, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>Your Learning Path</Text>
          <Text style={[styles.featuredSubtitle, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>Personalized modules to reach mastery</Text>
        </View>
        <View style={styles.featuredRight}>
          <CustomIcon name="school" size={28} color={Colors.primaryLight} />
        </View>
      </View>

      {/* Courses list */}
      <ScrollView style={styles.courses} showsVerticalScrollIndicator={false}>
        {courses.map((course, idx) => (
          <TouchableOpacity key={idx} style={styles.courseCard}>
            <CustomImage source={course.image} width={responsiveWidth(26)} height={responsiveHeight(12)} style={styles.courseImage} />
            <View style={styles.courseInfo}>
              <Text style={[styles.courseTitle, Typography.titleSmall, { color: Colors.textPrimaryLight }]}>{course.title}</Text>
              <Text style={[styles.courseMeta, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>
                {course.level} • {course.duration}
              </Text>
              <View style={styles.courseActions}>
                <View style={styles.badgePrimary}>
                  <Text style={[styles.badgeText, Typography.labelSmall, { color: 'white' }]}>Start</Text>
                </View>
                <TouchableOpacity>
                  <Text style={[styles.secondaryAction, Typography.labelSmall, { color: Colors.primaryLight }]}>Details</Text>
                </TouchableOpacity>
              </View>
            </View>
          </TouchableOpacity>
        ))}
        <View style={{ height: responsiveHeight(8) }} />
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.backgroundLight,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: responsiveWidth(4),
    paddingVertical: responsiveHeight(2),
  },
  headerTitle: {
    fontWeight: '600',
  },
  headerRight: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  categories: {
    marginBottom: responsiveHeight(2),
  },
  categoriesContent: {
    paddingHorizontal: responsiveWidth(4),
  },
  categoryChip: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.surfaceLight,
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.md,
    borderRadius: BorderRadius.lg,
    marginRight: Spacing.md,
  },
  categoryText: {
    marginLeft: Spacing.sm,
    fontWeight: '600',
  },
  featuredCard: {
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    marginHorizontal: responsiveWidth(4),
    marginBottom: responsiveHeight(2),
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
  },
  featuredLeft: { flex: 1 },
  featuredRight: { marginLeft: Spacing.lg },
  featuredTitle: { fontWeight: '600' },
  featuredSubtitle: {},
  courses: {
    paddingHorizontal: responsiveWidth(4),
  },
  courseCard: {
    flexDirection: 'row',
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    marginBottom: Spacing.lg,
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
  },
  courseImage: {
    borderRadius: BorderRadius.md,
  },
  courseInfo: {
    flex: 1,
    marginLeft: Spacing.lg,
  },
  courseTitle: {
    fontWeight: '600',
    marginBottom: Spacing.xs,
  },
  courseMeta: {
    marginBottom: Spacing.md,
  },
  courseActions: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  badgePrimary: {
    backgroundColor: Colors.primaryLight,
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.sm,
    borderRadius: BorderRadius.lg,
    marginRight: Spacing.md,
  },
  badgeText: { fontWeight: '600' },
  secondaryAction: { fontWeight: '600' },
});
