import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/utils/responsive.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/gold/screens/portfolio_screen.dart';
import 'features/gold/screens/schemes_screen.dart';
import 'features/gold/screens/transaction_history_screen.dart';
import 'features/gold/screens/buy_gold_screen.dart';
import 'features/gold/services/gold_price_service.dart';
import 'features/gold/models/gold_price_model.dart';

void main() {
  runApp(const DigiGoldApp());
}

class DigiGoldApp extends StatelessWidget {
  const DigiGoldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digi Gold',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const OnboardingScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoldPriceService _priceService = GoldPriceService();
  GoldPriceModel? _currentPrice;
  double investmentAmount = 2000.0;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() {
    _priceService.initialize();

    // Listen to price updates
    _priceService.priceStream.listen((price) {
      if (mounted) {
        setState(() {
          _currentPrice = price;
        });
      }
    });

    // Load initial price
    _loadInitialPrice();
  }

  void _loadInitialPrice() async {
    final price = await _priceService.getCurrentPrice();
    setState(() {
      _currentPrice = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    final goldPrice = _currentPrice?.pricePerGram ?? 6250.50;
    final goldQuantity = investmentAmount / goldPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digi Gold'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: Responsive.getPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: AppColors.goldGreenGradient,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Digi Gold',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Start your digital gold investment journey',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Gold Price Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Gold Price',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (_currentPrice != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: _currentPrice!.isPositive
                                  ? AppColors.success.withValues(alpha: 0.1)
                                  : _currentPrice!.isNegative
                                      ? AppColors.error.withValues(alpha: 0.1)
                                      : AppColors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _currentPrice!.isPositive
                                      ? Icons.trending_up
                                      : _currentPrice!.isNegative
                                          ? Icons.trending_down
                                          : Icons.trending_flat,
                                  size: 12,
                                  color: _currentPrice!.isPositive
                                      ? AppColors.success
                                      : _currentPrice!.isNegative
                                          ? AppColors.error
                                          : AppColors.grey,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  _currentPrice!.formattedChange,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: _currentPrice!.isPositive
                                        ? AppColors.success
                                        : _currentPrice!.isNegative
                                            ? AppColors.error
                                            : AppColors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '₹${goldPrice.toStringAsFixed(2)}/gram',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.primaryGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Last updated: ${DateTime.now().toString().substring(0, 16)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Investment Calculator Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Investment Calculator',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Investment Amount',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '₹${investmentAmount.toStringAsFixed(0)}',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward, color: AppColors.grey),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Gold Quantity',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '${goldQuantity.toStringAsFixed(4)} grams',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.primaryGold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BuyGoldScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Buy Gold'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SchemesScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.trending_up),
                    label: const Text('View Schemes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1: // Portfolio
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PortfolioScreen()),
              );
              break;
            case 2: // History
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
              );
              break;
            case 3: // Profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile feature coming soon!'),
                  backgroundColor: AppColors.info,
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
