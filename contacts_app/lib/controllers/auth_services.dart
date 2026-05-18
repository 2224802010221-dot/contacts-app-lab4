// lib/controllers/auth_services.dart
// Xử lý đăng nhập, đăng ký, đăng xuất với Firebase Auth
// Hỗ trợ Email/Password và Google Sign-in

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ── User hiện tại ──────────────────────────────────────────────────────────
  static User? get currentUser => _auth.currentUser;

  // Stream theo dõi trạng thái đăng nhập
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── ĐĂNG KÝ - Email/Password ───────────────────────────────────────────────
  static Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null; // null = thành công
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e) {
      return 'Có lỗi xảy ra. Vui lòng thử lại.';
    }
  }

  // ── ĐĂNG NHẬP - Email/Password ─────────────────────────────────────────────
  static Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e) {
      return 'Có lỗi xảy ra. Vui lòng thử lại.';
    }
  }

  // ── ĐĂNG NHẬP với GOOGLE ──────────────────────────────────────────────────
  static Future<String?> signInWithGoogle() async {
    try {
      // Bước 1: Bật popup chọn Google account
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return 'Bạn đã hủy đăng nhập.';

      // Bước 2: Lấy auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Bước 3: Tạo credential để đăng nhập vào Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Bước 4: Sign in với Firebase
      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e) {
      return 'Đăng nhập Google thất bại: $e';
    }
  }

  // ── ĐĂNG XUẤT ─────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    await _googleSignIn.signOut(); // Đảm bảo logout cả Google
    await _auth.signOut();
  }

  // ── FORGOT PASSWORD ───────────────────────────────────────────────────────
  static Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    }
  }

  // ── Helper: chuyển mã lỗi Firebase thành text tiếng Việt ──────────────────
  static String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Sai email hoặc mật khẩu.';
      case 'email-already-in-use':
        return 'Email này đã được sử dụng.';
      case 'weak-password':
        return 'Mật khẩu quá yếu (ít nhất 6 ký tự).';
      case 'invalid-email':
        return 'Email không hợp lệ.';
      case 'too-many-requests':
        return 'Quá nhiều lần thử. Vui lòng thử lại sau.';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng.';
      default:
        return 'Đã xảy ra lỗi: $code';
    }
  }
}
