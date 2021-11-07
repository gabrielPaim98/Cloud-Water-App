import 'package:cloud_water/model/api_status.dart';
import 'package:cloud_water/model/logs.dart';
import 'package:cloud_water/util/colors.dart';
import 'package:cloud_water/util/text_styles.dart';
import 'package:cloud_water/view/components/base_container.dart';
import 'package:cloud_water/view/logs/logs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogsView extends StatelessWidget {
  const LogsView() : super();

  @override
  Widget build(BuildContext context) {
    return Consumer<LogsViewModel>(
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
                            onPressed: () => viewModel.getLogs(),
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: BaseContainer(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Histórico',
                                  style: HeaderTS,
                                ),
                              ),
                              ListView.separated(
                                  itemCount: viewModel.logs.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Divider(
                                            thickness: 2,
                                            indent: 4,
                                            endIndent: 4,
                                            height: 24,
                                          ),
                                  itemBuilder: (context, index) {
                                    Log log = viewModel.logs.elementAt(index);
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          log.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(log.value),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
