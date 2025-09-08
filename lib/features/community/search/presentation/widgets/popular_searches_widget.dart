import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/search_entities.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class PopularSearchesWidget extends StatelessWidget {
  final Function(String) onSearchSelected;

  const PopularSearchesWidget({Key? key, required this.onSearchSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen:
          (previous, current) =>
              current is PopularSearchesLoading ||
              current is PopularSearchesLoaded ||
              current is PopularSearchesError,
      builder: (context, state) {
        if (state is PopularSearchesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PopularSearchesLoaded) {
          return _buildPopularSearches(context, state.searches);
        } else if (state is PopularSearchesError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildPopularSearches(
    BuildContext context,
    List<PopularSearch> searches,
  ) {
    if (searches.isEmpty) {
      return Center(
        child: Text(
          'لا توجد عمليات بحث شائعة',
          style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            'عمليات البحث الشائعة',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children:
              searches
                  .map((search) => _buildSearchChip(context, search))
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildSearchChip(BuildContext context, PopularSearch search) {
    return InkWell(
      onTap: () => onSearchSelected(search.query),
      child: Chip(
        backgroundColor: AppColors.background,
        side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        label: Text(
          search.query,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
        ),
        avatar:
            search.category != null
                ? CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Text(
                    search.category!.substring(0, 1),
                    style: TextStyle(color: AppColors.primary, fontSize: 12.sp),
                  ),
                )
                : null,
      ),
    );
  }
}
