//
//  FITPlayerView.m
//  FitUnity
//
//  Created by Dylan Moore on 8/19/15.
//  Copyright (c) 2015 FitUnity. All rights reserved.
//

#import "FITPlayerView.h"

@implementation FITPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer*)player {
    AVPlayer *player = [(AVPlayerLayer *)[self layer] player];
    return player;
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}
@end

