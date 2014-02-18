//
//  MyScene.h
//  SpriteKitDemo
//

//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene {
    int nextCoin;
    double nextCoinSpawn;
}

@property (strong, nonatomic) SKSpriteNode   *flappyBird;
@property (strong, nonatomic) NSMutableArray *flappyFrames;

@property (strong, nonatomic) NSMutableArray *coinsArray;
@property (nonatomic, strong) NSMutableArray *coinFrames;

@end
