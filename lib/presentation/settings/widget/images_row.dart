import 'package:flutter/material.dart';

class ImageRow extends StatelessWidget {
  final List<ImageProvider<Object>> images;
  final void Function(ImageProvider<Object>) onPreviewClick;
  final void Function() onAddClick;
  const ImageRow(
      {super.key,
      required this.images,
      required this.onPreviewClick,
      required this.onAddClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemBuilder: (context, index) {
          if (index < images.length) {
            return SizedBox(
                width: 140,
                child: Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(8),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: InkWell(
                          onTap: () => onPreviewClick(images[index]),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Image(
                            image: images[index],
                            height: 180,
                          )),
                    )));
          } else {
            return SizedBox(
              width: 140,
              child: Card(
                color: Theme.of(context).colorScheme.primary,
                margin: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: onAddClick,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            );
          }
        },
        itemCount: images.length + 1,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
      ),
    );
  }
}
