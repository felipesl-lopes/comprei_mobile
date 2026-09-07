import 'dart:async';

import 'package:appshop/core/widgets/image_fallback_icon.dart';
import 'package:appshop/modules/home/models/banner_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerModel> bannerList;

  BannerCarousel({required this.bannerList});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.bannerList.length > 1) _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {
        if (!_controller.hasClients) return;

        _currentPage++;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (widget.bannerList.isEmpty) return const SizedBox.shrink();

    final banners = widget.bannerList;

    return AspectRatio(
      aspectRatio: 19 / 9,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index % banners.length;
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = banners[index % banners.length];

              return CachedNetworkImage(
                imageUrl: banner.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Image.asset(
                    'assets/images/banner-padrao.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return ImageFallbackIcon(size: 120);
                    },
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 8,
            child: Row(
              children: List.generate(
                banners.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 10 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? colorScheme.onPrimary
                        : colorScheme.onPrimary.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
