import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'subscription_plans_page_model.dart';
export 'subscription_plans_page_model.dart';

class SubscriptionPlansPageWidget extends StatefulWidget {
  const SubscriptionPlansPageWidget({super.key});

  static String routeName = 'SubscriptionPlansPage';
  static String routePath = 'subscriptionPlansPage';

  @override
  State<SubscriptionPlansPageWidget> createState() =>
      _SubscriptionPlansPageWidgetState();
}

class _SubscriptionPlansPageWidgetState
    extends State<SubscriptionPlansPageWidget> {
  late SubscriptionPlansPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Planos v2 carregados do Supabase
  List<SubscriptionPlansRow> _planosV2 = [];
  bool _loadingPlans = true;

  // Controla se o seletor de plano está visível (para alterar plano ativo)
  bool _showPlanSelector = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionPlansPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'SubscriptionPlansPage'});

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadPlans();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _loadPlans() async {
    final plans = await SubscriptionPlansTable().queryRows(
      queryFn: (q) => q
          .eq('plan_version', 2)
          .eq('is_active', true)
          .order('sort_order', ascending: true),
    );
    if (mounted) {
      setState(() {
        _planosV2 = plans;
        _loadingPlans = false;
        // Pre-selecionar o plano gratuito (sort_order = 0)
        final freeIndex = plans.indexWhere((p) => p.planType == 'free');
        _model.selectedPlanIndex = freeIndex >= 0 ? freeIndex : 0;
        if (plans.isNotEmpty) {
          _model.selectedPlanId = plans[_model.selectedPlanIndex].id;
        }
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _formatFreeTierExpiry(DateTime? expiresAt) {
    if (expiresAt == null) return '';
    return 'Até ${DateFormat('dd/MM/yyyy').format(expiresAt.toLocal())}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ViewSubsRow>>(
      stream: _model.subscriptionPlansPageSupabaseStream ??=
          SupaFlow.client
              .from('view_subs')
              .stream(primaryKey: ['id'])
              .eqOrNull('user_id', currentUserUid)
              .map((list) => list.map((item) => ViewSubsRow(item)).toList()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final viewSubsRows = snapshot.data!;
        final activeSubscription = viewSubsRows.isNotEmpty
            ? viewSubsRows.firstWhere(
                (r) => r.status == 'active' || r.status == 'pending',
                orElse: () => viewSubsRows.first,
              )
            : null;

        final hasActiveSub = activeSubscription?.id != null &&
            activeSubscription!.id!.isNotEmpty;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  logFirebaseEvent('SUBSCRIPTION_PLANS_back_ICN_ON_TAP');
                  context.pop();
                },
              ),
              title: Text(
                'Plano Crédito por Assinatura',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                    ),
              ),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: hasActiveSub && !_showPlanSelector
                  ? _buildActiveSubscriptionView(context, activeSubscription)
                  : _buildPlanSelectorView(
                      context,
                      currentSub: hasActiveSub ? activeSubscription : null,
                    ),
            ),
          ),
        );
      },
    );
  }

  // ───────────────────────────────────────────────────────
  // Vista: ya tiene assinatura ativa
  // ───────────────────────────────────────────────────────
  Widget _buildActiveSubscriptionView(
      BuildContext context, ViewSubsRow sub) {
    final isUnlimited = sub.cbIsUnlimited ?? false;
    final creditsRemaining = sub.creditsRemaining ?? 0;
    final creditsGranted = sub.creditsGranted ?? 0;
    final isFree = sub.spIsFree ?? false;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          // Título
          Text(
            'Seu plano atual',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Recorrência no Cartão de Crédito ou PIX',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.inter(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 24.0),
          // Card do plano ativo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color(0xFF4A6CF7),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28.0,
                      height: 28.0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.circle,
                          color: Color(0xFF4A6CF7), size: 14.0),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        (sub.spName ?? 'Plano').toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18.0,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (isFree && sub.spFreeTierExpiresAt != null)
                      Text(
                        _formatFreeTierExpiry(sub.spFreeTierExpiresAt),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.0,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Saldo de créditos
                if (!isUnlimited) ...[
                  Text(
                    '$creditsRemaining de $creditsGranted créditos restantes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: LinearProgressIndicator(
                      value: creditsGranted > 0
                          ? creditsRemaining / creditsGranted
                          : 0.0,
                      backgroundColor: Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6.0,
                    ),
                  ),
                ] else
                  const Text(
                    'Créditos ilimitados',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(height: 8.0),
                Text(
                  'Status: ${sub.status ?? '-'}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          // Botão de ir para link de pagamento (se pending)
          if (sub.status == 'pending') ...[
            FFButtonWidget(
              onPressed: () async {
                logFirebaseEvent('SUBSCRIPTION_PLANS_pagamento_BTN_ON_TAP');
                await launchURL(
                    getJsonField(sub.metadata, r'''$.payment_link_url''')
                        .toString());
              },
              text: 'Ir para o Link de pagamento',
              options: FFButtonOptions(
                width: double.infinity,
                height: 48.0,
                color: FlutterFlowTheme.of(context).primary,
                textStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(height: 12.0),
          ],
          // Botão: alterar plano
          FFButtonWidget(
            onPressed: () {
              logFirebaseEvent('SUBSCRIPTION_PLANS_alterar_BTN_ON_TAP');
              setState(() {
                _showPlanSelector = true;
                // Pré-selecionar um plano diferente do atual
                if (_planosV2.isNotEmpty) {
                  final differentIndex = _planosV2.indexWhere(
                    (p) => p.id != sub.planId,
                  );
                  _model.selectedPlanIndex =
                      differentIndex >= 0 ? differentIndex : 0;
                  _model.selectedPlanId =
                      _planosV2[_model.selectedPlanIndex].id;
                }
              });
            },
            text: 'Alterar plano',
            icon: const Icon(Icons.swap_horiz, size: 16.0),
            options: FFButtonOptions(
              width: double.infinity,
              height: 48.0,
              color: Colors.transparent,
              textStyle: TextStyle(
                color: FlutterFlowTheme.of(context).primary,
                fontWeight: FontWeight.w600,
              ),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8.0),
              elevation: 0.0,
            ),
          ),
          const SizedBox(height: 16.0),
          // Suporte
          Row(
            children: [
              const Icon(Icons.headset_mic_outlined,
                  color: Color(0xFFBABABA), size: 24.0),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Em caso de dúvidas, entre em contato com o suporte.',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          FFButtonWidget(
            onPressed: () async {
              logFirebaseEvent('SUBSCRIPTION_PLANS_suporte_BTN_ON_TAP');
              await launchURL('https://wa.me/5511965939170');
            },
            text: 'Entrar em contato',
            icon: const Icon(Icons.chat_bubble_outline, size: 16.0),
            options: FFButtonOptions(
              height: 44.0,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              color: FlutterFlowTheme.of(context).secondaryText,
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────
  // Vista: seletor de planos (radio buttons)
  // ───────────────────────────────────────────────────────
  Widget _buildPlanSelectorView(BuildContext context, {ViewSubsRow? currentSub}) {
    if (_loadingPlans) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_planosV2.isEmpty) {
      return Center(
        child: Text(
          'Nenhum plano disponível no momento.',
          style: FlutterFlowTheme.of(context).bodyMedium,
        ),
      );
    }

    final selectedPlan = _model.selectedPlanIndex < _planosV2.length
        ? _planosV2[_model.selectedPlanIndex]
        : null;

    final isFreePlanSelected = selectedPlan?.planType == 'free' ||
        selectedPlan?.isFree == true;

    final isChangingPlan = currentSub != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          // Header com botão voltar quando está alterando plano
          if (isChangingPlan)
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _showPlanSelector = false),
                  child: const Icon(Icons.arrow_back_ios, size: 18.0),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Alterar plano',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ],
            )
          else
            Text(
              'Plano Crédito por Assinatura',
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    letterSpacing: 0.0,
                  ),
            ),
          const SizedBox(height: 4.0),
          Text(
            isChangingPlan
                ? 'Seu plano atual: ${currentSub.spName ?? '-'}'
                : 'Recorrência no Cartão de Crédito ou PIX',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.inter(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 24.0),
          // Radio list de planos
          ...List.generate(_planosV2.length, (index) {
            final plan = _planosV2[index];
            final isSelected = _model.selectedPlanIndex == index;
            // Quando alterando, marcar o plano atual com indicador
            final isCurrentPlan = currentSub != null && plan.id == currentSub.planId;
            return _buildPlanTile(
              context, plan, index, isSelected,
              isCurrentPlan: isCurrentPlan,
            );
          }),
          const SizedBox(height: 32.0),
          // Botão principal
          _model.isCreating
              ? const Center(child: CircularProgressIndicator())
              : FFButtonWidget(
                  onPressed: () async {
                    logFirebaseEvent('SUBSCRIPTION_PLANS_assinar_BTN_ON_TAP');
                    await _handleSubscribe(
                      context,
                      selectedPlan,
                      currentSub: currentSub,
                    );
                  },
                  text: isFreePlanSelected
                      ? 'Ativar plano gratuito'
                      : isChangingPlan
                          ? 'Confirmar alteração'
                          : 'Assinar',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 52.0,
                    color: const Color(0xFF4A6CF7),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    elevation: 0.0,
                  ),
                ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _buildPlanTile(
    BuildContext context,
    SubscriptionPlansRow plan,
    int index,
    bool isSelected, {
    bool isCurrentPlan = false,
  }) {
    final isFree = plan.planType == 'free' || plan.isFree == true;
    final hasTag = !isFree;
    final tagText = plan.sortOrder == 1
        ? 'PLANO 1'
        : plan.sortOrder == 2
            ? 'PLANO 2'
            : null;

    return GestureDetector(
      onTap: () {
        setState(() {
          _model.selectedPlanIndex = index;
          _model.selectedPlanId = plan.id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4A6CF7)
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A6CF7)
                : FlutterFlowTheme.of(context).alternate,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 18.0),
              child: Row(
                children: [
                  // Radio button
                  Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 10.0,
                              height: 10.0,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16.0),
                  // Nome do plano
                  Expanded(
                    child: Text(
                      _getPlanDisplayName(plan).toUpperCase(),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.w800,
                        fontSize: 16.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  // Preço ou expiry
                  if (isFree && plan.freeTierExpiresAt != null)
                    Text(
                      _formatFreeTierExpiry(plan.freeTierExpiresAt),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white70
                            : FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                      ),
                    )
                  else if (!isFree && plan.priceMonthly != null)
                    Text(
                      'R\$ ${plan.priceMonthly!.toStringAsFixed(2).replaceAll('.', ',')}/ mês',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF4A6CF7),
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                      ),
                    ),
                ],
              ),
            ),
            // Badge "Plano atual" (quando alterando)
            if (isCurrentPlan)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.25)
                        : FlutterFlowTheme.of(context).secondaryText,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'ATUAL',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.0,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              )
            // Tag do plano (PLANO 1 / PLANO 2)
            else if (hasTag && tagText != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A6CF7),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    tagText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.0,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getPlanDisplayName(SubscriptionPlansRow plan) {
    if (plan.planType == 'free') return 'Gratuito';
    if (plan.isUnlimited == true) return 'Ilimitado';
    final credits = plan.creditsPerMonth;
    if (credits != null) return '$credits Créditos';
    return plan.name;
  }

  Future<void> _handleSubscribe(
    BuildContext context,
    SubscriptionPlansRow? plan, {
    ViewSubsRow? currentSub,
  }) async {
    if (plan == null) return;

    // Não permite assinar o mesmo plano que já está ativo
    if (currentSub != null && plan.id == currentSub.planId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este já é o seu plano atual.')),
      );
      return;
    }

    setState(() => _model.isCreating = true);

    try {
      // Se está alterando plano, cancela o atual antes
      if (currentSub != null && currentSub.id != null) {
        final cancelResult = await actions.cancelSubscription(
          currentSub.id!,
          true,
          'plan_change',
        );
        if (cancelResult is Map && cancelResult['success'] == false) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(cancelResult['error']?.toString() ??
                    'Erro ao cancelar plano atual'),
              ),
            );
          }
          return;
        }
      }

      final result = await actions.createSubscription(
        plan.id,
        'monthly',
        'pix',
      );

      if (result is Map && result['success'] == false) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['error']?.toString() ??
                  'Erro ao criar assinatura'),
            ),
          );
        }
        return;
      }

      // Plano gratuito: ativado diretamente
      if (result is Map && result['isFree'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Plano gratuito ativado com sucesso!')),
          );
          context.pop();
        }
        return;
      }

      // Plano pago: abrir link de pagamento
      final paymentLink = result is Map ? result['paymentLink'] as String? : null;
      if (mounted) {
        setState(() => _showPlanSelector = false);
        if (paymentLink != null && paymentLink.isNotEmpty) {
          await launchURL(paymentLink);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Assinatura criada! Aguardando pagamento.')),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _model.isCreating = false);
    }
  }
}
