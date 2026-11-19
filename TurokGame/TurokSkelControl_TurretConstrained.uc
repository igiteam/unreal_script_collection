class TurokSkelControl_TurretConstrained extends SkelControlSingleBone
    native
    hidecategories(Object);

struct native FTurretMovementSettings
{
    var() const editconst name Axis;
    var() float mRotationSpeed;
    var() bool mbEnable;
    var() bool mbInvert;

    structdefaultproperties
    {
        Axis="None"
        mRotationSpeed=1.0000000
        mbEnable=false
        mbInvert=false
    }
};

var() @NULL mSettings[3];
var private @NULL DesiredBoneRotation;
var private @NULL MyPawn;
var private bool mbDoForceRotation;
var private bool mbHoldRotation;

// Export UTurokSkelControl_TurretConstrained::execSetDesiredRotation(FFrame&, void* const)
native simulated function SetDesiredRotation(@NULL Rotation);

function SetPawn(@NULL P)
{
    MyPawn = P;
    //return;    
}

simulated function HoldCurrentRotation()
{
    mbHoldRotation = true;
    //return;    
}

simulated function ReleaseCurrentRotation()
{
    mbHoldRotation = false;
    //return;    
}

defaultproperties
{
    mSettings[0]=(Axis="Pitch",mRotationSpeed=1.0000000,mbEnable=false,mbInvert=false)
    mSettings[1]=(Axis="Yaw",mRotationSpeed=1.0000000,mbEnable=false,mbInvert=false)
    mSettings[2]=(Axis="Roll",mRotationSpeed=1.0000000,mbEnable=false,mbInvert=false)
    bApplyRotation=true
    BoneRotationSpace=4
}