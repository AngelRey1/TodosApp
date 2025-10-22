// Not required for test files
import 'dart:async';

import 'package:test/test.dart';
import 'package:todos_api/todos_api.dart';

class _FakeTodosApi implements TodosApi {
  final _controller = StreamController<List<Todo>>.broadcast();
  List<Todo> _todos = [];

  @override
  Stream<List<Todo>> getTodos() async* {
    yield _todos;
    yield* _controller.stream;
  }

  @override
  Future<void> saveTodo(Todo todo) async {
    _todos = [..._todos, todo];
    _controller.add(_todos);
  }

  @override
  Future<void> deleteTodo(String id) async {
    _todos = _todos.where((t) => t.id != id).toList();
    _controller.add(_todos);
  }

  @override
  Future<int> clearCompleted() async {
    final before = _todos.length;
    _todos = _todos.where((t) => !t.isCompleted).toList();
    _controller.add(_todos);
    return before - _todos.length;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    final beforeIncomplete = _todos
        .where((t) => t.isCompleted != isCompleted)
        .length;
    _todos = _todos
        .map((t) => t.copyWith(isCompleted: isCompleted))
        .toList();
    _controller.add(_todos);
    return beforeIncomplete;
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

void main() {
  group('TodosApi', () {
    test('fake can be instantiated', () {
      final api = _FakeTodosApi();
      expect(api, isNotNull);
    });
  });
}
