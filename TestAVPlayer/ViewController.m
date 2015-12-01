//
//  ViewController.m
//  TestAVPlayer
//
//  Created by Alex Ogorek on 11/30/15.
//  Copyright © 2015 FitUnity. All rights reserved.
//

#import "ViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "FITPlayerView.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *playerContainerView;
@property (nonatomic, strong) NSMutableArray *playerArray;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"output" ofType:@"mov"];
	NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
	
	self.playerArray = [[NSMutableArray alloc] init];
	
	for (NSInteger x = 0; x < 30; ++x) {
		AVPlayer *player = [AVPlayer playerWithURL:url];
		[player addObserver:self forKeyPath:@"status" options:0 context:nil];
		
		//these 2 lines detect when the video has come to an end...
		player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(playerItemDidReachEnd:)
													 name:AVPlayerItemDidPlayToEndTimeNotification
												   object:[player currentItem]];
		
		[self.playerArray addObject:player];
		
		[self addPlayerToScreen:player];
	}
}

- (void)addPlayerToScreen:(AVPlayer *)player {
	CGSize winSize = [UIScreen mainScreen].bounds.size;
	
	FITPlayerView *newView = [[FITPlayerView alloc] initWithFrame:CGRectMake((self.playerArray.count-1)*winSize.width, 0, winSize.width, winSize.height)];
	UIButton *play = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height)];
	[play addTarget:self action:@selector(playVideoAtIndex:) forControlEvents:UIControlEventTouchUpInside];
	play.tag = self.playerArray.count-1;
	[newView addSubview:play];
	
	[(AVPlayerLayer *)[newView layer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	[(AVPlayerLayer *)[newView layer] setPlayer:player];
	
	[self.playerContainerView addSubview:newView];
}

-(void)playVideoAtIndex:(id)sender {
	UIButton *button = (UIButton*)sender;
	NSInteger tag = button.tag;
	
	AVPlayer *player = self.playerArray[tag];
	
	//check to see if the video is currently playing... if so, PAUSE
	if (player.rate > 0 && !player.error)
	{
		//[self showPaused];
		[player pause];
	}
	else
	{
		NSLog(@"playing...");
		[player play];
		//self.playPauseButton.alpha = 0;
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						change:(NSDictionary *)change context:(void *)context {
	
	for (AVPlayer *player in self.playerArray) {
		if (object == player && [keyPath isEqualToString:@"status"]) {
			if (player.status == AVPlayerStatusReadyToPlay) {
				//self.playIconParentView.hidden = YES;
			} else if (player.status == AVPlayerStatusFailed) {
				// something went wrong. player.error should contain some information
				
			}
			break;
		}
	}
}

//the method for when the video reaches the end... set it to the beginning and play it again
- (void)playerItemDidReachEnd:(NSNotification *)notification {
	
	AVPlayerItem *notifPlayerItem = [notification object];
	
	for (AVPlayer *player in self.playerArray) {
		AVPlayerItem *playerItem = [player currentItem];
		if (notifPlayerItem == playerItem) {
			[notifPlayerItem seekToTime:kCMTimeZero];
			//[self.player play]; //uncomment for auto-restart
		}
	}
	
	//[self.playPauseButton setImage:[UIImage imageNamed:@"replay_icon"] forState:UIControlStateNormal];
	//[self showPaused];
	
}


-(IBAction)pauseAllVideos {
	for (AVPlayer *player in self.playerArray) {
		[player pause];
	}
}
@end
