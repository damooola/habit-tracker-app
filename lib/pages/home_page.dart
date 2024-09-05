import 'package:flutter/material.dart';
import 'package:habit_trackerapp/components/heat_map.dart';
import 'package:habit_trackerapp/components/my_drawer.dart';
import 'package:habit_trackerapp/database/habit_database.dart';
import 'package:provider/provider.dart';

import '../components/habit_tile.dart';
import '../models/habit.dart';
import '../util/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).fetchHabits();
    super.initState();
  }

  //text controller
  final textController = TextEditingController();
  void createNewhabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text('Add new habit',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary)),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
                hintText: "Create a habit",
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          actions: [
            //cancel button
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  textController.clear();
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary))),
            // create textbutton
            TextButton(
                onPressed: () {
                  String habitName = textController.text;
                  context.read<HabitDatabase>().addHabit(habitName);
                  Navigator.pop(context);
                  textController.clear();
                },
                child: Text('Save',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary)))
          ]),
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().editHabitCompletion(habit.id, value);
    }
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
          ),
          actions: [
            // cancel button
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  textController.clear();
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary))),
            // edit button
            TextButton(
                onPressed: () {
                  String newHabitName = textController.text;
                  context
                      .read<HabitDatabase>()
                      .editHabitName(newHabitName, habit.id);
                  Navigator.pop(context);
                  textController.clear();
                },
                child: Text('Save',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary)))
          ]),
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: Text("Are you sure you want to delete?",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary)),
          actions: [
            //cancel button
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary))),

            // delete button
            TextButton(
                onPressed: () {
                  context.read<HabitDatabase>().deleteHabit(habit.id);
                  Navigator.pop(context);
                },
                child: Text('Delete',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary)))
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(
              "Habit Tracker",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true),
        drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          onPressed: createNewhabit,
          elevation: 0,
          child: const Icon(Icons.add),
        ),
        body: ListView(children: [
          // heatmap
          _buildHeatMap(),
          //habit list
          _buildHabitList(),
        ]));
  }

//heat map build
  Widget _buildHeatMap() {
    //habit database
    final habitDatabase = context.watch<HabitDatabase>();

//current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //heat map UI
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLAunchDate(),
      builder: (context, snapshot) {
        // build heat map with available data
        if (snapshot.hasData) {
          return MyHeatMap(
              startDate: snapshot.data!,
              dataSets: prepHeatmapDatasets(currentHabits));
        }

        //if data is null
        else {
          return Container();
        }
      },
    );
  }

//habit list build
  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    //current list of habit in database
    List<Habit> currentHabits = habitDatabase.currentHabits;
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompletedToday =
            isHabitCompletedToday(habit.listOfCompletedDays);
        return HabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
