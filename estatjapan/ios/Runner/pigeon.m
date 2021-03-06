// Autogenerated from Pigeon (v1.0.7), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "pigeon.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary<NSString *, id> *wrapResult(id result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
        @"code": (error.code ? error.code : [NSNull null]),
        @"message": (error.message ? error.message : [NSNull null]),
        @"details": (error.details ? error.details : [NSNull null]),
        };
  }
  return @{
      @"result": (result ? result : [NSNull null]),
      @"error": errorDict,
      };
}

@interface EJPurchaseModel ()
+ (EJPurchaseModel *)fromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end

@implementation EJPurchaseModel
+ (EJPurchaseModel *)fromMap:(NSDictionary *)dict {
  EJPurchaseModel *result = [[EJPurchaseModel alloc] init];
  result.isPurchase = dict[@"isPurchase"];
  if ((NSNull *)result.isPurchase == [NSNull null]) {
    result.isPurchase = nil;
  }
  result.isUsedTrial = dict[@"isUsedTrial"];
  if ((NSNull *)result.isUsedTrial == [NSNull null]) {
    result.isUsedTrial = nil;
  }
  return result;
}
- (NSDictionary *)toMap {
  return [NSDictionary dictionaryWithObjectsAndKeys:(self.isPurchase ? self.isPurchase : [NSNull null]), @"isPurchase", (self.isUsedTrial ? self.isUsedTrial : [NSNull null]), @"isUsedTrial", nil];
}
@end

@interface EJHostPurchaseModelApiCodecReader : FlutterStandardReader
@end
@implementation EJHostPurchaseModelApiCodecReader
- (nullable id)readValueOfType:(UInt8)type 
{
  switch (type) {
    case 128:     
      return [EJPurchaseModel fromMap:[self readValue]];
    
    default:    
      return [super readValueOfType:type];
    
  }
}
@end

@interface EJHostPurchaseModelApiCodecWriter : FlutterStandardWriter
@end
@implementation EJHostPurchaseModelApiCodecWriter
- (void)writeValue:(id)value 
{
  if ([value isKindOfClass:[EJPurchaseModel class]]) {
    [self writeByte:128];
    [self writeValue:[value toMap]];
  } else 
{
    [super writeValue:value];
  }
}
@end

@interface EJHostPurchaseModelApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation EJHostPurchaseModelApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[EJHostPurchaseModelApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[EJHostPurchaseModelApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *EJHostPurchaseModelApiGetCodec() {
  static dispatch_once_t s_pred = 0;
  static FlutterStandardMessageCodec *s_sharedObject = nil;
  dispatch_once(&s_pred, ^{
    EJHostPurchaseModelApiCodecReaderWriter *readerWriter = [[EJHostPurchaseModelApiCodecReaderWriter alloc] init];
    s_sharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return s_sharedObject;
}


void EJHostPurchaseModelApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<EJHostPurchaseModelApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.HostPurchaseModelApi.getPurchaseModel"
        binaryMessenger:binaryMessenger
        codec:EJHostPurchaseModelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getPurchaseModelWithError:)], @"EJHostPurchaseModelApi api (%@) doesn't respond to @selector(getPurchaseModelWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        EJPurchaseModel *output = [api getPurchaseModelWithError:&error];
        callback(wrapResult(output, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.HostPurchaseModelApi.getIsUsedTrial"
        binaryMessenger:binaryMessenger
        codec:EJHostPurchaseModelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getIsUsedTrialWithError:)], @"EJHostPurchaseModelApi api (%@) doesn't respond to @selector(getIsUsedTrialWithError:)", api);
        [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                FlutterError *error;
                NSNumber *output = [api getIsUsedTrialWithError:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(wrapResult(output, error));
                });
            });
        }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.HostPurchaseModelApi.requestPurchaseModel"
        binaryMessenger:binaryMessenger
        codec:EJHostPurchaseModelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(requestPurchaseModelWithError:)], @"EJHostPurchaseModelApi api (%@) doesn't respond to @selector(requestPurchaseModelWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api requestPurchaseModelWithError:&error];
        callback(wrapResult(output, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.HostPurchaseModelApi.restorePurchaseModel"
        binaryMessenger:binaryMessenger
        codec:EJHostPurchaseModelApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(restorePurchaseModelWithError:)], @"EJHostPurchaseModelApi api (%@) doesn't respond to @selector(restorePurchaseModelWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api restorePurchaseModelWithError:&error];
        callback(wrapResult(output, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface EJFlutterPurchaseModelApiCodecReader : FlutterStandardReader
@end
@implementation EJFlutterPurchaseModelApiCodecReader
- (nullable id)readValueOfType:(UInt8)type 
{
  switch (type) {
    case 128:     
      return [EJPurchaseModel fromMap:[self readValue]];
    
    default:    
      return [super readValueOfType:type];
    
  }
}
@end

@interface EJFlutterPurchaseModelApiCodecWriter : FlutterStandardWriter
@end
@implementation EJFlutterPurchaseModelApiCodecWriter
- (void)writeValue:(id)value 
{
  if ([value isKindOfClass:[EJPurchaseModel class]]) {
    [self writeByte:128];
    [self writeValue:[value toMap]];
  } else 
{
    [super writeValue:value];
  }
}
@end

@interface EJFlutterPurchaseModelApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation EJFlutterPurchaseModelApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[EJFlutterPurchaseModelApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[EJFlutterPurchaseModelApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *EJFlutterPurchaseModelApiGetCodec() {
  static dispatch_once_t s_pred = 0;
  static FlutterStandardMessageCodec *s_sharedObject = nil;
  dispatch_once(&s_pred, ^{
    EJFlutterPurchaseModelApiCodecReaderWriter *readerWriter = [[EJFlutterPurchaseModelApiCodecReaderWriter alloc] init];
    s_sharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return s_sharedObject;
}


@interface EJFlutterPurchaseModelApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation EJFlutterPurchaseModelApi
- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}

- (void)sendPurchaseModelPurchaseModel:(EJPurchaseModel *)arg_purchaseModel completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.FlutterPurchaseModelApi.sendPurchaseModel"
      binaryMessenger:self.binaryMessenger
      codec:EJFlutterPurchaseModelApiGetCodec()];
  [channel sendMessage:@[arg_purchaseModel] reply:^(id reply) {
    completion(nil);
  }];
}
@end
