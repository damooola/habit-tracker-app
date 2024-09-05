import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;
  const HabitTile(
      {super.key,
      required this.text,
      required this.isCompleted,
      required this.onChanged,
      required this.editHabit,
      required this.deleteHabit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          //edit
          SlidableAction(
            onPressed: editHabit,
            backgroundColor: Colors.grey,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(8),
          ),
          SlidableAction(
            onPressed: deleteHabit,
            backgroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),
          ),

          //option
        ]),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              //change completion status
              onChanged!(!isCompleted);
              // or onChanged!.call(!isCompleted);
            }
          },
          //habit tile
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.primary),
            padding: const EdgeInsets.all(10),
            child: ListTile(
              // habit text
              title: Text(
                text,
                style: TextStyle(
                    color: isCompleted
                        ? Colors.white
                        : Theme.of(context).colorScheme.inversePrimary),
              ),
              leading: Checkbox(
                value: isCompleted,
                onChanged: onChanged,
                activeColor: Colors.green,
                checkColor: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
