part of 'todos_overview_bloc.dart';

abstract class TodosOverviewEvent {}

class TodosOverviewSubscriptionRequested extends TodosOverviewEvent {}

class TodosOverviewTodosUpdated extends TodosOverviewEvent {
  TodosOverviewTodosUpdated(this.todos);

  final List<Todo> todos;
}

class TodosOverviewTodosUpdatedFailed extends TodosOverviewTodosUpdated {
  TodosOverviewTodosUpdatedFailed() : super(const []);
}
