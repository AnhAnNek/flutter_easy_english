import 'package:flutter/material.dart';
import 'package:flutter_easy_english/screens/course_tab_screen.dart';
import 'package:flutter_easy_english/screens/login_screen.dart';
import 'package:flutter_easy_english/screens/message_tab_screen.dart';
import 'package:flutter_easy_english/screens/order_tab_screen.dart';
import 'package:flutter_easy_english/screens/user_tab_screen.dart';
import 'package:flutter_easy_english/services/i_auth_service.dart';
import 'package:flutter_easy_english/utils/auth_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class IndexScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0); // Quản lý tab hiện tại

    // Danh sách các màn hình (Tab)
    final screens = [
      CourseTabScreen(),
      OrderTabScreen(),
      UserTabScreen(),
      MessageTabScreen(),
      AccountTab(),
    ];

    // Tiêu đề của từng tab
    final titles = [
      'Course',
      'Order',
      'User',
      'Message',
      'Account',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex.value]),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: currentIndex.value,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: (index) => currentIndex.value = index, // Cập nhật tab khi click
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Course'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Account'),
        ],
      ),
    );
  }
}

// Tab Account
class AccountTab extends StatelessWidget {
  final List<String> accountItems = [
    'Logout',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: accountItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(
            index == 0
                ? Icons.person
                : index == 1
                ? Icons.lock
                : Icons.exit_to_app,
            color: Colors.blue,
          ),
          title: Text(accountItems[index]),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            if (index == 2) {
              _showLogoutDialog(context);
            } else {
              EasyLoading.showToast('Clicked on ${accountItems[index]}');
            }
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final IAuthService authService =
              Provider.of<IAuthService>(context, listen: false);

              authService.logout();
              await AuthUtils.removeLoginResponse();
              EasyLoading.showSuccess('Logged out successfully!');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}