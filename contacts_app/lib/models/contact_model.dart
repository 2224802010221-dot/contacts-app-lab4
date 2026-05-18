// lib/models/contact_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String? id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String userId; // ID của user sở hữu contact này

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.userId,
  });

  // Chuyển sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Tạo Contact từ DocumentSnapshot
  factory Contact.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Contact(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      userId: data['userId'] ?? '',
    );
  }
}
