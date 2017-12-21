//
//  ARImageViewerViewController.m
//  ARImageViewer
//
//  Created by fk on 2017/12/20.
//  Copyright © 2017年 fk. All rights reserved.
//

#import "ARImageViewerViewController.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

#import "ARImageNode.h"
#import "ARImagePreviewView.h"
#import "ARImageViewerConfig.h"

@interface ARImageViewerViewController ()<ARSCNViewDelegate>

@property (nonatomic, strong) ARSCNView *sceneView;

@property (nonatomic, strong) ARImageViewerConfig *imageConfig;
@end

@implementation ARImageViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
//
//    SCNScene *scene = [SCNScene scene];
////    [self thirdWithScene:scene isLeft:YES];
//    self.sceneView.delegate = self;
//    self.sceneView.scene = scene;
    
    _imageConfig = [ARImageViewerConfig new];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreenAction:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.sceneView addGestureRecognizer:tapGestureRecognizer];
    
    NSArray *imgList = @[@"qq.PNG",@"c.jpg",@"qq.PNG",@"fanyi",@"fanyi"];

    NSArray *imgList1 = @[@"c.jpg",@"fanyi",@"qq.PNG",@"fanyi",@"fanyi"];

    
    [self setupSceneImageWithImages:imgList rowIndex:0 isLeft:YES];
    [self setupSceneImageWithImages:imgList1 rowIndex:1 isLeft:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.sceneView.session pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Events
- (void)tapScreenAction:(UITapGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self.sceneView];
    ARImageNode *arObject = [self virtualObjectAtPoint:touchPoint];
    if (arObject && arObject.image) {        
        [ARImagePreviewView showPreviewARImage:arObject.image inView:self.view];
        
    }
}

#pragma mark - Private
- (ARImageNode *)virtualObjectAtPoint:(CGPoint)point {
    
    NSDictionary *dict = @{SCNHitTestBoundingBoxOnlyKey:@(YES)};
    
    NSArray<SCNHitTestResult *> *results= [self.sceneView hitTest:point options:dict];
    for (SCNHitTestResult *res in results) {
        
        ARImageNode *arObject = [ARImageNode isNodePartOfARObject:res.node];
        if (arObject) {
            return arObject;
            break;
        }
    }
    return nil;

}

//- (void)setupSceneImageWithImages:(NSArray *)imgList isLeft:(BOOL)isLeft {
//
//    //    NSArray *imgList = @[@"x.jpg",@"x.jpg",@"x.jpg",@"x.jpg",@"x.jpg",@"x.jpg"];
//
//    NSMutableArray <SCNNode *>*nodeArr = [NSMutableArray arrayWithCapacity:imgList.count];
//    for (int idx = 0; idx < imgList.count; idx++) {
//        NSString *imgName = imgList[idx];
//        ARImageNode *imgNode = [self fetchNodeWithMaterialImageName:imgName];
//        imgNode.position = SCNVector3Make(0, 0, -_imageConfig.imageDepth);
//        [nodeArr addObject:imgNode];
//    }
//
//    __block float angleDU = 0;
//
//    //    float flag = 1;
//    //    if (isLeft) {
//    //        flag = -1;
//    //    }
//
//    __block NSInteger leftCount = 0;
//    __block NSInteger rightCount = 0;
//
//    __block float lastLeftAng = 0;
//    __block float lastRightAng = 0;
//
//    float marginAngle = _imageConfig.marginAngle/180.0 * M_PI;
//
//
//    [nodeArr enumerateObjectsUsingBlock:^(SCNNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        float flag = 1; //left
//        if (idx % 2 == 0) {
//            flag = -1;//right
//        }
//
//        SCNVector3 minBound,maxBound;
//        [obj.geometry getBoundingBoxMin:&minBound max:&maxBound];
//        CGFloat width = maxBound.x - minBound.x;
//
//        float arctan = atan(width / 2.0 / _imageConfig.imageDepth);
//
//        float transAngle = 0;
//
//        if (idx != 0) {
//            //            angleDU += arctan;
//            transAngle = arctan;
//
//            if (flag == 1) {
//                transAngle += lastLeftAng;
//            } else {
//                transAngle += lastRightAng;
//            }
//        }
//
//
//        SCNNode *node = [SCNNode new];
//        node.position = SCNVector3Zero;
//        [self.sceneView.scene.rootNode addChildNode:node];
//        [node addChildNode:obj];
//        node.rotation = SCNVector4Make(0, 1, 0, flag * transAngle);
//
//        float du =  arctan + marginAngle;
//
//        if (flag == 1) {
//            lastLeftAng += du;
//        } else {
//            lastRightAng += du;
//        }
//
//        angleDU += du;
//    }];
//}


- (void)setupSceneImageWithImages:(NSArray *)imgList rowIndex:(NSInteger)rowIndex isLeft:(BOOL)isLeft {

    NSMutableArray <SCNNode *>*nodeArr = [NSMutableArray arrayWithCapacity:imgList.count];
    for (int idx = 0; idx < imgList.count; idx++) {
        NSString *imgName = imgList[idx];
        ARImageNode *imgNode = [self fetchNodeWithMaterialImageName:imgName];
        imgNode.position = SCNVector3Make(0, -0.5+rowIndex*(_imageConfig.imageHeight + 0.06), -_imageConfig.imageDepth);
//        imgNode.rotation = SCNVector4Make(1, 0, 0, 5/180.0 * M_PI);

        [nodeArr addObject:imgNode];
    }

    __block float angleDU = -20/180.0 * M_PI;

    float flag = 1;
    if (isLeft) flag = -1;

    float marginAngle = _imageConfig.marginAngle/180.0 * M_PI;

    [nodeArr enumerateObjectsUsingBlock:^(SCNNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        SCNVector3 minBound,maxBound;
        [obj.geometry getBoundingBoxMin:&minBound max:&maxBound];
        CGFloat width = maxBound.x - minBound.x;

        float arctan = atan(width / 2.0 / _imageConfig.imageDepth);

        if (idx != 0) {
            angleDU += arctan;
        }

        SCNNode *node = [SCNNode new];
        node.position = SCNVector3Zero;
        [self.sceneView.scene.rootNode addChildNode:node];
        [node addChildNode:obj];
        node.rotation = SCNVector4Make(0, 1, 0, flag * angleDU);

        angleDU += marginAngle;
        angleDU += arctan;
    }];
}

- (ARImageNode *)fetchNodeWithMaterialImageName:(NSString *)imgName {
    
    SCNMaterial *material = [SCNMaterial material];
    UIImage *img = [UIImage imageNamed:imgName];
    material.diffuse.contents = img;
    material.lightingModelName = SCNLightingModelPhysicallyBased;
    
    float ratio = _imageConfig.imageHeight/img.size.height;
    
    float width = ratio * img.size.width;
    
    NSLog(@"width --- %f",width);
    
    SCNBox *boxGeometry = [SCNBox boxWithWidth:width height:_imageConfig.imageHeight length:0 chamferRadius:0];
    boxGeometry.materials = @[material];
    
    
    ARImageNode *boxNode = [[ARImageNode alloc]initNodeWithGeometry:boxGeometry];
    boxNode.image = img;
    return boxNode;
}



#pragma mark - Lazy Init
- (ARSCNView *)sceneView {
    if (_sceneView) return _sceneView;

    _sceneView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    SCNScene *scene = [SCNScene scene];
    _sceneView.scene = scene;
    _sceneView.delegate = self;
    [self.view addSubview:_sceneView];
//    _sceneView.session = self.arSession;
//    _sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    
//    _sceneView.antialiasingMode = SCNAntialiasingModeMultisampling4X;
//    _sceneView.automaticallyUpdatesLighting = NO;
//    _sceneView.autoenablesDefaultLighting = NO;
//    _sceneView.preferredFramesPerSecond = 60;
//    _sceneView.contentScaleFactor = 1.3;
    
//    SCNCamera *camera = _sceneView.pointOfView.camera;
//    if (camera) {
//        camera.wantsHDR = YES;
//        camera.wantsExposureAdaptation = YES;
//        camera.exposureOffset = -1;
//        camera.minimumExposure = -1;
//        camera.maximumExposure = 3;
//    }
    return _sceneView;
}

@end
