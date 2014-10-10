//
//  UIViewController+CameraHandlerCategory.m
//  CameraHandlerExample
//
//  Created by Emerson Mendes Filho on 08/10/14.
//  Copyright (c) 2014 Emerson Mendes. All rights reserved.
//

#import "UIViewController+CameraHandlerCategory.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>

static void * PhotoHandlerPropertyKey = &PhotoHandlerPropertyKey;
static void * NewMediaPropertyKey = &NewMediaPropertyKey;
BOOL newMedia;

@implementation UIViewController (CameraHandlerCategory)

- (photoHandlerCompletionType)photoHandlerCompletion {
    return objc_getAssociatedObject(self, PhotoHandlerPropertyKey);
}

- (void)setPhotoHandlerCompletion:(photoHandlerCompletionType)photoHandlerCompletion {
    objc_setAssociatedObject(self, PhotoHandlerPropertyKey, photoHandlerCompletion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)getPhotoWithCompletionHandler:(photoHandlerCompletionType)completionHandler{
    
    self.photoHandlerCompletion = completionHandler;
    
    UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:NSLocalizedString(@"Take Photo",nil),NSLocalizedString(@"Choose Existing Photo",nil), nil];
    
    [photoActionSheet showInView:self.view];
    
}

#pragma mark - Handle Camera and Images

-(void)usePhoneCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = YES;
    }
}

//Code to access personal Library and take photos
- (void) useCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        self.photoHandlerCompletion(nil,image);
        
        if (newMedia) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
        }
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        // Code here to support video if enabled
    }
    
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        self.photoHandlerCompletion(error,nil);
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self usePhoneCamera];
            break;
        case 1:
            [self useCameraRoll];
            break;
        default:
            break;
    }
}


@end
