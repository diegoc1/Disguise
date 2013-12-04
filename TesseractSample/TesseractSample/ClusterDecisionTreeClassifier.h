

#import <Foundation/Foundation.h>


@class ReceiptModel;
@class SpellChecker;

@interface ClusterDecisionTreeClassifier : NSObject

+(ReceiptModel *) processReceiptFromClusters: (NSMutableArray *) clusters withSpellChecker: (SpellChecker *) spellChecker;

@end
