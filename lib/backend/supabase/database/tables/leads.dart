import '../database.dart';

class LeadsTable extends SupabaseTable<LeadsRow> {
  @override
  String get tableName => 'leads';

  @override
  LeadsRow createRow(Map<String, dynamic> data) => LeadsRow(data);
}

class LeadsRow extends SupabaseDataRow {
  LeadsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LeadsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get typeFornecedor => getField<String>('type_fornecedor');
  set typeFornecedor(String? value) =>
      setField<String>('type_fornecedor', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  DateTime? get dataField => getField<DateTime>('data');
  set dataField(DateTime? value) => setField<DateTime>('data', value);

  int? get qtd => getField<int>('qtd');
  set qtd(int? value) => setField<int>('qtd', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);

  String? get perfilPublico => getField<String>('perfil_publico');
  set perfilPublico(String? value) => setField<String>('perfil_publico', value);

  String? get fornecedorWait => getField<String>('fornecedor_wait');
  set fornecedorWait(String? value) =>
      setField<String>('fornecedor_wait', value);

  String? get orcamento => getField<String>('orcamento');
  set orcamento(String? value) => setField<String>('orcamento', value);

  DateTime? get prazoRetorno => getField<DateTime>('prazo_retorno');
  set prazoRetorno(DateTime? value) =>
      setField<DateTime>('prazo_retorno', value);

  String? get contatoDuvida => getField<String>('contato_duvida');
  set contatoDuvida(String? value) => setField<String>('contato_duvida', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get userId => getField<String>('userId');
  set userId(String? value) => setField<String>('userId', value);

  String? get zipCode => getField<String>('zipCode');
  set zipCode(String? value) => setField<String>('zipCode', value);

  bool? get endRegister => getField<bool>('endRegister');
  set endRegister(bool? value) => setField<bool>('endRegister', value);

  bool? get finished => getField<bool>('finished');
  set finished(bool? value) => setField<bool>('finished', value);
}
