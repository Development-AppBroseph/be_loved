// ignore_for_file: public_member_api_docs

abstract class NetworkSettings {
  static const String domainRelease = 'securepayments.sberbank.ru';
  static const String domainDebug = '3dsec.sberbank.ru';
  static const String apiPath = 'payment/';

  static const String contentType = 'content-type';
  static const String contentTypeJson = 'application/json';
  static const String contentTypeFormUrlencoded =
      'application/x-www-form-urlencoded';
  static const Map<String, String> baseHeaders = <String, String>{
    contentType: contentTypeFormUrlencoded,
  };

  static const Duration timeout = Duration(seconds: 40);
}

abstract class ApiMethods {
  static const String register = 'rest/register.do';
  static const String registerPreAuth = 'rest/registerPreAuth.do';
  static const String deposit = 'rest/deposit.do';
  static const String reverse = 'rest/reverse.do';
  static const String refund = 'rest/refund.do';
  static const String getOrderStatusExtended = 'rest/getOrderStatusExtended.do';
  static const String verifyEnrollment = 'rest/verifyEnrollment.do';
  static const String applePay = 'applepay/payment.do';
  static const String applePayRecurrent = 'recurrentPayment.do';
  static const String googlePay = 'google/payment.do';
  static const String decline = 'rest/decline.do';
  static const String getReceiptStatus = 'rest/getReceiptStatus.do';
  static const String unBindCard = 'rest/unBindCard.do';
  static const String bindCard = 'rest/bindCard.do';
  static const String getBindings = 'rest/getBindings.do';
  static const String getAllBindings = 'rest/getAllBindings.do';
  static const String getBindingsByCardOrId = 'rest/getBindingsByCardOrId.do';
  static const String extendBinding = 'rest/extendBinding.do';
  static const String createBindingNoPayment = 'rest/createBindingNoPayment.do';
}

abstract class JsonValues {
  static const String desktop = 'DESKTOP';
  static const String mobile = 'MOBILE';
  static const String autoPayment = 'AUTO_PAYMENT';
  static const String verify = 'VERIFY';
  static const String forceTDS = 'FORCE_TDS';
  static const String forceSSL = 'FORCE_SSL';
  static const String forceFullTDS = 'FORCE_FULL_TDS';
  static const String ios = 'ios';
  static const String android = 'android';
  static const int registeredNotPaid = 0;
  static const int preAuthorized = 1;
  static const int fullAuthorization = 2;
  static const int authorizationCanceled = 3;
  static const int refaundTransactions = 4;
  static const int authorizationThroughIssuingBank = 5;
  static const int authorizationDenied = 6;
  static const String card = 'CARD';
  static const String cardBinding = 'CARD_BINDING';
  static const String cardMoto = 'CARD_MOTO';
  static const String cardPresent = 'CARD_PRESENT';
  static const String sberSbol = 'SBRF_SBOL';
  static const String upop = 'UPOP';
  static const String fileBinding = 'FILE_BINDING';
  static const String smsBinding = 'SMS_BINDING';
  static const String p2p = 'P2P';
  static const String p2pBinding = 'P2P_BINDING';
  static const String paypal = 'PAYPAL';
  static const String mts = 'MTS';
  static const String applePay = 'APPLE_PAY';
  static const String applePayBinding = 'APPLE_PAY_BINDING';
  static const String androidPay = 'ANDROID_PAY';
  static const String androidPayBinding = 'ANDROID_PAY_BINDING';
  static const String googlePayCard = 'GOOGLE_PAY_CARD';
  static const String googlePayCardBinding = 'GOOGLE_PAY_CARD_BINDING';
  static const String googlePayTokenized = 'GOOGLE_PAY_TOKENIZED';
  static const String googlePayTokenizedBinding =
      'GOOGLE_PAY_TOKENIZED_BINDING';
  static const String samsungPay = 'SAMSUNG_PAY';
  static const String samsungPayBinding = 'SAMSUNG_PAY_BINDING';
  static const String iPOS = 'IPOS';
  static const String sberPay = 'SBERPAY';
  static const String sberId = 'SBERID';
  static const String visa = 'VISA';
  static const String mastercard = 'MASTERCARD';
  static const String amex = 'AMEX';
  static const String jcb = 'JCB';
  static const String cup = 'CUP';
  static const String mir = 'MIR';
  static const String a = 'A';
  static const String b = 'B';
  static const String c = 'С';
  static const String d = 'D';
  static const String e = 'E';
  static const String f = 'F';
  static const String y = 'Y';
  static const String n = 'N';
  static const String u = 'U';
  static const String i = 'I';
  static const String r = 'R';
  static const String rc = 'RC';
  static const String created = 'CREATED';
  static const String approved = 'APPROVED';
  static const String deposited = 'DEPOSITED';
  static const String declined = 'DECLINED';
  static const String reversed = 'REVERSED';
  static const String refunded = 'REFUNDED';
  static const int paymentSent = 0;
  static const int paymentDelivered = 1;
  static const int paymentError = 2;
  static const int refundSent = 3;
  static const int refundDelivered = 4;
  static const int refundError = 5;
  static const String ecv1 = 'ECv1';
  static const String ecv2 = 'ECv2';
}

abstract class JsonKeys {
  static const String errorCode = 'errorCode';
  static const String errorMessage = 'errorMessage';
  static const String orderNumber = 'orderNumber';
  static const String amount = 'amount';
  static const String currency = 'currency';
  static const String returnUrl = 'returnUrl';
  static const String failUrl = 'failUrl';
  static const String dynamicCallbackUrl = 'dynamicCallbackUrl';
  static const String description = 'description';
  static const String language = 'language';
  static const String pageView = 'pageView';
  static const String clientId = 'clientId';
  static const String merchantLogin = 'merchantLogin';
  static const String jsonParams = 'jsonParams';
  static const String sessionTimeoutSecs = 'sessionTimeoutSecs';
  static const String expirationDate = 'expirationDate';
  static const String bindingId = 'bindingId';
  static const String features = 'features';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String app2app = 'app2app';
  static const String osType = 'app.osType';
  static const String deepLink = 'app.deepLink';
  static const String back2app = 'back2app';
  static const String autocompletionDate = 'autocompletionDate';
  static const String billingPayerData = 'billingPayerData';
  static const String orderId = 'orderId';
  static const String formUrl = 'formUrl';
  static const String externalParams = 'externalParams';
  static const String sbolDeepLink = 'sbolDeepLink';
  static const String sbolBankInvoiceId = 'sbolBankInvoiceId';
  static const String sbolInactive = 'sbolInactive';
  static const String orderStatus = 'orderStatus';
  static const String actionCode = 'actionCode';
  static const String actionCodeDescription = 'actionCodeDescription';
  static const String date = 'date';
  static const String depositedDate = 'depositedDate';
  static const String orderDescription = 'orderDescription';
  static const String ip = 'ip';
  static const String authRefNum = 'authRefNum';
  static const String refundedDate = 'refundedDate';
  static const String paymentWay = 'paymentWay';
  static const String avsCode = 'avsCode';
  static const String merchantOrderParams = 'merchantOrderParams';
  static const String attributes = 'attributes';
  static const String transactionAttributes = 'transactionAttributes';
  static const String terminalId = 'terminalId';
  static const String paymentAmountInfo = 'paymentAmountInfo';
  static const String bankInfo = 'bankInfo';
  static const String bindingInfo = 'bindingInfo';
  static const String payerData = 'payerData';
  static const String refunds = 'refunds';
  static const String name = 'name';
  static const String value = 'value';
  static const String cardAuthInfo = 'cardAuthInfo';
  static const String maskedPan = 'maskedPan';
  static const String expiration = 'expiration';
  static const String cardholderName = 'cardholderName';
  static const String approvalCode = 'approvalCode';
  static const String chargeback = 'chargeback';
  static const String paymentSystem = 'paymentSystem';
  static const String secureAuthInfo = 'secureAuthInfo';
  static const String pan = 'pan';
  static const String productCategory = 'productCategory';
  static const String product = 'product';
  static const String eci = 'eci';
  static const String threeDsInfo = 'threeDsInfo';
  static const String cavv = 'cavv';
  static const String xid = 'xid';
  static const String bankName = 'bankName';
  static const String bankCountryCode = 'bankCountryCode';
  static const String bankCountryName = 'bankCountryName';
  static const String approvedAmount = 'approvedAmount';
  static const String depositedAmount = 'depositedAmount';
  static const String refundedAmount = 'refundedAmount';
  static const String paymentState = 'paymentState';
  static const String feeAmount = 'feeAmount';
  static const String totalAmount = 'totalAmount';
  static const String authDateTime = 'authDateTime';
  static const String referenceNumber = 'referenceNumber';
  static const String isEnrolled = 'isEnrolled';
  static const String emitterName = 'emitterName';
  static const String emitterCountryCode = 'emitterCountryCode';
  static const String merchant = 'merchant';
  static const String additionalParameters = 'additionalParameters';
  static const String preAuth = 'preAuth';
  static const String paymentToken = 'paymentToken';
  static const String success = 'success';
  static const String data = 'data';
  static const String code = 'code';
  static const String message = 'message';
  static const String error = 'error';
  static const String currencyCode = 'currencyCode';
  static const String acsUrl = 'acsUrl';
  static const String paReq = 'paReq';
  static const String termUrl = 'termUrl';
  static const String userMessage = 'userMessage';
  static const String uuid = 'uuid';
  static const String originalOfdUuid = 'original_ofd_uuid';
  static const String daemonCode = 'daemonCode';
  static const String ecrRegistrationNumber = 'ecr_registration_number';
  static const String receiptStatus = 'receiptStatus';
  static const String shiftNumber = 'shift_number';
  static const String fiscalReceiptNumber = 'fiscal_receipt_number';
  static const String receiptDatetime = 'receipt_datetime';
  static const String fnNumber = 'fn_number';
  static const String fiscalDocumentNumber = 'fiscal_document_number';
  static const String fiscalDocumentAttribute = 'fiscal_document_attribute';
  static const String amountTotal = 'amount_total';
  static const String serialNumber = 'serial_number';
  static const String fnsSite = 'fnsSite';
  static const String ofdReceiptUrl = 'ofd_receipt_url';
  static const String ofd = 'OFD';
  static const String website = 'website';
  static const String inn = 'INN';
  static const String receipt = 'receipt';
  static const String bindings = 'bindings';
  static const String expiryDate = 'expiryDate';
  static const String showExpired = 'showExpired';
  static const String newExpiry = 'newExpiry';
  static const String userName = 'userName';
  static const String password = 'password';
  static const String token = 'token';
  static const String bindingType = 'bindingType';
  static const String bindingCategory = 'bindingCategory';
  static const String displayLabel = 'displayLabel';
  static const String feeInput = 'feeInput';
  static const String billingCity = 'billingCity';
  static const String billingCountry = 'billingCountry';
  static const String billingAddressLine1 = 'billingAddressLine1';
  static const String billingAddressLine2 = 'billingAddressLine2';
  static const String billingAddressLine3 = 'billingAddressLine3';
  static const String billingPostalCode = 'billingPostalCode';
  static const String billingState = 'billingState';
  static const String protocolVersion = 'protocolVersion';
}

class Months {
  static List<int> month1 = [
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31,
  ];
  static List<int> month2 = [
    31,
    29,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31,
  ];
  static int returnMonth() {
    int days = 0;
    if (DateTime.now().year % 4 == 0) {
      days = month2[DateTime.now().month];
      return days;
    } else {
      days = month1[DateTime.now().month];
      return days;
    }
  }

  static int returnDays(int month) {
    int days = 0;
    for (var i = 1; i <= month; i++) {
      if (DateTime.now().year % 4 == 0) {
        days = days + month2[i];
      }else{
        days = days + month1[i];
      }
    }
    return days;
  }
}
