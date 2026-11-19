class AnimNodeAimOffset extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

enum EAnimAimDir
{
    ANIMAIM_LEFTUP,                 // 0
    ANIMAIM_CENTERUP,               // 1
    ANIMAIM_RIGHTUP,                // 2
    ANIMAIM_LEFTCENTER,             // 3
    ANIMAIM_CENTERCENTER,           // 4
    ANIMAIM_RIGHTCENTER,            // 5
    ANIMAIM_LEFTDOWN,               // 6
    ANIMAIM_CENTERDOWN,             // 7
    ANIMAIM_RIGHTDOWN,              // 8
    ANIMAIM_MAX                     // 9
};

struct AimTransform
{
    var() Rotator Rotation;
    var() Vector Translation;

    structdefaultproperties
    {
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct AimComponent
{
    var() name BoneName;
    var byte BoneIndex;
    var() AimTransform LU;
    var() AimTransform LC;
    var() AimTransform LD;
    var() AimTransform CU;
    var() AimTransform CC;
    var() AimTransform CD;
    var() AimTransform RU;
    var() AimTransform RC;
    var() AimTransform RD;

    structdefaultproperties
    {
        BoneName="None"
        BoneIndex=0
        LU=(Rotation=(Pitch=0,Yaw=0,Roll=0),Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        LC=(Rotation=(Pitch=0,Yaw=0,Roll=0),Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        LD=(Rotation=(Pitch=0,Yaw=0,Roll=0),Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        CU=(Rotation=(Pitch=0,Yaw=0,Roll=0),Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        CC=(Rotation=(Pitch=0,Yaw=0,Roll=0),Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        CD=(Rotation=(Pitch=0,Yaw=0,Roll=0),Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        RU=(Rotation=(Pitch=0,Yaw=0,Roll=0),Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        RC=(Rotation=(Pitch=0,Yaw=0,Roll=0),Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        RD=(Rotation=(Pitch=0,Yaw=0,Roll=0),Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
    }
};

var array<AimComponent> AimComponents;
var() Vector2D Aim;
var() Vector2D HorizontalRange;
var() Vector2D VerticalRange;
var() bool bForceAimDir;
var(TransformSpace) bool m_bLocalSpace;
var() AnimNodeAimOffset.EAnimAimDir ForcedAimDir;
var array<byte> RequiredBones;
var transient bool bNotValidSetup;
var array<Matrix> BoneTM;

defaultproperties
{
    HorizontalRange=(X=0.0000000,Y=0.0000000)
    VerticalRange=(X=0.0000000,Y=0.0000000)
    ForcedAimDir=4
    Children[0]=(Name="Input",Anim=none,m_iAnimLeafIndex=-1,Weight=1.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    bFixNumChildren=true
}