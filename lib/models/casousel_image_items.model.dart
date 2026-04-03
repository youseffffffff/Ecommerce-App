class ImageCarouselItem {
  final int id;
  final String imageUrl;

  ImageCarouselItem({required this.imageUrl, required this.id});
}

List<ImageCarouselItem> carouselItems = [
  ImageCarouselItem(
    id: 1,
    imageUrl:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
  ),
  ImageCarouselItem(
    id: 2,
    imageUrl:
        'https://images.unsplash.com/photo-1491553895911-0055eca6402d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
  ),
  ImageCarouselItem(
    id: 3,
    imageUrl:
        'https://images.unsplash.com/photo-1572635196237-14b3f281503f?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
  ),
  ImageCarouselItem(
    id: 4,
    imageUrl:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
  ),
  ImageCarouselItem(
    id: 5,
    imageUrl:
        'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
  ),
];
