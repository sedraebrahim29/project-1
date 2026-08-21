import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../data/doctor_listing_repository.dart';
import '../models/doctor_dummy_data.dart';
import 'doctor_listing_state.dart';

class DoctorListingCubit extends Cubit<DoctorListingState> {
  final DoctorListingRepository _repository;

  DoctorListingCubit(List<DoctorListingModel> initialDoctors, {DoctorListingRepository? repository})
      : _repository = repository ?? DoctorListingRepository(),
        super(DoctorListingState.initial(initialDoctors)) {
    // The search field's controller lives here, in the Cubit, instead of
    // being rebuilt on every state emission inside the screen's build().
    // Recreating a TextEditingController on every keystroke (as the old
    // screen did) drops the cursor position and breaks IME composition —
    // especially noticeable typing Arabic. A single controller with a
    // proper lifecycle fixes that.
    searchController.addListener(() {
      if (searchController.text != state.searchQuery) {
        updateSearchQuery(searchController.text);
      }
    });
  }

  final TextEditingController searchController = TextEditingController();

  /// يجيب الأطباء الحقيقيين المسجّلين فعلياً بالتطبيق (راجع ملاحظة
  /// DoctorListingRepository). بتستبدل أي بيانات أولية كانت موجودة
  /// (حتى لو كانت dummy لأغراض العرض المؤقت) بمجرد ما يوصل الرد.
  Future<void> loadDoctors() async {
    final doctors = await _repository.getDoctors();
    emit(state.copyWith(
      allDoctors: doctors,
      favCount: doctors.where((d) => d.isFavourite).length,
    ));
    _filterAndSearch();
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void updateFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter));
    _filterAndSearch();
  }

  void updateSearchQuery(String query) {
    if (searchController.text != query) {
      searchController.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }
    emit(state.copyWith(searchQuery: query));
    _filterAndSearch();
  }

  /// Applied by the Filters screen when the user taps "Apply Filters":
  /// switches to the full (non-favourites) list, jumps to the Doctors tab,
  /// and carries over the specialty + search query that were chosen there.
  void applyExternalFilters({String? subSpecialty, required String searchQuery}) {
    emit(state.copyWith(
      showingAll: true,
      currentIndex: 1,
      selectedFilter: subSpecialty ?? AppStrings.allSpecialtiesValue,
      searchQuery: searchQuery,
    ));
    if (searchController.text != searchQuery) {
      searchController.value = TextEditingValue(
        text: searchQuery,
        selection: TextSelection.collapsed(offset: searchQuery.length),
      );
    }
    _filterAndSearch();
  }

  void toggleShowingAll() {
    emit(state.copyWith(showingAll: !state.showingAll));
    _filterAndSearch();
  }

  void toggleFavourite(String id) {
    final updatedDoctors = state.allDoctors.map((doc) {
      return doc.id == id ? doc.copyWith(isFavourite: !doc.isFavourite) : doc;
    }).toList();

    final newFavCount = updatedDoctors.where((d) => d.isFavourite).length;

    emit(state.copyWith(
      allDoctors: updatedDoctors,
      favCount: newFavCount,
    ));
    _filterAndSearch();
  }

  void _filterAndSearch() {
    final pool = state.showingAll
        ? state.allDoctors
        : state.allDoctors.where((d) => d.isFavourite).toList();

    final query = state.searchQuery.trim().toLowerCase();

    final filtered = pool.where((doc) {
      final matchQuery = query.isEmpty ||
          doc.fullName.toLowerCase().contains(query) ||
          doc.subSpecialty.toLowerCase().contains(query) ||
          doc.mainSpecialty.toLowerCase().contains(query);

      final matchFilter = !state.showingAll ||
          state.selectedFilter == AppStrings.allSpecialtiesValue ||
          doc.subSpecialty.toLowerCase() == state.selectedFilter.toLowerCase() ||
          doc.mainSpecialty.toLowerCase() == state.selectedFilter.toLowerCase();

      return matchQuery && matchFilter;
    }).toList();

    emit(state.copyWith(visibleDoctors: filtered));
  }
}
