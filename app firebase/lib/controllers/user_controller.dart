import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soulcode_template_firebase/models/user_model.dart';

enum AuthState { signed, unsigned, loading }

class UserController extends ChangeNotifier {
  AuthState authState = AuthState.loading;

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance; // chamando o firestore
  late UserModel model;
  User? get user => _auth.currentUser;
UserController() {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        authState = AuthState.signed;
        final documento = await _db.collection('usuarios').doc(user.uid).get();
        model = UserModel.fromMap(documento.data()!);
      } else {
        authState = AuthState.unsigned;
      }
      notifyListeners();
    });
  }

  Future<void> login(String email, String senha) async {
    // login , porem quando colocamos o await , é preciso colocar o async .
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> signup(
    String email,
    String senha,
    UserModel payload,
  ) async {
    final credentials = await _auth.createUserWithEmailAndPassword( // cadastra usuario com email esenha 
      email: email,
      password: senha,
    );

    /// TODO salvar o payload no firestaore
    final uid = credentials.user?.uid;
    final data = payload.toMap();
    data['key'] = uid;

    final doc = _db.collection('usuarios').doc(uid);
    await doc.set(data); // vai pegar os dados e mandar para o firebase
  }
}
