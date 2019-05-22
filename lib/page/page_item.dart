import 'package:flutter/material.dart';
import 'package:flutter_gallery/model/picture.dart';
import 'package:flutter_gallery/page/page_transformer.dart';
import 'package:meta/meta.dart';

class PageItemWidget extends StatelessWidget {
  PageItemWidget({
    @required this.item,
    @required this.pageVisibility,
  });

  final Picture item;
  final PageVisibility pageVisibility;

  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    final double xTranslation = pageVisibility.pagePosition * translationFactor;

    return Opacity(
      opacity: pageVisibility.visibleFraction,
      child: Transform(
        alignment: FractionalOffset.topLeft,
        transform: Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var categoryText = _applyTextEffects(
      translationFactor: 300.0,
      child: Text(
        item.author,
        style: textTheme.caption.copyWith(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          fontSize: 14.0,
        ),
        textAlign: TextAlign.center,
      ),
    );

    var titleText = _applyTextEffects(
      translationFactor: 200.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          item.author,
          style: textTheme.title
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Positioned(
      bottom: 56.0,
      left: 32.0,
      right: 32.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          categoryText,
          titleText,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var image = Image.network(
      "https://picsum.photos/id/${item.id}/400/600",
      fit: BoxFit.cover,
      alignment: FractionalOffset(
        0.5 + (pageVisibility.pagePosition / 3),
        0.5,
      ),
    );

    return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 8.0,
        ),
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8.0),
          child: new Column(
            children: <Widget>[
              new Expanded(
                  child: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  image,
                ],
              )),
//              RaisedButton(
//                  child: Text("下载"),
//                  onPressed: _onImageSaveButtonPressed(item.download_url)),
              new Container(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: _applyTextEffects(
                  translationFactor: 300.0,
                  child: Text(
                    "@${item.author}",
                    style: Theme.of(context).textTheme.caption.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontSize: 14.0,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
