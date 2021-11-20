import 'package:cloud_water/model/api_status.dart';
import 'package:cloud_water/model/home_options.dart';
import 'package:cloud_water/util/colors.dart';
import 'package:cloud_water/util/text_styles.dart';
import 'package:cloud_water/view/components/base_container.dart';
import 'package:cloud_water/view/home/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView() : super();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, viewModel, child) {
      return Container(
        color: BLUE,
        child: viewModel.apiStatus == ApiStatus.LOADING
            ? Center(
                child: CircularProgressIndicator(),
              )
            : viewModel.apiStatus == ApiStatus.ERROR
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Ocorreu um erro ao buscar os seus dados, por favor tente novamente!',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          child: Text('Tentar Novamente'),
                          onPressed: () => viewModel.getConfig(),
                        )
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          BaseContainer(
                            padding: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SwitchListTile(
                                onChanged: (value) =>
                                    viewModel.updateFaucetStatus(value),
                                value: viewModel.homeOptions.faucetOn,
                                title: Text(
                                  'Torneira Ativada',
                                  style: HeaderTS,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          BaseContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Umidade do Solo',
                                  style: HeaderTS,
                                ),
                                viewModel.homeOptions.soilRead.isEmpty ?
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Ainda não há informações deste dispositivo', textAlign: TextAlign.center,),
                                      ),
                                    ) :
                                ListView.builder(
                                    itemCount:
                                        viewModel.homeOptions.soilRead.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      SoilRead soilRead = viewModel
                                          .homeOptions.soilRead
                                          .elementAt(index);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              soilRead.name,
                                              style: TextStyle(
                                                  color: soilRead.status ==
                                                          SoilReadStatus.LOW
                                                      ? RED
                                                      : soilRead.status ==
                                                              SoilReadStatus
                                                                  .NORMAL
                                                          ? BLACK
                                                          : DARK_BLUE),
                                            ),
                                            Text(
                                              soilRead.value.toStringAsFixed(3),
                                              style: TextStyle(
                                                  color: soilRead.status ==
                                                          SoilReadStatus.LOW
                                                      ? RED
                                                      : soilRead.status ==
                                                              SoilReadStatus
                                                                  .NORMAL
                                                          ? BLACK
                                                          : DARK_BLUE),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          BaseContainer(
                            padding: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Configurações',
                                    style: HeaderTS,
                                  ),
                                ),
                                ListView.builder(
                                    itemCount:
                                        viewModel.homeOptions.config.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Config config = viewModel
                                          .homeOptions.config
                                          .elementAt(index);
                                      return SwitchListTile(
                                        onChanged: (value) => viewModel
                                            .updateConfig(index, value),
                                        value: config.value,
                                        title: Text(
                                          config.name,
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      viewModel.isLoading
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              color: Colors.black26,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : Container(),
                      viewModel.showUpdateConfigError
                          ? Container(
                              color: Colors.black26,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    color: Colors.white,
                                    width: MediaQuery.of(context).size.width *
                                        0.80,
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Ocorreu um erro ao atualizar os dados do seu dispositivo!',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 16),
                                        ElevatedButton(
                                          child: Text('Ok'),
                                          onPressed: () => viewModel
                                              .onUpdateConfigErrorClick(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
      );
    });
  }
}
