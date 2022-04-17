import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as element;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:flutter/material.dart';
import 'package:pejskari/pages/DogWeight/WeightSeries.dart';

/// This class represents chart showing weight in time.
class WeightChart extends StatelessWidget {
  final List<WeightSeries> data;
  final int view;
  const WeightChart({Key? key, required this.data, required this.view})
      : super(key: key);

  /// Method generates ticks for month. Used when only data for current month is displayed.
  _getTicksForMonth(DateTime date) {
    var totalDays = _daysInMonth(date);

    var listOfDates = List<int>.generate(totalDays, (i) => i + 1);
    var pickedDates = [];
    for (int i = 0; i < listOfDates.length; i++) {
      if (i % 5 == 0) {
        pickedDates.add(listOfDates[i]);
      }
    }
    var now = DateTime.now();
    int lastDay = DateTime(now.year, now.month + 1, 0).day;
    if (!pickedDates.contains(lastDay)) {
      pickedDates.add(lastDay);
    }
    return pickedDates
        .map((e) =>
            charts.TickSpec<DateTime>(DateTime(date.year, date.month, e)))
        .toList();
  }

  /// Calculates days in month.
  int _daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<WeightSeries, DateTime>> series = [
      charts.Series(
          id: "dog_weights",
          data: data,
          domainFn: (WeightSeries series, _) => series.date,
          measureFn: (WeightSeries series, _) => series.weight,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault),
    ];

    return Container(
        height: 300,
        padding: const EdgeInsets.all(10),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Column(children: <Widget>[
                  Text(
                    "Vývoj váhy psa",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Expanded(
                    child: charts.TimeSeriesChart(
                      series,
                      animate: false,
                      domainAxis: charts.DateTimeAxisSpec(
                          // viewport: ,
                          tickProviderSpec: view == 1 || data.length <= 1
                              ? charts.StaticDateTimeTickProviderSpec(
                                  _getTicksForMonth( view == 0 && data.length == 1 ? data[0].date : DateTime.now()))
                              : null,
                          tickFormatterSpec:
                              const charts.AutoDateTimeTickFormatterSpec(
                                  day: charts.TimeFormatterSpec(
                                      format: 'd.M.', transitionFormat: 'd.M.'),
                                  month: charts.TimeFormatterSpec(
                                      format: 'd.M.', transitionFormat: 'd.M.'),
                                  hour: charts.TimeFormatterSpec(
                                      format: 'd.M.',
                                      transitionFormat: 'd.M.'))),
                      defaultRenderer: charts.LineRendererConfig(
                        includePoints: true,
                        radiusPx: 6,
                        includeArea: true,
                      ),
                      selectionModels: [
                        charts.SelectionModelConfig(
                            updatedListener: (charts.SelectionModel model) {
                          if (model.hasDatumSelection) {
                            TextSymbolRenderer.value = model
                                .selectedSeries.first
                                .measureFn(model.selectedDatum.first.index)
                                .toString();
                          }
                        })
                      ],
                      behaviors: [
                        charts.LinePointHighlighter(
                          symbolRenderer: TextSymbolRenderer(),
                        ),
                      ],
                    ),
                  )
                ]))));
  }
}

//https://github.com/google/charts/issues/58#issuecomment-1023006331
class TextSymbolRenderer extends charts.CircleSymbolRenderer {
  TextSymbolRenderer(
      {this.marginBottom = 8, this.padding = const EdgeInsets.all(8)});

  final double marginBottom;
  final EdgeInsets padding;
  static String value = "";

  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      charts.Color? fillColor,
      charts.FillPatternType? fillPattern,
      charts.Color? strokeColor,
      double? strokeWidthPx}) {
    style.TextStyle textStyle = style.TextStyle();
    textStyle.color = charts.Color.black;
    textStyle.fontSize = 15;

    element.TextElement textElement =
        element.TextElement(value, style: textStyle);
    double width = textElement.measurement.horizontalSliceWidth;
    double height = textElement.measurement.verticalSliceWidth;

    double centerX = bounds.left + bounds.width / 2;
    double centerY = bounds.top +
        bounds.height / 2 -
        marginBottom -
        (padding.top + padding.bottom);

    canvas.drawRRect(
      Rectangle(
        centerX - (width / 2) - padding.left,
        centerY - (height / 2) - padding.top,
        width + (padding.left + padding.right),
        height + (padding.top + padding.bottom),
      ),
      fill: charts.Color.white,
      radius: 16,
      roundTopLeft: true,
      roundTopRight: true,
      roundBottomRight: true,
      roundBottomLeft: true,
    );
    canvas.drawText(
      textElement,
      (centerX - (width / 2)).round(),
      (centerY - (height / 2)).round(),
    );
  }
}
