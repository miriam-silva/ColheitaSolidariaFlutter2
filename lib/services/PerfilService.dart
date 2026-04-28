import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilService {
  final supabase = Supabase.instance.client;
  final firestore = FirebaseFirestore.instance;

  Future<String?> uploadFotoPerfil(File arquivo, String uid) async {
    try {
      final fileName =
          "perfil/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg";

      // upload
      await supabase.storage
          .from("users") // 👈 CONFIRMA se esse é seu bucket
          .upload(
            fileName,
            arquivo,
            fileOptions: const FileOptions(upsert: true),
          );

      // URL pública
      final url =
          supabase.storage.from("users").getPublicUrl(fileName);

      // salva no Firestore
      await firestore.collection("users").doc(uid).update({
        "fotoPerfil": url,
      });

      return url;
    } catch (e) {
      debugPrint("Erro upload perfil: $e");
      return null;
    }
  }
}