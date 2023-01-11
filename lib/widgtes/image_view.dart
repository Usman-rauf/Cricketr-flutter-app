import 'package:cached_network_image/cached_network_image.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:flutter/material.dart';

class NetworkImageView extends StatelessWidget {
  final double imageSize;
  final String imageUrl;
  final String username;
  const NetworkImageView(
      {super.key,
      required this.imageSize,
      required this.imageUrl,
      required this.username});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: imageSize,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ConstColors.appGreen8FColor,
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Text(
            username[0].toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.07,
            ),
          ),
        ),
      ),
    );
  }
}

class NetworkImageView2 extends StatelessWidget {
  final double imageSize;
  final String imageUrl;
  final String username;
  final double fontsize;
  const NetworkImageView2({
    super.key,
    required this.imageSize,
    required this.imageUrl,
    required this.username,
    required this.fontsize,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: imageSize,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ConstColors.appGreen8FColor,
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Text(
            username[0].toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
            ),
          ),
        ),
      ),
    );
  }
}

class CachedNetworkImageView extends StatelessWidget {
  final String imageUrl;
  final double? imageSize;
  final String? username;
  final double? textSize;
  const CachedNetworkImageView({
    super.key,
    required this.imageUrl,
    this.imageSize,
    required this.username,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: imageSize ?? size.width * 0.15,
        height: imageSize ?? size.height * 0.15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        alignment: Alignment.center,
        width: imageSize ?? size.height * 0.15,
        height: imageSize ?? size.width * 0.15,
        decoration: const BoxDecoration(
          color: ConstColors.appGreen8FColor,
          shape: BoxShape.circle,
        ),
        child: Text(
          username == null || username == ""
              ? ""
              : username?[0].toString() ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: textSize ?? size.height * 0.03,
            color: ConstColors.white,
          ),
        ),
      ),
    );
  }
}
