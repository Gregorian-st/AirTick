//
//  TabBarController.m
//  AirTick
//
//  Created by Grigory Stolyarov on 28.05.2021.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "FavoriteTicketsViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor = [UIColor systemBlueColor];
    }
    return self;
}

- (void)viewDidLoad {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:12]} forState:UIControlStateNormal];
}

- (NSArray<UIViewController*> *)createViewControllers {
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray new];
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Ticket Search" image:[UIImage imageNamed:@"ticket_search"] tag:0];
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [mainNavigationController setTitle:@"Ticket Search"];
    [controllers addObject:mainNavigationController];
    
    MapViewController *mapViewController = [[MapViewController alloc] init];
    mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Price Map" image:[UIImage imageNamed:@"price_map"] tag:1];
    UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    [mapNavigationController setTitle:@"Price Map"];
    [controllers addObject:mapNavigationController];
    
    FavoriteTicketsViewController *favoriteViewController = [[FavoriteTicketsViewController alloc] initFavoriteTicketsController];
    favoriteViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorites" image:[UIImage systemImageNamed:@"star"] tag:2];
    UINavigationController *favoriteNavigationController = [[UINavigationController alloc] initWithRootViewController:favoriteViewController];
    [favoriteNavigationController setTitle:@"Favorites"];
    [controllers addObject:favoriteNavigationController];
    
    return controllers;
}

@end
