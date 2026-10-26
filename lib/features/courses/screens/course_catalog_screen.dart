import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/course_card.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../providers/course_provider.dart';
import '../../learning/providers/learning_provider.dart';

class CourseCatalogScreen extends StatelessWidget {
  const CourseCatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final courseProvider = context.watch<CourseProvider>();
    final learningProvider = context.watch<LearningProvider>();

    final filteredList = courseProvider.filteredCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Discovery Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'Bookmarked Courses',
            onPressed: () {
              courseProvider.setCategory('All');
              courseProvider.setSearchQuery('');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Input
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by course title, topic, or instructor...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: courseProvider.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => courseProvider.setSearchQuery(''),
                            )
                          : null,
                    ),
                    onChanged: (val) => courseProvider.setSearchQuery(val),
                  ),
                  const SizedBox(height: 16),

                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: courseProvider.categories.map((cat) {
                        final isSelected = courseProvider.selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) courseProvider.setCategory(cat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Secondary Filter Row (Difficulty & Sort By)
                  Row(
                    children: [
                      // Difficulty Filter
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: courseProvider.selectedDifficulty,
                          decoration: const InputDecoration(
                            labelText: 'Difficulty',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: courseProvider.difficulties.map((diff) {
                            return DropdownMenuItem(value: diff, child: Text(diff));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) courseProvider.setDifficulty(val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Sort Filter
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: courseProvider.sortBy,
                          decoration: const InputDecoration(
                            labelText: 'Sort By',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'popular', child: Text('Most Popular')),
                            DropdownMenuItem(value: 'newest', child: Text('Newest First')),
                            DropdownMenuItem(value: 'title', child: Text('Alphabetical')),
                            DropdownMenuItem(value: 'duration', child: Text('Duration')),
                          ],
                          onChanged: (val) {
                            if (val != null) courseProvider.setSortBy(val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Results Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${filteredList.length} course${filteredList.length == 1 ? '' : 's'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      if (courseProvider.searchQuery.isNotEmpty ||
                          courseProvider.selectedCategory != 'All' ||
                          courseProvider.selectedDifficulty != 'All')
                        TextButton(
                          onPressed: () => courseProvider.resetFilters(),
                          child: const Text('Reset Filters'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Course Cards Grid
                  if (filteredList.isEmpty)
                    EmptyStateView(
                      icon: Icons.search_off,
                      title: 'No Matching Courses Found',
                      message: 'Try adjusting your search keywords or clearing active filters.',
                      actionLabel: 'Reset Filters',
                      onAction: () => courseProvider.resetFilters(),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 900
                            ? 3
                            : (constraints.maxWidth > 550 ? 2 : 1);
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.88,
                          ),
                          itemBuilder: (context, index) {
                            final course = filteredList[index];
                            final isEnrolled = learningProvider.isEnrolled(course.id);
                            final progress = isEnrolled
                                ? learningProvider.getCourseProgress(
                                    course.id,
                                    course.lessonCount,
                                  )
                                : null;

                            return CourseCard(
                              course: course,
                              progress: progress,
                              onTap: () => context.push('/course-details/${course.id}'),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
