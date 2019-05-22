import 'package:flutter/material.dart';
import 'package:flutter_gallery/model/picture.dart';
import 'package:flutter_gallery/page/page_item.dart';
import 'package:flutter_gallery/page/page_transformer.dart';

class GalleryPageView extends StatelessWidget {
  List<Picture> pictureList;
  void Function(int) pageCallback;

  PageController _controller = PageController(viewportFraction: 0.85);

  GalleryPageView(@required this.pictureList, @required this.pageCallback);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size.fromHeight(500.0),
      child: PageTransformer(
        pageViewBuilder: (context, visibilityResolver) {
          return PageView.builder(
            onPageChanged: (page) {
              pageCallback(page);
            },
            controller: _controller,
            itemCount: pictureList.length,
            itemBuilder: (context, index) {
              final item = pictureList[index];
              final pageVisibility =
                  visibilityResolver.resolvePageVisibility(index);

              return PageItemWidget(
                item: item,
                pageVisibility: pageVisibility,
              );
            },
          );
        },
      ),
    );
  }
}
