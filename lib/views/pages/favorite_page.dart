import 'dart:math';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:ecommerce_app/services/users_services.dart';
import 'package:ecommerce_app/utils/current_user.dart';
import 'package:ecommerce_app/view_models/checkout/cubit/checkout_cubit.dart';
import 'package:ecommerce_app/view_models/product/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//

// ─────────────────────────────────────────────
//  THEME CONSTANTS
// ─────────────────────────────────────────────

abstract class _AppColors {
  static const background = Color(0xFFF7F7F5);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF111111);
  static const accent = Color(0xFFE84040);
  static const textPrimary = Color(0xFF111111);
  static const textSecondary = Color(0xFF888888);
  static const star = Color(0xFFFFC043);
  static const divider = Color(0xFFEEEEEE);
}

// ─────────────────────────────────────────────
//  FAVORITE PAGE
// ─────────────────────────────────────────────

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  List<Product?> _products = [];
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();

    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  void _toggleFavorite(Product product) async {
    await BlocProvider.of<ProductCubit>(
      context,
    ).removeFromFavorites(currentUser!.id, product.id);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ProductCubit>(context)
      ..getAllFavorites(currentUser!.id);

    return BlocBuilder<ProductCubit, ProductState>(
      bloc: cubit,

      buildWhen: (previous, current) =>
          current is FavoriteLoading ||
          current is FavoriteLoaded ||
          current is FavoriteError,
      builder: (context, state) {
        if (state is FavoriteLoading) {
          return const Scaffold(
            backgroundColor: _AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is FavoriteError) {
          return Scaffold(
            backgroundColor: _AppColors.background,
            appBar: _buildAppBar(),
            body: Center(
              child: Text(
                'Error loading favorites:\n${(state as FavoriteError).message}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: _AppColors.textSecondary,
                ),
              ),
            ),
          );
        } else if (state is FavoriteLoaded) {
          _products = (state as FavoriteLoaded).favoriteItems;
          return Scaffold(
            backgroundColor: _AppColors.background,
            appBar: _buildAppBar(),
            body: _buildGrid(),
          );
        } else {
          return Scaffold(
            backgroundColor: _AppColors.background,
            appBar: _buildAppBar(),
            body: _buildEmptyState(),
          );
        }
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: const Text(
        'Favorites',
        style: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: _AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        if (_products.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_products.length} items',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _AppColors.divider,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 44,
              color: _AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start adding products you love',
            style: TextStyle(
              fontSize: 14,
              color: _AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final delay = (index * 80).clamp(0, 500);

        return _AnimatedCardWrapper(
          controller: _listController,
          delay: delay,
          child: ProductCard(
            product: product!,
            onFavoriteToggle: () => _toggleFavorite(product!),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  ANIMATED CARD WRAPPER
// ─────────────────────────────────────────────

class _AnimatedCardWrapper extends StatelessWidget {
  final AnimationController controller;
  final int delay;
  final Widget child;

  const _AnimatedCardWrapper({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = (delay / 1000).clamp(0.0, 0.8);
    final end = (start + 0.5).clamp(0.0, 1.0);

    final fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    final slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        );

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }
}

// ─────────────────────────────────────────────
//  PRODUCT CARD
// ─────────────────────────────────────────────

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.onFavoriteToggle,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heartScale =
        TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _handleFavoriteTap() {
    _heartController.forward(from: 0);
    widget.onFavoriteToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildImage(), _buildInfo()],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: [
          Hero(
            tag: widget.product.id,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: _AppColors.divider,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: _AppColors.textSecondary,
                      size: 32,
                    ),
                  ),
                ),
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: _AppColors.divider,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: _AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Category badge
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.product.category,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _AppColors.textPrimary,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),

          // Favorite button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: _handleFavoriteTap,
              child: AnimatedBuilder(
                animation: _heartScale,
                builder: (_, __) => Transform.scale(
                  scale: _heartScale.value,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: widget.product.isFavorite
                          ? _AppColors.accent
                          : Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 16,
                      color: widget.product.isFavorite
                          ? Colors.white
                          : _AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _AppColors.textPrimary,
                height: 1.35,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: 6),
            _buildRating(),
            const SizedBox(height: 6),
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRating() {
    final rate = widget.product.averageRate.clamp(0.0, 5.0);
    final fullStars = rate.floor();
    final hasHalf = (rate - fullStars) >= 0.5;

    return Row(
      children: [
        Row(
          children: List.generate(5, (i) {
            IconData icon;
            if (i < fullStars) {
              icon = Icons.star_rounded;
            } else if (i == fullStars && hasHalf) {
              icon = Icons.star_half_rounded;
            } else {
              icon = Icons.star_outline_rounded;
            }
            return Icon(icon, size: 12, color: _AppColors.star);
          }),
        ),
        const SizedBox(width: 4),
        Text(
          rate.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
