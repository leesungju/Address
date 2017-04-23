//
//  UILabel+Common.m
//  Aireleven
//
//  Created by SungJu on 2017. 3. 17..
//  Copyright © 2017년 Aireleven. All rights reserved.
//

#import "UILabel+Common.h"

@implementation UILabel (SJCommon)

- (void)setAttributeTextColor:(UIColor*)color changeText:(NSString*)text
{
    NSRange range = [self.text.lowercaseString rangeOfString:text.lowercaseString];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [string addAttribute:NSForegroundColorAttributeName value:color range:range];
    [self setAttributedText:string];
}


@end
