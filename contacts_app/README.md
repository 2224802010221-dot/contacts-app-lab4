# 📇 Lab 4 - Contacts App with Firebase

Ứng dụng quản lý contacts với Firebase Auth (Email/Password + Google) và Firestore CRUD.

## 📁 Cấu trúc Project

```
contacts_app/
├── lib/
│   ├── main.dart                          # Entry point + Auth state listener
│   ├── firebase_options.dart              # Firebase config (auto-generate)
│   ├── controllers/
│   │   ├── auth_services.dart             # Email/Password + Google Sign-in
│   │   └── crud_services.dart             # CRUD contacts với Firestore
│   ├── models/
│   │   └── contact_model.dart
│   └── views/
│       ├── login_page.dart
│       ├── sign_up_page.dart
│       ├── home.dart                      # List contacts real-time
│       ├── add_contact_page.dart
│       └── update_contact.dart
└── pubspec.yaml
```

## 🎯 Tính năng

- ✅ **Đăng ký / Đăng nhập** Email/Password
- ✅ **Đăng nhập với Google**
- ✅ **Forgot Password** (gửi email reset)
- ✅ **CRUD Contacts** (Add, Update, Delete, View)
- ✅ **Real-time sync** với Firestore (StreamBuilder)
- ✅ **Auto-login** khi mở lại app
- ✅ Mỗi user chỉ thấy contacts của mình
- ✅ Logout

---

## 🚀 Cài đặt và chạy

### BƯỚC 1: Tạo Firebase Project

1. Vào https://console.firebase.google.com
2. **Create project** → tên: `ContactsApp` (hoặc tên bất kỳ)
3. Tắt Google Analytics → **Create project**

### BƯỚC 2: Bật Authentication

1. **Authentication** → **Get started**
2. **Sign-in method** → bật **Email/Password** → Save
3. Bật thêm **Google** → cấu hình email support → Save

### BƯỚC 3: Tạo Firestore Database

1. **Firestore Database** → **Create database**
2. Chọn **Start in test mode** → Next
3. Region **asia-southeast1** → **Enable**

### BƯỚC 4: Setup Flutter project

```bash
# Clone hoặc giải nén project
cd contacts_app

# Tạo native folders (Android, iOS)
flutter create . --org com.example

# Cài dependencies
flutter pub get
```

### BƯỚC 5: Kết nối Firebase với Flutter

```bash
# Cài FlutterFire CLI (chỉ chạy lần đầu)
dart pub global activate flutterfire_cli

# Đăng nhập Firebase
firebase login

# Configure - tự động tạo lib/firebase_options.dart
flutterfire configure
```

Khi `flutterfire configure` chạy:
- Chọn project Firebase bạn vừa tạo
- Chọn platforms: **android** (bấm Space) → Enter

### BƯỚC 6: Cấu hình SHA-1 cho Google Sign-in

```bash
cd android
./gradlew signingReport   # Linux/Mac
# hoặc Windows:
gradlew signingReport
```

Copy giá trị **SHA1** và **SHA-256** của **debugAndroidTest** variant.

Vào **Firebase Console** → **Project Settings** → **Your apps** → Android app → **Add fingerprint** → dán SHA1 + SHA-256 → Save.

Tải lại `google-services.json` mới và thay vào `android/app/`.

### BƯỚC 7: Chạy app

```bash
flutter run
```

---

## 📤 Upload lên GitHub

### Cách 1: Tạo repo và push (nhanh nhất)

```bash
# Trong thư mục contacts_app
git init
git add .
git commit -m "feat: Lab 4 - Contacts App with Firebase"
git branch -M main

# Thay TÊN_BẠN bằng username GitHub
git remote add origin https://github.com/TÊN_BẠN/contacts-app-lab4.git
git push -u origin main
```

### Cách 2: Tạo repo trên GitHub trước

1. Vào **github.com** → Click **New repository**
2. Tên: `contacts-app-lab4`
3. Chọn **Public** (để giảng viên xem)
4. **KHÔNG tick** "Add README" (đã có sẵn rồi)
5. Click **Create repository**
6. Chạy các lệnh GitHub gợi ý hoặc copy 5 lệnh ở trên

### ⚠️ Lưu ý quan trọng trước khi push:

File `.gitignore` đã **ignore** sẵn:
- `google-services.json` (chứa Firebase secrets)
- `firebase_options.dart` config thật
- Build files, IDE files

Nhưng nếu nộp bài, **giảng viên có thể cần xem** file này. Nếu muốn push lên (project học tập):

```bash
# Xóa dòng google-services.json trong .gitignore (nếu cần push)
# Hoặc force-add:
git add -f android/app/google-services.json
git add -f lib/firebase_options.dart
git commit -m "include firebase configs for demo"
git push
```

> ⚠️ Đây là project học tập nên ok, nhưng project thật **đừng bao giờ commit secrets**.

---

## 🧪 Test app

1. Mở app → đăng ký tài khoản mới
2. Hoặc đăng nhập với Google
3. Bấm **+** ở góc dưới → thêm contact (tên, SĐT, email, địa chỉ)
4. List sẽ tự động cập nhật (Firestore real-time)
5. Click vào contact → xem chi tiết
6. Bấm ✏️ → sửa contact
7. Bấm 🗑️ → xóa contact

---

## 🛠️ Tech Stack

- **Flutter 3.x**
- **firebase_core** - Khởi tạo Firebase
- **firebase_auth** - Email/Password + Google Auth
- **cloud_firestore** - Realtime database
- **google_sign_in** - OAuth với Google

---

## 📺 Tham khảo

- Firebase Setup: https://firebase.google.com/docs/flutter/setup
- Firestore: https://pub.dev/packages/cloud_firestore
- Google Sign-In: https://pub.dev/packages/google_sign_in
- Firebase Auth: https://pub.dev/packages/firebase_auth
