import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/constants.dart';
import '../models/book.dart';
import '../utils/format_rules.dart';
import '../widgets/logo.dart';

class ShareScreen extends StatefulWidget {
  final Book book;

  const ShareScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final GlobalKey genKey = GlobalKey();

  Future<void> takePicture() async {
    RenderRepaintBoundary boundary =
        genKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final directory = await getExternalStorageDirectory();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    File imgFile = new File('${directory!.path}/${widget.book.name}photo.png');
    print(directory);
    imgFile.writeAsBytes(pngBytes);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Save image successfully!!!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Text(
          widget.book.name,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline4?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsConstant.primaryColor,
              ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RepaintBoundary(
                key: genKey,
                child: Container(
                    width: double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 3)),
                        ],
                        color: Colors.red,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            widget.book.imageUrl,
                          ),
                          fit: BoxFit.cover,
                        )),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Logo(),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.book.imageUrl,
                                    // width: 150,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.book.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                    ),
                                    Text(
                                      widget.book.author,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                            (widget.book.avgRate >= 1)
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow),
                                        Icon(
                                            (widget.book.avgRate >= 2)
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow),
                                        Icon(
                                            (widget.book.avgRate >= 3)
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow),
                                        Icon(
                                            (widget.book.avgRate >= 4)
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow),
                                        Icon(
                                            (widget.book.avgRate == 5)
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow),
                                      ],
                                    ),
                                    Visibility(
                                      visible: widget.book.discountRatio != 0,
                                      child: Text(
                                        FormatRules.formatPrice(
                                            widget.book.price),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontWeight: FontWeight.w100,
                                              fontSize: 15,
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      FormatRules.formatPrice(widget
                                              .book.price *
                                          (100 - widget.book.discountRatio) ~/
                                          100),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            height: 80,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    ColorsConstant.primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
              ),
              onPressed: () async => takePicture(),
              child: Text(
                'Save Image',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
