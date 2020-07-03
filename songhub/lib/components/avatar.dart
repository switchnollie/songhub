import 'package:flutter/material.dart';

class AvatarRow extends StatelessWidget {
  final List<String> imgs;

  AvatarRow({this.imgs});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: -10,
      children: imgs
          .map((img) => CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Avatar(img: img),
              ))
          .toList(),
    );
  }
}

class Avatar extends StatelessWidget {
  final String img;

  Avatar({this.img});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      // backgroundImage: AssetImage(img),
      child: ClipOval(
        child: Image.network(img),
      ),
      radius: 12.5,
    );
  }
}
