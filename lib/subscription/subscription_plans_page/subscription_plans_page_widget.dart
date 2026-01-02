import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'subscription_plans_page_model.dart';
export 'subscription_plans_page_model.dart';

class SubscriptionPlansPageWidget extends StatefulWidget {
  const SubscriptionPlansPageWidget({super.key});

  static String routeName = 'SubscriptionPlansPage';
  static String routePath = '/subscriptionPlansPage';

  @override
  State<SubscriptionPlansPageWidget> createState() =>
      _SubscriptionPlansPageWidgetState();
}

class _SubscriptionPlansPageWidgetState
    extends State<SubscriptionPlansPageWidget> {
  late SubscriptionPlansPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionPlansPageModel());
    _loadData();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _model.isLoading = true;
      _model.errorMessage = null;
    });

    try {
      // Load subscription plans
      final plansResponse = await SupaFlow.client
          .from('subscription_plans')
          .select()
          .eq('is_active', true)
          .order('sort_order')
          .order('created_at');

      _model.subscriptionPlans = (plansResponse as List)
          .map((plan) => SubscriptionPlansRow(plan))
          .toList();

      // Load current subscription status
      _model.currentSubscriptionStatus =
          await actions.getSubscriptionStatus();

      setState(() {
        _model.isLoading = false;
      });
    } catch (e) {
      setState(() {
        _model.isLoading = false;
        _model.errorMessage = 'Erro ao carregar planos: $e';
      });
    }
  }

  Future<void> _createSubscription() async {
    if (_model.selectedPlanId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um plano')),
      );
      return;
    }

    setState(() {
      _model.isCreatingSubscription = true;
      _model.errorMessage = null;
    });

    try {
      final result = await actions.createSubscription(
        _model.selectedPlanId!,
        _model.selectedBillingCycle ?? 'monthly',
        'pix', // Default payment method, can be changed
      );

      setState(() {
        _model.isCreatingSubscription = false;
      });

      if (result != null && result['success'] == true) {
        // Navigate to checkout page with payment details
        context.pushNamed(
          'SubscriptionCheckoutPage',
          queryParameters: {
            'subscriptionData': serializeParam(
              result,
              ParamType.JSON,
            ),
          },
        );
      } else {
        setState(() {
          _model.errorMessage =
              result?['error'] ?? 'Erro ao criar assinatura';
        });
      }
    } catch (e) {
      setState(() {
        _model.isCreatingSubscription = false;
        _model.errorMessage = 'Erro: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Clube dos 100',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: _model.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                )
              : _model.errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: FlutterFlowTheme.of(context).error,
                              size: 60.0,
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              _model.errorMessage!,
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context).error,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            SizedBox(height: 16.0),
                            FFButtonWidget(
                              onPressed: _loadData,
                              text: 'Tentar Novamente',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header Section
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  FlutterFlowTheme.of(context).primary,
                                  FlutterFlowTheme.of(context).secondary,
                                ],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Escolha seu Plano',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineLarge
                                        .override(
                                          fontFamily: 'Outfit',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Desbloqueie todo o potencial do Rupies',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Billing Cycle Toggle
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildBillingCycleButton('Mensal', 'monthly'),
                                SizedBox(width: 16.0),
                                _buildBillingCycleButton('Anual', 'yearly'),
                              ],
                            ),
                          ),

                          // Plans List
                          if (_model.subscriptionPlans != null &&
                              _model.subscriptionPlans!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _model.subscriptionPlans!.length,
                                itemBuilder: (context, index) {
                                  final plan =
                                      _model.subscriptionPlans![index];
                                  final isSelected =
                                      _model.selectedPlanId == plan.id;
                                  final price =
                                      _model.selectedBillingCycle == 'yearly'
                                          ? plan.priceYearly
                                          : plan.priceMonthly;

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _model.selectPlan(plan.id);
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                                  .withOpacity(0.1)
                                              : FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: isSelected
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                : FlutterFlowTheme.of(context)
                                                    .alternate,
                                            width: isSelected ? 2.0 : 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    plan.name,
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineSmall
                                                            .override(
                                                              fontFamily:
                                                                  'Outfit',
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                  ),
                                                  if (isSelected)
                                                    Icon(
                                                      Icons.check_circle,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      size: 24.0,
                                                    ),
                                                ],
                                              ),
                                              if (plan.description != null)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 8.0),
                                                  child: Text(
                                                    plan.description!,
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                  ),
                                                ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'R\$',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                    ),
                                                    Text(
                                                      price != null
                                                          ? price
                                                              .toStringAsFixed(
                                                                  2)
                                                          : '0.00',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displaySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Outfit',
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                    ),
                                                    Text(
                                                      _model.selectedBillingCycle ==
                                                              'yearly'
                                                          ? '/ano'
                                                          : '/mês',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          // Subscribe Button
                          Padding(
                            padding: EdgeInsets.all(24.0),
                            child: FFButtonWidget(
                              onPressed: _model.isCreatingSubscription
                                  ? null
                                  : _createSubscription,
                              text: _model.isCreatingSubscription
                                  ? 'Processando...'
                                  : 'Continuar para Pagamento',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(25.0),
                                disabledColor:
                                    FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildBillingCycleButton(String label, String cycle) {
    final isSelected = _model.selectedBillingCycle == cycle;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _model.selectBillingCycle(cycle);
          });
        },
        child: Container(
          height: 44.0,
          decoration: BoxDecoration(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(22.0),
            border: Border.all(
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: isSelected
                        ? Colors.white
                        : FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
