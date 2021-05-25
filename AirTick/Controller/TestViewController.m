//
//  TestViewController.m
//  AirTick
//
//  Created by Grigory Stolyarov on 14.05.2021.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
}

- (void)setupViewController {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"Test";
    
    CGFloat nextY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].windows.lastObject.windowScene.statusBarManager.statusBarFrame.size.height;
    
    // Create UILabel
    CGRect testLabelFrame = CGRectMake(20, nextY + 10, self.view.bounds.size.width - 40, 20);
    UILabel *testLabel = [[UILabel alloc] initWithFrame:testLabelFrame];
    testLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
    testLabel.textColor = [UIColor darkGrayColor];
    testLabel.textAlignment = NSTextAlignmentCenter;
    testLabel.text = @"This is a test Label";
    [self.view addSubview:testLabel];
    nextY += 10 + testLabelFrame.size.height;
    
    // Create UITextField
    CGRect testTextFieldFrame = CGRectMake(20, nextY + 10, self.view.bounds.size.width - 40, 40);
    UITextField *testTextField = [[UITextField alloc] initWithFrame:testTextFieldFrame];
    testTextField.borderStyle = UITextBorderStyleRoundedRect;
    testTextField.placeholder = @"Input text here...";
    [self.view addSubview:testTextField];
    nextY += 10 + testTextFieldFrame.size.height;
    
    // Create UITextView
    CGRect testTextViewFrame = CGRectMake(20, nextY + 10, self.view.bounds.size.width - 40, 80);
    UITextView *testTextView = [[UITextView alloc] initWithFrame:testTextViewFrame];
    testTextView.layer.borderColor = [[UIColor systemGray2Color] CGColor];
    testTextView.layer.borderWidth = 0.5;
    testTextView.layer.cornerRadius = 5.0;
    [testTextView.layer masksToBounds];
    testTextView.backgroundColor = [UIColor systemGray6Color];
    testTextView.text = @"This is a test";
    [self.view addSubview:testTextView];
    nextY += 10 + testTextViewFrame.size.height;
    
    // Create UIImageView
    CGRect testImageViewFrame = CGRectMake(20, nextY + 10, self.view.bounds.size.width - 40, 100);
    UIImageView *testImageView = [[UIImageView alloc] initWithFrame: testImageViewFrame];
    testImageView.image = [UIImage imageNamed:@"coffee"];
    testImageView.contentMode = UIViewContentModeScaleAspectFill;
    testImageView.clipsToBounds = YES;
    testImageView.layer.cornerRadius = 5.0;
    [testImageView.layer masksToBounds];
    [self.view addSubview:testImageView];
    nextY += 10 + testImageViewFrame.size.height;
    
    // Create UIProgressView
    CGRect testProgressViewFrame = CGRectMake(20, nextY + 10, self.view.bounds.size.width - 40, 20);
    UIProgressView *testProgressView = [[UIProgressView alloc] initWithFrame:testProgressViewFrame];
    testProgressView.progressViewStyle = UIProgressViewStyleDefault;
    testProgressView.progressTintColor = [UIColor systemGreenColor];
    testProgressView.progress = 0.5;
    [self.view addSubview:testProgressView];
    nextY += 10 + testProgressViewFrame.size.height;
    
    // Create UISlider
    CGRect testSliderFrame = CGRectMake(20, nextY + 10, self.view.bounds.size.width - 40, 20);
    UISlider *testSlider = [[UISlider alloc] init];
    testSlider.frame = testSliderFrame;
    testSlider.tintColor = [UIColor systemGreenColor];
    testSlider.value = 0.5;
    [self.view addSubview:testSlider];
    nextY += 10 + testSliderFrame.size.height;
    
    // Create UIActivityIndicatorView
    CGRect testActivityIndicatorViewFrame = CGRectMake(20, nextY + 10, self.view.bounds.size.width - 40, 80);
    UIActivityIndicatorView *testActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:testActivityIndicatorViewFrame];
    testActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
    testActivityIndicatorView.color = [UIColor systemGrayColor];
    [testActivityIndicatorView startAnimating];
    [self.view addSubview:testActivityIndicatorView];
}

@end
