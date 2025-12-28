import '../database.dart';

class ServicesRatingTable extends SupabaseTable<ServicesRatingRow> {
  @override
  String get tableName => 'services_rating';

  @override
  ServicesRatingRow createRow(Map<String, dynamic> data) =>
      ServicesRatingRow(data);
}

class ServicesRatingRow extends SupabaseDataRow {
  ServicesRatingRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServicesRatingTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get serviceId => getField<String>('serviceId');
  set serviceId(String? value) => setField<String>('serviceId', value);

  String? get contractorComment => getField<String>('contractor_comment');
  set contractorComment(String? value) =>
      setField<String>('contractor_comment', value);

  double? get contractorRating => getField<double>('contractor_rating');
  set contractorRating(double? value) =>
      setField<double>('contractor_rating', value);

  String? get prestadorComment => getField<String>('prestador_comment');
  set prestadorComment(String? value) =>
      setField<String>('prestador_comment', value);

  double? get prestadorRating => getField<double>('prestador_rating');
  set prestadorRating(double? value) =>
      setField<double>('prestador_rating', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get contractor => getField<String>('contractor');
  set contractor(String? value) => setField<String>('contractor', value);

  String? get prestador => getField<String>('prestador');
  set prestador(String? value) => setField<String>('prestador', value);
}
