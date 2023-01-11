import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/model/user/get_user_info_model.dart';
import 'package:cricketly/widgtes/image_view.dart';
import 'package:cricketly/widgtes/user_card.dart';
import 'package:flutter/material.dart';

class CustomDialogBox extends StatefulWidget {
  final UserData userInfo;

  const CustomDialogBox({required this.userInfo});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, size),
    );
  }

  contentBox(context, Size size) {
    var strikeRate = widget.userInfo.totalBall == 0
        ? 0
        : (widget.userInfo.totalRun ?? 0) / (widget.userInfo.totalBall ?? 0);
    var avrage =
        (widget.userInfo.totalRun ?? 0) / (widget.userInfo.totalRun ?? 0);
    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          padding: const EdgeInsets.only(
            left: 5,
            top: Constants.avatarRadius + Constants.padding,
            right: 5,
            bottom: Constants.padding,
          ),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                capitalizeAllWord(
                  "${widget.userInfo.username ?? ''}  ${widget.userInfo.jerseyNo}",
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.height * 0.03,
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPlayerInfo(
                    title: 'TOTAL INNINGS',
                    value: widget.userInfo.totalInnings.toString(),
                  ),
                  _buildDivider(size),
                  _buildPlayerInfo(
                    title: 'TOTAL RUN',
                    value: widget.userInfo.totalRun.toString(),
                  ),
                  _buildDivider(size),
                  _buildPlayerInfo(
                    title: 'STRIKE RATE',
                    value: strikeRate.toString(),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPlayerInfo(
                    title: 'TOTAL 50/100',
                    value:
                        "${widget.userInfo.total50}/${widget.userInfo.total100}",
                  ),
                  _buildDivider(size),
                  _buildPlayerInfo(
                    title: 'AVERAGE',
                    value: avrage.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.14,
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: Constants.avatarRadius,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Constants.avatarRadius)),
                  child: CachedNetworkImageView(
                    imageUrl: widget.userInfo.profileImage ?? '',
                    username: widget.userInfo.username ?? '',
                    imageSize: size.height * 0.2,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.05),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(Size size) {
    return Container(
      color: ConstColors.black,
      width: 2,
      height: size.height * 0.05,
    );
  }

  Widget _buildPlayerInfo({
    required String value,
    required String title,
  }) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: ConstColors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: ConstColors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
