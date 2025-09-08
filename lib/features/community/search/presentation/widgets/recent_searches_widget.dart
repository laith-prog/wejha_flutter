import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/search_entities.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class RecentSearchesWidget extends StatelessWidget {
  final Function(String) onSearchSelected;

  const RecentSearchesWidget({Key? key, required this.onSearchSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen:
          (previous, current) =>
              current is RecentSearchesLoading ||
              current is RecentSearchesLoaded ||
              current is RecentSearchesError,
      builder: (context, state) {
        if (state is RecentSearchesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RecentSearchesLoaded) {
          return _buildRecentSearches(context, state.searches);
        } else if (state is RecentSearchesError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildRecentSearches(
    BuildContext context,
    List<RecentSearch> searches,
  ) {
    if (searches.isEmpty) {
      return Center(
        child: Text(
          'لا توجد عمليات بحث سابقة',
          style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
        ),
      );
    }

    // Return only the list (title handled by page)
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searches.length,
      separatorBuilder:
          (context, index) => Divider(color: AppColors.divider, height: 1.h),
      itemBuilder: (context, index) {
        final search = searches[index];
        return ListTile(
          onTap: () => onSearchSelected(search.query),
          leading: const Icon(Icons.history, color: AppColors.textSecondary),
          title: Text(
            search.query,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 16.sp),
          ),
          subtitle:
              search.category != null
                  ? Text(
                    search.category!,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  )
                  : null,
          trailing: Text(
            _formatTimestamp(search.timestamp),
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
