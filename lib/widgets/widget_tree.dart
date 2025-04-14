import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentease/data/notifiers.dart';
import 'package:rentease/providers/auth_provider.dart';
import 'package:rentease/screens/owner/owner_notf.dart';
import 'package:rentease/screens/owner/owner_search.dart';
import 'package:rentease/screens/welcome_screen/homepage.dart';
import 'package:rentease/screens/tenant/tenant_notf.dart';
import 'package:rentease/screens/tenant/tenant_search.dart';
import 'package:rentease/utils/constants.dart';
// import 'package:lottie/lottie.dart';
import 'package:rentease/widgets/bottom_navbar.dart';
import 'package:rentease/widgets/sidebar_drawer.dart';

// List<Widget> pages = [OwnerHomepage(), OwnerSearch(), OwnerNotf()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Determine the correct page list based on login type
    final List<Widget> pages =
        authProvider.isLoginOwner
            ? [Homepage(), OwnerSearch(), OwnerNotificationPage()]
            : [Homepage(), TenantSearch(), TenantNotificationPage()];
    return Scaffold(
      drawer: SidebarDrawer(isOwner: authProvider.isLoginOwner),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'RentEase',
          style: TextStyle(color: BackgroundColor.button2),
        ),
        iconTheme: IconThemeData(color: BackgroundColor.button2),
        backgroundColor: BackgroundColor.bgcolor,
      ),
      backgroundColor: BackgroundColor.bgcolor,
      bottomNavigationBar: BottomNavbar(isOwner: authProvider.isLoginOwner),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
    );
  }
}
