import 'package:flutter/material.dart';

import 'monitor_utils.dart';

class SortableSeriesTable extends StatefulWidget {
  final StatType statType;
  final List<TimeSeriesStat> startingData;

  const SortableSeriesTable(this.statType, this.startingData, {Key key})
      : super(key: key);

  @override
  _SortableSeriesTableState createState() => _SortableSeriesTableState();
}

class _SortableSeriesTableState extends State<SortableSeriesTable> {
  List<TimeSeriesStat> dataPoints = [];
  bool timeSort = true;
  bool ascending = false;

  void copyPoints(List<TimeSeriesStat> other) {
    setState(() {
      dataPoints = List.from(other);
    });
  }

  void onPressSort(bool pressedTime) {
    if ((pressedTime && timeSort) || (!pressedTime && !timeSort)) {
      ascending = !ascending;
    } else {
      timeSort = !timeSort;
      ascending = false;
    }
    sortData();
  }

  void sortData() {
    setState(() {
      dataPoints.sort((a, b) {
        if (timeSort) {
          if (ascending) {
            return a.time.compareTo(b.time);
          }
          return b.time.compareTo(a.time);
        }
        if (ascending) {
          return a.stat.compareTo(b.stat);
        }
        return b.stat.compareTo(a.stat);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // too lazy to do proper state updating from parent
    copyPoints(widget.startingData);
    sortData();
    return DataTable(
      columns: [
        DataColumn(
          label: TextButton(
            child: Row(
              children: [
                Text("Time"),
                timeSort
                    ? Icon(ascending
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down)
                    : Container(),
              ],
            ),
            onPressed: () => onPressSort(true),
          ),
        ),
        DataColumn(
          label: TextButton(
            child: Row(
              children: [
                Text(widget.statType.label),
                !timeSort
                    ? Icon(ascending
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down)
                    : Container(),
              ],
            ),
            onPressed: () => onPressSort(false),
          ),
        ),
      ],
      rows: dataPoints
          .map(
            (d) => DataRow(
              cells: [
                DataCell(Text(d.time.toString())),
                DataCell(Text(d.stat.toString())),
              ],
            ),
          )
          .toList(),
    );
  }
}
