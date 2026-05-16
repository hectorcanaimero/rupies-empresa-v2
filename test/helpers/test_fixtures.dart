import 'package:rupies_empresas/backend/schema/structs/subs_data_type_struct.dart';

const kFakeToken = 'test-token-abc123';
const kBaseUrl =
    'https://ejnzgjczritznohpdnxl.supabase.co/functions/v1';

SubsDataTypeStruct activeWithCredits({int credits = 10}) =>
    SubsDataTypeStruct(
      id: 'sub-001',
      status: 'active',
      creditsRemaining: credits,
      creditsGranted: 20,
      isUnlimited: false,
      planId: 'plan-basic',
      billingCycle: 'monthly',
      planType: 'basic',
    );

SubsDataTypeStruct activeUnlimited() => SubsDataTypeStruct(
      id: 'sub-002',
      status: 'active',
      creditsRemaining: 0,
      creditsGranted: 0,
      isUnlimited: true,
      planId: 'plan-unlimited',
      billingCycle: 'monthly',
      planType: 'unlimited',
    );

SubsDataTypeStruct inactive() => SubsDataTypeStruct(
      id: 'sub-003',
      status: 'canceled',
      creditsRemaining: 0,
      creditsGranted: 0,
      isUnlimited: false,
    );

SubsDataTypeStruct activeNoCredits() => SubsDataTypeStruct(
      id: 'sub-004',
      status: 'active',
      creditsRemaining: 0,
      creditsGranted: 10,
      isUnlimited: false,
      planId: 'plan-basic',
      billingCycle: 'monthly',
      planType: 'basic',
    );
