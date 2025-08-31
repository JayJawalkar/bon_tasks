import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math' as math;

class CardRoulette extends StatefulWidget {
  const CardRoulette({super.key});

  @override
  State<CardRoulette> createState() => _CardRouletteState();
}

class _CardRouletteState extends State<CardRoulette>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _rotationController;
  late AnimationController _floatingController;
  late AnimationController _shimmerController;
  late AnimationController _entryController;
  late PageController _pageController;

  // Animations
  late Animation<double> _rotationAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _entryFadeAnimation;
  late Animation<Offset> _entrySlideAnimation;

  int _currentCardIndex = 0;
  bool _isSpinning = false;

  // Card data - now with proper image asset paths
  final List<CreditCard> cards = [
    CreditCard(
      name: 'American Express Silver',
      imagePath: 'assets/pngs/amexsilver9.png',
      type: 'Premium Travel',
      cashback: '2x Points',
      annualFee: '\$0',
      benefits: [
        'No foreign transaction fees',
        'Purchase protection',
        '24/7 concierge service',
        'Extended warranty',
      ],
      gradientColors: [Color(0xFFC0C0C0), Color(0xFFE5E5E5), Color(0xFFA8A8A8)],
      accentColor: Color(0xFF6B7280),
    ),
    CreditCard(
      name: 'American Express Gold',
      imagePath: 'assets/pngs/amexgold.png',
      type: 'Luxury Rewards',
      cashback: '4x Points',
      annualFee: '\$250',
      benefits: [
        '4x points on dining & groceries',
        '\$120 dining credit annually',
        'Airport lounge access',
        'Travel insurance coverage',
      ],
      gradientColors: [Color(0xFFFFD700), Color(0xFFFFC107), Color(0xFFFF8F00)],
      accentColor: Color(0xFFFF8F00),
    ),
    CreditCard(
      name: 'Chase Freedom',
      imagePath: 'assets/pngs/chasefreedom7.png',
      type: 'Everyday Cashback',
      cashback: '5% Categories',
      annualFee: '\$0',
      benefits: [
        '5% cashback on rotating categories',
        '1% on all other purchases',
        'No annual fee ever',
        'Fraud protection',
      ],
      gradientColors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF60A5FA)],
      accentColor: Color(0xFF1E3A8A),
    ),
    CreditCard(
      name: 'Discover Card',
      imagePath: 'assets/pngs/discover.png',
      type: 'Student Friendly',
      cashback: '1% Unlimited',
      annualFee: '\$0',
      benefits: [
        '1% unlimited cashback',
        'Cashback match for first year',
        'Free FICO credit score',
        'No late fees first time',
      ],
      gradientColors: [Color(0xFFFF6B35), Color(0xFFFF8F00), Color(0xFFFFB74D)],
      accentColor: Color(0xFFFF6B35),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeControllers() {
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
  }

  void _initializeAnimations() {
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _floatingAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(_shimmerController);

    _entryFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _entrySlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
        );
  }

  void _startEntryAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _entryController.forward();
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _floatingController.dispose();
    _shimmerController.dispose();
    _entryController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _spinRoulette() async {
    if (_isSpinning) return;

    setState(() => _isSpinning = true);
    HapticFeedback.mediumImpact();

    final random = math.Random();
    final finalIndex = random.nextInt(cards.length);

    await _rotationController.forward();

    await _pageController.animateToPage(
      finalIndex,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );

    setState(() {
      _currentCardIndex = finalIndex;
      _isSpinning = false;
    });

    _rotationController.reset();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Card Roulette',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0F0F23),
      ),
      backgroundColor: const Color(0xFF0F0F23),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [Color(0xFF1A1A2E), Color(0xFF0F0F23), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: isTablet ? 32 : 24),
              _CardCarousel(
                pageController: _pageController,
                rotationAnimation: _rotationAnimation,
                floatingAnimation: _floatingAnimation,
                shimmerAnimation: _shimmerAnimation,
                entryFadeAnimation: _entryFadeAnimation,
                entrySlideAnimation: _entrySlideAnimation,
                cards: cards,
                currentCardIndex: _currentCardIndex,
                isSpinning: _isSpinning,
                onPageChanged: (index) =>
                    setState(() => _currentCardIndex = index),
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 32 : 24),
              _CardInfo(
                card: cards[_currentCardIndex],
                entryFadeAnimation: _entryFadeAnimation,
                isTablet: isTablet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data model for credit cards
class CreditCard {
  final String name;
  final String imagePath;
  final String type;
  final String cashback;
  final String annualFee;
  final List<String> benefits;
  final List<Color> gradientColors;
  final Color accentColor;

  CreditCard({
    required this.name,
    required this.imagePath,
    required this.type,
    required this.cashback,
    required this.annualFee,
    required this.benefits,
    required this.gradientColors,
    required this.accentColor,
  });
}

// Header Widget
class _Header extends StatelessWidget {
  final Animation<double> entryFadeAnimation;
  final AnimationController entryController;

  const _Header({
    required this.entryFadeAnimation,
    required this.entryController,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return FadeTransition(
      opacity: entryFadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: entryController,
                curve: Curves.easeOutCubic,
              ),
            ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 32 : 24),
          child: Column(
            children: [
              Text(
                'Card Roulette',
                style: TextStyle(
                  fontSize: isTablet ? 25 : 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Discover your perfect credit card match',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Icon Button
class _IconButton extends StatelessWidget {
  final IconData icon;

  const _IconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}

// Card Carousel Widget
class _CardCarousel extends StatelessWidget {
  final PageController pageController;
  final Animation<double> rotationAnimation;
  final Animation<double> floatingAnimation;
  final Animation<double> shimmerAnimation;
  final Animation<double> entryFadeAnimation;
  final Animation<Offset> entrySlideAnimation;
  final List<CreditCard> cards;
  final int currentCardIndex;
  final bool isSpinning;
  final ValueChanged<int> onPageChanged;
  final bool isTablet;

  const _CardCarousel({
    required this.pageController,
    required this.rotationAnimation,
    required this.floatingAnimation,
    required this.shimmerAnimation,
    required this.entryFadeAnimation,
    required this.entrySlideAnimation,
    required this.cards,
    required this.currentCardIndex,
    required this.isSpinning,
    required this.onPageChanged,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return FadeTransition(
      opacity: entryFadeAnimation,
      child: SlideTransition(
        position: entrySlideAnimation,
        child: AnimatedBuilder(
          animation: floatingAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, floatingAnimation.value),
              child: SizedBox(
                height: screenHeight * (isTablet ? 0.35 : 0.32),
                child: AnimatedBuilder(
                  animation: rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: isSpinning ? rotationAnimation.value : 0,
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: onPageChanged,
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          return AnimatedBuilder(
                            animation: pageController,
                            builder: (context, child) {
                              double value = 0;
                              if (pageController.position.haveDimensions) {
                                value =
                                    index.toDouble() -
                                    (pageController.page ?? 0);
                                value = (value * 0.15).clamp(-1, 1);
                              }

                              return Transform.rotate(
                                angle: value,
                                child: _CardWidget(
                                  card: cards[index],
                                  isActive: index == currentCardIndex,
                                  isTablet: isTablet,
                                  shimmerAnimation: shimmerAnimation,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Individual Card Widget
class _CardWidget extends StatelessWidget {
  final CreditCard card;
  final bool isActive;
  final bool isTablet;
  final Animation<double> shimmerAnimation;

  const _CardWidget({
    required this.card,
    required this.isActive,
    required this.isTablet,
    required this.shimmerAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 3 : 1,
        vertical: isActive ? 0 : (isTablet ? 24 : 20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: card.accentColor.withOpacity(isActive ? 0.4 : 0.2),
              blurRadius: isActive ? 30 : 15,
              offset: const Offset(0, 15),
              spreadRadius: isActive ? 5 : 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Card background with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: card.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Card image
              Positioned.fill(
                child: Image.asset(card.imagePath, fit: BoxFit.contain),
              ),

              // Shimmer effect
              if (isActive)
                AnimatedBuilder(
                  animation: shimmerAnimation,
                  builder: (context, child) {
                    return Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                            stops: [
                              (shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                              shimmerAnimation.value.clamp(0.0, 1.0),
                              (shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

              // Holographic border effect
              if (isActive)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Card Information Widget
class _CardInfo extends StatelessWidget {
  final CreditCard card;
  final Animation<double> entryFadeAnimation;
  final bool isTablet;

  const _CardInfo({
    required this.card,
    required this.entryFadeAnimation,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: entryFadeAnimation,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Container(
          key: ValueKey(card.name),
          margin: EdgeInsets.symmetric(horizontal: isTablet ? 48 : 24),
          padding: EdgeInsets.all(isTablet ? 28 : 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: card.accentColor.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.name,
                          style: TextStyle(
                            fontSize: isTablet ? 22 : 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: isTablet ? 8 : 6),
                        Text(
                          card.type,
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            color: card.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: card.gradientColors),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      card.cashback,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 20 : 16),
              Row(
                children: [
                  _InfoChip(
                    icon: Iconsax.wallet_3,
                    label: 'Annual Fee',
                    value: card.annualFee,
                    color: card.accentColor,
                  ),
                  const SizedBox(width: 12),
                  _InfoChip(
                    icon: Iconsax.star,
                    label: 'Rewards',
                    value: card.cashback,
                    color: card.accentColor,
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 20 : 16),
              Text(
                'Key Benefits',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              ...card.benefits
                  .map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: card.accentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              benefit,
                              style: TextStyle(
                                fontSize: isTablet ? 15 : 14,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}

// Info Chip Widget
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
