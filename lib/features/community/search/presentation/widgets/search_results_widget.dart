import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/search_entities.dart';
import 'search_result_card.dart';
import 'sort_bottom_sheet.dart';

class SearchResultsWidget extends StatelessWidget {
  final SearchResults results;
  final SearchType searchType;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final SortOption? currentSortOption;
  final Function(SortOption)? onSortChanged;

  const SearchResultsWidget({
    Key? key,
    required this.results,
    required this.searchType,
    required this.scrollController,
    this.isLoadingMore = false,
    this.currentSortOption,
    this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Results Header with Sort
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          color: AppColors.background,
          child: Column(
            children: [
              // First row: Results count, page info, sort button
              Row(
                children: [
                  Text(
                    'النتائج: ${results.total}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'الصفحة ${results.currentPage} من ${results.lastPage}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (onSortChanged != null) _buildSortButton(context),
                ],
              ),
            ],
          ),
        ),

        // Results Grid
        Expanded(
          child: GridView.builder(
            controller: scrollController,
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 0.78, // more height to reduce overflow
            ),
            itemCount: results.items.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == results.items.length) {
                // Loading more indicator (as a grid tile)
                return const Center(child: LoadingIndicator());
              }

              final item = results.items[index];
              return SearchResultCard(result: item, searchType: searchType);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSortButton(BuildContext context) {
    final currentSort = currentSortOption ?? SortOption.newest;

    return GestureDetector(
      onTap: () {
        if (onSortChanged != null) {
          SortBottomSheet.show(
            context,
            searchType: searchType,
            currentSortOption: currentSort,
            onSortSelected: onSortChanged!,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(6.r),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ترتيب',
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
            ),
            SizedBox(width: 2.w),
            Icon(
              Icons.keyboard_arrow_down,
              size: 14.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
