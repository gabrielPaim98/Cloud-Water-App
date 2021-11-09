import 'package:cloud_water/util/colors.dart';
import 'package:cloud_water/util/text_styles.dart';
import 'package:cloud_water/view/login/login_view_model.dart';
import 'package:cloud_water/view/main/main_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.shouldNavigateHome) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainView()),
              (route) => false);
        }

        return Scaffold(
          backgroundColor: BLUE,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(
                  'Bem vindo ao Cloud Water!',
                  style: HeaderTS,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Por favor acesse ou crie sua conta para usar o aplicativo',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? email) {
                      if (email!.isEmpty || !email.contains('@')) {
                        return 'Email inválido!';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: BLACK),
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: BLACK,
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !viewModel.isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: const TextStyle(
                        color: BLACK,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: BLACK,
                      ),
                      border: const UnderlineInputBorder(),
                      suffix: IconButton(
                        icon: Icon(viewModel.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => viewModel.changePasswordVisibility(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => viewModel.onLoginClick(
                      _emailController.text, _passwordController.text),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(BLACK),
                  ),
                  child: Text(
                    'Entrar',
                    style: TextStyle(color: WHITE),
                  ),
                ),
                const SizedBox(height: 60),
                TextButton(
                  onPressed: () => viewModel.onRegisterClick(
                      _emailController.text, _passwordController.text),
                  child: Text(
                    'Registrar-se',
                    style: TextStyle(color: BLACK),
                  ),
                ),
                TextButton(
                  onPressed: () => viewModel.onAnonymousLoginClick(),
                  child: Text(
                    'Login Anônimo',
                    style: TextStyle(color: BLACK),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
