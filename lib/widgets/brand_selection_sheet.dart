import 'package:bon_task/widgets/clean_brand_option.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BrandSelectionSheet extends StatefulWidget {
  final VoidCallback onBrandSelected;

  const BrandSelectionSheet({super.key, required this.onBrandSelected});

  @override
  State<BrandSelectionSheet> createState() => _BrandSelectionSheetState();
}

class _BrandSelectionSheetState extends State<BrandSelectionSheet>
    with TickerProviderStateMixin {
  late AnimationController _sheetController;
  late List<AnimationController> _itemControllers;
  late List<Animation<Offset>> _itemSlideAnimations;
  late List<Animation<double>> _itemFadeAnimations;

  final List<Map<String, dynamic>> brands = [
    {
      'icon': Iconsax.crown,
      'title': 'BonCredit Partners',
      'subtitle': 'Premium exclusive offers',
      'color': Color(0xFF0F172A),
      'badge': 'EXCLUSIVE',
      'discount': 'Up to 20% off',
    },
    {
      'icon': Iconsax.coffee,
      'title': 'Food & Dining',
      'subtitle': 'Restaurants, cafes & delivery',
      'color': Color(0xFFEF4444),
      'badge': 'POPULAR',
      'discount': 'Up to 15% off',
    },
    {
      'icon': Iconsax.shopping_bag,
      'title': 'Retail & Fashion',
      'subtitle': 'Clothing, electronics & more',
      'color': Color(0xFF8B5CF6),
      'badge': null,
      'discount': 'Up to 10% off',
    },
    {
      'icon': Iconsax.gas_station,
      'title': 'Travel & Transport',
      'subtitle': 'Gas, rides & booking',
      'color': Color(0xFF06B6D4),
      'badge': null,
      'discount': 'Up to 5% off',
    },
  ];

  @override
  void initState() {
    super.initState();

    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _itemControllers = List.generate(
      brands.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    _itemSlideAnimations = List.generate(
      brands.length,
      (index) =>
          Tween<Offset>(begin: const Offset(0, 0.8), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _itemControllers[index],
              curve: Curves.easeOutCubic,
            ),
          ),
    );

    _itemFadeAnimations = List.generate(
      brands.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _itemControllers[index], curve: Curves.easeOut),
      ),
    );

    _startAnimation();
  }

  void _startAnimation() {
    _sheetController.forward().then((_) {
      for (int i = 0; i < _itemControllers.length; i++) {
        Future.delayed(Duration(milliseconds: i * 80), () {
          if (mounted) {
            _itemControllers[i].forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final maxHeight = screenHeight * 0.8;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(isTablet ? 32 : 24),
            child: Column(
              children: [
                Text(
                  'Select Store Category',
                  style: TextStyle(
                    fontSize: isTablet ? 26 : 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: isTablet ? 12 : 8),
                Text(
                  'Choose where to redeem your \$10 reward',
                  style: TextStyle(
                    fontSize: isTablet ? 17 : 15,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Brand options with proper spacing
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24),
              child: Column(
                children: List.generate(brands.length, (index) {
                  final brand = brands[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == brands.length - 1
                          ? 0
                          : (isTablet ? 16 : 12),
                    ),
                    child: SlideTransition(
                      position: _itemSlideAnimations[index],
                      child: FadeTransition(
                        opacity: _itemFadeAnimations[index],
                        child: CleanBrandOption(
                          icon: brand['icon'],
                          title: brand['title'],
                          subtitle: brand['subtitle'],
                          discount: brand['discount'],
                          color: brand['color'],
                          badge: brand['badge'],
                          isTablet: isTablet,
                          onTap: () {
                            Navigator.pop(context);
                            widget.onBrandSelected();
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          SizedBox(height: isTablet ? 32 : 24),
        ],
      ),
    );
  }
}
