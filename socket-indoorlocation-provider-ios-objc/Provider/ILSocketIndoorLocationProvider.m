#import "ILSocketIndoorLocationProvider.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface ILSocketIndoorLocationProvider ()

@property (nonatomic, strong) NSURL* serverUrl;
@property (nonatomic, strong) NSString* clientIp;
@property (nonatomic, strong) SocketManager* socketManager;
@property (nonatomic, strong) SocketIOClient* socketClient;
@property (nonatomic, strong) NSTimer* refreshIpTimer;
@property (nonatomic, assign) BOOL connected;

@end

@implementation ILSocketIndoorLocationProvider {
}

    
- (instancetype) initWithUrl:(NSString*) url {
    self = [super init];
    if (self) {
        _serverUrl = [[NSURL alloc] initWithString:url];
    }
    return self;
}
    
- (void) start {
    [self refreshIp];
    _connected = YES;
    _refreshIpTimer = [NSTimer scheduledTimerWithTimeInterval: 30
                                                       target: self
                                                     selector:@selector(refreshIp)
                                                     userInfo: nil repeats:YES];
}

- (void) initSocket {
    if (self.serverUrl && self.clientIp) {
        
        self.socketManager = [[SocketManager alloc] initWithSocketURL:self.serverUrl config:@{@"connectParams":@{@"userId": self.clientIp}}];
        self.socketClient = [self.socketManager defaultSocket];
        
        [self.socketClient on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            [self dispatchDidStart];
        }];
        
        [self.socketClient on:@"indoorLocationChange" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSDictionary* responseDictionary = data[0];
            NSDictionary* indoorLocationDictionary = responseDictionary[@"indoorLocation"];
            NSNumber* latitude = indoorLocationDictionary[@"latitude"];
            NSNumber* longitude = indoorLocationDictionary[@"longitude"];
            NSNumber* floor = indoorLocationDictionary[@"floor"];
            ILIndoorLocation* indoorLocation = [[ILIndoorLocation alloc] initWithProvider:self latitude:latitude.doubleValue longitude:longitude.doubleValue floor:floor];
            indoorLocation.accuracy = ((NSNumber*)indoorLocationDictionary[@"accuracy"]).doubleValue;
            
            [self dispatchDidUpdateLocation:indoorLocation];
        }];
        
        [self.socketClient on:@"error" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSString* message = data[0];
            [self dispatchDidFailWithError:[[NSError alloc] initWithDomain:message code:502 userInfo:nil]];
        }];
        
        [self.socketClient connect];
        
    }
}
    
- (void) destroySocket {
    [self.socketClient disconnect];
    self.socketClient = nil;
    self.socketManager = nil;
}
    
- (void) stop {
    [self.refreshIpTimer invalidate];
    [self destroySocket];
    self.connected = NO;
}

- (BOOL) isStarted {
    return _connected;
}

- (BOOL) supportsFloor {
    return YES;
}
    
- (void) refreshIp {
    NSLog(@"RefreshIp");
    NSString* newIp = [self getIPAddress];
    if (newIp && ![newIp isEqualToString:self.clientIp]) {
        self.clientIp = newIp;
        [self destroySocket];
        [self initSocket];
        
        NSLog(@"RefreshIp & Init socket");
    }
}
    
- (NSString *)getIPAddress {
    
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

    
@end
