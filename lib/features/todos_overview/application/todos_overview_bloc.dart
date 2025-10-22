import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';

part 'todos_overview_event.dart';
part 'todos_overview_state.dart';

class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  TodosOverviewBloc({required TodosRepository todosRepository})
    : _todosRepository = todosRepository,
      super(const TodosOverviewState.initial()) {
    on<TodosOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<TodosOverviewTodosUpdated>(_onTodosUpdated);
  }

  final TodosRepository _todosRepository;
  StreamSubscription<List<Todo>>? _todosSubscription;

  Future<void> _onSubscriptionRequested(
    TodosOverviewSubscriptionRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TodosOverviewStatus.loading));
    await _todosSubscription?.cancel();
    _todosSubscription = _todosRepository.getTodos().listen(
      (todos) => add(TodosOverviewTodosUpdated(todos)),
      onError: (_) => add(TodosOverviewTodosUpdatedFailed()),
    );
  }

  void _onTodosUpdated(
    TodosOverviewTodosUpdated event,
    Emitter<TodosOverviewState> emit,
  ) {
    if (event is TodosOverviewTodosUpdatedFailed) {
      emit(state.copyWith(status: TodosOverviewStatus.failure));
    } else {
      emit(
        state.copyWith(
          status: TodosOverviewStatus.success,
          todos: event.todos,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}
