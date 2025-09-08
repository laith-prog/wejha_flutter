import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/components/custom_text_field.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/search_entities.dart';

class SearchFiltersWidget extends StatefulWidget {
  final SearchType searchType;
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;
  final Function(SearchType)? onSearchTypeChanged;

  const SearchFiltersWidget({
    Key? key,
    required this.searchType,
    required this.currentFilters,
    required this.onFiltersChanged,
    this.onSearchTypeChanged,
  }) : super(key: key);

  @override
  State<SearchFiltersWidget> createState() => _SearchFiltersWidgetState();
}

class _SearchFiltersWidgetState extends State<SearchFiltersWidget> {
  late Map<String, dynamic> _filters;
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _priceMinController = TextEditingController();
  final TextEditingController _priceMaxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _initializeControllers();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _areaController.dispose();
    _priceMinController.dispose();
    _priceMaxController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _cityController.text = _filters['city']?.toString() ?? '';
    _areaController.text = _filters['area']?.toString() ?? '';
    _priceMinController.text = _filters['priceMin']?.toString() ?? '';
    _priceMaxController.text = _filters['priceMax']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  Text(
                    'الفلاتر',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text(
                      'مسح الكل',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Filters Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Type Selector
                    if (widget.onSearchTypeChanged != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تبحث عن ؟',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.w,
                            mainAxisSpacing: 8.h,
                            childAspectRatio: 1.0,
                            children: [
                              _buildTypeCard(
                                type: SearchType.realEstateRooms,
                                iconAsset: 'assets/icons/room_icon.png',
                                label: 'غرف للايجار',
                                isSelected:
                                    widget.searchType ==
                                    SearchType.realEstateRooms,
                              ),
                              _buildTypeCard(
                                type: SearchType.realEstateSales,
                                iconAsset:
                                    'assets/icons/property_sale_icon.png',
                                label: 'عقار للبيع',
                                isSelected:
                                    widget.searchType ==
                                    SearchType.realEstateSales,
                              ),
                              _buildTypeCard(
                                type: SearchType.realEstateRentals,
                                iconAsset:
                                    'assets/icons/property_rent_icon.png',
                                label: 'عقار للايجار',
                                isSelected:
                                    widget.searchType ==
                                    SearchType.realEstateRentals,
                              ),
                              _buildTypeCard(
                                type: SearchType.vehicles,
                                iconAsset: 'assets/icons/vehicle_icon.png',
                                label: 'المركبات',
                                isSelected:
                                    widget.searchType == SearchType.vehicles,
                              ),
                              _buildTypeCard(
                                type: SearchType.services,
                                iconAsset: 'assets/icons/service_icon.png',
                                label: 'الخدمات',
                                isSelected:
                                    widget.searchType == SearchType.services,
                              ),
                              _buildTypeCard(
                                type: SearchType.realEstateInvestment,
                                iconAsset: 'assets/icons/construction_icon.png',
                                label: 'منشأة قيد التنفيذ',
                                isSelected:
                                    widget.searchType ==
                                    SearchType.realEstateInvestment,
                              ),
                              _buildTypeCard(
                                type: SearchType.jobs,
                                iconAsset: 'assets/icons/job_icon.png',
                                label: 'فرص عمل',
                                isSelected:
                                    widget.searchType == SearchType.jobs,
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Divider(),
                          SizedBox(height: 16.h),
                        ],
                      ),

                    // Common and Type-specific filters
                    _buildCommonFilters(),
                    SizedBox(height: 24.h),
                    _buildTypeSpecificFilters(),
                  ],
                ),
              ),
            ),

            // Footer with Apply button
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'فلترة النتائج (420 نتيجة)',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('الموقع'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _cityController,
                hintText: 'المدينة',
                onChanged:
                    (value) =>
                        _filters['city'] = value.isNotEmpty ? value : null,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextField(
                controller: _areaController,
                hintText: 'المنطقة',
                onChanged:
                    (value) =>
                        _filters['area'] = value.isNotEmpty ? value : null,
              ),
            ),
          ],
        ),

        SizedBox(height: 24.h),
        _buildSectionTitle('السعر'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _priceMinController,
                hintText: 'الحد الأدنى',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        _filters['priceMin'] =
                            value.isNotEmpty ? double.tryParse(value) : null,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextField(
                controller: _priceMaxController,
                hintText: 'الحد الأقصى',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        _filters['priceMax'] =
                            value.isNotEmpty ? double.tryParse(value) : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeSpecificFilters() {
    switch (widget.searchType) {
      case SearchType.realEstateRentals:
      case SearchType.realEstateSales:
      case SearchType.realEstateRooms:
      case SearchType.realEstateInvestment:
        return _buildRealEstateFilters();
      case SearchType.vehicles:
        return _buildVehicleFilters();
      case SearchType.services:
        return _buildServiceFilters();
      case SearchType.jobs:
        return _buildJobFilters();
    }
  }

  Widget _buildRealEstateFilters() {
    if (widget.searchType == SearchType.realEstateRentals) {
      return _buildRealEstateRentalFilters();
    } else if (widget.searchType == SearchType.realEstateSales) {
      return _buildRealEstateSaleFilters();
    } else if (widget.searchType == SearchType.realEstateRooms) {
      return _buildRealEstateRoomFilters();
    } else {
      return _buildRealEstateInvestmentFilters();
    }
  }

  Widget _buildRealEstateRentalFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('نوع العقار'),
        SizedBox(height: 12.h),
        _buildDropdown(
          value: _filters['propertyType'],
          items: ['سكني', 'تجاري', 'أرض'],
          onChanged:
              (value) => setState(() => _filters['propertyType'] = value),
          hint: 'اختر نوع العقار',
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('مساحة البناء'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: '0.00',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        _filters['propertyAreaMin'] =
                            value.isNotEmpty ? double.tryParse(value) : null,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'متر مربع',
              style: TextStyle(fontSize: 12.sp, color: Colors.red),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('عدد الغرف'),
        SizedBox(height: 12.h),
        _buildRoomNumberSelector(),

        SizedBox(height: 20.h),
        _buildSectionTitle('عدد الحمامات'),
        SizedBox(height: 12.h),
        _buildBathroomNumberSelector(),

        SizedBox(height: 20.h),
        _buildSectionTitle('الفرش'),
        SizedBox(height: 12.h),
        _buildFurnishingOptions(),

        SizedBox(height: 20.h),
        _buildSectionTitle('منشور بواسطة'),
        SizedBox(height: 12.h),
        _buildPublisherOptions(),
      ],
    );
  }

  Widget _buildRealEstateSaleFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('نوع العقار'),
        SizedBox(height: 12.h),
        _buildDropdown(
          value: _filters['propertyType'],
          items: ['سكني', 'تجاري', 'أرض'],
          onChanged:
              (value) => setState(() => _filters['propertyType'] = value),
          hint: 'اختر نوع العقار',
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('السعر'),
        SizedBox(height: 12.h),
        _buildPaymentTypeOptions(),

        SizedBox(height: 20.h),
        _buildSectionTitle('مساحة البناء'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: '0.00',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        _filters['propertyAreaMin'] =
                            value.isNotEmpty ? double.tryParse(value) : null,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'متر مربع',
              style: TextStyle(fontSize: 12.sp, color: Colors.red),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('عدد الغرف'),
        SizedBox(height: 12.h),
        _buildRoomNumberSelector(),

        SizedBox(height: 20.h),
        _buildSectionTitle('عدد الحمامات'),
        SizedBox(height: 12.h),
        _buildBathroomNumberSelector(),

        SizedBox(height: 20.h),
        _buildSectionTitle('الفرش'),
        SizedBox(height: 12.h),
        _buildFurnishingOptions(),

        SizedBox(height: 20.h),
        _buildSectionTitle('منشور بواسطة'),
        SizedBox(height: 12.h),
        _buildPublisherOptions(),
      ],
    );
  }

  Widget _buildRealEstateRoomFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('مساحة البناء'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: '0.00',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        _filters['propertyAreaMin'] =
                            value.isNotEmpty ? double.tryParse(value) : null,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'متر مربع',
              style: TextStyle(fontSize: 12.sp, color: Colors.red),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('مدة الايجار'),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildSelectableOption(
              'يومي',
              _filters['rentalPeriod'] == 'daily',
              (selected) => setState(
                () => _filters['rentalPeriod'] = selected ? 'daily' : null,
              ),
            ),
            SizedBox(width: 12.w),
            _buildSelectableOption(
              'شهري',
              _filters['rentalPeriod'] == 'monthly',
              (selected) => setState(
                () => _filters['rentalPeriod'] = selected ? 'monthly' : null,
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('عدد الحمامات'),
        SizedBox(height: 12.h),
        _buildBathroomNumberSelector(),

        SizedBox(height: 20.h),
        _buildSectionTitle('الفرش'),
        SizedBox(height: 12.h),
        _buildFurnishingOptions(),

        SizedBox(height: 20.h),
        _buildSectionTitle('الجنس'),
        SizedBox(height: 12.h),
        _buildGenderOptions(),

        SizedBox(height: 20.h),
        _buildSectionTitle('منشور بواسطة'),
        SizedBox(height: 12.h),
        _buildPublisherOptions(),
      ],
    );
  }

  Widget _buildRealEstateInvestmentFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('مساحة البناء'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: '0.00',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        _filters['propertyAreaMin'] =
                            value.isNotEmpty ? double.tryParse(value) : null,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'متر مربع',
              style: TextStyle(fontSize: 12.sp, color: Colors.red),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('موعد التسليم'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  );
                  if (picked != null) {
                    setState(() {
                      _filters['deliveryDate'] = picked.toIso8601String();
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16.sp),
                      SizedBox(width: 8.w),
                      Text(
                        _filters['deliveryDate'] != null
                            ? DateTime.parse(
                              _filters['deliveryDate'],
                            ).toString().split(' ')[0]
                            : '0',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('عدد الغرف'),
        SizedBox(height: 12.h),
        _buildRoomNumberSelector(),

        SizedBox(height: 20.h),
        _buildSectionTitle('عدد الحمامات'),
        SizedBox(height: 12.h),
        _buildBathroomNumberSelector(),

        SizedBox(height: 20.h),
        _buildSectionTitle('الفرش'),
        SizedBox(height: 12.h),
        _buildFurnishingOptions(),

        SizedBox(height: 20.h),
        _buildSectionTitle('نوع البيع'),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildSelectableOption(
              'الكل',
              _filters['saleType'] == 'all',
              (selected) => setState(
                () => _filters['saleType'] = selected ? 'all' : null,
              ),
            ),
            SizedBox(width: 8.w),
            _buildSelectableOption(
              'البيع الأولي',
              _filters['saleType'] == 'primary',
              (selected) => setState(
                () => _filters['saleType'] = selected ? 'primary' : null,
              ),
            ),
            SizedBox(width: 8.w),
            _buildSelectableOption(
              'إعادة بيع',
              _filters['saleType'] == 'resale',
              (selected) => setState(
                () => _filters['saleType'] = selected ? 'resale' : null,
              ),
            ),
            SizedBox(width: 8.w),
            _buildSelectableOption(
              'مباشرة من المطور',
              _filters['saleType'] == 'direct',
              (selected) => setState(
                () => _filters['saleType'] = selected ? 'direct' : null,
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('منشور بواسطة'),
        SizedBox(height: 12.h),
        _buildPublisherOptions(),

        SizedBox(height: 20.h),
        _buildSectionTitle('حالة المشروع'),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildSelectableOption(
              'جاهز',
              _filters['projectStatus'] == 'ready',
              (selected) => setState(
                () => _filters['projectStatus'] = selected ? 'ready' : null,
              ),
            ),
            SizedBox(width: 12.w),
            _buildSelectableOption(
              'قيد التنفيذ',
              _filters['projectStatus'] == 'under_construction',
              (selected) => setState(
                () =>
                    _filters['projectStatus'] =
                        selected ? 'under_construction' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVehicleFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('الموقع'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Location picker would go here
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16.sp,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'انقر لتحديد الموقع',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'الأقرب مسافة',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('الشركة'),
        SizedBox(height: 12.h),
        _buildDropdown(
          value: _filters['make'],
          items: [
            'KIA',
            'تويوتا',
            'هوندا',
            'نيسان',
            'مرسيدس',
            'بي إم دبليو',
            'أودي',
          ],
          onChanged: (value) => setState(() => _filters['make'] = value),
          hint: 'اختر الشركة المصنعة',
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('الموديل'),
        SizedBox(height: 12.h),
        CustomTextField(
          hintText: 'Sportag 2024',
          onChanged:
              (value) => _filters['model'] = value.isNotEmpty ? value : null,
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('سنة الصنع'),
        SizedBox(height: 12.h),
        CustomTextField(
          hintText: '2024',
          keyboardType: TextInputType.number,
          onChanged:
              (value) =>
                  _filters['yearMin'] =
                      value.isNotEmpty ? int.tryParse(value) : null,
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('المسافة المقطوعة (بالكيلومتر)'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: '2500',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        _filters['mileageMax'] =
                            value.isNotEmpty ? int.tryParse(value) : null,
              ),
            ),
            SizedBox(width: 8.w),
            Text('كم', style: TextStyle(fontSize: 12.sp, color: Colors.red)),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('نوع الوقود'),
        SizedBox(height: 12.h),
        _buildDropdown(
          value: _filters['fuelType'],
          items: ['بنزين', 'ديزل', 'هجين', 'كهربائي'],
          onChanged: (value) => setState(() => _filters['fuelType'] = value),
          hint: 'اختر نوع الوقود',
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('نوع الغيار'),
        SizedBox(height: 12.h),
        _buildDropdown(
          value: _filters['transmission'],
          items: ['أوتوماتيك', 'يدوي'],
          onChanged:
              (value) => setState(() => _filters['transmission'] = value),
          hint: 'اختر نوع ناقل الحركة',
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('اللون الخارجي'),
        SizedBox(height: 12.h),
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => _filters['color'] = 'red'),
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        _filters['color'] == 'red'
                            ? Colors.black
                            : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Add more color options here
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('نوع السيارة'),
        SizedBox(height: 12.h),
        _buildDropdown(
          value: _filters['bodyType'],
          items: ['سيدان', 'هاتشباك', 'SUV', 'كوبيه', 'بيك آب'],
          onChanged: (value) => setState(() => _filters['bodyType'] = value),
          hint: 'اختر نوع السيارة',
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('منشور بواسطة'),
        SizedBox(height: 12.h),
        _buildPublisherOptions(),

        SizedBox(height: 20.h),
        _buildSectionTitle('الاضافات'),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildSelectableOption(
              'تكييف هواء',
              _filters['hasAC'] == true,
              (selected) => setState(() => _filters['hasAC'] = selected),
            ),
            _buildSelectableOption(
              'وكالة',
              _filters['isAgency'] == true,
              (selected) => setState(() => _filters['isAgency'] = selected),
            ),
            _buildSelectableOption(
              'تيبة',
              _filters['isTurbo'] == true,
              (selected) => setState(() => _filters['isTurbo'] = selected),
            ),
            _buildSelectableOption(
              'تاجر',
              _filters['isDealer'] == true,
              (selected) => setState(() => _filters['isDealer'] = selected),
            ),
          ],
        ),
      ],
    );
  }

  // Helper methods for filter options
  Widget _buildRoomNumberSelector() {
    return Wrap(
      spacing: 8.w,
      children: [
        _buildSelectableOption(
          '1-3',
          _filters['roomNumber'] == '1-3',
          (selected) =>
              setState(() => _filters['roomNumber'] = selected ? '1-3' : null),
        ),
        _buildSelectableOption(
          '3-6',
          _filters['roomNumber'] == '3-6',
          (selected) =>
              setState(() => _filters['roomNumber'] = selected ? '3-6' : null),
        ),
        _buildSelectableOption(
          '6-9',
          _filters['roomNumber'] == '6-9',
          (selected) =>
              setState(() => _filters['roomNumber'] = selected ? '6-9' : null),
        ),
        _buildSelectableOption(
          '+9',
          _filters['roomNumber'] == '9+',
          (selected) =>
              setState(() => _filters['roomNumber'] = selected ? '9+' : null),
        ),
      ],
    );
  }

  Widget _buildBathroomNumberSelector() {
    return Wrap(
      spacing: 8.w,
      children: [
        _buildSelectableOption(
          '1-3',
          _filters['bathrooms'] == '1-3',
          (selected) =>
              setState(() => _filters['bathrooms'] = selected ? '1-3' : null),
        ),
        _buildSelectableOption(
          '3-6',
          _filters['bathrooms'] == '3-6',
          (selected) =>
              setState(() => _filters['bathrooms'] = selected ? '3-6' : null),
        ),
        _buildSelectableOption(
          '+6',
          _filters['bathrooms'] == '6+',
          (selected) =>
              setState(() => _filters['bathrooms'] = selected ? '6+' : null),
        ),
      ],
    );
  }

  Widget _buildFurnishingOptions() {
    return Wrap(
      spacing: 8.w,
      children: [
        _buildSelectableOption(
          'مفروش',
          _filters['furnished'] == 'furnished',
          (selected) => setState(
            () => _filters['furnished'] = selected ? 'furnished' : null,
          ),
        ),
        _buildSelectableOption(
          'غير مفروش',
          _filters['furnished'] == 'unfurnished',
          (selected) => setState(
            () => _filters['furnished'] = selected ? 'unfurnished' : null,
          ),
        ),
        _buildSelectableOption(
          'الكل',
          _filters['furnished'] == 'all',
          (selected) =>
              setState(() => _filters['furnished'] = selected ? 'all' : null),
        ),
      ],
    );
  }

  Widget _buildPublisherOptions() {
    return Wrap(
      spacing: 8.w,
      children: [
        _buildSelectableOption(
          'المالك',
          _filters['publisher'] == 'owner',
          (selected) =>
              setState(() => _filters['publisher'] = selected ? 'owner' : null),
        ),
        _buildSelectableOption(
          'وكالة',
          _filters['publisher'] == 'agency',
          (selected) => setState(
            () => _filters['publisher'] = selected ? 'agency' : null,
          ),
        ),
        _buildSelectableOption(
          'وسيط',
          _filters['publisher'] == 'broker',
          (selected) => setState(
            () => _filters['publisher'] = selected ? 'broker' : null,
          ),
        ),
        _buildSelectableOption(
          'الكل',
          _filters['publisher'] == 'all',
          (selected) =>
              setState(() => _filters['publisher'] = selected ? 'all' : null),
        ),
      ],
    );
  }

  Widget _buildGenderOptions() {
    return Wrap(
      spacing: 8.w,
      children: [
        _buildSelectableOption(
          'ذكور',
          _filters['gender'] == 'male',
          (selected) =>
              setState(() => _filters['gender'] = selected ? 'male' : null),
        ),
        _buildSelectableOption(
          'اناث',
          _filters['gender'] == 'female',
          (selected) =>
              setState(() => _filters['gender'] = selected ? 'female' : null),
        ),
        _buildSelectableOption(
          'ثنائي',
          _filters['gender'] == 'mixed',
          (selected) =>
              setState(() => _filters['gender'] = selected ? 'mixed' : null),
        ),
        _buildSelectableOption(
          'عائلات',
          _filters['gender'] == 'families',
          (selected) =>
              setState(() => _filters['gender'] = selected ? 'families' : null),
        ),
      ],
    );
  }

  Widget _buildPaymentTypeOptions() {
    return Row(
      children: [
        _buildSelectableOption(
          'كاش',
          _filters['paymentType'] == 'cash',
          (selected) => setState(
            () => _filters['paymentType'] = selected ? 'cash' : null,
          ),
        ),
        SizedBox(width: 12.w),
        _buildSelectableOption(
          'اقساط',
          _filters['paymentType'] == 'installments',
          (selected) => setState(
            () => _filters['paymentType'] = selected ? 'installments' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableOption(
    String label,
    bool isSelected,
    Function(bool) onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(!isSelected),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 1 : 1,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Container(
                width: 16.w,
                height: 16.h,
                margin: EdgeInsets.only(right: 4.w),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 12.sp),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color:
                    isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('الموقع'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Location picker would go here
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16.sp,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'انقر لتحديد الموقع',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'الأقرب مسافة',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('السعر'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _priceMinController,
                hintText: 'الحد الأدنى',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        _filters['priceMin'] =
                            value.isNotEmpty ? double.tryParse(value) : null,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextField(
                controller: _priceMaxController,
                hintText: 'الحد الأقصى',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        _filters['priceMax'] =
                            value.isNotEmpty ? double.tryParse(value) : null,
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('نوع السعر'),
        SizedBox(height: 12.h),
        _buildDropdown(
          value: _filters['priceType'],
          items: ['ساعي', 'يومي', 'شهري', 'سنوي', 'مرة واحدة'],
          onChanged: (value) => setState(() => _filters['priceType'] = value),
          hint: 'نوع السعر',
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('سنوات الخبرة'),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          children: [
            _buildSelectableOption(
              '1+',
              _filters['experienceYearsMin'] == 1,
              (selected) => setState(
                () => _filters['experienceYearsMin'] = selected ? 1 : null,
              ),
            ),
            _buildSelectableOption(
              '2+',
              _filters['experienceYearsMin'] == 2,
              (selected) => setState(
                () => _filters['experienceYearsMin'] = selected ? 2 : null,
              ),
            ),
            _buildSelectableOption(
              '3+',
              _filters['experienceYearsMin'] == 3,
              (selected) => setState(
                () => _filters['experienceYearsMin'] = selected ? 3 : null,
              ),
            ),
            _buildSelectableOption(
              '5+',
              _filters['experienceYearsMin'] == 5,
              (selected) => setState(
                () => _filters['experienceYearsMin'] = selected ? 5 : null,
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        Row(
          children: [
            Checkbox(
              value: _filters['isMobile'] == true,
              onChanged:
                  (value) => setState(() => _filters['isMobile'] = value),
              activeColor: AppColors.primary,
            ),
            Text('خدمة متنقلة', style: TextStyle(fontSize: 14.sp)),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('منشور بواسطة'),
        SizedBox(height: 12.h),
        _buildPublisherOptions(),
      ],
    );
  }

  Widget _buildJobFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('الموقع'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Location picker would go here
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16.sp,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'انقر لتحديد الموقع',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'الأقرب مسافة',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('نوع الوظيفة'),
        SizedBox(height: 12.h),
        _buildDropdown(
          value: _filters['jobType'],
          items: ['دوام كامل', 'دوام جزئي', 'مؤقت', 'تدريب', 'عقد'],
          onChanged: (value) => setState(() => _filters['jobType'] = value),
          hint: 'نوع الوظيفة',
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('نوع الحضور'),
        SizedBox(height: 12.h),
        _buildDropdown(
          value: _filters['attendanceType'],
          items: ['مكتبي', 'عن بعد', 'هجين'],
          onChanged:
              (value) => setState(() => _filters['attendanceType'] = value),
          hint: 'نوع الحضور',
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('الراتب'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: 'الحد الأدنى',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        _filters['salaryMin'] =
                            value.isNotEmpty ? double.tryParse(value) : null,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextField(
                hintText: 'الحد الأقصى',
                keyboardType: TextInputType.number,
                onChanged:
                    (value) =>
                        _filters['salaryMax'] =
                            value.isNotEmpty ? double.tryParse(value) : null,
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSectionTitle('الحد الأدنى للتعليم'),
        SizedBox(height: 12.h),
        _buildDropdown(
          value: _filters['educationLevel'],
          items: [
            'شهادة جامعية',
            'ثانوي',
            'دبلوم',
            'بكالوريوس',
            'ماجستير',
            'دكتوراه',
          ],
          onChanged:
              (value) => setState(() => _filters['educationLevel'] = value),
          hint: 'مستوى التعليم',
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _filters.clear();
      _cityController.clear();
      _areaController.clear();
      _priceMinController.clear();
      _priceMaxController.clear();
    });
    // Notify parent about cleared filters
    widget.onFiltersChanged(_filters);
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }

  Widget _buildTypeCard({
    required SearchType type,
    required String iconAsset,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (widget.onSearchTypeChanged != null) {
          widget.onSearchTypeChanged!(type);
        }
      },
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
              errorBuilder:
                  (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 24.sp,
                    color: isSelected ? AppColors.primary : Colors.red.shade400,
                  ),
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

class CheckboxItem {
  final String label;
  final String key;

  CheckboxItem(this.label, this.key);
}
