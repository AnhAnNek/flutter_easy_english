import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giới thiệu thành viên'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MemberCard(
              name: 'Đặng Xuân Hùng',
              role: '21110194',
              avatarUrl: 'https://res.cloudinary.com/dq7y35u7s/image/upload/v1730987018/tjgmqlkdkwurxtlj2ugr.png',
              icon: FontAwesomeIcons.user,
            ),
            SizedBox(height: 16),
            MemberCard(
              name: 'Trần Văn An',
              role: '21110120',
              avatarUrl: 'https://res.cloudinary.com/dq7y35u7s/image/upload/v1730987092/hucniq50gdwouvlbpnv0.jpg',
              icon: FontAwesomeIcons.userTie,
            ),
          ],
        ),
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String avatarUrl;
  final IconData icon;

  MemberCard({
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            Spacer(),
            FaIcon(
              icon,
              size: 30,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}