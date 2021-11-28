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
                            'Ocorreu um erro ao buscar os seus dados, por favor tente novamente!',
                            textAlign: TextAlign.center,
                          ),
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
                        SizedBox(height: 16),
                        Text(
                          'Previsão climática',
                          style: HeaderTS,
                        ),
                        SizedBox(
                          height: 16,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: BaseContainer(
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
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud,
                                      size: 64,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${viewModel.prediction.today.current}°',
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(viewModel.prediction.today.status ?? '', style: TextStyle(fontSize: 22),),
                                SizedBox(height: 8),
                                Text(
                                    'Min. ${viewModel.prediction.today.min}°   Max. ${viewModel.prediction.today.max}°', style: TextStyle(fontSize: 22),),
                                SizedBox(height: 8),
                                Text(
                                    'Volume de chuva: ${viewModel.prediction.today.rainChance}', style: TextStyle(fontSize: 22),),
                                SizedBox(height: 8),
                                Text(
                                    'Indice UV: ${viewModel.prediction.today.uv}', style: TextStyle(fontSize: 22),),
                                SizedBox(height: 8),
                                Text(
                                    'Umidade: ${viewModel.prediction.today.humidity}%', style: TextStyle(fontSize: 22),),
                              ],
                            ),
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
                                      Text(
                                          '${viewModel.prediction.tomorrow.min}°/${viewModel.prediction.tomorrow.max}°', style: TextStyle(fontSize: 22),)
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Volume de chuva: ${viewModel.prediction.tomorrow.rainChance}', style: TextStyle(fontSize: 22),)
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
