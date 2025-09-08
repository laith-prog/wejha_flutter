import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/search_entities.dart';

class SearchTypeSelector extends StatelessWidget {
  final SearchType currentType;
  final Function(SearchType) onTypeChanged;

  const SearchTypeSelector({
    Key? key,
    required this.currentType,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              'تبحث عن ؟',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(height: 8.h),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 1.0,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildTypeCard(
                type: SearchType.realEstateRooms,
                iconAsset: 'assets/icons/room_icon.png',
                label: 'غرف للايجار',
                isSelected: currentType == SearchType.realEstateRooms,
              ),
              _buildTypeCard(
                type: SearchType.realEstateSales,
                iconAsset: 'assets/icons/property_sale_icon.png',
                label: 'عقار للبيع',
                isSelected: currentType == SearchType.realEstateSales,
              ),
              _buildTypeCard(
                type: SearchType.realEstateRentals,
                iconAsset: 'assets/icons/property_rent_icon.png',
                label: 'عقار للايجار',
                isSelected: currentType == SearchType.realEstateRentals,
              ),
              _buildTypeCard(
                type: SearchType.vehicles,
                iconAsset: 'assets/icons/vehicle_icon.png',
                label: 'المركبات',
                isSelected: currentType == SearchType.vehicles,
              ),
              _buildTypeCard(
                type: SearchType.services,
                iconAsset: 'assets/icons/service_icon.png',
                label: 'الخدمات',
                isSelected: currentType == SearchType.services,
              ),
              _buildTypeCard(
                type: SearchType.realEstateInvestment,
                iconAsset: 'assets/icons/construction_icon.png',
                label: 'منشأة قيد التنفيذ',
                isSelected: currentType == SearchType.realEstateInvestment,
              ),
              _buildTypeCard(
                type: SearchType.realEstateInvestment,
                iconAsset: 'assets/icons/luxury_project_icon.png',
                label: 'المشاريع العقارية الفاخرة',
                isSelected: false,
              ),
              _buildTypeCard(
                type: SearchType.jobs,
                iconAsset: 'assets/icons/job_icon.png',
                label: 'فرص عمل',
                isSelected: currentType == SearchType.jobs,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required SearchType type,
    required String iconAsset,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTypeChanged(type),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconAsset,
              width: 24.w,
              height: 24.h,
              color: isSelected ? AppColors.primary : Colors.red.shade400,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.normal,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

