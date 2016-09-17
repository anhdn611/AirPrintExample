//
//  ViewController.m
//  AirPrintDemo
//
//  Created by cauca on 9/17/16.
//  Copyright © 2016 cauca. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIPrinter *selectedPrinter;
@property (weak, nonatomic) IBOutlet UIButton *button;
 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)printTapped:(id)sender {
    [self print];
}

- (void)showPrintPicker {
    UIPrinterPickerController *printPicker = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:self.selectedPrinter];
    self.selectedPrinter = printPicker.selectedPrinter;
[printPicker presentFromRect:self.button.frame inView:self.button animated:YES completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
    self.selectedPrinter = printerPickerController.selectedPrinter;
    [self print];
}];
}

- (void)print
{
    if (!self.selectedPrinter) {
        [self showPrintPicker];
        return;
    }
    
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"KiotViet";
    pc.printInfo = printInfo;
    pc.showsPageRange = YES;
    
    NSString *printString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"InvoiceSimple" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    
    UIMarkupTextPrintFormatter *markup = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:printString];
    
    pc.printInfo = printInfo;
    pc.printFormatter = markup;
    
    [pc printToPrinter:self.selectedPrinter completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        
    }];

}
@end
