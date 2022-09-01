import 'dart:async';

import 'package:flutter/foundation.dart' show WriteBuffer, ReadBuffer;
import 'package:flutter/services.dart';

import '../state/PurchaseModel.dart';

class _HostPurchaseModelApiCodec extends StandardMessageCodec {
  const _HostPurchaseModelApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is PurchaseModel) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return PurchaseModel.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class HostPurchaseModelApi {
  HostPurchaseModelApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _HostPurchaseModelApiCodec();
  Future<PurchaseModel> getPurchaseModel() async {
    BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.HostPurchaseModelApi.getPurchaseModel', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as PurchaseModel?)!;
    }
  }

  Future<bool> requestPurchaseModel() async {
    BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.HostPurchaseModelApi.requestPurchaseModel', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as bool?) ?? false;
    }
  }

  Future<bool> restorePurchaseModel() async {
    BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.HostPurchaseModelApi.restorePurchaseModel', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as bool?) ?? false;
    }
  }

  Future<bool> getIsUsedTrial() async {
    BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.HostPurchaseModelApi.getIsUsedTrial', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as bool?) ?? false;
    }
  }
}

class _FlutterPurchaseModelApiCodec extends StandardMessageCodec {
  const _FlutterPurchaseModelApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is PurchaseModel) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return PurchaseModel.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class FlutterPurchaseModelApi {
  static const MessageCodec<Object?> codec = _FlutterPurchaseModelApiCodec();

  void sendPurchaseModel(PurchaseModel purchaseModel);
  static void setup(FlutterPurchaseModelApi? api) {
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.FlutterPurchaseModelApi.sendPurchaseModel',
          codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.FlutterPurchaseModelApi.sendPurchaseModel was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final PurchaseModel? argPurchaseModel = args[0] as PurchaseModel?;
          assert(argPurchaseModel != null,
              'Argument for dev.flutter.pigeon.FlutterPurchaseModelApi.sendPurchaseModel was null, expected non-null Book.');
          api.sendPurchaseModel(argPurchaseModel!);
          return;
        });
      }
    }
  }
}
