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

    final initialPage =
        widget.imageUrls.length > 1 ? widget.imageUrls.length ~/ 2 : 0;

    _pageController = PageController(
      viewportFraction: 0.7,
      initialPage: initialPage,
    );

    _currentPage = initialPage;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildExactCard(
      String imageUrl, double cardWidth, double cardHeight, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin:
          EdgeInsets.symmetric(horizontal: isActive ? 6 : 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD4AF37),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: cardWidth,
            height: cardHeight,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, err, stack) {
              return Container(
                color: Colors.grey[800],
                child: const Center(
                  child:
                      Icon(Icons.broken_image, color: Colors.white60, size: 48),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;


      final isMobile = MediaQuery.of(context).size.width < 600;

      final cardWidth = isMobile
          ? screenWidth * 0.55
          : screenWidth * 0.45;

      final cardHeight = isMobile
          ? cardWidth * 9 / 16 
          : MediaQuery.of(context).size.height *
              0.45; 

      return SizedBox(
        height: cardHeight + 50,
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
                final isActive = index == _currentPage;
                return _buildExactCard(
                  imageUrl,
                  cardWidth,
                  cardHeight,
                  isActive,
                );
              },
            ),

            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageUrls.length, (dotIndex) {
                  final isActive = (dotIndex == _currentPage);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 10 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? const Color(0xFFD4AF37)
                          : Colors.white.withOpacity(0.6),
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
