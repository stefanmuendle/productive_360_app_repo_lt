// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// import '../../models/habit.dart';

// Future<void> addHabit(Habit habit) async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     throw Exception('User not authenticated');
//   }

//   await FirebaseFirestore.instance
//       .collection('users')
//       .doc(user.uid)
//       .collection('habits')
//       .add(habit.toJson()); // <-- Use the toJson method directly
// }

// //TODO: add # ...
// // target 'Runner' do
// //   pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => '8.15.0'
// // # ...
// // end

// class DatabaseService {
//   // This class will handle
//   final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

//   Future<void> create({required String path, required String data}) async {
//     final DatabaseReference ref = _firebaseDatabase.ref().child(path);
//     await ref.set(data);
//   }

//   //Read
//   Future<DataSnapshot?> read({required String path}) async {
//     final DatabaseReference ref = _firebaseDatabase.ref().child(path);
//     final DataSnapshot snapshot = await ref.get();

//     return snapshot.exists ? snapshot : null;
//   }

//   //Update
//   Future<void> update({
//     required String path,
//     required Map<String, dynamic> data,
//   }) async {
//     final DatabaseReference ref = _firebaseDatabase.ref().child(path);
//     await ref.update(data);
//   }

//   //Delete
//   Future<void> delete({required String path}) async {
//     final DatabaseReference ref = _firebaseDatabase.ref().child(path);
//     await ref.remove();
//   }
// }

// Future<void> updateHabit(Habit habit) async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     throw Exception('User not authenticated');
//   }

//   // Find the habit document by a unique field, e.g. name
//   final habitsRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user.uid)
//       .collection('habits');

//   final query = await habitsRef.where('name', isEqualTo: habit.name).get();

//   if (query.docs.isNotEmpty) {
//     // Update the first matching habit
//     await query.docs.first.reference.set(
//       habit.toJson(),
//       SetOptions(merge: true),
//     );
//   } else {
//     // If not found, add as new
//     await habitsRef.add(habit.toJson());
//   }
// }

// Future<List<Habit>> loadHabits() async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     throw Exception('User not authenticated');
//   }

//   final habitsRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user.uid)
//       .collection('habits');

//   final snapshot = await habitsRef.get();
//   List<Habit> habits = [];
//   for (final doc in snapshot.docs) {
//     final data = doc.data();
//     habits.add(
//       Habit(
//           name: data['name'],
//           icon: IconData(
//             data['icon'] is int
//                 ? data['icon']
//                 : int.tryParse(data['icon'].toString()) ??
//                       Icons.help_outline.codePoint,
//             fontFamily: data['iconFontFamily'] ?? 'MaterialIcons',
//           ),
//           type: HabitType.values[data['type']],
//           durationToComplete: Duration(minutes: data['durationToComplete']),
//         )
//         ..records.addAll(
//           (data['records'] as Map<String, dynamic>? ?? {}).map(
//             (k, v) => MapEntry(
//               k,
//               HabitDayRecord(
//                 date: DateTime.parse(v['date']),
//                 isCompleted: v['isCompleted'] ?? false,
//                 timeSpent: Duration(minutes: v['timeSpent'] ?? 0),
//               ),
//             ),
//           ),
//         ),
//     );
//   }
//   return habits;
// }

// Future<void> deleteHabit(Habit habit) async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     throw Exception('User not authenticated');
//   }

//   final habitsRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user.uid)
//       .collection('habits');

//   // Find the habit document by a unique field, e.g. name
//   final query = await habitsRef.where('name', isEqualTo: habit.name).get();

//   for (final doc in query.docs) {
//     await doc.reference.delete();
//   }
// }

// Stream<List<Habit>> habitsStream() {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     // Return an empty stream if not authenticated
//     return Stream.value([]);
//   }

//   final habitsRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user.uid)
//       .collection('habits');

//   return habitsRef.snapshots().map((snapshot) {
//     return snapshot.docs.map((doc) {
//       final data = doc.data();
//       return Habit(
//           name: data['name'],
//           icon: IconData(
//             data['icon'] is int
//                 ? data['icon']
//                 : int.tryParse(data['icon'].toString()) ??
//                       Icons.help_outline.codePoint,
//             fontFamily: data['iconFontFamily'] ?? 'MaterialIcons',
//           ),
//           type: HabitType.values[data['type']],
//           durationToComplete: Duration(minutes: data['durationToComplete']),
//         )
//         ..records.addAll(
//           (data['records'] as Map<String, dynamic>? ?? {}).map(
//             (k, v) => MapEntry(
//               k,
//               HabitDayRecord(
//                 date: DateTime.parse(v['date']),
//                 isCompleted: v['isCompleted'] ?? false,
//                 timeSpent: Duration(minutes: v['timeSpent'] ?? 0),
//               ),
//             ),
//           ),
//         );
//     }).toList();
//   });
// }
