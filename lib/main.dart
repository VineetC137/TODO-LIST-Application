import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class Task {
  String title;
  DateTime? dateTime;

  Task({required this.title, this.dateTime});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Task> tasks = [];
  final TextEditingController titleController = TextEditingController();
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  final ValueNotifier<bool> notifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate = picked;
      // Display the string "vineet" after the selected date
      print('$selectedDate ');
    }
  }

  void selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
        selectedTime = picked; // Update the selected time
    }
  }

  void addTask() {
    if (titleController.text.isNotEmpty) {
      Task newTask = Task(
        title: titleController.text,
        dateTime: DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        ),
      );
      setState(() {
        tasks.add(newTask); // Add the new task to the list
      });
      clearInputFields(); // Clear input fields
    }
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index); // Remove the task directly from the list
    });
  }

  void clearInputFields() {
    titleController.clear();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO List'),
        backgroundColor: Colors.blue,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: notifier,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              Task task = tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: task.dateTime != null
                    ? Text(DateFormat('yyyy-MM-dd HH:mm').format(task.dateTime!))
                    : null,
                trailing: IconButton(
                  icon: Icon(Icons.delete, size: 18.0),
                  onPressed: () => deleteTask(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          selectedDate = DateTime.now();
          selectedTime = TimeOfDay.now();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => selectDate(context),
                          child: Text('Select Date'),
                        ),
                        Text(selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(selectedDate)
                            : 'No Date Selected'),
                      Text(''),],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => selectTime(context),
                          child: Text('Select Time'),
                        ),
                        Text(selectedTime != null
                            ? selectedTime.format(context)
                            : 'No Time Selected'),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      addTask();
                      Navigator.of(context).pop();
                      notifier.value = !notifier.value; // Update the UI after adding task
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
