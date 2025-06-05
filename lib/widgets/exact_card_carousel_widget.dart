import 'package:flutter/material.dart';

class ExactCardCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const ExactCardCarousel({Key? key, required this.imageUrls})
      : super(key: key);

  @override
  State<ExactCardCarousel> createState() => _ExactCardCarouselState();
}

class _ExactCardCarouselState extends State<ExactCardCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0); 
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildExactCard(String imageUrl) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 393,
          height: 218,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD4AF37), 
              width: 1, 
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 393,
              height: 218,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, err, stack) {
                return Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(Icons.broken_image,
                        color: Colors.white60, size: 48),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;

      final fraction = 393.0 / screenWidth;

      if ((_pageController.viewportFraction - fraction).abs() > 0.001) {
        _pageController.dispose();
        _pageController = PageController(
            viewportFraction: fraction, initialPage: _currentPage);
      }

      return SizedBox(
        height: 218 + 24,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (idx) {
                setState(() {
                  _currentPage = idx;
                });
              },
              itemBuilder: (context, index) {
                final imageUrl = widget.imageUrls[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6), 
                  child: _buildExactCard(imageUrl),
                );
              },
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageUrls.length, (dotIndex) {
                  final isActive = (dotIndex == _currentPage);
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? const Color(0xFFD4AF37) 
                          : Colors.white
                              .withOpacity(0.6),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }
}
