class SPWallAnimationReachSpec extends SPWallReachSpec
    native;

enum ECollisionFailureReason
{
    ecfrStraightLineBlocked,        // 0
    ecfrPlatformCheckFailed,        // 1
    ECollisionFailureReason_MAX     // 2
};

struct native AnimationConnection
{
    var name ClassName;
    var name AnimationName;
    var Vector startPointOffset;
    var Vector endPointOffset;
    var Matrix startMatrix;
    var Matrix endMatrix;

    structdefaultproperties
    {
        ClassName="None"
        AnimationName="None"
        startPointOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        endPointOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        startMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        endMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
    }
};

struct native PotentialConnectionEntry
{
    var class<SPPawn> ClassName;
    var AnimSequence AnimSequence;
    var AnimSet AnimSet;

    structdefaultproperties
    {
        ClassName=none
        AnimSequence=none
        AnimSet=none
    }
};

struct native WallBoxPoint
{
    var Vector PointLocation;
    var bool bCloserToWallHalf;

    structdefaultproperties
    {
        PointLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bCloserToWallHalf=false
    }
};

struct native AnimationSubDivideInfo
{
    var Vector Location;
    var Quat Rotation;
    var Color Color;
    var float Time;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000)
        Color=(R=0,G=0,B=0,A=0)
        Time=0.0000000
    }
};

var array<AnimationConnection> AnimationConnections;
var float HorizontalDistance;
var float VerticalDistance;
var float DistanceBias;
var float MaxAnimationReachSpecLength;
var bool bReportingMode;
var bool bCachedClassOK;
var SPWallAnimationReachSpec.ECollisionFailureReason CollisionFailureReason;

defaultproperties
{
    DistanceBias=1.0000000
    MaxAnimationReachSpecLength=1200.0000000
}