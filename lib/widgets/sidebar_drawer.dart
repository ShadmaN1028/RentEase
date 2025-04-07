import 'package:flutter/material.dart';
import 'package:rentease/screens/login_pages/login_page.dart';
import 'package:rentease/screens/test_login/test_login_owner.dart';
import 'package:rentease/services/api_services.dart';
import 'package:rentease/utils/constants.dart';

class SidebarDrawer extends StatelessWidget {
  final bool isOwner; // Determines if the user is an owner or tenant

  const SidebarDrawer({super.key, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text(
              "User Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              "user@example.com",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  "assets/images/user1.jpg",
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              children:
                  isOwner
                      ? _ownerMenuItems(context)
                      : _tenantMenuItems(context),
            ),
          ),

          // Logout Button at Bottom
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            onTap: () => handleLogout(context),
          ),
        ],
      ),
    );
  }

  // Owner's Menu Items
  List<Widget> _ownerMenuItems(BuildContext context) {
    return [
      _drawerItem(
        context,
        Icons.payment,
        Text(
          "Payment Status",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: BackgroundColor.textbold,
          ),
        ),
        TestLoginScreenOwner(),
      ),
      _drawerItem(
        context,
        Icons.people,
        Text(
          "Tenant List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: BackgroundColor.textbold,
          ),
        ),
        TestLoginScreenOwner(),
      ),
      _drawerItem(
        context,
        Icons.assignment,
        Text(
          "Applications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: BackgroundColor.textbold,
          ),
        ),
        TestLoginScreenOwner(),
      ),
      _drawerItem(
        context,
        Icons.build,
        Text(
          "Service Requests",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: BackgroundColor.textbold,
          ),
        ),
        TestLoginScreenOwner(),
      ),
      _drawerItem(
        context,
        Icons.settings,
        Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: BackgroundColor.textbold,
          ),
        ),
        TestLoginScreenOwner(),
      ),
    ];
  }

  // Tenant's Menu Items
  List<Widget> _tenantMenuItems(BuildContext context) {
    return [
      _drawerItem(
        context,
        Icons.home,
        Text(
          "My Flat",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: BackgroundColor.textbold,
          ),
        ),
        TestLoginScreenOwner(),
      ),
      _drawerItem(
        context,
        Icons.account_circle,
        Text(
          "Owner Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: BackgroundColor.textbold,
          ),
        ),
        TestLoginScreenOwner(),
      ),
      _drawerItem(
        context,
        Icons.assignment,
        Text(
          "Applications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: BackgroundColor.textbold,
          ),
        ),
        TestLoginScreenOwner(),
      ),
      _drawerItem(
        context,
        Icons.build,
        Text(
          "Service Requests",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: BackgroundColor.textbold,
          ),
        ),
        TestLoginScreenOwner(),
      ),
      _drawerItem(
        context,
        Icons.settings,
        Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: BackgroundColor.textbold,
          ),
        ),
        TestLoginScreenOwner(),
      ),
    ];
  }

  // Helper function to create drawer items with navigation
  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    Widget title,
    Widget destination,
  ) {
    return ListTile(
      leading: Icon(icon, color: BackgroundColor.textbold),
      title: title,
      onTap: () {
        print("Navigating to: ${title.toString()}");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }

  void handleLogout(BuildContext context) async {
    try {
      final api = ApiService();
      final response = await api.postRequest('logout', {});

      if (response.statusCode == 200 && response.data['success'] == true) {
        print(response.data['message']); // "Logged out successfully"
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        print("Logout failed: ${response.data}");
      }
    } catch (e) {
      print("Logout error: $e");
    }
  }
}
