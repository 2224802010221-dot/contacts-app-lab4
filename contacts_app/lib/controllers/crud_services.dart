// lib/controllers/crud_services.dart
// CRUD operations cho Contacts trong Firestore
// Mỗi user chỉ thấy được contacts của mình

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/contact_model.dart';

class CrudServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'contacts';

  // Reference đến collection contacts
  static CollectionReference get _contacts =>
      _firestore.collection(_collectionName);

  // Lấy userId hiện tại
  static String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  // ── CREATE - Thêm contact mới ──────────────────────────────────────────────
  static Future<String?> addContact({
    required String name,
    required String phone,
    required String email,
    required String address,
  }) async {
    try {
      final userId = _currentUserId;
      if (userId == null) return 'Bạn chưa đăng nhập.';

      final contact = Contact(
        name: name,
        phone: phone,
        email: email,
        address: address,
        userId: userId,
      );

      await _contacts.add(contact.toMap());
      return null; // null = thành công
    } catch (e) {
      return 'Lỗi thêm contact: $e';
    }
  }

  // ── READ - Lấy danh sách contacts của user hiện tại (real-time) ───────────
  static Stream<List<Contact>> getContacts() {
    final userId = _currentUserId;
    if (userId == null) return Stream.value([]);

    return _contacts
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Contact.fromDoc(doc)).toList());
  }

  // ── READ - Lấy 1 contact theo ID ──────────────────────────────────────────
  static Future<Contact?> getContactById(String id) async {
    try {
      final doc = await _contacts.doc(id).get();
      if (!doc.exists) return null;
      return Contact.fromDoc(doc);
    } catch (e) {
      return null;
    }
  }

  // ── UPDATE - Cập nhật contact ──────────────────────────────────────────────
  static Future<String?> updateContact({
    required String id,
    required String name,
    required String phone,
    required String email,
    required String address,
  }) async {
    try {
      await _contacts.doc(id).update({
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      return 'Lỗi cập nhật: $e';
    }
  }

  // ── DELETE - Xóa contact ──────────────────────────────────────────────────
  static Future<String?> deleteContact(String id) async {
    try {
      await _contacts.doc(id).delete();
      return null;
    } catch (e) {
      return 'Lỗi xóa: $e';
    }
  }
}
