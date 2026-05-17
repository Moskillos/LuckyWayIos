import 'dart:ui';

class PreferencesItem{
  String title;
  String icon;
  VoidCallback action;

  PreferencesItem(this.title, this.icon, this.action);
}