import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final String url;
  ImageViewer({this.url});
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PhotoView(
      imageProvider:
          NetworkImage(widget.url == null ? Container() : widget.url),
    ));
  }
}
