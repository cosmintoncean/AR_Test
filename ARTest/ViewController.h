//
//  ViewController.h
//  ARTest
//
//  Created by Cosmin Toncean on 7/21/17.
//  Copyright © 2017 Rodeapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface ViewController : UIViewController {
    ARWorldTrackingConfiguration *arTrackingConfig;
    NSMutableDictionary *planesDictionary;
}

@end
