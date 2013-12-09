/* Will Harvey */

/* Responsible for interfacing with the 221 opencv code */

#import "ReceiptGenerator.h"
#import "ImageProcessor.h"
#import "TesseractController.h"
#import "SpellChecker.h"
#import "ReceiptModel.h"
#import "ClusterDecisionTreeClassifier.h"
#import "ClusterMatrixManager.h"
#import "ClusterWrapper.h"
#import "UIImage+OpenCV.h"

@implementation ReceiptGenerator

+(ReceiptModel *) getReceiptForImage: (UIImage *) image {
    UIImage *newImage = [ImageProcessor resizeImage: image];
    cv::Mat theMat = [newImage CVMat];
    
    //Process original image - prepare for clustering
    [ImageProcessor performInitialImageProcessing: theMat];
    
    TesseractController *tc = [[TesseractController alloc] init];
    //Create clusters and superate matrices for each
    NSMutableArray *clusterMatrices = [ClusterMatrixManager extractClusterMats: theMat];
    
    //For each cluster matrix, use Tesseract OCR to create recognized text
    for (ClusterWrapper *cluster in clusterMatrices) {
        cluster.recognizedText = [tc processOcrAt: [UIImage imageWithCVMat: cluster.clusterMat]];
        NSLog(@"%@", cluster.recognizedText);
    }
    
    SpellChecker *spellChecker = [[SpellChecker alloc] init];
    ReceiptModel *receipt = [ClusterDecisionTreeClassifier processReceiptFromClusters: clusterMatrices withSpellChecker: spellChecker];
    NSLog(@"TITLE %@", receipt.title);
    NSLog(@"TOTAL AMOUNT: %f", receipt.totalAmount);
    NSLog(@"TAX AMOUNT: %f", receipt.taxAmount);
    NSLog(@"ITEMS: %@", receipt.itemsPurchased);
    
    return receipt;
}

@end
