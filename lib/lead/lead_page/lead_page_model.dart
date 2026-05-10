import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/nav_bar_widget/nav_bar_widget_widget.dart';
import '/widgets/user_widget/user_widget_widget.dart';
import '/index.dart';
import 'lead_page_widget.dart' show LeadPageWidget;
import 'package:flutter/material.dart';

class LeadPageModel extends FlutterFlowModel<LeadPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for UserWidget component.
  late UserWidgetModel userWidgetModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for navBarWidget component.
  late NavBarWidgetModel navBarWidgetModel;

  // Cache de TypeProviderRow indexado por id para evitar N+1 queries.
  Map<String, TypeProviderRow> typeProviderCache = {};

  /// Carrega leads disponíveis (não do usuário atual) e prefetch os TypeProviders
  /// em uma única query batch, populando [typeProviderCache].
  Future<List<LeadsRow>> fetchLeadsAvailable(String currentUserUid) async {
    final leads = await LeadsTable().queryRows(
      queryFn: (q) => q
          .neqOrNull('userId', currentUserUid)
          .eqOrNull('finished', false)
          .order('created_at'),
    );
    await _prefetchTypeProviders(leads);
    return leads;
  }

  /// Carrega leads do usuário atual e prefetch os TypeProviders
  /// em uma única query batch, populando [typeProviderCache].
  Future<List<LeadsRow>> fetchLeadsOwned(String currentUserUid) async {
    final leads = await LeadsTable().queryRows(
      queryFn: (q) => q
          .eqOrNull('userId', currentUserUid)
          .order('created_at'),
    );
    await _prefetchTypeProviders(leads);
    return leads;
  }

  Future<void> _prefetchTypeProviders(List<LeadsRow> leads) async {
    final ids = leads
        .map((l) => l.typeFornecedor)
        .whereType<String>()
        .toSet()
        .toList();
    if (ids.isEmpty) return;
    final rows = await TypeProviderTable().queryRows(
      queryFn: (q) => q.inFilterOrNull('id', ids),
    );
    for (final row in rows) {
      typeProviderCache[row.id] = row;
    }
  }

  @override
  void initState(BuildContext context) {
    userWidgetModel = createModel(context, () => UserWidgetModel());
    navBarWidgetModel = createModel(context, () => NavBarWidgetModel());
  }

  @override
  void dispose() {
    userWidgetModel.dispose();
    tabBarController?.dispose();
    navBarWidgetModel.dispose();
  }
}
