import 'package:cloud_water/model/api_status.dart';
import 'package:cloud_water/util/colors.dart';
import 'package:cloud_water/util/text_styles.dart';
import 'package:cloud_water/view/components/base_container.dart';
import 'package:cloud_water/view/weather/weather_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherView extends StatelessWidget {
  const WeatherView() : super();

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, viewModel, child) {
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
                        children: [
                          Text(
                              'Ocorreu um erro ao buscar os seus dados, por favor tente novamente!'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            child: Text('Tentar Novamente'),
                            onPressed: () => viewModel.getWeatherPrediction(),
                          )
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16
                        ),
                        Text(
                          'Previsão climática',
                          style: HeaderTS,
                        ),
                        SizedBox(
                          height: 16,
                          width: MediaQuery.of(context).size.width,
                        ),
                        BaseContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Hoje',
                                style: HeaderTS,
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud),
                                  SizedBox(width: 8),
                                  Text('${viewModel.prediction.today.current}°')
                                ],
                              ),
                              Text(viewModel.prediction.today.status ?? ''),
                              Text('Min. ${viewModel.prediction.today.min}°   Max. ${viewModel.prediction.today.max}°'),
                              Text('Chance de chuva: ${viewModel.prediction.today.rainChance}'),
                              Text('Indice UV: ${viewModel.prediction.today.uv}'),
                              Text('Umidade: ${viewModel.prediction.today.humidity}%'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BaseContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ontem',
                                    style: HeaderTS,
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud),
                                      SizedBox(width: 8),
                                      Text('${viewModel.prediction.yesterday.min}°/${viewModel.prediction.yesterday.max}°')
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_outlined),
                                      SizedBox(width: 8),
                                      Text('${viewModel.prediction.yesterday.rainChance}%')
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            BaseContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amanhã',
                                    style: HeaderTS,
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud),
                                      SizedBox(width: 8),
                                      Text('${viewModel.prediction.tomorrow.min}°/${viewModel.prediction.tomorrow.max}°')
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_outlined),
                                      SizedBox(width: 8),
                                      Text('${viewModel.prediction.tomorrow.rainChance}%')
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
