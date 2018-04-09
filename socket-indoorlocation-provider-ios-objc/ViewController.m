#import "ViewController.h"
#import "ILSocketIndoorLocationProvider.h"

@interface ViewController ()

@property (nonatomic, strong) ILSocketIndoorLocationProvider* socketProvider;

@end

@implementation ViewController {
    MapwizePlugin* mapwizePlugin;
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
    
    self.socketProvider = [[ILSocketIndoorLocationProvider alloc] initWithUrl:@"YOUR_SOCKET_SERVER_URL"];
    [mapwizePlugin setIndoorLocationProvider:self.socketProvider];
    
}

@end
