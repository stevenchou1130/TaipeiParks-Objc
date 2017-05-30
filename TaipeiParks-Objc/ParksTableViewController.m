//
//  ParksTableViewController.m
//  TaipeiParks-Objc
//
//  Created by steven.chou on 2017/5/30.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

#import "ParksTableViewController.h"

@interface ParksTableViewController ()

@property NSCache* imageCache;
@property UIActivityIndicatorView* activityIndicator;
@property NSMutableArray<ParkModel*>* parksList;
@property bool isLoading;
@property int limitNum;
@property int offsetNum;

@end

@implementation ParksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setDefaultProperty];
    [self setView];
    [self loadParkData];
}

-(void)setDefaultProperty {

    self.imageCache = [[NSCache alloc] init];

    self.activityIndicator = [[UIActivityIndicatorView alloc] init];

    self.parksList = [[NSMutableArray alloc] init];

    self.isLoading = false;

    self.limitNum = 30;
    self.offsetNum = 0;
}

-(void)setView {
    NSLog(@"setView");

    self.navigationItem.title = @"Taipei City Parks";

    UINib *parkNib = [UINib nibWithNibName:PARK_TABLEVIEW_CELL bundle:nil];
    [self.tableView registerNib:parkNib forCellReuseIdentifier:PARK_TABLEVIEW_CELL];

    self.activityIndicator.center = self.view.center;
    self.activityIndicator.hidesWhenStopped = true;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.activityIndicator.color = UIColor.greenColor;
    [self.view addSubview: self.activityIndicator];

}

-(void)loadParkData {
    NSLog(@"loadParkData");

    self.isLoading = true;
//    [self.activityIndicator startAnimating];

    ParkProvider *parkProvider = ParkProvider.sharedInstance;
    [parkProvider getParkDataWithLimitNum:30 withOffsetNum:0];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    tableView.estimatedRowHeight = 44.0;
    tableView.rowHeight = UITableViewAutomaticDimension;

    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ParkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ParkTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

@end
