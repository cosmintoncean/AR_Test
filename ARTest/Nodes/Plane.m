//
//  Plane.m
//  ARTest
//
//  Created by Cosmin Toncean on 7/21/17.
//  Copyright © 2017 Rodeapps. All rights reserved.
//

#import "Plane.h"

@implementation Plane

- (instancetype)initWithAnchor:(ARPlaneAnchor *)anchor {
    self = [super init];
    
    self.planeGeometry = [SCNPlane planeWithWidth:anchor.extent.x height:anchor.extent.z];
    SCNNode *planeNode = [SCNNode nodeWithGeometry:self.planeGeometry];
    planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
    
    // Planes in SceneKit are vertical by default so we need to rotate
    // 90 degrees to match planes in ARKit
    planeNode.transform = SCNMatrix4MakeRotation(-M_PI / 2.0, 1.0, 0.0, 0.0);
    [self addChildNode:planeNode];
    
    return self;
}

- (void)update:(ARPlaneAnchor *)anchor {
    // As the user moves around the extend and location of the plane
    // may be updated. We need to update our 3D geometry to match the
    // new parameters of the plane.
    self.planeGeometry.width = anchor.extent.x;
    self.planeGeometry.height = anchor.extent.z;
    
    // When the plane is first created it's center is 0,0,0 and the nodes
    // transform contains the translation parameters. As the plane is updated
    // the planes translation remains the same but it's center is updated so
    // we need to update the 3D geometry position
    self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
    
//    SCNNode *node = [self.childNodes firstObject];
//    node.physicsBody = [SCNPhysicsBody
//                        bodyWithType:SCNPhysicsBodyTypeKinematic
//                        shape: [SCNPhysicsShape shapeWithGeometry:self.planeGeometry options:nil]];
}

@end
