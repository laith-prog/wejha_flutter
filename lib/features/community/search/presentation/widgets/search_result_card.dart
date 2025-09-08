import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/search_entities.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResult result;
  final SearchType searchType;

  const SearchResultCard({
    Key? key,
    required this.result,
    required this.searchType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _onCardTap(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image with loading/error handling
            AspectRatio(
              aspectRatio: 1.15,
              child: Container(
                color: AppColors.background,
                child:
                    (result.images?.isNotEmpty == true &&
                            (result.images!.first).trim().isNotEmpty)
                        ? Image.network(
                          result.images!.first,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder:
                              (context, error, stackTrace) => Center(
                                child: Icon(
                                  _getIconForSearchType(),
                                  size: 32.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                        )
                        : Center(
                          child: Icon(
                            _getIconForSearchType(),
                            size: 32.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
              ),
            ),

            // Text content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Location
                  Text(
                    '${result.city} - ${result.area}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),

                  // Title (2 lines, centered)
                  Text(
                    result.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),

                  // Price in primary color at bottom
                  if (result.price != null)
                    Text(
                      '${result.price} ${result.currency}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow() {
    final metadata = result.metadata!;
    List<Widget> chips = [];

    switch (searchType) {
      case SearchType.realEstateRentals:
      case SearchType.realEstateSales:
      case SearchType.realEstateRooms:
      case SearchType.realEstateInvestment:
        if (metadata['room_number'] != null) {
          chips.add(_buildChip('${metadata['room_number']} غرف'));
        }
        if (metadata['bathrooms'] != null) {
          chips.add(_buildChip('${metadata['bathrooms']} حمام'));
        }
        if (metadata['property_area'] != null) {
          chips.add(_buildChip('${metadata['property_area']} م²'));
        }
        break;

      case SearchType.vehicles:
        if (metadata['make'] != null && metadata['model'] != null) {
          chips.add(_buildChip('${metadata['make']} ${metadata['model']}'));
        }
        if (metadata['year'] != null) {
          chips.add(_buildChip('${metadata['year']}'));
        }
        if (metadata['mileage'] != null) {
          chips.add(_buildChip('${metadata['mileage']} كم'));
        }
        break;

      case SearchType.services:
        if (metadata['experience_years'] != null) {
          chips.add(_buildChip('${metadata['experience_years']} سنوات خبرة'));
        }
        if (metadata['is_mobile'] == true) {
          chips.add(_buildChip('خدمة متنقلة'));
        }
        break;

      case SearchType.jobs:
        if (metadata['job_type'] != null) {
          chips.add(_buildChip(metadata['job_type']));
        }
        if (metadata['attendance_type'] != null) {
          chips.add(_buildChip(metadata['attendance_type']));
        }
        if (metadata['experience_years_min'] != null) {
          chips.add(
            _buildChip('${metadata['experience_years_min']} سنوات خبرة'),
          );
        }
        break;
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      children: chips.take(3).toList(), // Limit to 3 chips
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
      ),
    );
  }

  IconData _getIconForSearchType() {
    switch (searchType) {
      case SearchType.realEstateRentals:
      case SearchType.realEstateSales:
      case SearchType.realEstateRooms:
      case SearchType.realEstateInvestment:
        return Icons.home;
      case SearchType.vehicles:
        return Icons.directions_car;
      case SearchType.services:
        return Icons.build;
      case SearchType.jobs:
        return Icons.work;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}';
    } else {
      return 'منذ ${difference.inMinutes} ${difference.inMinutes == 1 ? 'دقيقة' : 'دقائق'}';
    }
  }

  void _onCardTap(BuildContext context) {
    // Navigate to detail page
    // TODO: Implement navigation to detail page
    print('Tapped on result: ${result.id}');
  }

  void _onContactTap(BuildContext context) {
    // Show contact options
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('معلومات الاتصال'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('رقم الهاتف: ${result.phoneNumber}'),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement phone call
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('اتصال'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement WhatsApp
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.message),
                      label: const Text('واتساب'),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ],
          ),
    );
  }
}


