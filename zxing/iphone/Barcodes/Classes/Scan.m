//
//  Scan.m
//  ZXing
//
//  Created by Christian Brunschen on 29/05/2008.
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

#import "Scan.h"


@implementation Scan

@synthesize ident;
@synthesize text;
@synthesize stamp;

- (id)initWithIdent:(int)i text:(NSString *)t stamp:(NSDate *)s {
  if ((self = [super init]) != nil) {
    self.ident = i;
    self.text = t;
    self.stamp = s;
  }
  return self;
}

//- (void)dealloc {
//  [stamp release];
//  [text release];
//  [super dealloc];
//}

@end
