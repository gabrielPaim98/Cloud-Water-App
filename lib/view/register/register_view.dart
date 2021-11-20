import 'package:cloud_water/util/colors.dart';
import 'package:cloud_water/util/text_styles.dart';
import 'package:cloud_water/view/main/main_view.dart';
import 'package:cloud_water/view/register/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, viewModel, child) {
        viewModel.updateContext(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('Cadastro'),
            centerTitle: true,
          ),
          backgroundColor: BLUE,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'Bem vindo ao Cloud Water!',
                      style: HeaderTS,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Por favor insira as informações abaixo',
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
                            onPressed: () =>
                                viewModel.changePasswordVisibility(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (String? name) {
                          if (name!.isEmpty) {
                            return 'Nome vazio!';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: const TextStyle(color: BLACK),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: BLACK,
                          ),
                          border: const UnderlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 32),
                    viewModel.showRegistryError
                        ? Text(
                            viewModel.errorMsg,
                            style: TextStyle(color: RED),
                          )
                        : Container(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.onRegisterClick(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(BLACK),
                      ),
                      child: Text(
                        'Registrar-se',
                        style: TextStyle(color: WHITE),
                      ),
                    ),
                    const SizedBox(height: 60),
                    TextButton(
                      onPressed: () => viewModel
                          .onAnonymousRegisterClick(_nameController.text),
                      child: Text(
                        'Entrar anonimamente',
                        style: TextStyle(color: BLACK),
                      ),
                    ),
                  ],
                ),
              ),
              viewModel.isLoading
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black26,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
