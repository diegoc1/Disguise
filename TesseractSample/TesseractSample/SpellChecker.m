//
//  SpellChecker.m
//  TesseractSample
//
//  Created by Will Harvey on 12/3/13.
//
//

#import "WordDictionary.h"
#import "UnigramModel.h"
#import "SpellChecker.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////                                                                                                             ////
////  This algorithm was adapted from the algorithm described at http://norvig.com/spell-correct.html            ////
////                                                                                                             ////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



@implementation SpellChecker

-(id)init {
    self = [super init];
    if (self) {
        self.wordDictionary = [[WordDictionary alloc] init];
        self.uniModel = [[UnigramModel alloc] init];
    }
    return self;
}

- (NSString *) spellCheckWord:(NSString *) string {
    NSString *word = [string lowercaseString];
    if ([self.wordDictionary.dict containsObject:word] || [self.uniModel.dict objectForKey:word]) {
        return string;
    }
    NSMutableArray *possibleCorrections = [self generatePossibleCorrectWordsForString:word];
    NSMutableArray *secondLevelOfPossibleCorrections = [[NSMutableArray alloc] init];
    [secondLevelOfPossibleCorrections addObjectsFromArray:possibleCorrections];
    for (NSString *correctedWord in possibleCorrections) {
        [secondLevelOfPossibleCorrections addObjectsFromArray:[self generatePossibleCorrectWordsForString:correctedWord]];
    }
    //     NSMutableArray *thirdLevel = [[NSMutableArray alloc] init];
    //    [thirdLevel addObjectsFromArray:secondLevelOfPossibleCorrections];
    //    for (NSString *correctedWord in secondLevelOfPossibleCorrections) {
    //        [thirdLevel addObjectsFromArray:[self generatePossibleCorrectWordsForString:correctedWord]];
    //    }
    return [self getMostProbableWord:secondLevelOfPossibleCorrections];
}

- (NSMutableArray *) generatePossibleCorrectWordsForString: (NSString *)word {
    NSMutableArray *all = [[NSMutableArray alloc] init];
    NSMutableArray *deletes = [self getDeletesForWord:word];
    [all addObjectsFromArray:deletes];
    NSMutableArray *inserts = [self getInsertionsForWord:word];
    [all addObjectsFromArray:inserts];
    NSMutableArray *replaces = [self getReplacesForWord:word];
    [all addObjectsFromArray:replaces];
    return all;
}

-(NSString *) getMostProbableWord:(NSMutableArray *) possibleWords {
    int maxVal = INT_MIN;
    NSString *maxWord = @"";
    for (NSString *word in possibleWords) {
        if ([self.uniModel.dict objectForKey:word]) {
            int countForWord = [[self.uniModel.dict objectForKey:word] intValue];
            if (countForWord > maxVal) {
                maxVal = countForWord;
                maxWord = word;
            }
        }
    }
    return maxWord;
}


- (NSMutableArray *) getDeletesForWord: (NSString *) word {
    int wordLength = word.length;
    NSMutableArray *deletes = [[NSMutableArray alloc] init];
    for (int i = 0; i < wordLength; i++) {
        NSString *firstHalf = [word substringWithRange:NSMakeRange(0,i)];
        NSString *secondHalf = [word substringWithRange:NSMakeRange(i+1,wordLength - (i + 1))];
        NSString *full = [NSString stringWithFormat:@"%@%@",firstHalf, secondHalf];
        [deletes addObject:full];
    }
    return deletes;
}

- (NSMutableArray *) getInsertionsForWord: (NSString *) word {
    int wordLength = word.length;
    NSString *alphabet = @"abcdefghijklmnopqrstuvwxyz";
    NSMutableArray *insertions = [[NSMutableArray alloc] init];
    for (int i = 0; i < wordLength; i++) {
        NSString *firstHalf = [word substringWithRange:NSMakeRange(0,i)];
        NSString *secondHalf = [word substringWithRange:NSMakeRange(i,wordLength - i)];
        for (int j = 0; j < [alphabet length]; j++) {
            NSString *full = [NSString stringWithFormat:@"%@%c%@",firstHalf, [alphabet characterAtIndex:j], secondHalf];
            [insertions addObject:full];
        }
        
    }
    return insertions;
}

- (NSMutableArray *) getReplacesForWord: (NSString *) word {
    int wordLength = word.length;
    NSString *alphabet = @"abcdefghijklmnopqrstuvwxyz";
    NSMutableArray *insertions = [[NSMutableArray alloc] init];
    for (int i = 0; i < wordLength; i++) {
        NSString *firstHalf = [word substringWithRange:NSMakeRange(0,i)];
        NSString *secondHalf = [word substringWithRange:NSMakeRange(i + 1,wordLength - (i + 1))];
        for (int j = 0; j < [alphabet length]; j++) {
            NSString *full = [NSString stringWithFormat:@"%@%c%@",firstHalf, [alphabet characterAtIndex:j], secondHalf];
            [insertions addObject:full];
        }
        
    }
    return insertions;
}


+(NSString *) getRemovedEndingNoise: (NSString *) string {
    while (TRUE) {
        if ([string length] == 0) break;
        
        unichar lastChar = [string characterAtIndex: [string length] - 1];
        if (![[NSCharacterSet alphanumericCharacterSet] characterIsMember: lastChar]) {
            NSLog(@"REMOVE --- %C", lastChar);
            string = [string substringToIndex: [string length] - 1];
        }
        else break;
    }
    return string;
}

+(NSString *) getCleanedUpNumericalEnding: (NSString *) string {
    NSString *clusterText = [string copy];
    
    unichar lastChar = [clusterText characterAtIndex: [clusterText length] - 1];
    if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember: lastChar] && [clusterText length] > 3) {
        
        unichar thirdLast = [clusterText characterAtIndex: [clusterText length] - 3];
        unichar secondLast = [clusterText characterAtIndex: [clusterText length] - 2];
        if ([[NSCharacterSet alphanumericCharacterSet] characterIsMember: thirdLast] && [[NSCharacterSet alphanumericCharacterSet] characterIsMember: secondLast]) {
            return string;
        }
        
        //Find first letter
        if ([clusterText length] < 3) return clusterText;
        
        int j = [clusterText length] - 2;
        while (j >= 0) {
            unichar prevChar = [clusterText characterAtIndex: j];
            
            if ([[NSCharacterSet letterCharacterSet] characterIsMember: prevChar]) {
                j++;
                break;
            }
            
            j--;
        }
        j = MAX(j, 0);
        
        NSString *nonNumericalString = [clusterText substringToIndex: j];
        NSString *numericString = [clusterText substringFromIndex: j];
        
        
        numericString = [numericString stringByTrimmingCharactersInSet: [[NSCharacterSet alphanumericCharacterSet] invertedSet]];
        numericString = [numericString stringByReplacingOccurrencesOfString: @"." withString: @""];
        numericString = [numericString stringByReplacingOccurrencesOfString: @":" withString: @""];
        numericString = [numericString stringByReplacingOccurrencesOfString: @"'" withString: @""];
        numericString = [numericString stringByReplacingOccurrencesOfString: @"-" withString: @""];
        numericString = [numericString stringByReplacingOccurrencesOfString: @"~" withString: @""];
        numericString = [numericString stringByReplacingOccurrencesOfString: @"'" withString: @""];
        numericString = [numericString stringByReplacingOccurrencesOfString: @"`" withString: @""];
        numericString = [numericString stringByReplacingOccurrencesOfString: @"_" withString: @""];
        numericString = [numericString stringByReplacingOccurrencesOfString: @" " withString: @""];
        
        
        if ([numericString length] < 3) return string;
        NSLog(@"found numeric string %@", numericString);
        
        
        NSString *firstNumeric = [numericString substringToIndex: [numericString length] - 2];
        NSString *secondNumeric = [numericString substringFromIndex: [numericString length] - 2];
        
        clusterText = [NSString stringWithFormat: @"%@ %@%c%@", nonNumericalString, firstNumeric, '.', secondNumeric];
        NSLog(@"RESULTING TEXT!!! %@", clusterText);
        return clusterText;
    }
    return string;
}

+(int) levDistance: (NSString *) w1 to: (NSString *) w2 {
    if ([w1 isEqualToString: @""] || [w2 isEqualToString: @""]) {
        return MAX([w1 length], [w2 length]);
    }
    
    //Delete first
    NSString *new1 = [w1 substringFromIndex: 1];
    int lev1 = [self levDistance: new1 to: w2] + 1;
    
    //Delete second
    NSString *new2 = [w2 substringFromIndex: 1];
    int lev2 = [self levDistance: w1 to: new2] + 1;
    
    //Replace both if not same
    int lev3 = [self levDistance: new1 to: new2] + 1 * ([w1 characterAtIndex: 0] != [w2 characterAtIndex: 0]);
    
    return MIN(MIN(lev1, lev2), lev3);
}

+(BOOL) isNumericString: (NSString *) string {
    NSScanner *scanner = [NSScanner scannerWithString: string];
    BOOL isNumeric = [scanner scanInteger: NULL] && [scanner isAtEnd];
    return isNumeric;
}

-(NSString *) getSpellChecked: (NSString *) string {
    NSArray *wordsList = [string componentsSeparatedByString: @" "];
    NSMutableArray *words = [NSMutableArray arrayWithArray: wordsList];
    for (int i = 0; i < [words count] - 1; i++) {
        NSString *word = words[i];
        
        if (![SpellChecker isNumericString: word]) {
            NSString *spellCheckedWord = [self spellCheckWord: word];
            if ([spellCheckedWord length] == 0) continue;
            
            if (i == 0) { //capitalize first character
                spellCheckedWord = [[[spellCheckedWord substringToIndex: 1] uppercaseString] stringByAppendingString: [spellCheckedWord substringFromIndex: 1]];
            }
            
            
            if (![spellCheckedWord isEqualToString: word]) NSLog(@"REPLACE %@ with %@", word, spellCheckedWord);
            
            words[i] = spellCheckedWord;
        }
    }
    
    
    NSString *retString = @"";
    for (int i = 0; i < [words count]; i++) {
        retString = [retString stringByAppendingString: words[i]];
        if (i != [words count] - 1) retString = [retString stringByAppendingString: @" "];
    }
    return retString;
}

+(int) getDistanceFromWord: (NSString *) word1 toWord: (NSString *) word2 {
    NSString *w1 = [word1 lowercaseString];
    NSString *w2 = [word2 lowercaseString];
    int levDistance = [self levDistance: w1 to: w2];
    NSLog(@"DISTANCE BETWEEN %@ and %@ is %d", word1, word2, levDistance);
    return levDistance;
}

+(NSString *) getPossibleMatchForTaxAndTip: (NSString *) string {
    int i = 0;
    while (i < [string length]) {
        if ([string characterAtIndex: i] == ' ') {
            break;
        }
        i++;
    }
    
    if (i > 0) {
        NSString *firstWord = [string substringToIndex: i];
        int distanceToTotal = [self getDistanceFromWord: firstWord toWord: @"total"];
        int distanceToTax = [self getDistanceFromWord: firstWord toWord: @"tax"];
        int distanceToSubtotal = [self getDistanceFromWord: firstWord toWord: @"subtotal"];
        
        if (distanceToSubtotal < 3) {
            return [NSString stringWithFormat: @"Subtotal%@", [string substringFromIndex:i]];
        }
        if (distanceToTotal < 3) {
            return [NSString stringWithFormat: @"Total%@", [string substringFromIndex:i]];
        }
        else if (distanceToTax < 3) {
            return [NSString stringWithFormat: @"Tax%@", [string substringFromIndex:i]];
        }
    }
    
    return string;
}


@end
