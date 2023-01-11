import 'package:cricketly/model/user/leaderboard_model.dart';
import 'package:flutter/material.dart';

class CountryLeaderBoaderScreen extends StatelessWidget {
  final List<Result>? result;
  const CountryLeaderBoaderScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.02, vertical: size.height * 0.015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rank',
                style: TextStyle(
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Player name',
                style: TextStyle(
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(),
                child: Text(
                  'Run',
                  style: TextStyle(
                    fontSize: size.height * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        ListView.builder(
          itemCount: result?.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02, vertical: size.height * 0.015),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${index + 1}",
                      style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      result?[index].username ?? '',
                      style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      result?[index].totalRun != null
                          ? (result?[index].totalRun.toString() ?? '0')
                          : '0',
                      style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
