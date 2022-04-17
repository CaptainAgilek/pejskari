import 'package:flutter/material.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/pages/DogWeight/WeightChart.dart';
import 'package:pejskari/pages/DogWeight/WeightSeries.dart';
import 'package:pejskari/service/DogWeightService.dart';

/// This class represents tab page for dog weight chart.
class DogWeightChartTab extends StatefulWidget {
  final List<DogProfile> dogProfiles;

  const DogWeightChartTab({Key? key, required this.dogProfiles}) : super(key: key);

  @override
  _DogWeightChartTabState createState() => _DogWeightChartTabState();
}

class _DogWeightChartTabState extends State<DogWeightChartTab> {
  final DogWeightService _dogWeightService = DogWeightService();
  List<WeightSeries> data = [];
  double actualWeight = 0;
  int _selectedDogProfileId = 1;

  @override
  void initState() {
    super.initState();
    _prepareData(_isSelected.indexWhere((element) => element == true));
    _selectedDogProfileId =
        widget.dogProfiles.isNotEmpty ? widget.dogProfiles[0].id : 1;
  }

  List<bool> _isSelected = [true, false, false];

  /// This method prepares data for chart.
  void _prepareData(int view) async {
    var list = await _dogWeightService.getAll();

    var series =
        list.map((e) => WeightSeries(e.weight, DateTime.parse(e.date))).toList()
          ..sort((a, b) {
            return a.date.compareTo(b.date);
          });

    setState(() {
      actualWeight = series.isNotEmpty ? series.last.weight : 0;
      if (view == 1) {
        data = _prepareDataForThisMonth(series);
        return;
      }
      if (view == 2) {
        data = _prepareDataForLast3Months(series);
        return;
      }
      data = series;
    });
  }

  /// This method prepares data for current month.
  List<WeightSeries> _prepareDataForThisMonth(List<WeightSeries> data) {
    int actualMonth = DateTime.now().month;
    int actualYear = DateTime.now().year;
    return data
        .where((element) =>
            element.date.month == actualMonth &&
            element.date.year == actualYear)
        .toList();
  }

  /// This method prepares data for last 3 months.
  List<WeightSeries> _prepareDataForLast3Months(List<WeightSeries> data) {
    var actualDate = DateTime.now();
    int actualYear = DateTime.now().year;
    List<int> last3Months = [
      actualDate.month,
      DateTime(actualDate.year, actualDate.month - 1, actualDate.day).month,
      DateTime(actualDate.year, actualDate.month - 2, actualDate.day).month
    ];
    return data
        .where((element) =>
            last3Months.contains(element.date.month) &&
            element.date.year == actualYear)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 10),
      ToggleButtons(
          children: const <Widget>[
            Padding(padding: EdgeInsets.all(8.0), child: Text("Vše")),
            Padding(padding: EdgeInsets.all(8.0), child: Text("Tento měsíc")),
            Padding(padding: EdgeInsets.all(8.0), child: Text("3 měsíce")),
          ],
          isSelected: _isSelected,
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < _isSelected.length; i++) {
                _isSelected[i] = i == index;
              }
              _prepareData(
                  _isSelected.indexWhere((element) => element == true));
            });
          },
          // region example 1
          color: Colors.grey,
          selectedColor: Colors.red,
          fillColor: Colors.lightBlueAccent,
          // endregion
          // region example 2
          borderColor: Colors.lightBlueAccent,
          selectedBorderColor: Colors.red,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      Padding(
          padding: const EdgeInsets.only(left: 13.0, right: 13),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.pets),
              hintText: 'Zvolte psa',
              labelText: 'Pes',
            ),
            hint: const Text('Zvolte psa'),
            items: widget.dogProfiles.map((e) {
              return DropdownMenuItem(child: Text(e.name), value: e.id);
            }).toList(),
            value: _selectedDogProfileId,
            onChanged: (value) {
              setState(() {
                _selectedDogProfileId = int.parse(value.toString());
              });
            },
            isExpanded: true,
          )),
      // endregion
      WeightChart(
          data: data,
          view: _isSelected.indexWhere((element) => element == true)),
      Flexible(
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 10, top: 0),
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Align(
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Aktuální váha ',
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                        text: actualWeight.toString() + " Kg",
                                        style: const TextStyle(
                                            color: Colors.blue, fontSize: 24)),
                                  ],
                                ),
                              )))))))
    ]);
  }
}
