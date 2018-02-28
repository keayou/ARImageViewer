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
#import "ARTextNode.h"


static const CGFloat StartY = -0.5;

static const NSInteger MAXImageCountInRow = 6;

@interface ARImageViewerViewController ()<ARSCNViewDelegate>

@property (nonatomic, strong) ARSCNView *sceneView;
@property (nonatomic, strong) ARImageViewerConfig *imageConfig;

@end

@implementation ARImageViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self viewSetups];
    
    _imageConfig = [ARImageViewerConfig new];
    
    NSArray *imgList = @[@"z.jpg",@"z.jpg",@"z.jpg",@"z.jpg",@"z.jpg",@"z.jpg",@"z.jpg",@"z.jpg",@"z.jpg",@"z.jpg"];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreenAction:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.sceneView addGestureRecognizer:tapGestureRecognizer];
    
    
    //计算行数、 行内最大图片数
    float rowF = 1.0 * imgList.count / MAXImageCountInRow;
    int rows = ceil(rowF);
    
    float countF = 1.0 * imgList.count / rows;
    int countInRow = ceil(countF);
    
    for (int i = 0; i < rows; i++) {
        NSInteger len = (imgList.count - i * countInRow) > countInRow ? countInRow : (imgList.count - i * countInRow);
        
        NSArray *showList = [imgList subarrayWithRange:NSMakeRange(i * countInRow, len)];
        [self setupSceneImageWithImages:showList rowIndex:i];
    }
    
    [self addTitleWithText:@"傻孩子! 你怎么会是傻孩子呢？"];
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

- (void)viewSetups {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 20, 40, 40);
    backBtn.layer.cornerRadius = 40 / 2;
    backBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sceneView addSubview:backBtn];
}

#pragma mark - Events
- (void)tapScreenAction:(UITapGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self.sceneView];
    ARImageNode *arObject = [self virtualObjectAtPoint:touchPoint];
    if (arObject && arObject.image) {        
        [ARImagePreviewView showPreviewARImage:arObject.image inView:self.view];
        
    }
}

- (void)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
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


- (void)setupSceneImageWithImages:(NSArray *)imgList rowIndex:(NSInteger)rowIndex {

    CGFloat yOffset = StartY;
    CGFloat yMargin = 0.06;

    NSMutableArray <SCNNode *>*nodeArr = [NSMutableArray arrayWithCapacity:imgList.count];
    for (int idx = 0; idx < imgList.count; idx++) {

        NSString *imgName = imgList[idx];
        ARImageNode *imgNode = [self fetchNodeWithMaterialImageName:imgName];
        imgNode.position = SCNVector3Make(0, yOffset - rowIndex * (_imageConfig.imageHeight + yMargin), -_imageConfig.imageDepth);
        [nodeArr addObject:imgNode];
    }

    float flag = -1.0;// -1.0：图片顺时针展开  1.0：逆时针展开
    __block float angleDU = flag * 20/180.0 * M_PI;//首张位置

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
        
        angleDU += arctan;
        angleDU += marginAngle;
    }];
}



- (ARImageNode *)fetchNodeWithMaterialImageName:(NSString *)imgName {
    
    SCNMaterial *material = [SCNMaterial material];
    UIImage *img = [UIImage imageNamed:imgName];
    material.diffuse.contents = img;
    material.lightingModelName = SCNLightingModelPhysicallyBased;
    
    float ratio = _imageConfig.imageHeight/img.size.height;
    float width = ratio * img.size.width;
    
    SCNBox *boxGeometry = [SCNBox boxWithWidth:width height:_imageConfig.imageHeight length:0 chamferRadius:0];
    boxGeometry.materials = @[material];
    
    ARImageNode *boxNode = [[ARImageNode alloc]initNodeWithGeometry:boxGeometry];
    boxNode.image = img;
    return boxNode;
}

- (void)addTitleWithText:(NSString *)text {
    ARTextNode *textNode = [[ARTextNode alloc] initWithText:text];
    textNode.position = SCNVector3Make(0, 0 , -_imageConfig.imageDepth);
    [self.sceneView.scene.rootNode addChildNode:textNode];
}

#pragma mark - Lazy Init
- (ARSCNView *)sceneView {
    if (_sceneView) return _sceneView;

    _sceneView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    SCNScene *scene = [SCNScene scene];
    _sceneView.scene = scene;
    _sceneView.delegate = self;
    [self.view addSubview:_sceneView];
    return _sceneView;
}

@end
