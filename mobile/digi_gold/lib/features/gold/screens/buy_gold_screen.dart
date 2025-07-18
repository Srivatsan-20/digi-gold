import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/gold_price_model.dart';
import '../services/gold_price_service.dart';

class BuyGoldScreen extends StatefulWidget {
  const BuyGoldScreen({super.key});

  @override
  State<BuyGoldScreen> createState() => _BuyGoldScreenState();
}

class _BuyGoldScreenState extends State<BuyGoldScreen> {
  final GoldPriceService _priceService = GoldPriceService();
  final TextEditingController _amountController = TextEditingController();
  
  GoldPriceModel? _currentPrice;
  double _selectedAmount = 2000.0;
  bool _isCustomAmount = false;

  // Predefined amount options
  final List<double> _predefinedAmounts = [500, 1000, 2000, 5000, 10000];

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _amountController.text = _selectedAmount.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
    final goldQuantity = _currentPrice != null 
        ? _selectedAmount / _currentPrice!.pricePerGram 
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Gold'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: Responsive.getPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Gold Price Card
            _buildGoldPriceCard(),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Amount Selection Section
            _buildAmountSelectionSection(),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Gold Quantity Preview
            _buildGoldQuantityPreview(goldQuantity),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Investment Summary
            _buildInvestmentSummary(goldQuantity),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Buy Button
            _buildBuyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldPriceCard() {
    if (_currentPrice == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                        size: 16,
                        color: _currentPrice!.isPositive 
                            ? AppColors.success
                            : _currentPrice!.isNegative
                                ? AppColors.error
                                : AppColors.grey,
                      ),
                      const SizedBox(width: AppSpacing.xs),
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
              _currentPrice!.formattedPrice,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'per gram • Last updated: ${_formatTime(_currentPrice!.timestamp)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Investment Amount',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Predefined Amount Chips
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _predefinedAmounts.map((amount) {
            final isSelected = !_isCustomAmount && _selectedAmount == amount;
            return FilterChip(
              label: Text('₹${amount.toStringAsFixed(0)}'),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedAmount = amount;
                  _isCustomAmount = false;
                  _amountController.text = amount.toStringAsFixed(0);
                });
              },
              backgroundColor: AppColors.lightGrey,
              selectedColor: AppColors.primaryGold.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primaryGold,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primaryGold : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: AppSpacing.lg),
        
        // Custom Amount Input
        Row(
          children: [
            Checkbox(
              value: _isCustomAmount,
              onChanged: (value) {
                setState(() {
                  _isCustomAmount = value ?? false;
                  if (_isCustomAmount) {
                    _amountController.clear();
                  } else {
                    _amountController.text = _selectedAmount.toStringAsFixed(0);
                  }
                });
              },
              activeColor: AppColors.primaryGold,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: CustomTextField(
                label: 'Custom Amount',
                hint: 'Enter amount in ₹',
                controller: _amountController,
                keyboardType: TextInputType.number,
                enabled: _isCustomAmount,
                prefixIcon: Icons.currency_rupee,
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0.0;
                  setState(() {
                    _selectedAmount = amount;
                  });
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(7), // Max 10 lakh
                ],
                validator: (value) {
                  if (_isCustomAmount) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount < 100) {
                      return 'Minimum amount is ₹100';
                    }
                    if (amount > 1000000) {
                      return 'Maximum amount is ₹10,00,000';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGoldQuantityPreview(double goldQuantity) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.diamond,
            size: 48,
            color: AppColors.white,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'You will get',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${goldQuantity.toStringAsFixed(4)} grams',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'of 24K Digital Gold',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentSummary(double goldQuantity) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Investment Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSummaryRow('Investment Amount', '₹${_selectedAmount.toStringAsFixed(2)}'),
            _buildSummaryRow('Gold Price', _currentPrice?.formattedPrice ?? '₹0.00'),
            _buildSummaryRow('Gold Quantity', '${goldQuantity.toStringAsFixed(4)} grams'),
            const Divider(height: AppSpacing.lg),
            _buildSummaryRow(
              'Total Payable', 
              '₹${_selectedAmount.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isTotal ? AppColors.primaryGold : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton() {
    final isValidAmount = _selectedAmount >= 100 && _selectedAmount <= 1000000;

    return GradientButton(
      text: 'Proceed to Payment',
      onPressed: isValidAmount ? _handleBuyGold : null,
      gradient: AppColors.goldGreenGradient,
      icon: Icons.payment,
      isFullWidth: true,
    );
  }

  void _handleBuyGold() {
    if (_selectedAmount < 100) {
      _showErrorDialog('Minimum investment amount is ₹100');
      return;
    }
    
    if (_selectedAmount > 1000000) {
      _showErrorDialog('Maximum investment amount is ₹10,00,000');
      return;
    }

    // TODO: Navigate to payment screen
    _showPaymentDialog();
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Integration'),
        content: Text(
          'Payment gateway integration will be implemented in Phase 2.\n\n'
          'Amount: ₹${_selectedAmount.toStringAsFixed(2)}\n'
          'Gold: ${(_selectedAmount / (_currentPrice?.pricePerGram ?? 1)).toStringAsFixed(4)} grams'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Amount'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Digital Gold'),
        content: const Text(
          '• 24K pure digital gold\n'
          '• Stored securely in digital vault\n'
          '• Real-time price updates\n'
          '• Minimum investment: ₹100\n'
          '• Maximum investment: ₹10,00,000\n'
          '• Instant purchase confirmation'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
