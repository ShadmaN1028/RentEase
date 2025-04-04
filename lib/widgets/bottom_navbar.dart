import 'package:flutter/material.dart';
import 'package:rentease/data/notifiers.dart';
import 'package:rentease/utils/constants.dart';

class BottomNavbar extends StatelessWidget {
  final bool isOwner;
  const BottomNavbar({super.key, required this.isOwner});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            //looking goof without shadow
            // boxShadow: [
            //   BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
            // ],
          ),
          child: NavigationBar(
            // backgroundColor: Color(0xfff6f8fc),
            backgroundColor: BackgroundColor.bgcolor,
            height: 70,
            indicatorColor: Colors.teal.shade100,
            surfaceTintColor: Colors.transparent,
            destinations: [
              _buildNavItem(Icons.home, "Home", 0, selectedPage),
              _buildNavItem(Icons.search, "Search", 1, selectedPage),
              _buildNavItem(
                Icons.notifications,
                "Notifications",
                2,
                selectedPage,
              ),
            ],
            onDestinationSelected: (int value) {
              selectedPageNotifier.value = value;
            },
            selectedIndex: selectedPage,
          ),
        );
      },
    );
  }

  NavigationDestination _buildNavItem(
    IconData icon,
    String label,
    int index,
    int selectedPage,
  ) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: selectedPage == index ? Colors.teal : Colors.grey,
      ),
      selectedIcon: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.teal),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold, // Already bold
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      label: '',
    );
  }
}
