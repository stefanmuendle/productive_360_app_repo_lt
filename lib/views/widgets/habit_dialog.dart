import 'package:flutter/material.dart';
import 'package:productive_360_app/models/habit.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  IconData _icon = Icons.check_box;
  HabitType _type = HabitType.checkbox;
  int _durationMinutes = 30;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Habit'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Habit Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a name' : null,
                onSaved: (value) => _name = value ?? '',
              ),
              DropdownButtonFormField<HabitType>(
                value: _type,
                items: [
                  DropdownMenuItem(
                    value: HabitType.checkbox,
                    child: Text('Checkbox'),
                  ),
                  DropdownMenuItem(
                    value: HabitType.timeSpent,
                    child: Text('Time Spent'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _type = value ?? HabitType.checkbox;
                  });
                },
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                initialValue: '30',
                onSaved: (value) =>
                    _durationMinutes = int.tryParse(value ?? '30') ?? 30,
              ),
              DropdownButtonFormField<IconData>(
                value: _icon,
                items: [
                  DropdownMenuItem(
                    value: Icons.check_box,
                    child: Icon(Icons.check_box),
                  ),
                  DropdownMenuItem(
                    value: Icons.timer,
                    child: Icon(Icons.timer),
                  ),
                  DropdownMenuItem(value: Icons.star, child: Icon(Icons.star)),
                  DropdownMenuItem(
                    value: Icons.favorite,
                    child: Icon(Icons.favorite),
                  ),
                  DropdownMenuItem(
                    value: Icons.sports_gymnastics,
                    child: Icon(Icons.sports_gymnastics),
                  ),
                  DropdownMenuItem(
                    value: Icons.laptop,
                    child: Icon(Icons.laptop),
                  ),
                  DropdownMenuItem(value: Icons.spa, child: Icon(Icons.spa)),
                ],
                onChanged: (value) {
                  setState(() {
                    _icon = value ?? Icons.check_box;
                  });
                },
                decoration: InputDecoration(labelText: 'Icon'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Add'),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              Navigator.of(context).pop(
                Habit(
                  name: _name,
                  icon: _icon,
                  type: _type,
                  durationToComplete: Duration(minutes: _durationMinutes),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
