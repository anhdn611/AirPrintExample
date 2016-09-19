//
//  ViewController.m
//  AirPrintDemo
//
//  Created by cauca on 9/17/16.
//  Copyright © 2016 cauca. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPrintInteractionControllerDelegate>

@property (nonatomic, strong) UIPrinter *selectedPrinter;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *printerView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   NSString *printString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"InvoiceSimple" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [printString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.textView.attributedText = attributedString;
    [self.webView loadHTMLString:printString baseURL:nil];
}
- (IBAction)defaultPrint:(id)sender {
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGrayscale;
    printInfo.jobName = @"KiotViet";
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    printInfo.duplex = UIPrintInfoDuplexNone;
    pc.showsPageRange = YES;
    
    NSString *printString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"InvoiceSimple" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    
    UIMarkupTextPrintFormatter *markup = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:printString];
    pc.delegate = self;
    pc.printInfo = printInfo;
    pc.printFormatter = markup;
    [pc presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        [printInteractionController dismissAnimated:YES];
    }];
}

- (void)printInteractionControllerWillPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    
}
- (void)printInteractionControllerDidPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    
}
- (void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    
}
- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    
}

- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController {
    
}
- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)printTapped:(id)sender {
    [self printFromWebView];
}

- (void)showPrintPicker {
    UIPrinterPickerController *printPicker = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:self.selectedPrinter];
    self.selectedPrinter = printPicker.selectedPrinter;
    [printPicker presentFromRect:self.button.frame inView:self.printerView animated:YES completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
        self.selectedPrinter = printerPickerController.selectedPrinter;
        [self printFromWebView];
    }];
}

- (void)printFromWebView
{
    
    if (!self.selectedPrinter) {
        [self showPrintPicker];
        return;
    }
    
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGrayscale;
    printInfo.jobName = @"KiotViet";
    pc.printInfo = printInfo;
    
    pc.showsPageRange = YES;
    
    pc.printInfo = printInfo;
    UIPrintFormatter *formater = [self.webView viewPrintFormatter];
    pc.printFormatter = formater;
    
    [pc printToPrinter:self.selectedPrinter completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
    }];
}

@end
