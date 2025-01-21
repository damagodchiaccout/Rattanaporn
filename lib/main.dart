import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'addproduct.dart';
import 'showproductgrid.dart';
import 'package:onlineapp_book/showproducttype.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyANTHWa7jGNV7YiaiSHXYbkKejiNw0Zz10",
        authDomain: "onlinefirebase-4e33d.firebaseapp.com",
        databaseURL: "https://onlinefirebase-4e33d-default-rtdb.firebaseio.com",
        projectId: "onlinefirebase-4e33d",
        storageBucket: "onlinefirebase-4e33d.firebasestorage.app",
        messagingSenderId: "824460666044",
        appId: "1:824460666044:web:f3c52eee49542c56e99cb9",
        measurementId: "G-H1KEKHJH2R",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 5, 61, 0),
        ),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการบันทึกข้อมูลสินค้า'),
      ),
      body: Stack(
        children: [
          //ภาพพื้นหลังที่ครอบคลุมทั้งหน้าจอ
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.png'), // Background image
                  fit: BoxFit.cover, //ทำให้ภาพครอบคลุมทั้งหน้าจอ
                ),
              ),
            ),
          ),
          //วางเนื้อหาหรือองค์ประกอบต่างๆ (เช่น ข้อความ รูปภาพ หรือปุ่ม)
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // จัดวางเนื้อหาทั้งหมด (เช่น ข้อความ รูปภาพ หรือปุ่ม) ให้อยู่ตรงกลางของพื้นที่
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //ใส่โลโก้
                  Image.asset(
                    'assets/logo.png', //ใส่โลโก้
                    width: 150, //ปรับขนาดตามความต้องการ
                    height: 150,
                  ),
                  SizedBox(height: 16), // ระยะห่างระหว่างโลโก้และข้อความ
                  Text(
                    'นางสาวรัตนาพร โตมา รหัส 116510505156-9', // Welcome message
                    style: TextStyle(
                      fontSize: 18, // Adjust font size
                      fontWeight: FontWeight.bold, // Bold text
                      color: Color.fromARGB(255, 0, 0, 0), // Text color
                    ),
                    textAlign: TextAlign.center, // จัดข้อความตรงกลาง
                  ),
                  SizedBox(height: 30), // ระยะห่างระหว่างข้อความและปุ่ม

                  // Buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => addproduct()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(250, 50), // ตั้งขนาดปุ่มให้คงที่
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'บันทึกข้อมูลสินค้า',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16), // ว้นระยะระหว่างปุ่ม

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => showproductgrid()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(250, 50), // กำหนดขนาดปุ่มให้คงที่
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'แสดงข้อมูลสินค้า',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16), //  เว้นระยะระหว่างปุ่ม

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => showproducttype()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(250, 50), // กำหนดขนาดคงที่สำหรับปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'ประเภทสินค้า',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
