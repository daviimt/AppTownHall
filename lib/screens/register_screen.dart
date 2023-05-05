// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import 'package:townhall/services/services.dart';
import 'package:townhall/Models/models.dart';
import 'package:townhall/widgets/widgets.dart';
import 'package:townhall/ui/input_decorations.dart';

import '../providers/providers.dart';

// class getCicles extends ChangeNotifier {
//   String _baseUrl = 'http://salesin.allsites.es/public/api/cicles';

//   CiclesProvider() {
//     print('Inicializando');
//   }

//   getCiclesName() async {
//     var url = Uri.https(_baseUrl);

//     final response = await http.get(url);

//     print(response.body);
//   }
// }

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          CardContainer(
              child: Column(
            children: [
              const SizedBox(height: 10),
              Text('Crear cuenta',
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 30),
              ChangeNotifierProvider(
                  create: (_) => RegisterFormProvider(), child: _RegisterForm())
            ],
          )),
          const SizedBox(height: 50),
          TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder())),
              child: const Text(
                '¿Ya tienes una cuenta?',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              )),
          const SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _RegisterForm extends StatelessWidget with InputValidationMixin {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Form(
      key: registerForm.formKey,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        // ignore: sort_child_properties_last
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
                hintText: '', labelText: 'Username', prefixIcon: Icons.person),
            onChanged: (value) => registerForm.username = value,
            validator: (username) {
              if (isTextValid(username)) {
                return null;
              } else {
                return 'Name field cant be null';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
                hintText: '', labelText: 'Name', prefixIcon: Icons.person),
            onChanged: (value) => registerForm.name = value,
            validator: (name) {
              if (isTextValid(name)) {
                return null;
              } else {
                return 'Name field cant be null';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
                hintText: '', labelText: 'Surname', prefixIcon: Icons.person),
            onChanged: (value) => registerForm.surname = value,
            validator: (surname) {
              if (isTextValid(surname)) {
                return null;
              } else {
                return 'Surname field cant be null';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
                hintText: '12345678P',
                labelText: 'DNI',
                prefixIcon: Icons.alternate_email_rounded),
            onChanged: (value) => registerForm.dni = value,
            validator: (dni) {
              if (isDniValid(dni)) {
                return null;
              } else {
                return 'Enter a valid DNI';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
                hintText: '*******',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline),
            onChanged: (value) => registerForm.password = value,
            validator: (password) {
              if (isPasswordValid(password)) {
                return null;
              } else {
                return 'Enter a valid password';
              }
            },
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
                hintText: '*******',
                labelText: 'Password',
                prefixIcon: Icons.lock_outline),
            validator: (value) {
              if (value != registerForm.password) {
                return "The passwords don't match";
              } else if (value == '') {
                return "The password cant be null";
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: registerForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (!registerForm.isValidForm()) return;

                      registerForm.isLoading = true;

                      //validar si el login es correcto
                      final String? errorMessage = await authService.createUser(
                          registerForm.username,
                          registerForm.name,
                          registerForm.surname,
                          registerForm.dni,
                          registerForm.password);
                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'login');
                      } else {
                        //mostrar error en pantalla
                        // customToast('The email is already registered', context);
                        registerForm.isLoading = false;
                        print(errorMessage);
                      }
                      // }
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    registerForm.isLoading ? 'Espere' : 'Registrar',
                    style: const TextStyle(color: Colors.white),
                  )))
        ],
      ),
    );
  }

  void customToast(String s, BuildContext context) {
    showToast(
      s,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}

mixin InputValidationMixin {
  bool isTextValid(texto) => texto.length > 0;

  bool isPasswordValid(password) => password.length >= 4;

  bool isDniValid(dni) {
    String pattern = '[0-9]{8}[A-Za-z]{1}';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(dni);
  }
}
