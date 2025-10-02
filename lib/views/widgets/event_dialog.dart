import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart';

class EventDialogWidget extends StatefulWidget {
  final void Function(Event) onSave;
  final Event? initialEvent;

  const EventDialogWidget({super.key, required this.onSave, this.initialEvent});

  @override
  State<EventDialogWidget> createState() => _EventDialogWidgetState();
}

class _EventDialogWidgetState extends State<EventDialogWidget> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late DateTime start;
  late DateTime end;
  late Color selectedColor;
  final colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    final event = widget.initialEvent;
    titleController = TextEditingController(text: event?.title ?? '');
    descController = TextEditingController(text: event?.description ?? '');
    start = event?.startTime ?? DateTime.now();
    end = event?.endTime ?? DateTime.now().add(const Duration(hours: 1));
    selectedColor = event?.color ?? Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialEvent == null ? 'Add Event' : 'Edit Event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Start:'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: start,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(start),
                        );
                        if (time != null) {
                          setState(() {
                            start = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              time.hour,
                              time.minute,
                            );
                            if (end.isBefore(start)) {
                              end = start.add(const Duration(hours: 1));
                            }
                          });
                        }
                      }
                    },
                    child: Text(DateFormat('yyyy-MM-dd HH:mm').format(start)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('End:'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: end,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(end),
                        );
                        if (time != null) {
                          setState(() {
                            end = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              time.hour,
                              time.minute,
                            );
                            if (end.isBefore(start)) {
                              end = start.add(const Duration(hours: 1));
                            }
                          });
                        }
                      }
                    },
                    child: Text(DateFormat('yyyy-MM-dd HH:mm').format(end)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Category:'),
                const SizedBox(width: 8),
                Wrap(
                  spacing: 4,
                  children: colors
                      .map(
                        (color) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: color,
                            radius: 12,
                            child: selectedColor == color
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              final event = Event(
                startTime: start,
                endTime: end,
                title: titleController.text,
                description: descController.text,
                color: selectedColor,
              );
              widget.onSave(event);
              Navigator.pop(context);
            }
          },
          child: Text(widget.initialEvent == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
