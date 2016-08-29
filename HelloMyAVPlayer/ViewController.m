//
//  ViewController.m
//  HelloMyAVPlayer
//
//  Created by 張峻綸 on 2016/7/13.
//  Copyright © 2016年 張峻綸. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface ViewController ()
{
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
}
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"fullscreenPlayback"]) {
        
        NSURL *url =[NSURL URLWithString:@"http://184.72.239.149/vod/smil:bigbuckbunnyiphone.smil/playlist.m3u8"];
        AVPlayerViewController *vc = segue.destinationViewController;
        vc.player=[[AVPlayer alloc]initWithURL:url];
        [vc.player play];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) playWithURL:(NSURL*)url {
    
    [self stopBtnPressed:nil];
    
    
    player=[[AVPlayer alloc] initWithURL:url];
    playerLayer =[AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame=_resultImageView.frame;
    [self.view.layer addSublayer:playerLayer];
    [player play];
}

- (IBAction)playRemoteMovieBtnPressed:(UIButton *)sender {
    
    NSURL *url =[NSURL URLWithString:@"http://184.72.239.149/vod/smil:bigbuckbunnyiphone.smil/playlist.m3u8"];
    [self playWithURL:url];
}

- (IBAction)playLocalMovieBtnPressed:(UIButton *)sender {
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"the-smartest-smartphone.mp4" withExtension:nil];
    [self playWithURL:url];
}

- (IBAction)playRemoteMP3BtnPressed:(UIButton *)sender {
}

- (IBAction)stopBtnPressed:(UIButton *)sender {
    
    if (player != nil) {
        //rate為播放速度,正常播放速度為1.0,設定成0.0為停止播放
        player.rate=0.0;
        [playerLayer removeFromSuperlayer];
        player=nil;
        playerLayer=nil;
    }
}

- (IBAction)getThumbnailBtnPressed:(UIButton *)sender {
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"the-smartest-smartphone.mp4" withExtension:nil];
    
    AVURLAsset *asset =[AVURLAsset URLAssetWithURL:url options:nil];
    
    AVAssetImageGenerator  *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    
    //設定成true時,縮圖會跟著影片的方向縮圖
    generator.appliesPreferredTrackTransform=true;
    
    //CGImage為UIImage更底層的Image,每個UIImage都會有CGImage
    //如有UIImage可以產生CGImage,相反有CGImage可以產生UIImage,這裡用CGImage產生UIImage
    //CMTimeMake(30, 10)為把影片每秒生成10張Image,這裡拿第30張,為影片第三秒的縮圖
    
    //Support Error
    NSError *error;
    CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(30, 10) actualTime:nil error:&error];
    
    if (error) {
        // ... handle the error
        NSLog(@"Error:%@",error);
    }
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    _resultImageView.image=image;
}

@end
