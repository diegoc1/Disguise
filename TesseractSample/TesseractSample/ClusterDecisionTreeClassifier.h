

#import <Foundation/Foundation.h>


@class ReceiptModel;
@class SpellChecker;

@interface ClusterDecisionTreeClassifier : NSObject

+(ReceiptModel *) processReceiptFromClusters: (NSMutableArray *) clusters withSpellChecker: (SpellChecker *) spellChecker;
+(float) getAmountFromString: (NSString *) string;
+(NSString *) getAmountStringFromString: (NSString *) string;
@end
