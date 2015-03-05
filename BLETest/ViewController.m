//
//  ViewController.m
//  BLETest
//
//  Created by   zenajung on 2015. 3. 5..
//  Copyright (c) 2015년   zenajung. All rights reserved.
//

#import "ViewController.h"

@import CoreBluetooth;

@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>


@property (strong, nonatomic) CBCentralManager *myCentralManager;
@property (strong, nonatomic) NSMutableArray *peripheralArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //CBCentralManager *myCentralManager;
    self.myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    self.peripheralArray = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    NSLog(@"centralManagerDidUpdateState - %@",central);
    switch (central.state)
    {
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"State: Unsupported");
        } break;
            
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"State: Unauthorized");
        } break;
            
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"State: Powered Off");
        } break;
            
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"State: Powered On");
            [self.myCentralManager scanForPeripheralsWithServices:nil options:nil];

            //[self.manager scanForPeripheralsWithServices:nil options:nil];
        } break;
            
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"State: Unknown");
        } break;
            
        default:
        {
        }
            
    }

}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@", peripheral.name);
    NSLog(@"advertisementData = %@",advertisementData);
    //[central stopScan];
    //NSLog(@"Scanning stopped");
    peripheral.delegate = self;
    [_peripheralArray addObject:peripheral];
    [central connectPeripheral:peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Peripheral connected");
    [peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
#if 0
    
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service %@", service);
        
         [peripheral discoverCharacteristics:nil forService:service];
        
    }
#endif
    CBService *service  = peripheral.services[0];
    [peripheral discoverCharacteristics:nil forService:service];
    
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"Discovered characteristic %@", characteristic);
        
        [peripheral readValueForCharacteristic:characteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSData *data = characteristic.value;
    // parse the data as needed
    NSLog(@"%@",data);
}

@end
