import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:javerage_todos/features/todos_overview/application/todos_overview_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodosOverviewBloc>(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(TodosOverviewSubscriptionRequested()),
      child: const _TodosOverviewView(),
    );
  }
}

class _TodosOverviewView extends StatelessWidget {
  const _TodosOverviewView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos Overview')),
      body: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
        builder: (context, state) {
          switch (state.status) {
            case TodosOverviewStatus.initial:
            case TodosOverviewStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case TodosOverviewStatus.failure:
              return const Center(child: Text('Failed to load todos'));
            case TodosOverviewStatus.success:
              final todos = state.todos;
              if (todos.isEmpty) {
                return const Center(child: Text('No todos'));
              }
              return ListView.separated(
                itemCount: todos.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1),
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo.title),
                    subtitle: todo.description.isEmpty
                        ? null
                        : Text(todo.description),
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: null,
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
