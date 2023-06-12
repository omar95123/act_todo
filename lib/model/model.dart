class TaskModel {
  final int id;
  final String title;
  final String description;
  final String time;
  final String date;

  TaskModel(this.id,
      {required this.title,
      required this.date,
      required this.description,
      required this.time});
}
