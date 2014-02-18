//
//  MyScene.m
//  SpriteKitDemo
//
//  Created by Ivan Lesko on 2/17/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "MyScene.h"

#define kNumCoins 8
#define kNumPowerups 1


@implementation MyScene


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        nextCoin = 0;
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        [self setupBackground];
        [self setupFlappyBird];
        [self setupCoins];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    [self.flappyBird.physicsBody setVelocity:CGVectorMake(0, 0)];
    [self.flappyBird.physicsBody applyImpulse:CGVectorMake(0, 10)];
}

-(void)update:(CFTimeInterval)currentTime {
    // Animate the background.
    [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *bg = (SKSpriteNode *)node;
        bg.position = CGPointMake(bg.position.x - 1.5, bg.position.y);
        
        if (bg.position.x <= -bg.size.width) {
            bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y);
        }
    }];
    
    double curTime = CACurrentMediaTime();
    
    if (curTime > nextCoinSpawn) {
        
        float randomSeconds = [self randomValueBetweenFloat:0.05f andValue:0.2f];
        nextCoinSpawn = randomSeconds + curTime;
        
        float randomY = [self randomValueBetweenFloat:0.0f andValue:self.frame.size.height];
        float randomDuration = [self randomValueBetweenFloat:5.0f andValue:8.0f];
        
        SKSpriteNode *coin = self.coinsArray[nextCoin];
        [coin removeAllActions];
        nextCoin++;
        
        if (nextCoin >= self.coinsArray.count) {
            nextCoin = 0;
        }
        
        coin.position = CGPointMake(self.frame.size.width + coin.size.width / 2, randomY);
        coin.hidden = NO;

        CGPoint location = CGPointMake(-600, randomY);
        
        [coin runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.coinFrames
                                                                       timePerFrame:0.1f
                                                                             resize:NO
                                                                            restore:YES]] withKey:@"spinningCoinInPlace"];
        
        SKAction *moveAction = [SKAction moveTo:location duration:randomDuration];
        SKAction *doneAction = [SKAction runBlock:^{
            coin.hidden = YES;
        }];

        SKAction *moveFlappyActionWithDone = [SKAction sequence:@[moveAction, doneAction]];
        
        [coin runAction:moveFlappyActionWithDone];
    
        // Checks if flappy bird intersects coin.
        for (SKSpriteNode *coin in self.coinsArray) {
            if ([self.flappyBird intersectsNode:coin]) {
                coin.hidden = YES;
            }
        }
    }
}



- (float)randomValueBetweenFloat:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low) + low);
}

- (void)setupBackground {
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        bg.anchorPoint = self.anchorPoint;
        bg.position = CGPointMake(i * self.size.width, 0);
        bg.size = self.size;
        bg.name = @"background";
        [self addChild:bg];
    }
}

- (void)setupFlappyBird {
    self.flappyFrames = [NSMutableArray array];
    SKTextureAtlas *flappyAnimatedAtlas = [SKTextureAtlas atlasNamed:@"flappyAnims"];
    
    for (int i = 1; i < flappyAnimatedAtlas.textureNames.count; i++) {
        NSString *textName = [NSString stringWithFormat:@"flappyBird_%d", i];
        SKTexture *temp = [flappyAnimatedAtlas textureNamed:textName];
        [self.flappyFrames addObject:temp];
    }
    
    NSMutableArray *flappyBirdFlappingFrames = self.flappyFrames;
    
    SKTexture *temp = flappyBirdFlappingFrames[0];
    self.flappyBird = [SKSpriteNode spriteNodeWithTexture:temp];
    self.flappyBird.size = CGSizeMake(self.flappyBird.size.width * 2, self.flappyBird.size.height * 2);
    self.flappyBird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:self.flappyBird];
    [self flappingBird];
    
    self.flappyBird.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.flappyBird.size];
    self.flappyBird.physicsBody.dynamic = YES;
    self.flappyBird.physicsBody.affectedByGravity = YES;
    self.flappyBird.physicsBody.mass = 0.025;
}

- (void)setupCoins {
    int numberOfCoins = 20;
    
    self.coinFrames = [NSMutableArray array];
    self.coinsArray = [NSMutableArray arrayWithCapacity:numberOfCoins];
    
    SKTextureAtlas *animatedCoinAtlas = [SKTextureAtlas atlasNamed:@"coinAnims"];
    
    for (int i = 1; i < animatedCoinAtlas.textureNames.count + 1; i++) {
        NSString *textName = [NSString stringWithFormat:@"coin_%d", i];
        SKTexture *temp = [animatedCoinAtlas textureNamed:textName];
        [self.coinFrames addObject:temp];
    }

    NSMutableArray *spinningCoinFrames = self.coinFrames;
    
    for (int i = 1; i < numberOfCoins + 1; i++) {
        SKSpriteNode *coin = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"coin_%d.png", i]];
        coin.name = @"coin";
        coin.hidden = YES;
        [self.coinsArray addObject:coin];
        [self addChild:coin];
    }
}

- (void)flappingBird {
    [self.flappyBird runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.flappyFrames
                                                                              timePerFrame:0.1f
                                                                                    resize:NO
                                                                                   restore:YES]] withKey:@"flappingInPlaceBird"];
    return;
}


@end












