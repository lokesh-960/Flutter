import 'package:flutter/material.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../seed/seed_data.dart';
import '../models/course_model.dart';

class CourseProvider extends ChangeNotifier {
  List<CourseModel> _courses = [];
  List<String> _bookmarkedCourseIds = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';
  String _sortBy = 'popular'; // 'popular' | 'newest' | 'title' | 'duration'

  List<CourseModel> get courses => _courses;
  List<String> get bookmarkedCourseIds => _bookmarkedCourseIds;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedDifficulty => _selectedDifficulty;
  String get sortBy => _sortBy;

  List<String> get categories {
    final set = {'All'};
    for (var c in _courses) {
      set.add(c.category);
    }
    return set.toList();
  }

  final List<String> difficulties = const ['All', 'Beginner', 'Intermediate', 'Advanced'];

  CourseProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    // Load initial seed courses
    _courses = List.from(SeedData.sampleCourses);

    // Load local bookmarks
    final storage = await LocalStorageService.getInstance();
    _bookmarkedCourseIds = storage.getBookmarks();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedDifficulty = 'All';
    _sortBy = 'popular';
    notifyListeners();
  }

  bool isBookmarked(String courseId) {
    return _bookmarkedCourseIds.contains(courseId);
  }

  Future<void> toggleBookmark(String courseId) async {
    if (_bookmarkedCourseIds.contains(courseId)) {
      _bookmarkedCourseIds.remove(courseId);
    } else {
      _bookmarkedCourseIds.add(courseId);
    }
    final storage = await LocalStorageService.getInstance();
    await storage.saveBookmarks(_bookmarkedCourseIds);
    notifyListeners();
  }

  CourseModel? getCourseById(String id) {
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<CourseModel> get filteredCourses {
    var result = _courses.where((course) {
      if (!course.isPublished) return false;

      // Search match (title, description, instructor)
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = course.title.toLowerCase().contains(q);
        final matchesDesc = course.description.toLowerCase().contains(q);
        final matchesInstructor = course.instructorName.toLowerCase().contains(q);
        if (!matchesTitle && !matchesDesc && !matchesInstructor) {
          return false;
        }
      }

      // Category match
      if (_selectedCategory != 'All' && course.category != _selectedCategory) {
        return false;
      }

      // Difficulty match
      if (_selectedDifficulty != 'All' && course.difficulty != _selectedDifficulty) {
        return false;
      }

      return true;
    }).toList();

    // Sorting
    switch (_sortBy) {
      case 'newest':
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'title':
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'duration':
        result.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
        break;
      case 'popular':
      default:
        result.sort((a, b) => b.enrollmentCount.compareTo(a.enrollmentCount));
        break;
    }

    return result;
  }

  List<CourseModel> get bookmarkedCourses {
    return _courses.where((c) => _bookmarkedCourseIds.contains(c.id)).toList();
  }

  // Instructor/Admin methods
  void addCourse(CourseModel course) {
    _courses.insert(0, course);
    notifyListeners();
  }

  void updateCourse(CourseModel updated) {
    final index = _courses.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _courses[index] = updated;
      notifyListeners();
    }
  }

  void deleteCourse(String courseId) {
    _courses.removeWhere((c) => c.id == courseId);
    notifyListeners();
  }
}
