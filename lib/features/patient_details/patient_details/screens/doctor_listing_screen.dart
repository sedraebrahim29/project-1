import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../core/Theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../view_models/doctor_listing_cubit.dart';
import '../view_models/doctor_listing_state.dart';
import 'doctor_filters_screen.dart';
import 'widgets/doctor_card_widget.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/specialties_list_widget.dart';

class DoctorListingScreen extends StatelessWidget {
  const DoctorListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final currentScale = settingsState.fontScale;
    final isDark = settingsState.themeMode == ThemeMode.dark;

    double titleSize = 24.sp;
    double sectionSize = 16.sp;
    double countSize = 13.sp;

    if (currentScale == FontScale.medium) {
      titleSize = 27.sp;
      sectionSize = 18.sp;
      countSize = 15.sp;
    } else if (currentScale == FontScale.large) {
      titleSize = 30.sp;
      sectionSize = 20.sp;
      countSize = 17.sp;
    }

    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreenColor = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;

    return BlocBuilder<DoctorListingCubit, DoctorListingState>(
      builder: (context, state) {
        final cubit = context.read<DoctorListingCubit>();

        // Canonical (English) sub-specialties paired with their translated
        // display label — keeps chip selection and doctor-matching correct
        // regardless of the active language (see DoctorListingCubit).
        final specialtyFilters = <SpecialtyFilterOption>[
          SpecialtyFilterOption(label: AppStrings.viewAll(context), value: AppStrings.allSpecialtiesValue),
          for (final entry in _zip(
            AppStrings.subSpecialties(context, 'Medicine'),
            AppStrings.subSpecialtiesCanonical('Medicine'),
          ))
            SpecialtyFilterOption(label: entry.$1, value: entry.$2),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.showingAll) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 12.h),
                child: Text(
                  AppStrings.findDoctorTitle(context),
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: primaryGreenColor,
                  ),
                ),
              ),
              SearchBarWidget(
                controller: cubit.searchController,
                onChanged: (value) => cubit.updateSearchQuery(value),
                onFilterTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BlocProvider.value(value: cubit, child: const DoctorFiltersScreen())),
                ),
              ),
              SpecialtiesListWidget(
                filters: specialtyFilters,
                selectedValue: state.selectedFilter,
                onFilterSelected: (value) => cubit.updateFilter(value),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                child: Text(
                  AppStrings.favourites(context),
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],

            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.showingAll ? AppStrings.availableDoctors(context) : AppStrings.savedDoctors(context),
                    style: TextStyle(
                      fontSize: sectionSize,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    state.showingAll
                        ? AppStrings.doctorsFoundCount(context, state.visibleDoctors.length)
                        : AppStrings.doctorsSavedCount(context, state.favCount),
                    style: TextStyle(
                      fontSize: countSize,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLightGrey,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: state.visibleDoctors.isEmpty
                  ? Center(
                child: Text(
                  state.showingAll ? AppStrings.noDoctorsFound(context) : AppStrings.noSavedDoctorsYet(context),
                  style: TextStyle(color: AppColors.textLightGrey, fontSize: 14.sp),
                ),
              )
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                itemCount: state.visibleDoctors.length,
                itemBuilder: (context, index) {
                  return DoctorCardWidget(
                    doc: state.visibleDoctors[index],
                    onToggleFav: () => cubit.toggleFavourite(state.visibleDoctors[index].id),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Iterable<(String, String)> _zip(List<String> a, List<String> b) sync* {
    for (var i = 0; i < a.length && i < b.length; i++) {
      yield (a[i], b[i]);
    }
  }
}
