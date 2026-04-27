import '../database.dart';

class SubscriptionPlansTable extends SupabaseTable<SubscriptionPlansRow> {
  @override
  String get tableName => 'subscription_plans';

  @override
  SubscriptionPlansRow createRow(Map<String, dynamic> data) =>
      SubscriptionPlansRow(data);
}

class SubscriptionPlansRow extends SupabaseDataRow {
  SubscriptionPlansRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubscriptionPlansTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  double? get priceMonthly => getField<double>('price_monthly');
  set priceMonthly(double? value) => setField<double>('price_monthly', value);

  double? get priceYearly => getField<double>('price_yearly');
  set priceYearly(double? value) => setField<double>('price_yearly', value);

  String? get asaasPlanId => getField<String>('asaas_plan_id');
  set asaasPlanId(String? value) => setField<String>('asaas_plan_id', value);

  dynamic get features => getField<dynamic>('features')!;
  set features(dynamic value) => setField<dynamic>('features', value);

  int? get maxServicesPerMonth => getField<int>('max_services_per_month');
  set maxServicesPerMonth(int? value) =>
      setField<int>('max_services_per_month', value);

  int? get maxContractorsContacted =>
      getField<int>('max_contractors_contacted');
  set maxContractorsContacted(int? value) =>
      setField<int>('max_contractors_contacted', value);

  bool? get prioritySupport => getField<bool>('priority_support');
  set prioritySupport(bool? value) => setField<bool>('priority_support', value);

  bool? get featuredListing => getField<bool>('featured_listing');
  set featuredListing(bool? value) => setField<bool>('featured_listing', value);

  bool? get analyticsDashboard => getField<bool>('analytics_dashboard');
  set analyticsDashboard(bool? value) =>
      setField<bool>('analytics_dashboard', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  String? get image2 => getField<String>('image2');
  set image2(String? value) => setField<String>('image2', value);

  String? get image3 => getField<String>('image3');
  set image3(String? value) => setField<String>('image3', value);
}
