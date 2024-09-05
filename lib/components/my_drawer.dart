import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';
import 'drawer_list_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;

    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const DrawerHeader(
                  child: Icon(Icons.calendar_month),
                ),
                const SizedBox(height: 20),
                DrawerListTile(
                  title: "Home",
                  icon: const Icon(Icons.home),
                  onTap: () => Navigator.pop(context),
                ),
                DrawerListTile(
                  title: "About",
                  icon: const Icon(Icons.person),
                  onTap: () {},
                ),
                DrawerListTile(
                  title: isDarkMode ? "Light mode" : "Night mode",
                  icon: isDarkMode
                      ? const Icon(Icons.light_mode)
                      : const Icon(Icons.dark_mode),
                  onTap: context.read<ThemeProvider>().changeTheme,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DrawerListTile(
                  title: "Log out",
                  icon: const Icon(Icons.logout),
                  onTap: () {}),
            )
          ],
        ));
  }
}
