class SPWallPathPlacementHelper extends Actor
    native
    placeable;

/** Vars */
var() SPWallPathPlacementHelperProperty WallPathPlacementHelperProperty;
var const export editinline SpriteComponent MySpriteComponent;
var duplicatetransient SPPathNode StartNode;
var duplicatetransient SPPathNode EndNode;
var Vector SurfaceNormal;
var Vector SurfaceLocation;
var Vector CornerLocation;
var float DistanceToSurface;
var float ElapsedTimeSinceMove;
var Vector LastFeatureFindLocation;
var Vector StartWallBoneLocation;
var Vector StartWallBoneNormal;
var Vector EndWallBoneLocation;
var Vector EndWallBoneNormal;
var Vector DefaultStartBoneLocalOffset;
var Vector DefaultStartBoneLocalNormal;
var Vector DefaultEndBoneEndOffset;
var Vector DefaultEndBoneLocalNormal;
var Vector DefaultUnderConstrainedWallBoneOffsetFromStart;
var bool bUseUnderConstrainedWallBoneOffset;
var float AnimationDistanceScale;
var Vector DefaultStartLocalWallToNodeOffset;
var Vector DefaultEndLocalWallToNodeOffset;
var duplicatetransient array<AnimationSubDivideInfo> AnimationSubDivideInfoArray;
var transient SPWallAnimationReachSpec TestReachSpec;
