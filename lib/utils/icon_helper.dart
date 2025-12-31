import 'package:flutter/material.dart';

class IconHelper {
  static IconData getIconData(String iconName) {
    switch (iconName) {
      case 'science':
        return Icons.science;
      case 'biotech':
        return Icons.biotech;
      case 'calculate':
        return Icons.calculate;
      case 'eco':
        return Icons.eco;
      case 'menu_book':
        return Icons.menu_book;
      case 'translate':
        return Icons.translate;
      case 'computer':
        return Icons.computer;
      case 'sports':
        return Icons.sports;
      case 'trending_up':
        return Icons.trending_up;
      case 'business':
        return Icons.business;
      case 'account_balance':
        return Icons.account_balance;
      case 'history_edu':
        return Icons.history_edu;
      case 'public':
        return Icons.public;
      case 'gavel':
        return Icons.gavel;
      default:
        return Icons.book;
    }
  }
}

