import 'package:cloud_water/model/api_status.dart';
import 'package:cloud_water/util/colors.dart';
import 'package:cloud_water/view/add_iot/add_iot_view_model.dart';
import 'package:cloud_water/view/components/base_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddIotView extends StatelessWidget {
  AddIotView(this.isMainIot);

  final bool isMainIot;
  final TextEditingController _deviceName = TextEditingController();
  final TextEditingController _deviceSerial = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AddIotViewModel>(
      builder: (context, viewModel, child) {
        viewModel.isMainIot = isMainIot;
        viewModel.updateContext(context);

        return Scaffold(
          backgroundColor: BLUE,
          appBar: AppBar(
            title: Text(isMainIot
                ? 'Adicionar Novo Dispositivo Principal'
                : 'Adicionar Novo Dispositivo Auxiliar'),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: BaseContainer(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        Text(
                          'Por favor insira as informações do seu dispositivo abaixo:',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        isMainIot ? Container() :
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: _deviceName,
                            keyboardType: TextInputType.text,
                            validator: (String? text) {
                              if (text!.isEmpty) {
                                return 'Apelido não pode estar vazio';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Apelido do dispositivo',
                              labelStyle: const TextStyle(color: BLACK),
                              prefixIcon: const Icon(
                                Icons.device_hub,
                                color: BLACK,
                              ),
                              border: const UnderlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: _deviceSerial,
                            keyboardType: TextInputType.text,
                            validator: (String? text) {
                              if (text!.isEmpty) {
                                return 'Serial não pode estar vazio';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Serial do dispositivo',
                              labelStyle: const TextStyle(color: BLACK),
                              prefixIcon: const Icon(
                                Icons.qr_code,
                                color: BLACK,
                              ),
                              border: const UnderlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 60),
                        ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            viewModel.onAddDeviceClick(
                                _deviceName.text, _deviceSerial.text);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(BLACK),
                          ),
                          child: Text(
                            'Inserir Dispositivo',
                            style: TextStyle(color: WHITE),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        viewModel.apiStatus == ApiStatus.ERROR
                            ? Text(
                                'Ocorreu um erro ao adicionar seu dispositivo, por favor tente novamente!',
                                style: TextStyle(color: RED),
                                textAlign: TextAlign.center,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
              viewModel.showSuccessDialog
                  ? Container(
                      color: Colors.black26,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.80,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Dispositivo adicionado com sucesso!',
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    viewModel.onSuccessDialogClick();
                                    if (!isMainIot) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              viewModel.apiStatus == ApiStatus.LOADING
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black26,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Container()
            ],
          ),
        );
      },
    );
  }
}
