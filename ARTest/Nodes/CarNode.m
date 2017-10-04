//
//  CarNode.m
//  ARTest
//
//  Created by Cosmin Toncean on 7/24/17.
//  Copyright © 2017 Rodeapps. All rights reserved.
//

#import "CarNode.h"

@implementation CarNode

- (instancetype)initWithPosition:(SCNVector3)position {
    self = [super init];
    
//    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/free_car_1.dae"];
//    self.carNode = [scene.rootNode childNodeWithName:@"car1" recursively:YES];
//    self.carNode.position = position;

    SCNScene *carScene = [SCNScene sceneNamed:@"art.scnassets/dodge.dae"];
    SCNNode *chassisNode = [carScene.rootNode childNodeWithName:@"Body_001" recursively:YES];
    
    SCNPhysicsBody *body = [SCNPhysicsBody dynamicBody];
    body.allowsResting = NO;
    body.mass = 80;
    body.restitution = 0.1;
    body.friction = 0.5;
    body.rollingFriction = 0;
    
    chassisNode.physicsBody = body;
    [carScene.rootNode addChildNode:chassisNode];
    
    return self;
}


@end
