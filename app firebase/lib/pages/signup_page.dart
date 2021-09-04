import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soulcode_template_firebase/controllers/user_controller.dart';
import 'package:soulcode_template_firebase/models/user_model.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String nome = "";
  String email = "";
  String senha = "";

  late final userController =
      Provider.of<UserController>(context, listen: false);

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar conta"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if(isLoading) CircularProgressIndicator(),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                onChanged: (texto) => nome = texto,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (texto) => email = texto,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                onChanged: (texto) => senha = texto,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final user = UserModel(nome: nome);
                    setState(() {
                      isLoading = true;
                    });
                    await userController.signup(email, senha, user);

                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    var msg = "";

                    if (e.code == "weak-password") {
                      msg = "Senha Fraca";
                    } else if (e.code == "email-already- in-use") {
                      msg = "E-mail já Cadastrado";
                    } else {
                      msg = "Ocorreu um Erro";
                    }

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(msg),
                    ));
                  }
                },
                child: Text("Criar conta"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
