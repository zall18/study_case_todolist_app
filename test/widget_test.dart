import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_case_todolist_app/main.dart';

void main() {
  testWidgets('displays empty state, input field, and save button initially', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Catatan Harian'), findsOneWidget);
    expect(find.text('Belum ada catatan'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Simpan'), findsOneWidget);
  });

  testWidgets('ignores empty or whitespace-only input', (tester) async {
    await tester.pumpWidget(const MainApp());

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Simpan'));
    await tester.pump();

    expect(find.byType(Checkbox), findsNothing);
    expect(find.text('Judul catatan tidak boleh kosong.'), findsOneWidget);
  });

  testWidgets('adds a task, marks it as done, and deletes it', (tester) async {
    await tester.pumpWidget(const MainApp());

    await tester.enterText(find.byType(TextField), 'Belajar Flutter');
    await tester.tap(find.text('Simpan'));
    await tester.pump();

    expect(find.text('Belajar Flutter'), findsOneWidget);
    expect(find.text('0/1 selesai'), findsOneWidget);

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.controller?.text, isEmpty);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox.value, isTrue);
    expect(find.text('1/1 selesai'), findsOneWidget);

    final titleText = tester.widget<Text>(find.text('Belajar Flutter'));
    expect(titleText.style?.decoration, TextDecoration.lineThrough);

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pump();

    expect(find.text('Belajar Flutter'), findsNothing);
    expect(find.text('Belum ada catatan'), findsOneWidget);
  });

  testWidgets('submits a task via keyboard done action', (tester) async {
    await tester.pumpWidget(const MainApp());

    await tester.enterText(find.byType(TextField), 'Rapikan catatan');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.text('Rapikan catatan'), findsOneWidget);
  });
}
