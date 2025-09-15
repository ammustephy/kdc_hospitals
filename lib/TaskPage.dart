// import 'package:cura_kefi/Api_Services.dart';
// import 'package:flutter/material.dart';
//
// class TaskPage extends StatefulWidget {
//   const TaskPage({Key? key}) : super(key: key);
//   @override _TaskPageState createState() => _TaskPageState();
// }
//
// class _TaskPageState extends State<TaskPage> {
//   late Future<List> _taskFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _taskFuture = ApiService.fetchTasks();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Tasks')),
//       body: FutureBuilder<List>(
//         future: _taskFuture,
//         builder: (ctx, snap) {
//           if (snap.connectionState != ConnectionState.done) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snap.hasError) {
//             return Center(child: Text('Error: ${snap.error}'));
//           }
//           final tasks = snap.data!;
//           return ListView.builder(
//             itemCount: tasks.length,
//             itemBuilder: (ctx, i) => ListTile(
//               title: Text(tasks[i]['title']),
//               subtitle: Text('Completed: ${tasks[i]['completed']}'),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
