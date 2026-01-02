import '/flutter_flow/flutter_flow_util.dart';
import 'subscription_checkout_page_widget.dart'
    show SubscriptionCheckoutPageWidget;
import 'package:flutter/material.dart';

class SubscriptionCheckoutPageModel
    extends FlutterFlowModel<SubscriptionCheckoutPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Subscription data from previous page
  dynamic subscriptionData;

  // Payment method selection
  String selectedPaymentMethod = 'pix'; // 'pix', 'boleto', 'credit_card'

  // Payment status
  bool isProcessingPayment = false;
  bool paymentCompleted = false;
  String? paymentError;

  // QR Code data for PIX
  String? pixQrCode;
  String? pixCopyPaste;

  // Boleto URL
  String? boletoUrl;

  // Subscription ID
  String? subscriptionId;

  @override
  void initState(BuildContext context) {
    // Initialization
  }

  @override
  void dispose() {
    // Cleanup
  }

  /// Set subscription data from navigation
  void setSubscriptionData(dynamic data) {
    subscriptionData = data;

    // Extract payment details
    if (data != null) {
      subscriptionId = data['subscriptionId'];
      pixQrCode = data['pixQrCode'];
      pixCopyPaste = data['pixCopyPaste'];
      boletoUrl = data['invoiceUrl'];

      // Determine payment method from data
      if (pixQrCode != null) {
        selectedPaymentMethod = 'pix';
      } else if (boletoUrl != null) {
        selectedPaymentMethod = 'boleto';
      }
    }
  }

  /// Select payment method
  void selectPaymentMethod(String method) {
    selectedPaymentMethod = method;
  }
}
