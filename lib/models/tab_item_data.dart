import 'package:flutter/material.dart';

class TabItemData {
  TabItemData({
    this.index = 0,
    this.iconData = Icons.info,
    this.isSelected = false,
    this.animationController,
  });

  int index;
  IconData iconData;
  String toolTip;
  bool isSelected;
  AnimationController animationController;

  static List<TabItemData> tabIconsList = <TabItemData>[
    TabItemData(
      index: 0,
      iconData: Icons.download_rounded,
      isSelected: true,
      animationController: null,
    ),
    TabItemData(
      index: 1,
      iconData: Icons.info_rounded,
      isSelected: false,
      animationController: null,
    ),
  ];
}
