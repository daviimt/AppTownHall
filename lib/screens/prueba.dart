import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:townhall/services/services.dart';

class Prueba extends StatelessWidget {
  const Prueba({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {},
        ),
      ),
    );
  }
}
