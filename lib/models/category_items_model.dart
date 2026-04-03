import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final int productCount;
  final Color bgColor;
  final Color textColor;
  final String ImageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.productCount,
    required this.bgColor,
    required this.textColor,
    required this.ImageUrl,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    int? productCount,
    Color? bgColor,
    Color? textColor,
    String? Imageurl,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      productCount: productCount ?? this.productCount,
      bgColor: bgColor ?? this.bgColor,
      textColor: textColor ?? this.textColor,
      ImageUrl: Imageurl ?? this.ImageUrl,
    );
  }
}

List<CategoryModel> categories = [
  CategoryModel(
    id: '1',
    name: 'Watch',
    productCount: 12,
    bgColor: AppColors.grey,
    textColor: AppColors.black,
    ImageUrl:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
  ),
  CategoryModel(
    id: '2',
    name: 'Bag',
    productCount: 8,
    bgColor: AppColors.white,
    textColor: AppColors.black,
    ImageUrl:
        'https://images.unsplash.com/photo-1491553895911-0055eca6402d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
  ),
  CategoryModel(
    id: '3',
    name: 'Slippers',
    productCount: 15,
    bgColor: AppColors.black,
    textColor: AppColors.white,
    ImageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
  ),

  CategoryModel(
    id: '4',
    name: 'Accessories',
    productCount: 20,
    bgColor: AppColors.grey,
    textColor: AppColors.white,
    ImageUrl:
        'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
  ),

  CategoryModel(
    id: '5',
    name: 'Phone cover',
    productCount: 18,
    bgColor: AppColors.grey,
    textColor: AppColors.white,
    ImageUrl:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
  ),

  CategoryModel(
    id: '6',
    name: 'Shirt',
    productCount: 25,
    bgColor: AppColors.grey,
    textColor: AppColors.black,
    ImageUrl:
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
  ),
];
