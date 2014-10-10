//
//  UIViewController+CameraHandlerCategory.h
//  CameraHandlerExample
//
//  Created by Emerson Mendes Filho on 08/10/14.
//  Copyright (c) 2014 Emerson Mendes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CameraHandlerCategory)<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

typedef void (^photoHandlerCompletionType)(NSError *error, UIImage *image);
@property(nonatomic,copy) photoHandlerCompletionType photoHandlerCompletion;

-(void)getPhotoWithCompletionHandler:(photoHandlerCompletionType)completionHandler;

@end
