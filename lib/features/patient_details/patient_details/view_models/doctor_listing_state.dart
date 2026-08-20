

import '../../../core/constants/app_strings.dart';
import '../models/doctor_dummy_data.dart';

class DoctorListingState {
  final List<DoctorListingModel> allDoctors;
  final List<DoctorListingModel> visibleDoctors;
  final String selectedFilter;
  final String searchQuery;
  final bool showingAll;
  final int favCount;
  final int currentIndex;

  const DoctorListingState({
    required this.allDoctors,
    required this.visibleDoctors,
    required this.selectedFilter,
    required this.searchQuery,
    required this.showingAll,
    required this.favCount,
    required this.currentIndex,
  });

  factory DoctorListingState.initial(List<DoctorListingModel> initialDoctors) {
    return DoctorListingState(
      allDoctors: initialDoctors,
      visibleDoctors: initialDoctors,
      selectedFilter: AppStrings.allSpecialtiesValue,
      searchQuery: '',
      showingAll: true,
      favCount: initialDoctors
          .where((d) => d.isFavourite)
          .length,
      currentIndex: 1,
    );
  }

  DoctorListingState copyWith({
    List<DoctorListingModel>? allDoctors,
    List<DoctorListingModel>? visibleDoctors,
    String? selectedFilter,
    String? searchQuery,
    bool? showingAll,
    int? favCount,
    int? currentIndex,
  }) {
    return DoctorListingState(
      allDoctors: allDoctors ?? this.allDoctors,
      visibleDoctors: visibleDoctors ?? this.visibleDoctors,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      showingAll: showingAll ?? this.showingAll,
      favCount: favCount ?? this.favCount,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
