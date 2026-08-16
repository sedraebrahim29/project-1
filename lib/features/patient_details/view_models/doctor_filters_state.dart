import 'package:flutter/material.dart';
import '../models/doctor_dummy_data.dart';

enum AvailabilityFilter { none, today, tomorrow, thisWeek, custom }

enum ConsultationTypeFilter { inPerson, online, both }

enum FilterTimeSlot { morning, afternoon, evening }

enum SortOption { bestMatch, priceLowToHigh, priceHighToLow, topRated, mostExperienced }

class DoctorFiltersState {
  final List<DoctorListingModel> pool;

  final String searchQuery;
  final bool nearMeEnabled;
  final String? selectedCity;
  final String? mainSpecialty; // canonical (English) value, or null = any
  final String? subSpecialty; // canonical (English) value, or null = any
  final RangeValues experienceRange;
  final RangeValues priceRange;
  final AvailabilityFilter availability;
  final Set<FilterTimeSlot> timeSlots;
  final ConsultationTypeFilter consultationType;
  final Set<String> genders; // UI-only: doctor records don't carry gender yet
  final SortOption sortBy;

  const DoctorFiltersState({
    required this.pool,
    this.searchQuery = '',
    this.nearMeEnabled = false,
    this.selectedCity,
    this.mainSpecialty,
    this.subSpecialty,
    this.experienceRange = const RangeValues(0, 40),
    this.priceRange = const RangeValues(0, 500),
    this.availability = AvailabilityFilter.none,
    this.timeSlots = const {},
    this.consultationType = ConsultationTypeFilter.both,
    this.genders = const {},
    this.sortBy = SortOption.bestMatch,
  });

  factory DoctorFiltersState.initial(List<DoctorListingModel> pool) =>
      DoctorFiltersState(pool: pool);

  /// Doctors from [pool] that satisfy every filter currently set. Only
  /// matches against fields that actually exist on [DoctorListingModel] —
  /// city/near-me/gender have no backing data yet, so they're intentionally
  /// not applied here rather than faked.
  List<DoctorListingModel> get matchingDoctors {
    return pool.where((doc) {
      final matchesQuery = searchQuery.trim().isEmpty ||
          doc.fullName.toLowerCase().contains(searchQuery.trim().toLowerCase()) ||
          doc.subSpecialty.toLowerCase().contains(searchQuery.trim().toLowerCase()) ||
          doc.mainSpecialty.toLowerCase().contains(searchQuery.trim().toLowerCase());

      final matchesMain = mainSpecialty == null ||
          doc.mainSpecialty.toLowerCase() == mainSpecialty!.toLowerCase();

      final matchesSub = subSpecialty == null ||
          doc.subSpecialty.toLowerCase() == subSpecialty!.toLowerCase();

      final years = int.tryParse(doc.experienceYears ?? '');
      final matchesExperience = years == null ||
          (years >= experienceRange.start && years <= experienceRange.end);

      final matchesPrice =
          doc.consultationFee >= priceRange.start && doc.consultationFee <= priceRange.end;

      final matchesType = switch (consultationType) {
        ConsultationTypeFilter.online => doc.offersOnlineConsultation,
        ConsultationTypeFilter.inPerson => true,
        ConsultationTypeFilter.both => true,
      };

      final matchesAvailability = switch (availability) {
        AvailabilityFilter.none => true,
        AvailabilityFilter.today => doc.availabilityStatus == 'today',
        AvailabilityFilter.tomorrow => doc.availabilityStatus == 'tomorrow',
        AvailabilityFilter.thisWeek => doc.availabilityStatus == 'today' ||
            doc.availabilityStatus == 'tomorrow' ||
            (doc.availabilityStatus == 'in_N_days' && (doc.availableInDays ?? 99) <= 7),
        AvailabilityFilter.custom => true,
      };

      return matchesQuery &&
          matchesMain &&
          matchesSub &&
          matchesExperience &&
          matchesPrice &&
          matchesType &&
          matchesAvailability;
    }).toList();
  }

  int get matchingCount => matchingDoctors.length;

  DoctorFiltersState copyWith({
    String? searchQuery,
    bool? nearMeEnabled,
    String? selectedCity,
    bool clearCity = false,
    String? mainSpecialty,
    bool clearMainSpecialty = false,
    String? subSpecialty,
    bool clearSubSpecialty = false,
    RangeValues? experienceRange,
    RangeValues? priceRange,
    AvailabilityFilter? availability,
    Set<FilterTimeSlot>? timeSlots,
    ConsultationTypeFilter? consultationType,
    Set<String>? genders,
    SortOption? sortBy,
  }) {
    return DoctorFiltersState(
      pool: pool,
      searchQuery: searchQuery ?? this.searchQuery,
      nearMeEnabled: nearMeEnabled ?? this.nearMeEnabled,
      selectedCity: clearCity ? null : (selectedCity ?? this.selectedCity),
      mainSpecialty: clearMainSpecialty ? null : (mainSpecialty ?? this.mainSpecialty),
      subSpecialty: clearSubSpecialty ? null : (subSpecialty ?? this.subSpecialty),
      experienceRange: experienceRange ?? this.experienceRange,
      priceRange: priceRange ?? this.priceRange,
      availability: availability ?? this.availability,
      timeSlots: timeSlots ?? this.timeSlots,
      consultationType: consultationType ?? this.consultationType,
      genders: genders ?? this.genders,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}
