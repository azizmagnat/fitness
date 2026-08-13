import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../state/user_profile.dart';
import '../widgets/feedback.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  String? _photoPath;
  bool _picking = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: UserProfile.name.value);
    _bioController = TextEditingController(text: UserProfile.bio.value);
    _photoPath = UserProfile.photoPath.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop(); // close the picker sheet
    setState(() => _picking = true);
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: source, maxWidth: 800, imageQuality: 85);
      if (file != null && mounted) {
        setState(() => _photoPath = file.path);
      }
    } catch (_) {
      if (mounted) showComingSoon(context, "Kamera yoki galereya");
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  void _openPhotoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded, color: AppColors.primary),
              title: const Text("Kamera bilan suratga olish"),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
              title: const Text("Galereyadan tanlash"),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            if (_photoPath != null)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                title: const Text("Rasmni o'chirish", style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() => _photoPath = null);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    await UserProfile.setName(_nameController.text);
    await UserProfile.setBio(_bioController.text);
    await UserProfile.setPhotoPath(_photoPath);
    if (!mounted) return;
    showConfirmed(context, "Profil yangilandi");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilni tahrirlash"),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text("Saqlash", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: GestureDetector(
              onTap: _picking ? null : _openPhotoSheet,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      image: _photoPath != null
                          ? DecorationImage(image: FileImage(File(_photoPath!)), fit: BoxFit.cover)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: _picking
                        ? const CircularProgressIndicator(color: Colors.white)
                        : (_photoPath == null
                            ? Text(
                                _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : "?",
                                style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                              )
                            : null),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 3),
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: _picking ? null : _openPhotoSheet,
              child: const Text("Rasmni o'zgartirish", style: TextStyle(color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Foydalanuvchi nomi", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              hintText: "Foydalanuvchi nomi",
              hintStyle: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Biografiya", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _bioController,
            maxLines: 3,
            maxLength: 150,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              hintText: "O'zingiz haqingizda qisqacha yozing",
              hintStyle: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
