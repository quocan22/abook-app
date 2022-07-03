import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../models/book.dart';
import '../screens/book_detail_screen.dart';
import '../utils/format_rules.dart';

class FavBookItem extends StatefulWidget {
  final Book book;

  const FavBookItem({Key? key, required this.book}) : super(key: key);

  @override
  State<FavBookItem> createState() => _FavBookItemState();
}

class _FavBookItemState extends State<FavBookItem> {
  PaletteGenerator? _paletteGenerator;
  PaletteColor _color = PaletteColor(Colors.grey.withOpacity(0.5), 2);

  @override
  void initState() {
    super.initState();
    _updateBackgroundColor();
  }

  _updateBackgroundColor() async {
    _paletteGenerator = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(
        widget.book.imageUrl,
      ),
      maximumColorCount: 20,
    );
    if (_paletteGenerator != null &&
        _paletteGenerator!.lightMutedColor != null) {
      if (this.mounted) {
        setState(() {
          _color = _paletteGenerator!.lightMutedColor!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: _color.color,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BookDetailScreen(book: widget.book)));
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.book.imageUrl,
                      width: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                        color: Colors.yellow)
                  ],
                ),
                Text(
                  widget.book.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  FormatRules.formatPrice(widget.book.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
