

#import "ClusterDecisionTreeClassifier.h"
#import "ReceiptModel.h"
#import "ClusterWrapper.h"

@interface ClusterDecisionTreeClassifier()
@property (nonatomic, strong) NSMutableArray *clusters;
@end

@implementation ClusterDecisionTreeClassifier

+(ReceiptModel *) processReceiptFromClusters: (NSMutableArray *) clusters {
    ReceiptModel *receipt = [[ReceiptModel alloc] init];
    receipt.itemsPurchased = [[NSMutableArray alloc] init];
    
    //Populate receipt data from clusters
    NSMutableArray *orderedClusters = [self orderClustersByMinY: clusters];
    [self cleanUpRecognizedText: orderedClusters];
    [self classifyOrderedClusters: orderedClusters];
    [self spellCheck: orderedClusters];
    
    for (int i = 0; i < [orderedClusters count]; i++) {
        ClusterWrapper *cluster = orderedClusters[i];
        if (cluster.clusterType == ReceiptClusterTypeTitle) {
            receipt.title = cluster.recognizedText;
        }
        else if (cluster.clusterType == ReceiptClusterTypeItem) {
            NSString *itemText = cluster.recognizedText;
            [receipt.itemsPurchased addObject: itemText];
        }
        else if (cluster.clusterType == ReceiptClusterTypeTotal) {
            receipt.totalAmount = [self getAmountFromString: cluster.recognizedText];
        }
        else if (cluster.clusterType == ReceiptClusterTypeTax) {
            receipt.taxAmount = [self getAmountFromString: cluster.recognizedText];
        }
    }
    
    return receipt;
}

+(NSMutableArray *) orderClustersByMinY: (NSMutableArray *) clusters {
    NSArray *newClusters = [clusters sortedArrayUsingComparator:^(id a, id b) {
        ClusterWrapper *clusterA = (ClusterWrapper *) a;
        ClusterWrapper *clusterB = (ClusterWrapper *) b;
        return (NSComparisonResult)(clusterA.minYVal > clusterB.minYVal);
        
    }];
    
    return [NSMutableArray arrayWithArray: newClusters];
}

+(void) cleanUpRecognizedText: (NSMutableArray *) orderedClusters {
    
}

+(void) spellCheck: (NSMutableArray *) orderedClusters {
    
}

+(BOOL) doesString: (NSString *) string containRegex: (NSString *) regexString {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: regexString options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSUInteger countMatches = [regex numberOfMatchesInString: string options:0 range:NSMakeRange(0, [string length])];
    
    return (countMatches > 0);
}

+(float) getAmountFromString: (NSString *) string {
    NSString *regexString = @"(\\d)\\.(\\d)(\\d)";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString: string options: NSMatchingProgress range:NSMakeRange(0, [string length])];
    
    NSLog(@"MATCHES %@", matches);
    
    if ([matches count] == 0) return -1;
   
    NSString *createdString = @"";
    createdString = [createdString stringByAppendingString: [string substringWithRange:[matches[0] range]]];
    NSLog(@"CREATED STRING : %@", createdString);
    
    return [createdString floatValue];
}


/* Using a decision tree, loop through and set the clusterType value for each cluster */
+(void) classifyOrderedClusters: (NSMutableArray *) orderedClusters {
    ReceiptClusterType lastClassifiedType = ReceiptClusterTypeFirst;
    BOOL titleFound = FALSE;
    BOOL totalFound = FALSE;
    BOOL taxFound = FALSE;
    
    for (int i = 0; i < [orderedClusters count]; i++) {
        ClusterWrapper *cluster = orderedClusters[i];
        ReceiptClusterType currentClassifiedType = ReceiptClusterTypeJunk;
        
        //Search for title
        if (lastClassifiedType == ReceiptClusterTypeFirst || (lastClassifiedType == ReceiptClusterTypeJunk && !titleFound)) {
            if ([cluster.recognizedText length] >= 4) {
                currentClassifiedType = ReceiptClusterTypeTitle;
                titleFound = TRUE;
            }
        }
        
        //Not title
        
        else {
            //Look for a price with no subtotal string
            if ([self doesString: cluster.recognizedText containRegex: @"[0-9]\\.[0-9][0-9]"] && ![self doesString: cluster.recognizedText containRegex: @"ubtotal"] && ![self doesString: cluster.recognizedText containRegex: @"ubtax"]) {
                
                NSLog(@"FITS REGEX: %@", cluster.recognizedText);
                
                //Search for total
                if (!totalFound && ([self doesString: cluster.recognizedText containRegex: @"total"] || [self doesString: cluster.recognizedText containRegex: @"Total"])) {
                    //Total amount
                    currentClassifiedType = ReceiptClusterTypeTotal;
                    totalFound = TRUE;
                }
                else if (!taxFound && ([self doesString: cluster.recognizedText containRegex: @"tax"] || [self doesString: cluster.recognizedText containRegex: @"Tax"])) {
                    //Total amount
                    currentClassifiedType = ReceiptClusterTypeTax;
                    taxFound = TRUE;
                }
                
                else {
                    currentClassifiedType = ReceiptClusterTypeItem;
                }
            }
        }
        
        cluster.clusterType = currentClassifiedType;
        lastClassifiedType = currentClassifiedType;
    }
}

@end
