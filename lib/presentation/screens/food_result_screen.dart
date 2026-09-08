import 'dart:io';
import 'package:flutter/material.dart';

class FoodResultScreen extends StatelessWidget {
  final dynamic food;
  final String imagePath;

  const FoodResultScreen({
    Key? key,
    required this.food,
    required this.imagePath,
  }) : super(key: key);

  String _formatFoodName(String name) {
    if (name.isEmpty) return name;
    return name
        .split(' ')
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    // Extract details safely
    Map<String, dynamic> foodMap = {};
    try {
      foodMap = food.toJson();
    } catch (_) {
      try {
        foodMap = Map<String, dynamic>.from(food);
      } catch (_) {}
    }

    final String rawName =
        (foodMap['name'] ?? food.name ?? 'Unknown Food').toString();
    final String foodName = _formatFoodName(rawName);

    final num caloriesRaw = foodMap['calories'] ?? food.calories ?? 0;
    final int calories = caloriesRaw.round();
    final double protein = (foodMap['protein'] as num?)?.toDouble() ?? 0.0;
    final double carbs = (foodMap['carbs'] as num?)?.toDouble() ?? 0.0;
    final double fats = (foodMap['fats'] as num?)?.toDouble() ??
        (foodMap['fat'] as num?)?.toDouble() ??
        0.0;

    double sugar = 1.24;
    try {
      sugar = (foodMap['sugar'] as num?)?.toDouble() ??
          (food.sugar as num?)?.toDouble() ??
          1.24;
    } catch (_) {}

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // A: Background Image Header (Top 45% of screen)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.45,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          ),

          // Image Gradient Overlay for legibility
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.45,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // C: Main Content Screen (Anchored to fill the bottom area)
          Positioned(
            top:
                screenHeight * 0.45 - 32, // Overlaps the image slightly by 32px
            left: 0,
            right: 0,
            bottom: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 400.0, end: 0.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: child,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 32,
                      bottom: MediaQuery.of(context).padding.bottom + 40,
                    ),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // D: Food Title
                        Text(
                          foodName,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // E: Calories Highlight Card
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(200),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Calories',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                            Icons.local_fire_department_rounded,
                                            color: Colors.orangeAccent,
                                            size: 16),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Estimated Energy',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '$calories',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      'kcal',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // F: Macronutrients Title & Row
                        Text(
                          'Macronutrients',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMacroCard(
                                context,
                                'Protein',
                                protein,
                                Colors.redAccent.shade400,
                                Icons.fitness_center_rounded),
                            _buildMacroCard(context, 'Carbs', carbs,
                                Colors.blueAccent.shade400, Icons.bolt_rounded),
                            _buildMacroCard(
                                context,
                                'Fat',
                                fats,
                                Colors.orangeAccent.shade400,
                                Icons.water_drop_rounded),
                            _buildMacroCard(
                                context,
                                'Sugar',
                                sugar,
                                Colors.purpleAccent.shade400,
                                Icons.cookie_rounded),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // G: CTA Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close ResultScreen
                            Navigator.pop(context); // Close ScannerScreen
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'Add to Diary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // B: Top Section: Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(BuildContext context, String label, double value,
      Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? color.withOpacity(0.12)
              : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 12),
            Text(
              '${value.toStringAsFixed(1)}g',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
