import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wejha/core/theme/app_colors.dart';
import 'package:wejha/core/utils/url_helper.dart';
import 'package:wejha/features/home/presentation/state/home_bloc.dart';
import 'package:wejha/features/home/presentation/state/home_event.dart';
import 'package:wejha/features/home/presentation/state/home_state.dart';
import 'package:wejha/features/home/domain/entities/home_data.dart';
import 'package:wejha/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:wejha/features/profile/presentation/pages/profile_page.dart';
import 'package:wejha/injection_container.dart' as di;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Order matches design: [حسابي, الإشعارات, إضافة, السلة, الرئيسية]
  int _currentIndex = 4; // start on Home
  int _sectionIndex = 0; // 0: community, 1: products

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 30.h),
        child: AppBar(
          toolbarHeight: kToolbarHeight + 30.h,
          leadingWidth: 64.w,
          leading: Padding(
            padding: EdgeInsetsDirectional.only(start: 16.w,top: 18.h,bottom: 18.h,end: 12.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                Navigator.pushNamed(context, '/search');
              },
              child: Container(
                height: 32.h,
                width: 32.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(

                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),
          ),
          title: const SizedBox.shrink(),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 12.w),
              child: Image.asset(
                'assets/images/home_logo.png',
                height: 32.h,
                fit: BoxFit.contain,
              ),
            ),
          ],
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
        ),
      ),
      body: Directionality(textDirection: TextDirection.rtl, child: _buildBody()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'حسابي',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'الإشعارات',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 44.w,
              height: 44.h,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            label: 'إضافة',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'السلة',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
        ],
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontFamily: 'LamaSans'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'LamaSans'),
        elevation: 8,
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 4: // Home (rightmost)
        return Column(
          children: [
            _TopTabs(
              currentIndex: _sectionIndex,
              onChanged: (i) => setState(() => _sectionIndex = i),
            ),
            Expanded(
              child: _sectionIndex == 0
                  ? BlocProvider(
                      create: (_) => di.sl<HomeBloc>()..add(LoadHomeRequested()),
                      child: const _HomeBody(),
                    )
                  : const _ProductsPlaceholder(),
            ),
          ],
        );
      case 1: // Notifications
        return const _NotificationsPlaceholder();
      case 2: // Add (center button)
        return const _AddPlaceholder();
      case 3: // Cart
        return const _CartPlaceholder();
      case 0: // Profile (leftmost)
        return BlocProvider(
          create: (_) => di.sl<ProfileBloc>(),
          child: const ProfilePage(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _TopTabs extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;
  const _TopTabs({required this.currentIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 105.w,
              child: _TabButton(
                text: 'قسم المجتمع',
                isActive: currentIndex == 0,
                onTap: () => onChanged(0),
              ),
            ),
            SizedBox(
              width: 105.w,
              child: _TabButton(
                text: 'قسم التسوق',
                isActive: currentIndex == 1,
                onTap: () => onChanged(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;
  const _TabButton({required this.text, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12.sp,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const _HomeShimmer();
        }
        if (state is HomeError) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
                Text(state.message, style: TextStyle(color: AppColors.error, fontSize: 14.sp)),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: () => context.read<HomeBloc>().add(LoadHomeRequested()),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        if (state is HomeLoaded) {
          final data = state.data;
          return RefreshIndicator(
            onRefresh: () async => context.read<HomeBloc>().add(LoadHomeRequested(force: true)),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20.h,),
                    // Best offers section on soft background (header + list)
                    if (data.bestOffers.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 12.h),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                              child: _DecoratedHeader(
                                title: 'أفضل عروض 2025',
                                prefix: '⚡',
                                suffixIcon: Icons.edit_outlined,
                                showChevronLeft: true,
                              ),
                            ),
                            SizedBox(
                              height: 174.h,
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => _ListingCard(item: data.bestOffers[index]),
                                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                                itemCount: data.bestOffers.length,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Latest listings grid
                    if (data.latestListings.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                        child: _DecoratedHeader(title: 'احدث الاعلانات', suffixIcon: Icons.mode_edit_outline_outlined, showChevronLeft: true),
                      ),
                    if (data.latestListings.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: GridView.builder(
                          padding: EdgeInsets.only(top: 8.h),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                            mainAxisSpacing: 12.h,
                            crossAxisSpacing: 12.w,
                          ),
                          itemCount: data.latestListings.length.clamp(0, 6),
                          itemBuilder: (_, i) => _ListingGridItem(item: data.latestListings[i]),
                        ),
                      ),

                    // Featured categories
                    if (data.categories.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                        child: _DecoratedHeader(title: 'أبرز الفئات', suffixIcon: Icons.star_border, showChevronLeft: true),
                      ),
                    if (data.categories.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: data.categories.take(3).map((c) => _CategoryPill(title: c.displayName, iconUrl: c.iconUrl)).toList(),
                        ),
                      ),

                    // CTA bar
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                      child: _CtaBar(title: 'اطلب عقارك الخاص الآن'),
                    ),

                    // Promotions: 2-column then wide
                    if (data.banners.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            Expanded(child: _PromoCard(bannerIndex: 0, banners: data.banners)),
                            SizedBox(width: 12.w),
                            Expanded(child: _PromoCard(bannerIndex: 1, banners: data.banners)),
                          ],
                        ),
                      ),
                    if (data.banners.length > 2)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                        child: _PromoWideCard(bannerIndex: 2, banners: data.banners),
                      ),

                    // Top rated
                    if (data.topRated.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                        child: _DecoratedHeader(title: 'الأعلى تقييماً', suffixIcon: Icons.star_border, showChevronLeft: true),
                      ),
                    if (data.topRated.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: GridView.builder(
                          padding: EdgeInsets.only(top: 8.h),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                            mainAxisSpacing: 12.h,
                            crossAxisSpacing: 12.w,
                          ),
                          itemBuilder: (_, i) => _ListingGridItem(item: data.topRated[i]),
                          itemCount: data.topRated.length.clamp(0, 6),
                        ),
                      ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ProductsPlaceholder extends StatelessWidget {
  const _ProductsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64.sp, color: AppColors.textSecondary),
            SizedBox(height: 12.h),
            Text(
              'قسم التسوق',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8.h),
            Text(
              'سيتم عرض المنتجات قريباً عند ربط واجهة برمجة التطبيقات الخاصة بالتسوق.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsPlaceholder extends StatelessWidget {
  const _NotificationsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_outlined, size: 64.sp, color: AppColors.textSecondary),
            SizedBox(height: 12.h),
            Text(
              'الإشعارات',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8.h),
            Text(
              'لا توجد إشعارات جديدة حالياً.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddPlaceholder extends StatelessWidget {
  const _AddPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 64.sp, color: AppColors.textSecondary),
            SizedBox(height: 12.h),
            Text(
              'إضافة إعلان جديد',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8.h),
            Text(
              'قم بإنشاء إعلان جديد لعرض منتجاتك أو خدماتك.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartPlaceholder extends StatelessWidget {
  const _CartPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64.sp, color: AppColors.textSecondary),
            SizedBox(height: 12.h),
            Text(
              'السلة',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8.h),
          Text(
              'سلة التسوق فارغة حالياً.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeShimmer extends StatelessWidget {
  const _HomeShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBox(height: 160.h, width: double.infinity, radius: 16.r),
            SizedBox(height: 16.h),
            _shimmerRow(height: 120.h),
            SizedBox(height: 16.h),
            _shimmerGrid(),
            SizedBox(height: 16.h),
            _shimmerRow(height: 120.h),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({required double height, double? width, double radius = 12}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _shimmerRow({required double height}) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) => _shimmerBox(height: height, width: 200.w, radius: 16.r),
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemCount: 3,
      ),
    );
  }

  Widget _shimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
      ),
      itemBuilder: (_, __) => _shimmerBox(height: 140.h, radius: 12.r),
      itemCount: 6,
    );
  }
}

// Legacy section widgets removed; replaced by _DecoratedHeader and promo cards.
class _ListingCard extends StatelessWidget {
  final ListingUi item;
  const _ListingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final url = UrlHelper.formatImageUrl(item.imageUrl);
    return SizedBox(
      width: 100.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: CachedNetworkImage(
              imageUrl: url,
              width: 100.w,
              height: 90.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10.h),
          Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700)),
          SizedBox(height: 2.h),
          Text(item.priceText ?? '', textAlign: TextAlign.right, style: TextStyle(fontSize: 10.sp, color: AppColors.error, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ListingGridItem extends StatelessWidget {
  final ListingUi item;
  const _ListingGridItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final url = UrlHelper.formatImageUrl(item.imageUrl);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
           ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              height: 90.h,
              width: 100.w,
            ),
          ),
        SizedBox(height: 10.h),
        Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700)),
        SizedBox(height: 2.h),
        Text(item.priceText ?? '', textAlign: TextAlign.right, style: TextStyle(fontSize: 10.sp, color: AppColors.error, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String title;
  final String? iconUrl;
  const _CategoryPill({required this.title, this.iconUrl});

  @override
  Widget build(BuildContext context) {
    IconData _iconForTitle(String t) {
      if (t.contains('بيع') || t.contains('عقار')) return Icons.apartment_rounded;
      if (t.contains('إيجار') || t.contains('إيجار')) return Icons.meeting_room_outlined;
      if (t.contains('خدم')) return Icons.handyman_outlined;
      return Icons.category_outlined;
    }

    return Expanded(
      child: Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(_iconForTitle(title), color: AppColors.primary),
            ),
            SizedBox(height: 8.h),
            Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _DecoratedHeader extends StatelessWidget {
  final String title;
  final String? prefix; // e.g., emoji
  final IconData? suffixIcon;
  final bool showChevronLeft;
  const _DecoratedHeader({required this.title, this.prefix, this.suffixIcon, this.showChevronLeft = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        if (showChevronLeft)
          const Directionality(
            textDirection: TextDirection.ltr,
            child: Icon(Icons.chevron_left, color: AppColors.textSecondary, size: 20),
          ),
        if (showChevronLeft) SizedBox(width: 6.w),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefix != null) Text(prefix!, style: TextStyle(fontSize: 16.sp)),
                if (prefix != null) SizedBox(width: 6.w),
                Text(title, textAlign: TextAlign.right, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                if (suffixIcon != null) ...[
                  SizedBox(width: 8.w),
                  Icon(suffixIcon, size: 18, color: AppColors.error.withOpacity(0.9)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CtaBar extends StatelessWidget {
  final String title;
  const _CtaBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          const Directionality(
            textDirection: TextDirection.ltr,
            child: Icon(Icons.chevron_left, color: AppColors.textSecondary),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ),
          const Icon(Icons.star_border, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final int bannerIndex;
  final List<HomeBanner> banners;
  const _PromoCard({required this.bannerIndex, required this.banners});

  @override
  Widget build(BuildContext context) {
    if (bannerIndex >= banners.length) return const SizedBox.shrink();
    final b = banners[bannerIndex];
    final url = UrlHelper.formatImageUrl(b.imageUrl);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        children: [
          CachedNetworkImage(imageUrl: url, height: 180.h, fit: BoxFit.cover),
          Container(
            height: 180.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.45)],
              ),
            ),
          ),
          Positioned(
            bottom: 12.h,
            left: 12.w,
            right: 12.w,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                minimumSize: Size(double.infinity, 40.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, fontFamily: 'LamaSans'),
              ),
              child: const Text('استكشف'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoWideCard extends StatelessWidget {
  final int bannerIndex;
  final List<HomeBanner> banners;
  const _PromoWideCard({required this.bannerIndex, required this.banners});

  @override
  Widget build(BuildContext context) {
    if (bannerIndex >= banners.length) return const SizedBox.shrink();
    final b = banners[bannerIndex];
    final url = UrlHelper.formatImageUrl(b.imageUrl);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        children: [
          CachedNetworkImage(imageUrl: url, height: 180.h, width: double.infinity, fit: BoxFit.cover),
          Container(
            height: 180.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.45)],
              ),
            ),
          ),
          Positioned(
            bottom: 12.h,
            left: 12.w,
            right: 12.w,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                minimumSize: Size(double.infinity, 40.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, fontFamily: 'LamaSans'),
              ),
              child: const Text('استكشف'),
            ),
          ),
        ],
      ),
    );
  }
} 