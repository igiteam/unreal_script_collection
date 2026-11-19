class EvilCoverMeshComponent extends SkeletalMeshComponent
    native(AI)
    config(Engine)
    editinlinenew
    hidecategories(Object);

var() name StdCoverRight;
var() name StdCoverLeft;
var() name StdCoverRightAim;
var() name StdCoverLeftAim;
var() name MidCoverRight;
var() name MidCoverLeft;
var() name MidCoverLeftUpAim;
var() name MidCoverRightUpAim;
var() name MidCoverRightAim;
var() name MidCoverLeftAim;
var bool bIsMirrored;
var editoronly transient bool bShowWhenNotSelected;
var CoverLink.ECoverAction CoverAction;
var Vector LocationOffset;

defaultproperties
{
    StdCoverRight="Cov_Std_R_Idle"
    StdCoverLeft="Cov_Std_L_Idle"
    StdCoverRightAim="Cov_Std_R_Aim"
    StdCoverLeftAim="Cov_Std_L_Aim"
    MidCoverRight="Cov_Mid_R_Idle"
    MidCoverLeft="Cov_Mid_L_Idle"
    MidCoverLeftUpAim="Cov_Mid_L_AimUp"
    MidCoverRightUpAim="Cov_Mid_R_AimUp"
    MidCoverRightAim="Cov_Mid_R_Aim"
    MidCoverLeftAim="Cov_Mid_L_Aim"
    LocationOffset=(X=0.0000000,Y=0.0000000,Z=-60.0000000)
    SkeletalMesh=none
    // Reference: AnimNodeSequence'Default__EvilCoverMeshComponent.AnimNodeSeq0'
    begin object name=AnimNodeSeq0 class=Class'Engine.AnimNodeSequence'
    end object
    Animations=AnimNodeSeq0
    MinDistFactorForKinematicUpdate=0.2000000
    bPerBoneMotionBlur=true
    bChartDistanceFactor=true
    bCacheAnimSequenceNodes=false
    ReplacementPrimitive=none
    RBDominanceGroup=20
    HiddenGame=true
    CastShadow=false
    bAcceptsLights=false
    bUseOnePassLightingOnTranslucency=true
}