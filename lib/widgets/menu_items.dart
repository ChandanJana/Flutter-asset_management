import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/app_theme_provider.dart';

class MenuItems extends ConsumerWidget {
  const MenuItems(
      {super.key,
      required this.textSize,
      required this.iconSize,
      required this.menuName,
      required this.menuImg,
      required this.onMenuItemClick});

  final String menuName;
  final IconData menuImg;
  final double textSize;
  final double iconSize;
  final void Function(String menuName) onMenuItemClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    return ListTile(
      key: Key(menuName),
      leading: Icon(
        menuImg,
        size: iconSize,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      title: Text(
        menuName,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: textSize,
            ),
      ),
      onTap: () {
        onMenuItemClick(menuName);
      },
    );
  }
}
