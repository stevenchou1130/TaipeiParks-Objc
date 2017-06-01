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

-(void) setCellImageWithPark:(ParkModel*)park withImageView:(UIImageView*)parkImageView {

    // todo: chech url is correct one

    parkImageView.image = [UIImage imageNamed:@"park"];

    UIImage *imageFromCache = [self.imageCache objectForKey:park.image];
    if (imageFromCache != nil) {
        parkImageView.image = imageFromCache;
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL *imageURL = [NSURL URLWithString:park.image];

        @try {

            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:imageData];

            if (image != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{

                    UIImage *imageToCache = [image resizableImageWithCapInsets: UIEdgeInsetsMake(0, 0, 0, 0) resizingMode: UIImageResizingModeStretch];

                    [self.imageCache setObject:imageToCache forKey:park.image];

                    parkImageView.image = [self.imageCache objectForKey:park.image];
                    parkImageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                });
            }

        } @catch (NSException *exception) {

            NSLog(@"Exception:%@",exception);

        } @finally {

            // finally
        }

    });
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

    ParkModel *park = self.parksList[indexPath.row];

    cell.parkNameLabel.text = park.parkName;
    cell.nameLabel.text = park.name;
    cell.introductionLabel.text = park.introduction;

    [self setCellImageWithPark:park withImageView:cell.parkImageView];

    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    unsigned long int lastElement = self.parksList.count - 1;

    if(indexPath.row == lastElement) {
        if (self.isLoading == false) {

            self.offsetNum += self.limitNum;
            [self loadParkData];
        }
    }
}

@end
