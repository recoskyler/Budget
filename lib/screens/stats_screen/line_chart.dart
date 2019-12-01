/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:budget/modules/functions.dart';
import 'package:budget/modules/classes.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
    final List<charts.Series> seriesList;
    final bool animate;

    SimpleTimeSeriesChart(this.seriesList, {this.animate});

    /// Creates a [TimeSeriesChart] with sample data and no transition.
    factory SimpleTimeSeriesChart.withSampleData() {
        return new SimpleTimeSeriesChart(
            _createSampleData(),
            animate: true,
        );
    }


    @override
    Widget build(BuildContext context) {
        return new charts.TimeSeriesChart(
            seriesList,
            animate: animate,
            defaultRenderer: new charts.LineRendererConfig(includeArea: true, stacked: true, includePoints: true, roundEndCaps: true, includeLine: false),
            dateTimeFactory: const charts.LocalDateTimeFactory()
        );
    }

    /// Create one series with sample hard coded data.
    static List<charts.Series<ChartEntry, DateTime>> _createSampleData() {
        return generateList();
    }
}