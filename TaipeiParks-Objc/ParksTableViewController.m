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
    [self.activityIndicator startAnimating];

    ParkProvider *parkProvider = ParkProvider.sharedInstance;
    [parkProvider getParkDataWithLimitNum:self.limitNum withOffsetNum:self.offsetNum withCompletionHandler:^(NSMutableArray<ParkModel *> * _Nullable parkArray, NSError * _Nullable error) {

        if (!error) {

            [self.parksList addObjectsFromArray:parkArray];
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            self.isLoading = false;
            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
        });

    }];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.parksList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    tableView.estimatedRowHeight = 44.0;
    tableView.rowHeight = UITableViewAutomaticDimension;

    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ParkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ParkTableViewCell" forIndexPath:indexPath];

    // todo: Configure the cell...

    ParkModel *park = self.parksList[indexPath.row];
    cell.parkNameLabel.text = park.parkName;
    cell.nameLabel.text = park.name;
    cell.introductionLabel.text = park.introduction;

    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    unsigned long int lastElement = self.parksList.count - 1;

    if(indexPath.row == lastElement) {
        if (self.isLoading == false) {

            NSLog(@"=== lastElement -> loadParkData");
            self.offsetNum += self.limitNum;
            [self loadParkData];
        }
    }

}

-(void) setCellImageWithPark:(ParkModel*)park withImageView:(UIImageView*)parkImageView {

    parkImageView.image = nil;

}

@end
