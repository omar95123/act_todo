import 'package:flutter/material.dart';
import 'package:todoapp2/bloc.dart';
import 'package:todoapp2/model/model.dart';

Widget defaultFormFiled({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  Function()? onTap,
  bool? enabled = true,
  required String? Function(dynamic value) validator,
}) =>
    TextFormField(
      enabled: enabled,
      controller: controller,
      keyboardType: type,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(TaskModel model, context, doneColor) => Dismissible(
      onDismissed: (directional) {
        AppBloc.taskBloc.deleteData(
          id: model.id,
        );
      },
      background: Container(
        color: Colors.red,
        child: const Center(
          child: Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      key: Key(model.id.toString()),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 40.0,
                child: Text(
                  model.time,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      model.description,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      model.date,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              IconButton(
                onPressed: () {
                  AppBloc.taskBloc.updateData(
                    status: 'done',
                    id: model.id,
                  );
                },
                icon: const Icon(Icons.check_circle),
                color: doneColor,
              ),
            ],
          ),
        ),
      ),
    );

Widget taskBuilder({
  required List<TaskModel> tasks,
  required Color bottomColor,
}) =>
    ListView.separated(
      itemBuilder: (context, index) =>
          buildTaskItem(tasks[index], context, bottomColor),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20.0,
        ),
        child: Container(
          width: double.infinity,
          color: Colors.grey[300],
        ),
      ),
      itemCount: tasks.length,
    );
