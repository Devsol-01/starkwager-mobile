part of '../../feature.dart';

class HomeScreenBody extends ConsumerWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _HomeScreenBodyContent();
  }
}

class _HomeScreenBodyContent extends ConsumerStatefulWidget {
  const _HomeScreenBodyContent();
  
  @override
  ConsumerState<_HomeScreenBodyContent> createState() => _HomeScreenBodyContentState();
}

class _HomeScreenBodyContentState extends ConsumerState<_HomeScreenBodyContent> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        debugPrint('Selected tab: $_selectedIndex');
      });
    }
  }

  void _showFundWalletDialog(BuildContext context) {
    if (context.isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => FundWalletDialog(),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => FundWalletDialog(),
      );
    }
  }

  Widget _buildCategoryTab(String title, String icon, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(16, 42, 86, 1)
              : const Color.fromRGBO(239, 241, 245, 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSelected) ...[
              SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              horizontalSpace(8),
              Text(
                title,
                style: AppTheme.of(context).textSmallMedium.copyWith(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.2,
                    ),
              ),
            ] else ...[
              Text(
                title,
                style: AppTheme.of(context).textSmallMedium.copyWith(
                      fontSize: 15,
                      color: const Color.fromRGBO(16, 42, 86, 1),
                      height: 1.2,
                    ),
              ),
              horizontalSpace(8),
              SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(16, 42, 86, 1),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: context.primaryBackgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildCategoryTab('Trending', AppIcons.trendingIcon, 0),
            _buildCategoryTab('Sports', AppIcons.sportsIcon, 1),
            _buildCategoryTab('Entertainment', AppIcons.entertainmentIcon, 2),
            _buildCategoryTab('Politics', AppIcons.politicsIcon, 3),
            _buildCategoryTab('Crypto', AppIcons.cryptoIcon, 4),
            _buildCategoryTab('Stocks', AppIcons.stocksIcon, 5),
            _buildCategoryTab('ESports', AppIcons.esportsIcon, 6),
            _buildCategoryTab('Games', AppIcons.gamesIcon, 7),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    final isLandscape = context.isLandscape;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppValues.padding16 : isLandscape ? 200 : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(24),
                ContractAddress(isTablet: !isMobile),
                verticalSpace(8),
                StarkAmount(
                  isTablet: !context.isMobile,
                  onAddMoney: () => _showFundWalletDialog(context),
                  onWithdraw: () {},
                ),
               
              ],
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: _CategoryTabsDelegate(
            builder: (overlapsContent) => _buildCategoryTabs(),
            selectedIndex: _selectedIndex,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index.isOdd) return verticalSpace(16);
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? AppValues.padding16 : isLandscape ? 200 : 0,
                  ),
                  child: const WagerWidget(),
                );
              },
              childCount: 6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _mobileNoWager(BuildContext context) {
    return Container(
      height: 81,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: context.containerColor,
      ),
      child: Row(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          horizontalSpace(16),
          SvgPicture.asset(AppIcons.noWagerIcon),
          Text(
            'noWagersCreatedYet'.tr(),
            style: AppTheme.of(context).bodyLarge16.copyWith(
                  color: context.textHintColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _tabletNoWager(BuildContext context) {
    return Container(
      height: 175,
      width: 696,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: context.containerColor,
      ),
      child: Column(
        spacing: 24,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppIcons.noWagerIcon, width: 88, height: 88),
          Text(
            'noWagersCreatedYet'.tr(),
            style: AppTheme.of(context).textMediumNormal.copyWith(
                  color: context.textHintColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTabsDelegate extends SliverPersistentHeaderDelegate {
  final Widget Function(bool) builder;
  final int selectedIndex;

  _CategoryTabsDelegate({
    required this.builder,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 100.0,
      color: context.primaryBackgroundColor,
      child: builder(overlapsContent),
    );
  }

  @override
  double get maxExtent => 100.0;

  @override
  double get minExtent => 100.0;

  @override
  bool shouldRebuild(covariant _CategoryTabsDelegate oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}
