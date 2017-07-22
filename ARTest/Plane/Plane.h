//
//  Plane.h
//  ARTest
//
//  Created by Cosmin Toncean on 7/21/17.
//  Copyright © 2017 Rodeapps. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface Plane : SCNNode

@property (nonatomic, strong) ARPlaneAnchor *anchor;
@property (nonatomic, strong) SCNPlane *planeGeometry;


- (instancetype)initWithAnchor:(ARPlaneAnchor *)anchor;
- (void)update:(ARPlaneAnchor *)anchor;

@end
