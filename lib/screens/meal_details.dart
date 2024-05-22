import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

// models
import 'package:meals_app/models/meal.dart';

// Providers
import 'package:meals_app/providers/favorites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            onPressed: () {
              final addedToFavorites =
                  ref.read(favoritesProvider.notifier).selectFavorite(meal);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(
                    addedToFavorites
                        ? 'Added to favorites'
                        : 'Removed from favorites',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            // icon: AnimatedSwitcher(
            //   transitionBuilder: (child, animation) {
            //     return RotationTransition(
            //         turns: Tween(begin: 0.7, end: 1.0).animate(animation),
            //         child: child);
            //   },
            //   duration: const Duration(milliseconds: 500),
            //   child: Icon(isFavorite ? Icons.star : Icons.star_border,
            //       key: ValueKey(isFavorite)),
            // ),
            color: isFavorite ? Colors.red[300] : Colors.white,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              clipBehavior: Clip.hardEdge,
              child: Hero(
                tag: meal.id,
                child: FadeInImage(
                  image: NetworkImage(meal.imageUrl),
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  placeholder: MemoryImage(kTransparentImage),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Text(
                  'Ingredients',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: Theme.of(context).colorScheme.primary),
                  ),
                  width: 250,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 200,
                  child: Column(
                    children: [
                      for (final ingredient in meal.ingredients)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: Text(
                              '${meal.ingredients.indexOf(ingredient) + 1}: $ingredient',
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              softWrap: true,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Recipe',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  width: 250,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 300,
                  child: Column(
                    children: [
                      for (final step in meal.steps)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: Text('${meal.steps.indexOf(step) + 1}: $step',
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              softWrap: true,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
