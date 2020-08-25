import 'package:flutter/material.dart';

class ExploreContentWidget extends StatelessWidget {
  final double currentExplorePercent;
  final placeName = const [
    "Authentic\nrestaurant",
    "Famous\nmonuments",
    "Weekend\ngetaways"
  ];
  const ExploreContentWidget({Key key, this.currentExplorePercent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentExplorePercent != 0) {
      return Positioned(
        top: 170,
        width: 300,
        child: Container(
          height: 700,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Opacity(
                opacity: currentExplorePercent,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Transform.translate(
                        offset: Offset(300 / 3 * (1 - currentExplorePercent),
                            700 / 3 / 2 * (1 - currentExplorePercent)),
                        child: Image.asset(
                          "icon_1.png",
                          width: 133,
                          height: 133,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "icon_2.png",
                        width: 133,
                        height: 133,
                      ),
                    ),
                    Expanded(
                      child: Transform.translate(
                        offset: Offset(300 / 3 * (1 - currentExplorePercent),
                            300 / 3 / 2 * (1 - currentExplorePercent)),
                        child: Image.asset(
                          "icon_3.png",
                          width: 133,
                          height: 133,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Transform.translate(
                  offset: Offset(0, 200),
                  child: Opacity(
                      opacity: currentExplorePercent,
                      child: Container(
                        width: 300,
                        height: 500,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 22),
                            ),
                            buildListItem(0, "Authentic\nrestaurant"),
                            buildListItem(1, "Famous\nmonuments"),
                            buildListItem(2, "Weekend\ngetaways"),
                            buildListItem(3, "Authentic\nrestaurant"),
                            buildListItem(4, "Famous\nmonuments"),
                            buildListItem(5, "Weekend\ngetaways"),
                          ],
                        ),
                      ))),
              Transform.translate(
                  offset: Offset(0, 50),
                  child: Opacity(
                    opacity: currentExplorePercent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 22),
                            child: Text("EVENTS",
                                style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Stack(
                            children: <Widget>[
                              Image.asset(
                                "dj.png",
                              ),
                              Positioned(
                                  bottom: 26,
                                  left: 24,
                                  child: Text(
                                    "Marshmello Live in Concert",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ))
                            ],
                          ),
                          Transform.translate(
                            offset: Offset(0,
                                30 - 30 * (currentExplorePercent - 0.75) * 4),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Image.asset("banner_4.png"),
                                ),
                                Expanded(
                                  child: Image.asset("banner_5.png"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: 262),
              )
            ],
          ),
        ),
      );
    } else {
      return const Padding(
        padding: const EdgeInsets.all(0),
      );
    }
  }

  buildListItem(int index, String name) {
    return Transform.translate(
      offset: Offset(0, index * 127 * (1 - currentExplorePercent)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            "banner_${index % 3 + 1}.png",
            width: 127,
            height: 127,
          ),
          Text(
            placeName[index % 3],
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
