// -*- mode:objc; c-basic-offset:2; indent-tabs-mode:nil -*-
/*
 * Copyright 2011 ZXing authors
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

#import <ZXing/ZXDecodeHints.h>

@implementation ZXDecodeHints

@synthesize native;

- (ZXDecodeHints*)init {
  if ((self = [super init])) {
    native = new zxing::DecodeHints;
  }
  return self;
}

//- (void)dealloc {
//  delete native;
//  [super dealloc];
//}

@end
