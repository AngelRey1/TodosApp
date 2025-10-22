part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

class TodosOverviewState extends Equatable {
  const TodosOverviewState._({
    required this.status,
    required this.todos,
  });

  const TodosOverviewState.initial()
      : this._(status: TodosOverviewStatus.initial, todos: const []);

  final TodosOverviewStatus status;
  final List<Todo> todos;

  TodosOverviewState copyWith({
    TodosOverviewStatus? status,
    List<Todo>? todos,
  }) {
    return TodosOverviewState._(
      status: status ?? this.status,
      todos: todos ?? this.todos,
    );
  }

  @override
  List<Object> get props => [status, todos];
}
