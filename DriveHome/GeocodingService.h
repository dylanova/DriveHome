//
//  GeocodingService.h
//  GeocodingAPISample
//
//  Created by Mano Marks on 4/11/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeocodingService : NSObject

- (id)init;
- (void)geocodeAddress:(NSString *)address
          withCallback:(SEL)callback
          withDelegate:(id)delegate;

@property (nonatomic, strong) NSDictionary *geocode;

@end
