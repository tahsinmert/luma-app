import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Database table for vault entries
class Entries extends Table {
  TextColumn get id => text()();
  IntColumn get type => integer()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get tags => text().withDefault(const Constant(''))();
  TextColumn get emotion => text().nullable()();
  TextColumn get filePath => text().nullable()();
  TextColumn get transcription => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift database for encrypted local storage
@DriftDatabase(tables: [Entries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Entry operations
  Future<List<Entry>> getAllEntries() => select(entries).get();

  Future<List<Entry>> getEntriesByType(int type) =>
      (select(entries)..where((tbl) => tbl.type.equals(type))).get();

  Future<Entry?> getEntryById(String id) =>
      (select(entries)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertEntry(EntriesCompanion entry) =>
      into(entries).insert(entry);

  Future<bool> updateEntry(EntriesCompanion entry) =>
      update(entries).replace(entry);

  Future<int> deleteEntry(String id) =>
      (delete(entries)..where((tbl) => tbl.id.equals(id))).go();

  Future<List<Entry>> searchEntries(String query) async {
    final lowercaseQuery = query.toLowerCase();
    return (select(entries)
          ..where((tbl) =>
              tbl.title.lower().like('%$lowercaseQuery%') |
              tbl.content.lower().like('%$lowercaseQuery%') |
              tbl.tags.lower().like('%$lowercaseQuery%') |
              tbl.transcription.lower().like('%$lowercaseQuery%')))
        .get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'vault.db'));
    return NativeDatabase(file);
  });
}
