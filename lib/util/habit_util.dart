// with a list of completed days
// is habit completed today?

import '../models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any((date) =>
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day);
}

//heat map dataset
Map<DateTime, int> prepHeatmapDatasets(List<Habit> habits) {
  Map<DateTime, int> dataSet = {};
  for (var habit in habits) {
    for (var date in habit.listOfCompletedDays) {
      //normalize date to avoid mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // if date exists in dataset increment count
      if (dataSet.containsKey(normalizedDate)) {
        dataSet[normalizedDate] = dataSet[normalizedDate]! + 1;
      } else {
        // init with acount of 1
        dataSet[normalizedDate] = 1;
      }
    }
  }
  return dataSet;
}
