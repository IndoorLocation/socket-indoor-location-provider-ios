#import "ViewController.h"
#import "ILSocketIndoorLocationProvider.h"

@interface ViewController ()

@end

@implementation ViewController {
    MapwizePlugin* mapwizePlugin;
    ILSocketIndoorLocationProvider* socketProvider;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mapwizePlugin = [[MapwizePlugin alloc] initWith:_mglMapView options:[[MWZOptions alloc] init]];
    mapwizePlugin.delegate = self;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
- (void) mapwizePluginDidLoad:(MapwizePlugin *)mapwizePlugin {
    
    socketProvider = [[ILSocketIndoorLocationProvider alloc] initWithUrl:@"YOUR_SOCKET_SERVER_URL"];
    [mapwizePlugin setIndoorLocationProvider:socketProvider];
    
}

@end
