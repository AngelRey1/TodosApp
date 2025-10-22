import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:javerage_todos/features/edit_todo/view/edit_todo_page.dart';
import 'package:javerage_todos/features/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:javerage_todos/features/todos_overview/widgets/widgets.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const TodosOverviewSubscriptionRequested()),
      child: const TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use literal strings here to avoid depending on generated localization
    // getters while the localization generator may not be up-to-date in this
    // environment. These match the English ARB defaults.
    const appBarTitle = 'Flutter Todos';
    const errorSnackbarText = 'An error occurred while loading todos.';
    const emptyText = 'No todos found with the selected filters.';

    return Scaffold(
      appBar: AppBar(
        title: const Text(appBarTitle),
        actions: const [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text(errorSnackbarText),
                    ),
                  );
              }
            },
          ),
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTodo != current.lastDeletedTodo &&
                current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      'Todo "${deletedTodo.title}" deleted.',
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context.read<TodosOverviewBloc>().add(
                          const TodosOverviewUndoDeletionRequested(),
                        );
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != TodosOverviewStatus.success) {
                return const SizedBox();
              } else {
                return const Center(
                  child: Text(
                    emptyText,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
              child: ListView.builder(
                itemCount: state.filteredTodos.length,
                itemBuilder: (_, index) {
                  final todo = state.filteredTodos.elementAt(index);
                  return TodoListTile(
                    todo: todo,
                    onToggleCompleted: (isCompleted) {
                      context.read<TodosOverviewBloc>().add(
                        TodosOverviewTodoCompletionToggled(
                          todo: todo,
                          isCompleted: isCompleted,
                        ),
                      );
                    },
                    onDismissed: (_) {
                      context.read<TodosOverviewBloc>().add(
                        TodosOverviewTodoDeleted(todo),
                      );
                    },
                    onTap: () {
                      // We intentionally don't await navigation here; handle any
                      // follow-up when the pushed route completes elsewhere.
                      // Use unawaited to make our intent explicit.
                      // ignore: discarded_futures
                      Navigator.of(context).push(
                        EditTodoPage.route(
                          initialTodo: todo,
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ignore: discarded_futures
          Navigator.of(context).push(EditTodoPage.route());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
