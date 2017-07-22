//
//  ViewController.m
//  ARTest
//
//  Created by Cosmin Toncean on 7/21/17.
//  Copyright © 2017 Rodeapps. All rights reserved.
//

#import "ViewController.h"
#import "Plane.h"

@interface ViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (nonatomic, strong) SCNNode *carNode;

@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupScene];
    [self setupSceneConfiguration];
    [self setupRecognizer];
    planesDictionary = [NSMutableDictionary dictionary];
    
    // Stop the screen from dimming while we are using the app
    [UIApplication.sharedApplication setIdleTimerDisabled:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.sceneView.session runWithConfiguration:arTrackingConfig options:0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

- (void)setupScene {
    self.sceneView.delegate = self;
    self.sceneView.showsStatistics = YES;
    self.sceneView.antialiasingMode = SCNAntialiasingModeMultisampling4X;
    self.sceneView.autoenablesDefaultLighting = YES;
    self.sceneView.automaticallyUpdatesLighting = YES;
    
    //DEBUG
    self.sceneView.debugOptions = ARSCNDebugOptionShowWorldOrigin | ARSCNDebugOptionShowFeaturePoints;
    
    // Set the scene to the view
//    self.sceneView.scene = scene;
}

- (void)setupSceneConfiguration {
    arTrackingConfig = [ARWorldTrackingSessionConfiguration new];
    arTrackingConfig.lightEstimationEnabled = YES;
    arTrackingConfig.planeDetection = ARPlaneDetectionHorizontal;
}

- (void)setupRecognizer {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tapGestureDetected:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.sceneView addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)tapGestureDetected:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    // Take the screen space tap coordinates and pass them to the hitTest method on the ARSCNView instance
    CGPoint tapPoint = [tapGestureRecognizer locationInView:self.sceneView];
    NSArray<ARHitTestResult *> *result = [self.sceneView hitTest:tapPoint types:ARHitTestResultTypeExistingPlaneUsingExtent];
    
    // If the intersection ray passes through any plane geometry they will be returned, with the planes
    // ordered by distance from the camera
    if (result.count == 0) {
        return;
    }
    
    // If there are multiple hits, just pick the closest plane
    ARHitTestResult * hitResult = [result firstObject];
    [self spawnCar:hitResult];
}

- (void)spawnCar:(ARHitTestResult *)hitResult {
    
    float insertionYOffset = 0.5;
    SCNVector3 position = SCNVector3Make(
                                         hitResult.worldTransform.columns[3].x,
                                         hitResult.worldTransform.columns[3].y + insertionYOffset,
                                         hitResult.worldTransform.columns[3].z
                                         );
    
    self.carNode = [[SCNNode alloc] init];
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/free_car_1.dae"];
    self.carNode = [scene.rootNode childNodeWithName:@"car1" recursively:YES];
    self.carNode.position = position;

    [self.sceneView.scene.rootNode addChildNode:self.carNode];
}

#pragma mark - ARSCNViewDelegate

/*
// Override to create and configure nodes for anchors added to the view's session.
- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
    SCNNode *node = [SCNNode new];
 
    // Add geometry to the node...
 
    return node;
}
*/

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
        return;
    }
    Plane *plane = [[Plane alloc] initWithAnchor:(ARPlaneAnchor *)anchor];
    [planesDictionary setObject:plane forKey:anchor.identifier];
    [node addChildNode:plane];
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    Plane *plane = [planesDictionary objectForKey:anchor.identifier];
    if (plane == nil) {
        return;
    }
    [plane update:(ARPlaneAnchor *)anchor];
}

- (void)showAlertWithMessage:(NSString *)message andTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Interruption"
                                                                   message:@"The tracking session has been interrupted. The session will be reset once the interruption has completed"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    [self showAlertWithMessage:@"Session Error" andTitle:@"Fuck"];
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay, or being put in to the background
    [self showAlertWithMessage:@"The tracking session has been interrupted. The session will be reset once the interruption has completed" andTitle:@"Interruption"];
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    [self showAlertWithMessage:@"Tracking session has been reset due to interruption" andTitle:@"Interruption Ended"];
    
}


@end
