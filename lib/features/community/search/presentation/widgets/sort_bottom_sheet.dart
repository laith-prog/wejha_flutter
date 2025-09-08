import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/search_entities.dart';

class SortBottomSheet extends StatelessWidget {
  final SearchType searchType;
  final SortOption currentSortOption;
  final Function(SortOption) onSortSelected;

  const SortBottomSheet({
    Key? key,
    required this.searchType,
    required this.currentSortOption,
    required this.onSortSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final availableOptions = _getAvailableSortOptions();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  'ترتيب حسب',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1.h, color: AppColors.divider),

          // Sort options
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableOptions.length,
              itemBuilder: (context, index) {
                final option = availableOptions[index];
                final isSelected = option == currentSortOption;

                return InkWell(
                  onTap: () {
                    onSortSelected(option);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: [
                        if (isSelected)
                          Icon(
                            Icons.check,
                            size: 20.sp,
                            color: AppColors.primary,
                          ),
                        const Spacer(),
                        Text(
                          option.displayName,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                            fontWeight:
                                isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
        ],
      ),
    );
  }

  List<SortOption> _getAvailableSortOptions() {
    // Return different sort options based on search type
    switch (searchType) {
      case SearchType.realEstateRentals:
      case SearchType.realEstateSales:
      case SearchType.realEstateRooms:
      case SearchType.realEstateInvestment:
        return [
          SortOption.newest,
          SortOption.oldest,
          SortOption.priceHighToLow,
          SortOption.priceLowToHigh,
          SortOption.last24Hours,
          SortOption.last7Days,
        ];
      case SearchType.vehicles:
        return [
          SortOption.newest,
          SortOption.oldest,
          SortOption.priceHighToLow,
          SortOption.priceLowToHigh,
          SortOption.last24Hours,
          SortOption.last7Days,
        ];
      case SearchType.services:
        return [
          SortOption.newest,
          SortOption.oldest,
          SortOption.priceHighToLow,
          SortOption.priceLowToHigh,
          SortOption.last24Hours,
          SortOption.last7Days,
          SortOption.distance,
        ];
      case SearchType.jobs:
        return [
          SortOption.newest,
          SortOption.oldest,
          SortOption.last24Hours,
          SortOption.last7Days,
          SortOption.distance,
        ];
    }
  }

  static void show(
    BuildContext context, {
    required SearchType searchType,
    required SortOption currentSortOption,
    required Function(SortOption) onSortSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SortBottomSheet(
            searchType: searchType,
            currentSortOption: currentSortOption,
            onSortSelected: onSortSelected,
          ),
    );
  }
}
