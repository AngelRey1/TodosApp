// Ignore for testing purposes

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:javerage_todos/app/app.dart';
import 'package:javerage_todos/features/todos_overview/presentation/todos_overview_page.dart';
import 'package:todos_repository/todos_repository.dart';

class _FakeTodosRepository implements TodosRepository {
  final _controller = StreamController<List<Todo>>.broadcast();

  @override
  Stream<List<Todo>> getTodos() async* {
    yield const [];
    yield* _controller.stream;
  }

  @override
  Future<void> saveTodo(Todo todo) async {}

  @override
  Future<void> deleteTodo(String id) async {}

  @override
  Future<int> clearCompleted() async => 0;

  @override
  Future<int> completeAll({required bool isCompleted}) async => 0;

  @override
  void dispose() {}
}

void main() {
  group('App', () {
    testWidgets('renders TodosOverviewPage', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<TodosRepository>(
          create: (_) => _FakeTodosRepository(),
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TodosOverviewPage), findsOneWidget);
    });
  });
}
