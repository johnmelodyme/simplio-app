import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';

class SlidableGameImages extends StatelessWidget {
  const SlidableGameImages({
    super.key,
    required this.images,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadii.radius20,
      child: SizedBox(
        height: 213,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (context, index) => Gaps.gap16,
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            Widget item = ClipRRect(
              borderRadius: BorderRadii.radius20,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  images[index % images.length],
                  fit: BoxFit.cover,
                  width: 213,
                  height: 213,
                ),
              ),
            );
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(left: Dimensions.padding16),
                child: item,
              );
            } else if (index == images.length - 1) {
              return Padding(
                padding: const EdgeInsets.only(right: Dimensions.padding16),
                child: item,
              );
            }
            return item;
          },
        ),
      ),
    );
  }
}
