import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onlineapp_book/productdetail.dart';

class showfiltertype extends StatefulWidget {
  final String category;

  const showfiltertype({Key? key, required this.category}) : super(key: key);

  @override
  State<showfiltertype> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showfiltertype> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      final query = dbRef.orderByChild('category').equalTo(widget.category);
      final snapshot = await query.get();

      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] = child.key;
          loadedProducts.add(product);
        });

        setState(() {
          products = loadedProducts;
        });
      } else {
        print("ไม่พบรายการสินค้าในหมวด ${widget.category}");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  Future<void> showEditProductDialog(Map<String, dynamic> product) async {
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('แก้ไขสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'รายละเอียดสินค้า'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'ราคา'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                await dbRef.child(product['key']).update({
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price':
                      double.tryParse(priceController.text) ?? product['price'],
                });
                Navigator.pop(context);
                fetchProducts(); // รีโหลดสินค้าใหม่หลังจากอัปเดต
              },
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteConfirmationDialog(String key) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: const Text('คุณต้องการลบสินค้านี้หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                await dbRef.child(key).remove();
                Navigator.pop(context);
                fetchProducts(); // รีโหลดสินค้าใหม่หลังจากลบ
              },
              child: const Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สินค้าในหมวด ${widget.category}'),
        backgroundColor: Color.fromARGB(255, 0, 126, 65),
        foregroundColor: Colors.white,
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] ?? 'ไม่มีชื่อสินค้า',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'รายละเอียด: ${product['description'] ?? 'ไม่มีรายละเอียด'}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ราคา: ${product['price']} บาท',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'วันที่ผลิต: ${formatDate(product['productionDate'] ?? '')}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: const Color.fromARGB(255, 0, 0, 0),
                              iconSize: 24,
                              tooltip: 'แก้ไขสินค้า',
                              onPressed: () {
                                showEditProductDialog(product);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: const Color.fromARGB(255, 211, 0, 0),
                              iconSize: 24,
                              tooltip: 'ลบสินค้า',
                              onPressed: () {
                                showDeleteConfirmationDialog(product['key']);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
