import 'package:flutter/material.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget actionWidget;
  final bool leading;
  final double height;
  const ReusableAppBar(
      {super.key,
      this.actionWidget = const SizedBox(),
      this.leading = false,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height,
      automaticallyImplyLeading: leading,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        'MyNews',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).colorScheme.surface,
            ),
      ),
      actions: [actionWidget],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
