import 'package:flutter/material.dart';

class Paddings {
  static const EdgeInsetsGeometry left5 =
      EdgeInsets.only(left: Dimensions.padding5);
  static const EdgeInsetsGeometry left8 =
      EdgeInsets.only(left: Dimensions.padding8);
  static const EdgeInsetsGeometry left10 =
      EdgeInsets.only(left: Dimensions.padding10);
  static const EdgeInsetsGeometry left20 =
      EdgeInsets.only(left: Dimensions.padding20);
  static const EdgeInsetsGeometry left32 =
      EdgeInsets.only(left: Dimensions.padding32);
  static const EdgeInsetsGeometry left48 =
      EdgeInsets.only(left: Dimensions.padding48);

  static const EdgeInsetsGeometry right5 =
      EdgeInsets.only(right: Dimensions.padding5);
  static const EdgeInsetsGeometry right8 =
      EdgeInsets.only(right: Dimensions.padding8);
  static const EdgeInsetsGeometry right10 =
      EdgeInsets.only(right: Dimensions.padding10);
  static const EdgeInsetsGeometry right20 =
      EdgeInsets.only(right: Dimensions.padding20);
  static const EdgeInsetsGeometry right32 =
      EdgeInsets.only(right: Dimensions.padding32);
  static const EdgeInsetsGeometry right48 =
      EdgeInsets.only(right: Dimensions.padding48);

  static const EdgeInsetsGeometry top5 =
      EdgeInsets.only(top: Dimensions.padding5);
  static const EdgeInsetsGeometry top8 =
      EdgeInsets.only(top: Dimensions.padding8);
  static const EdgeInsetsGeometry top10 =
      EdgeInsets.only(top: Dimensions.padding10);
  static const EdgeInsetsGeometry top20 =
      EdgeInsets.only(top: Dimensions.padding20);
  static const EdgeInsetsGeometry top32 =
      EdgeInsets.only(top: Dimensions.padding32);
  static const EdgeInsetsGeometry top48 =
      EdgeInsets.only(top: Dimensions.padding48);

  static const EdgeInsetsGeometry bottom5 =
      EdgeInsets.only(bottom: Dimensions.padding5);
  static const EdgeInsetsGeometry bottom8 =
      EdgeInsets.only(bottom: Dimensions.padding8);
  static const EdgeInsetsGeometry bottom10 =
      EdgeInsets.only(bottom: Dimensions.padding10);
  static const EdgeInsetsGeometry bottom20 =
      EdgeInsets.only(bottom: Dimensions.padding20);
  static const EdgeInsetsGeometry bottom32 =
      EdgeInsets.only(bottom: Dimensions.padding32);
  static const EdgeInsetsGeometry bottom48 =
      EdgeInsets.only(bottom: Dimensions.padding48);

  static const EdgeInsetsGeometry horizontal5 =
      EdgeInsets.symmetric(horizontal: Dimensions.padding5);
  static const EdgeInsetsGeometry horizontal8 =
      EdgeInsets.symmetric(horizontal: Dimensions.padding8);
  static const EdgeInsetsGeometry horizontal10 =
      EdgeInsets.symmetric(horizontal: Dimensions.padding10);
  static const EdgeInsetsGeometry horizontal16 =
      EdgeInsets.symmetric(horizontal: Dimensions.padding16);
  static const EdgeInsetsGeometry horizontal20 =
      EdgeInsets.symmetric(horizontal: Dimensions.padding20);
  static const EdgeInsetsGeometry horizontal32 =
      EdgeInsets.symmetric(horizontal: Dimensions.padding32);
  static const EdgeInsetsGeometry horizontal48 =
      EdgeInsets.symmetric(horizontal: Dimensions.padding48);

  static const EdgeInsetsGeometry vertical5 =
      EdgeInsets.symmetric(vertical: Dimensions.padding5);
  static const EdgeInsetsGeometry vertical8 =
      EdgeInsets.symmetric(vertical: Dimensions.padding8);
  static const EdgeInsetsGeometry vertical10 =
      EdgeInsets.symmetric(vertical: Dimensions.padding10);
  static const EdgeInsetsGeometry vertical16 =
      EdgeInsets.symmetric(vertical: Dimensions.padding16);
  static const EdgeInsetsGeometry vertical20 =
      EdgeInsets.symmetric(vertical: Dimensions.padding20);
  static const EdgeInsetsGeometry vertical32 =
      EdgeInsets.symmetric(vertical: Dimensions.padding32);
  static const EdgeInsetsGeometry vertical48 =
      EdgeInsets.symmetric(vertical: Dimensions.padding48);

  static const EdgeInsetsGeometry all5 = EdgeInsets.all(Dimensions.padding5);
  static const EdgeInsetsGeometry all8 = EdgeInsets.all(Dimensions.padding8);
  static const EdgeInsetsGeometry all10 = EdgeInsets.all(Dimensions.padding10);
  static const EdgeInsetsGeometry all20 = EdgeInsets.all(Dimensions.padding20);
  static const EdgeInsetsGeometry all32 = EdgeInsets.all(Dimensions.padding32);
  static const EdgeInsetsGeometry all48 = EdgeInsets.all(Dimensions.padding48);
}

class BorderRadiuses {
  static BorderRadius radius6 =
      const BorderRadius.all(Radius.circular(RadiusSize.radius6));
  static BorderRadius radius12 =
      const BorderRadius.all(Radius.circular(RadiusSize.radius12));
  static BorderRadius radius20 =
      const BorderRadius.all(Radius.circular(RadiusSize.radius20));
  static BorderRadius radius50 =
      const BorderRadius.all(Radius.circular(RadiusSize.radius50));
  static BorderRadius radius64 =
      const BorderRadius.all(Radius.circular(RadiusSize.radius64));
}

class Dimensions {
  static const double padding2 = 2;
  static const double padding4 = 4;
  static const double padding5 = 5;
  static const double padding8 = 8;
  static const double padding10 = 10;
  static const double padding16 = 16;
  static const double padding20 = 20;
  static const double padding32 = 32;
  static const double padding48 = 48;
}

class RadiusSize {
  static const double radius6 = 6;
  static const double radius10 = 10;
  static const double radius12 = 12;
  static const double radius20 = 20;
  static const double radius50 = 50;
  static const double radius64 = 64;
}

class Constants {
  static const double appBarHeight = 75;
  static const double bottomTabBarHeight = 56;
  static const double navigationTabBarHeight = 45;
  static const double searchBarHeight = 42;

  static const pageSizeTransactions = 7;
}
