import 'package:flutter/cupertino.dart';
import 'package:habit_trackerapp/models/app_settings.dart';
import 'package:habit_trackerapp/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

// INITIALIZE  DATABASE ON APP START UP
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

// SAVE FIRST EVER DATE on app launch
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

// GET FIRST DATE on app launch
  Future<DateTime?> getFirstLAunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

// List that holds all current habit in our database that we use for the UI
  List<Habit> currentHabits = [];

  // CREATE - add new habit to database
  Future<void> addHabit(String habitName) async {
    // create new habit
    final newHabit = Habit()..name = habitName;

    // save to database
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // reread database
    fetchHabits();
  }

  // READ - read habits from database
  Future<void> fetchHabits() async {
    final fetchedHabits = await isar.habits.where().findAll();
    //alway clear before adding to list
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);
    notifyListeners();
  }

  // UPDATE - check habit on or off
  Future<void> editHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        //if completed, add currrentdate  to completedDaysList
        if (isCompleted &&
            !habit.listOfCompletedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          // add currentDate if not already in he list
          habit.listOfCompletedDays
              .add(DateTime(today.year, today.month, today.day));
        }
        //if not complted remove currentDate from list
        else {
          habit.listOfCompletedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }

        await isar.habits.put(habit);
      });
    }
    fetchHabits();
  }

  // UPDATE - edit habit name in database
  Future<void> editHabitName(String newName, int id) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    fetchHabits();
  }

  // DELETE - delete habit from database
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      return await isar.habits.delete(id);
    });
    fetchHabits();
  }
}
