import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:townhall/models/models.dart';
import 'package:townhall/screens/screens.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreen();
}

class _UpdateScreen extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AuthBackground(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              CardContainer(
                  child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Update Account',
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(), child: _LoginForm())
                ],
              )),
              SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'userscreen'),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(StadiumBorder())),
                  child: Text(
                    'Back',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  )),
              SizedBox(height: 50),
            ],
          ),
        )));
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => __LoginForm();
}

class __LoginForm extends State<_LoginForm> {
  final userService = UserService();
  User user = User();

  Future getUser() async {
    await userService.getUser();
    User us = await userService.getUser();
    setState(() {
      user = us;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              initialValue: user.username,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: user.username.toString(),
                labelText: 'Username',
                prefixIcon: Icons.account_circle_sharp,
              ),
              onChanged: (value) => loginForm.username = value,
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              initialValue: user.dni,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: user.dni.toString(),
                  labelText: 'Dni',
                  prefixIcon: Icons.account_circle_sharp),
              onChanged: (value) => loginForm.dni = value,
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              initialValue: user.name,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: user.name.toString(),
                  labelText: 'Name',
                  prefixIcon: Icons.text_decrease),
              onChanged: (value) => loginForm.name = value,
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              initialValue: user.surname,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: user.surname.toString(),
                  labelText: 'Surname',
                  prefixIcon: Icons.account_circle_sharp),
              onChanged: (value) => loginForm.surname = value,
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              initialValue: user.password,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
            ),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.blueGrey,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? 'Wait' : 'Submit',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        String dniPattern = r'^\d{8}[A-Za-z]$';
                        RegExp regex = RegExp(dniPattern);
                        if (loginForm.dni.isEmpty ||
                            loginForm.username.isEmpty ||
                            loginForm.password.isEmpty ||
                            loginForm.name.isEmpty ||
                            loginForm.surname.isEmpty) {
                          customToast("Fiels can't be empty", context);
                        } else {
                          if (!regex.hasMatch(loginForm.dni)) {
                            customToast(
                                "El dni no cumple los parametros", context);
                          } else {
                            FocusScope.of(context).unfocus();
                            final authService = Provider.of<AuthService>(
                                context,
                                listen: false);

                            if (!loginForm.isValidForm()) return;

                            loginForm.isLoading = true;

                            // TODO: validar si el login es correcto
                            final String? errorMessage =
                                await userService.update(
                                    loginForm.username,
                                    loginForm.password,
                                    loginForm.dni,
                                    loginForm.name,
                                    loginForm.surname);

                            if (errorMessage == '201') {
                              customToast('Updated', context);
                              Navigator.pushReplacementNamed(
                                  context, 'userscreen');
                            } else if (errorMessage == '500') {
                              // TODO: mostrar error en pantalla
                              customToast('User registered', context);

                              loginForm.isLoading = false;
                            } else {
                              customToast('Server error', context);
                            }
                          }
                        }
                      })
          ],
        ),
      ),
    );
  }

  void customToast(String message, BuildContext context) {
    showToast(
      message,
      textStyle: const TextStyle(
        fontSize: 14,
        wordSpacing: 0.1,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textPadding: const EdgeInsets.all(23),
      fullWidth: true,
      toastHorizontalMargin: 25,
      borderRadius: BorderRadius.circular(15),
      backgroundColor: Colors.blueGrey,
      alignment: Alignment.topCenter,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 3),
      animation: StyledToastAnimation.slideFromBottom,
      context: context,
    );
  }
}
