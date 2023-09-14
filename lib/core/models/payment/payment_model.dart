// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  final String id;
  final String status;
  final Amount amount;
  final String description;
  final Recipient recipient;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final Confirmation? confirmation;
  final bool test;
  final bool paid;
  final bool refundable;
  final Metadata metadata;
  final String merchantCustomerId;

  PaymentModel({
    required this.id,
    required this.status,
    required this.amount,
    required this.description,
    required this.recipient,
    required this.paymentMethod,
    required this.createdAt,
    required this.confirmation,
    required this.test,
    required this.paid,
    required this.refundable,
    required this.metadata,
    required this.merchantCustomerId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json["id"],
        status: json["status"],
        amount: Amount.fromJson(json["amount"]),
        description: json["description"],
        recipient: Recipient.fromJson(json["recipient"]),
        paymentMethod: PaymentMethod.fromJson(json["payment_method"]),
        createdAt: DateTime.parse(json["created_at"]),
        confirmation: json["confirmation"] != null
            ? Confirmation.fromJson(json["confirmation"])
            : null,
        test: json["test"],
        paid: json["paid"],
        refundable: json["refundable"],
        metadata: Metadata.fromJson(json["metadata"]),
        merchantCustomerId: json["merchant_customer_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "amount": amount.toJson(),
        "description": description,
        "recipient": recipient.toJson(),
        "payment_method": paymentMethod.toJson(),
        "created_at": createdAt.toIso8601String(),
        "confirmation": confirmation?.toJson(),
        "test": test,
        "paid": paid,
        "refundable": refundable,
        "metadata": metadata.toJson(),
        "merchant_customer_id": merchantCustomerId,
      };
}

class Amount {
  final String value;
  final String currency;

  Amount({
    required this.value,
    required this.currency,
  });

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
        value: json["value"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "currency": currency,
      };
}

class Confirmation {
  final String type;
  final String confirmationUrl;

  Confirmation({
    required this.type,
    required this.confirmationUrl,
  });

  factory Confirmation.fromJson(Map<String, dynamic> json) => Confirmation(
        type: json["type"],
        confirmationUrl: json["confirmation_url"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "confirmation_url": confirmationUrl,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}

class PaymentMethod {
  final String type;
  final String id;
  final bool saved;
  final String title;
  final Card card;

  PaymentMethod({
    required this.type,
    required this.id,
    required this.saved,
    required this.title,
    required this.card,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        type: json["type"],
        id: json["id"],
        saved: json["saved"],
        title: json["title"],
        card: Card.fromJson(json["card"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "saved": saved,
        "title": title,
        "card": card.toJson(),
      };
}

class Card {
  final String first6;
  final String last4;
  final String expiryYear;
  final String expiryMonth;
  final String cardType;
  final String issuerCountry;
  final String issuerName;

  Card({
    required this.first6,
    required this.last4,
    required this.expiryYear,
    required this.expiryMonth,
    required this.cardType,
    required this.issuerCountry,
    required this.issuerName,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        first6: json["first6"],
        last4: json["last4"],
        expiryYear: json["expiry_year"],
        expiryMonth: json["expiry_month"],
        cardType: json["card_type"],
        issuerCountry: json["issuer_country"],
        issuerName: json["issuer_name"],
      );

  Map<String, dynamic> toJson() => {
        "first6": first6,
        "last4": last4,
        "expiry_year": expiryYear,
        "expiry_month": expiryMonth,
        "card_type": cardType,
        "issuer_country": issuerCountry,
        "issuer_name": issuerName,
      };
}

class Recipient {
  final String accountId;
  final String gatewayId;

  Recipient({
    required this.accountId,
    required this.gatewayId,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        accountId: json["account_id"],
        gatewayId: json["gateway_id"],
      );

  Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "gateway_id": gatewayId,
      };
}
