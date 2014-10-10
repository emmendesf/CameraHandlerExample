//
//  ViewController.m
//  CameraHandlerExample
//
//  Created by Emerson Mendes Filho on 07/10/14.
//  Copyright (c) 2014 Emerson Mendes. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+CameraHandlerCategory.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getPhoto:(id)sender {
    
    [self getPhotoWithCompletionHandler:^(NSError *error, UIImage *image) {
        if (!error) {
            self.imageView.image = image;
        }
    }];
    
}

@end
