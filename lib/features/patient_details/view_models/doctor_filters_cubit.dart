import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/doctor_dummy_data.dart';
import 'doctor_filters_state.dart';

class DoctorFiltersCubit extends Cubit<DoctorFiltersState> {
  DoctorFiltersCubit(List<DoctorListingModel> pool)
      : super(DoctorFiltersState.initial(pool));

  void updateSearchQuery(String query) => emit(state.copyWith(searchQuery: query));

  void applyQuickTag(String tag) => emit(state.copyWith(searchQuery: tag));

  void toggleNearMe() => emit(state.copyWith(nearMeEnabled: !state.nearMeEnabled));

  void setCity(String? city) => emit(
        city == null ? state.copyWith(clearCity: true) : state.copyWith(selectedCity: city),
      );

  void setMainSpecialty(String? value) => emit(
        value == null
            ? state.copyWith(clearMainSpecialty: true, clearSubSpecialty: true)
            : state.copyWith(mainSpecialty: value, clearSubSpecialty: true),
      );

  void setSubSpecialty(String? value) => emit(
        value == null ? state.copyWith(clearSubSpecialty: true) : state.copyWith(subSpecialty: value),
      );

  void setExperienceRange(RangeValues range) => emit(state.copyWith(experienceRange: range));

  void setPriceRange(RangeValues range) => emit(state.copyWith(priceRange: range));

  void setAvailability(AvailabilityFilter value) {
    // Tapping the same availability chip again clears it back to "none".
    final next = state.availability == value ? AvailabilityFilter.none : value;
    emit(state.copyWith(availability: next));
  }

  void toggleTimeSlot(FilterTimeSlot slot) {
    final next = Set<FilterTimeSlot>.from(state.timeSlots);
    next.contains(slot) ? next.remove(slot) : next.add(slot);
    emit(state.copyWith(timeSlots: next));
  }

  void setConsultationType(ConsultationTypeFilter type) =>
      emit(state.copyWith(consultationType: type));

  void toggleGender(String gender) {
    final next = Set<String>.from(state.genders);
    next.contains(gender) ? next.remove(gender) : next.add(gender);
    emit(state.copyWith(genders: next));
  }

  void setSortBy(SortOption option) => emit(state.copyWith(sortBy: option));

  void reset() => emit(DoctorFiltersState.initial(state.pool));
}
