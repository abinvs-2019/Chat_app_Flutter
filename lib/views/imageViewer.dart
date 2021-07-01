import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final String url;
  ImageViewer({this.url});
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  String url;

  @override
  void initState() {
    url = widget.url;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
            image: NetworkImage('$url'),
          ) ??
          Text("Coudn't Load image."),
    );
  }
}
