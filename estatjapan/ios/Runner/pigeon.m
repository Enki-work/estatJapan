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

@interface BKVersion ()
+ (BKVersion *)fromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end

@implementation BKVersion
+ (BKVersion *)fromMap:(NSDictionary *)dict {
  BKVersion *result = [[BKVersion alloc] init];
  result.string = dict[@"string"];
  if ((NSNull *)result.string == [NSNull null]) {
    result.string = nil;
  }
  return result;
}
- (NSDictionary *)toMap {
  return [NSDictionary dictionaryWithObjectsAndKeys:(self.string ? self.string : [NSNull null]), @"string", nil];
}
@end

@interface BKPlatformVersionApiCodecReader : FlutterStandardReader
@end
@implementation BKPlatformVersionApiCodecReader
- (nullable id)readValueOfType:(UInt8)type 
{
  switch (type) {
    case 128:     
      return [BKVersion fromMap:[self readValue]];
    
    default:    
      return [super readValueOfType:type];
    
  }
}
@end

@interface BKPlatformVersionApiCodecWriter : FlutterStandardWriter
@end
@implementation BKPlatformVersionApiCodecWriter
- (void)writeValue:(id)value 
{
  if ([value isKindOfClass:[BKVersion class]]) {
    [self writeByte:128];
    [self writeValue:[value toMap]];
  } else 
{
    [super writeValue:value];
  }
}
@end

@interface BKPlatformVersionApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation BKPlatformVersionApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[BKPlatformVersionApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[BKPlatformVersionApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *BKPlatformVersionApiGetCodec() {
  static dispatch_once_t s_pred = 0;
  static FlutterStandardMessageCodec *s_sharedObject = nil;
  dispatch_once(&s_pred, ^{
    BKPlatformVersionApiCodecReaderWriter *readerWriter = [[BKPlatformVersionApiCodecReaderWriter alloc] init];
    s_sharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return s_sharedObject;
}


void BKPlatformVersionApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<BKPlatformVersionApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.PlatformVersionApi.getPlatformVersion"
        binaryMessenger:binaryMessenger
        codec:BKPlatformVersionApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getPlatformVersionWithError:)], @"BKPlatformVersionApi api (%@) doesn't respond to @selector(getPlatformVersionWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        BKVersion *output = [api getPlatformVersionWithError:&error];
        callback(wrapResult(output, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
