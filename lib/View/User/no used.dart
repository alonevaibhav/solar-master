
import 'package:flutter/material.dart';

import '../../utils/shimmer.dart';

class ShimmerPatternsExample extends StatelessWidget {
  final double scaleFactor = 0.9; // Define the scale factor as a constant

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shimmer Patterns')),
      body: Transform.scale(
        scale: scaleFactor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BASIC TEXT SHIMMER
              Text('1. Basic Text Shimmer:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              UniversalShimmer(
                layout: ShimmerLayout.column(
                  children: [
                    ShimmerElementChild(ShimmerElement.text(widthSU: 200, heightSU: 16)),
                    ShimmerElementChild(ShimmerElement.text(widthSU: 150, heightSU: 16)),
                    ShimmerElementChild(ShimmerElement.text(widthSU: 180, heightSU: 16)),
                  ],
                ),
                showCard: false,
              ),

              SizedBox(height: 30),

              // 2. PROFILE CARD SHIMMER
              Text('2. Profile Card Shimmer:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              UniversalShimmer(
                layout: ShimmerLayout.row(
                  children: [
                    ShimmerElementChild(ShimmerElement.circle(sizeSU: 40)),
                    ShimmerLayoutChild(
                      ShimmerLayout.column(
                        children: [
                          ShimmerElementChild(ShimmerElement.text(widthSU: 100, heightSU: 18)),
                          ShimmerElementChild(ShimmerElement.text(widthSU: 190, heightSU: 14)),
                          ShimmerElementChild(ShimmerElement.text(widthSU: 70, heightSU: 14)),
                        ],
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),

              SizedBox(height: 30),

              // 3. PRODUCT CARD SHIMMER
              Text('3. Product Card Shimmer:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              UniversalShimmer(
                layout: ShimmerLayout.column(
                  children: [
                    ShimmerElementChild(
                        ShimmerElement.box(
                          widthSU: 300,
                          heightSU: 200,
                          borderRadiusSU: 12,
                        )
                    ),
                    ShimmerElementChild(ShimmerElement.text(widthSU: 250, heightSU: 20)),
                    ShimmerElementChild(ShimmerElement.text(widthSU: 300, heightSU: 16)),
                    ShimmerLayoutChild(
                      ShimmerLayout.row(
                        children: [
                          ShimmerElementChild(ShimmerElement.text(widthSU: 80, heightSU: 18)),
                          ShimmerElementChild(ShimmerElement.box(widthSU: 100, heightSU: 36, borderRadiusSU: 8)),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // 4. LIST ITEM SHIMMER
              Text('4. List Item Shimmer:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              UniversalShimmer(
                layout: ShimmerLayout.row(
                  children: [
                    ShimmerElementChild(ShimmerElement.circle(sizeSU: 40)),
                    ShimmerLayoutChild(
                      ShimmerLayout.column(
                        children: [
                          ShimmerElementChild(ShimmerElement.text(widthSU: 180, heightSU: 16)),
                          ShimmerElementChild(ShimmerElement.text(widthSU: 120, heightSU: 14)),
                        ],
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                count: 3,
              ),

              SizedBox(height: 30),

              // 5. CUSTOM BUTTON SHIMMER
              Text('5. Custom Button Shimmer:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              UniversalShimmer(
                layout: ShimmerLayout.row(
                  children: [
                    ShimmerElementChild(
                        ShimmerElement.box(
                          widthSU: 120,
                          heightSU: 40,
                          borderRadiusSU: 20,
                        )
                    ),
                    ShimmerSpacerChild(widthSU: 16),
                    ShimmerElementChild(
                        ShimmerElement.box(
                          widthSU: 100,
                          heightSU: 40,
                          borderRadiusSU: 8,
                        )
                    ),
                  ],
                ),
                showCard: false,
              ),

              SizedBox(height: 30),

              // 6. ARTICLE/NEWS SHIMMER
              Text('6. Article/News Shimmer:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              UniversalShimmer(
                layout: ShimmerLayout.row(
                  children: [
                    ShimmerElementChild(
                        ShimmerElement.box(
                          widthSU: 40,
                          heightSU: 80,
                          borderRadiusSU: 8,
                        )
                    ),
                    ShimmerLayoutChild(
                      ShimmerLayout.column(
                        children: [
                          ShimmerElementChild(ShimmerElement.text(widthSU: 170, heightSU: 18)),
                          ShimmerElementChild(ShimmerElement.text(widthSU: 150, heightSU: 14)),
                          ShimmerElementChild(ShimmerElement.text(widthSU: 180, heightSU: 14)),
                          ShimmerElementChild(ShimmerElement.text(widthSU: 100, heightSU: 12)),
                        ],
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),

              SizedBox(height: 30),

              // 7. USING PRE-BUILT PATTERNS
              Text('7. Using Pre-built Patterns:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),

              UniversalShimmer(
                layout: ScreenUtilShimmerPatterns.userProfile(),
              ),

              SizedBox(height: 16),

              UniversalShimmer(
                layout: ScreenUtilShimmerPatterns.productCard(),
              ),

              SizedBox(height: 16),

              UniversalShimmer(
                layout: ScreenUtilShimmerPatterns.article(),
                count: 2,
              ),

              SizedBox(height: 30),

              // 8. CUSTOM COLORS AND TIMING
              Text('8. Custom Colors & Animation:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              UniversalShimmer(
                layout: ShimmerLayout.column(
                  children: [
                    ShimmerElementChild(ShimmerElement.text(widthSU: 180, heightSU: 16)),
                    ShimmerElementChild(ShimmerElement.text(widthSU: 150, heightSU: 16)),
                  ],
                ),
                baseColor: Colors.red[200],
                highlightColor: Colors.red[50],
                period: Duration(milliseconds: 800),
                showCard: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper classes and methods remain the same as in your original code
class CustomShimmerPatterns {
  static ShimmerLayout chatMessage({bool isMe = false}) {
    final children = <ShimmerChild>[];

    if (!isMe) {
      children.add(ShimmerElementChild(ShimmerElement.circle(sizeSU: 32)));
    }

    children.add(
        ShimmerElementChild(
            ShimmerElement.box(
              widthSU: isMe ? 200 : 180,
              heightSU: 40,
              borderRadiusSU: 16,
            )
        )
    );

    return ShimmerLayout.row(
      children: children,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }

  static ShimmerLayout statsDashboard() {
    final children = <ShimmerChild>[];

    final statsRow = <ShimmerChild>[];
    for (int i = 0; i < 3; i++) {
      statsRow.add(
        ShimmerLayoutChild(
          ShimmerLayout.column(
            children: [
              ShimmerElementChild(ShimmerElement.text(widthSU: 60, heightSU: 24)),
              ShimmerElementChild(ShimmerElement.text(widthSU: 80, heightSU: 14)),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
      );
    }

    children.add(
      ShimmerLayoutChild(
        ShimmerLayout.row(
          children: statsRow,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    );

    children.add(
        ShimmerElementChild(
            ShimmerElement.box(
              widthSU: 350,
              heightSU: 200,
              borderRadiusSU: 12,
            )
        )
    );

    return ShimmerLayout.column(children: children);
  }
}


