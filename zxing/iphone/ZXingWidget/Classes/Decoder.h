// -*- mode:objc; c-basic-offset:2; indent-tabs-mode:nil -*-
/*
 * Copyright 2008 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Modified by G. Nixon for TXLF March 2014
 */

#import <UIKit/UIKit.h>
#import "DecoderDelegate.h"

@interface Decoder : NSObject {
  NSSet *readers;
  UIImage *image;
  CGRect cropRect;
  UIImage *subsetImage;
  size_t subsetWidth;
  size_t subsetHeight;
  size_t subsetBytesPerRow;
  //id<DecoderDelegate> delegate;
}

@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) NSSet *readers;
@property(nonatomic, assign) id<DecoderDelegate> delegate;

- (BOOL) decodeImage:(UIImage *)image;
- (BOOL) decodeImage:(UIImage *)image cropRect:(CGRect)cropRect;
- (void) resultPointCallback:(CGPoint)point;

@end
