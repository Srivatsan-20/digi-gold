import 'dart:async';
import 'dart:math';
import '../models/gold_price_model.dart';

class GoldPriceService {
  static final GoldPriceService _instance = GoldPriceService._internal();
  factory GoldPriceService() => _instance;
  GoldPriceService._internal();

  // Stream controller for real-time price updates
  final StreamController<GoldPriceModel> _priceController = StreamController<GoldPriceModel>.broadcast();
  Stream<GoldPriceModel> get priceStream => _priceController.stream;

  // Current price cache
  GoldPriceModel? _currentPrice;
  Timer? _priceUpdateTimer;

  // Base price for simulation (in real app, this would come from API)
  static const double _basePrice = 6250.50;
  final Random _random = Random();

  // Initialize the service
  void initialize() {
    _generateInitialPrice();
    _startPriceUpdates();
  }

  // Dispose resources
  void dispose() {
    _priceUpdateTimer?.cancel();
    _priceController.close();
  }

  // Get current gold price
  GoldPriceModel? get currentPrice => _currentPrice;

  // Get current price as Future
  Future<GoldPriceModel> getCurrentPrice() async {
    if (_currentPrice == null) {
      _generateInitialPrice();
    }
    return _currentPrice!;
  }

  // Simulate real-time price updates
  void _startPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updatePrice();
    });
  }

  // Generate initial price
  void _generateInitialPrice() {
    final now = DateTime.now();
    final priceVariation = (_random.nextDouble() - 0.5) * 100; // ±50 variation
    final newPrice = _basePrice + priceVariation;
    
    _currentPrice = GoldPriceModel(
      pricePerGram: newPrice,
      pricePerOunce: newPrice * 31.1035, // 1 ounce = 31.1035 grams
      currency: 'INR',
      timestamp: now,
      changePercent: 0.0,
      changeAmount: 0.0,
      trend: 'stable',
    );

    _priceController.add(_currentPrice!);
  }

  // Update price with realistic fluctuations
  void _updatePrice() {
    if (_currentPrice == null) return;

    final now = DateTime.now();
    final previousPrice = _currentPrice!.pricePerGram;
    
    // Generate realistic price movement (±2% max change)
    final changePercent = (_random.nextDouble() - 0.5) * 4; // ±2%
    final changeAmount = previousPrice * (changePercent / 100);
    final newPrice = previousPrice + changeAmount;
    
    // Ensure price doesn't go below a reasonable minimum
    final finalPrice = newPrice < 5000 ? 5000.0 : newPrice;
    final finalChangeAmount = finalPrice - previousPrice;
    final finalChangePercent = (finalChangeAmount / previousPrice) * 100;
    
    String trend;
    if (finalChangePercent > 0.1) {
      trend = 'up';
    } else if (finalChangePercent < -0.1) {
      trend = 'down';
    } else {
      trend = 'stable';
    }

    _currentPrice = GoldPriceModel(
      pricePerGram: finalPrice,
      pricePerOunce: finalPrice * 31.1035,
      currency: 'INR',
      timestamp: now,
      changePercent: finalChangePercent,
      changeAmount: finalChangeAmount,
      trend: trend,
    );

    _priceController.add(_currentPrice!);
  }

  // Manual price refresh
  Future<GoldPriceModel> refreshPrice() async {
    _updatePrice();
    return _currentPrice!;
  }

  // Get historical prices (simulated)
  Future<List<GoldPriceModel>> getHistoricalPrices({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final List<GoldPriceModel> historicalPrices = [];
    final daysDifference = endDate.difference(startDate).inDays;
    
    for (int i = 0; i <= daysDifference; i++) {
      final date = startDate.add(Duration(days: i));
      final priceVariation = (_random.nextDouble() - 0.5) * 200; // ±100 variation
      final price = _basePrice + priceVariation;
      final changePercent = (_random.nextDouble() - 0.5) * 6; // ±3%
      final changeAmount = price * (changePercent / 100);
      
      String trend;
      if (changePercent > 0.5) {
        trend = 'up';
      } else if (changePercent < -0.5) {
        trend = 'down';
      } else {
        trend = 'stable';
      }

      historicalPrices.add(GoldPriceModel(
        pricePerGram: price,
        pricePerOunce: price * 31.1035,
        currency: 'INR',
        timestamp: date,
        changePercent: changePercent,
        changeAmount: changeAmount,
        trend: trend,
      ));
    }

    return historicalPrices;
  }

  // Calculate investment scenarios
  Map<String, dynamic> calculateInvestmentScenario({
    required double monthlyAmount,
    required int months,
  }) {
    final currentPrice = _currentPrice?.pricePerGram ?? _basePrice;
    final totalInvestment = monthlyAmount * months;
    
    // Simulate average price over the period (with slight appreciation)
    final averagePrice = currentPrice * (1 + (0.05 * months / 12)); // 5% annual appreciation
    final totalGoldQuantity = totalInvestment / averagePrice;
    
    // Calculate potential returns
    final futurePrice = currentPrice * (1 + (0.08 * months / 12)); // 8% annual appreciation
    final futureValue = totalGoldQuantity * futurePrice;
    final potentialGain = futureValue - totalInvestment;
    final potentialGainPercent = (potentialGain / totalInvestment) * 100;

    return {
      'totalInvestment': totalInvestment,
      'averagePrice': averagePrice,
      'totalGoldQuantity': totalGoldQuantity,
      'currentValue': totalGoldQuantity * currentPrice,
      'futureValue': futureValue,
      'potentialGain': potentialGain,
      'potentialGainPercent': potentialGainPercent,
    };
  }

  // Get price alerts (for future implementation)
  Future<void> setPriceAlert({
    required double targetPrice,
    required String alertType, // 'above' or 'below'
  }) async {
    // TODO: Implement price alerts
    // This would typically involve backend integration
  }
}
