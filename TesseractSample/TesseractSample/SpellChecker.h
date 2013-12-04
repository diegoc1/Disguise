//
//  SpellChecker.h
//  TesseractSample
//
//  Created by Will Harvey on 12/3/13.
//
//

#import <Foundation/Foundation.h>

@class WordDictionary;
@class UnigramModel;

@interface SpellChecker : NSObject

@property (strong, nonatomic) WordDictionary *wordDictionary;
@property (strong, nonatomic) UnigramModel *uniModel;
@property (strong, nonatomic) NSArray *alphabet;

- (NSString *) spellCheckWord:(NSString *) string;
-(NSString *) getSpellChecked: (NSString *) string;


+(NSString *) getRemovedEndingNoise: (NSString *) string;
+(NSString *) getCleanedUpNumericalEnding: (NSString *) string;
+(NSString *) getPossibleMatchForTaxAndTip: (NSString *) string;


@end
