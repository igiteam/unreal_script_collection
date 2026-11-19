class PawnOwnedOIRImpl extends Object
    abstract
    native
    implements(OIROwnerInterface);

var Vector Position;
var Rotator Rotation;
var AnimSet OIRAnimSet;
var AnimTree OIRAnimTree;
var bool bSetInPlace;
var MOHAAIPawn OwningPawn;

function float GetArrivedAtRadius()
{
    return 5.0000000;
    //return ReturnValue;    
}

function OIRData GetOIRData()
{
    local OIRData oir;

    // End:0x4A
    if(bSetInPlace && OwningPawn != none)
    {
        oir.OIRPosition = MOHAAIController(OwningPawn.Controller).GetPathablePosition();        
    }
    else
    {
        oir.OIRPosition = Position;
    }
    oir.OIRRotation = Rotation;
    oir.OIRRotation.Pitch = 0;
    oir.OIRRotation.Roll = 0;
    oir.OIRAnimSet = OIRAnimSet;
    oir.OIRAnimTree = OIRAnimTree;
    oir.OIRCollideWorldRadius = OwningPawn.default.CylinderComponent.CollisionRadius;
    return oir;
    //return ReturnValue;    
}

function GetAttachData(out Actor out_Actor, optional out SkeletalMeshComponent out_SkelMesh, optional out name out_AttachName)
{
    //return;    
}

function bool IsReady()
{
    //return ReturnValue;    
}

function SetReady()
{
    //return;    
}

function SetNotReady()
{
    //return;    
}

function name GetActivityPose(name InName)
{
    return 'None';
    //return ReturnValue;    
}

function bool IsDifferentOIR(Object ActiveOIR, bool bAnimsChanged)
{
    local Vector pos;
    local float maxHeightDiff, heightDiff;

    // End:0x0B
    if(bAnimsChanged)
    {
        return true;
    }
    // End:0x4B
    if(bSetInPlace && OwningPawn != none)
    {
        pos = MOHAAIController(OwningPawn.Controller).GetPathablePosition();        
    }
    else
    {
        pos = Position;
    }
    heightDiff = Abs(OirInstance(ActiveOIR).Location.Z - pos.Z);
    maxHeightDiff = (2.0000000 * OwningPawn.MaxStepHeight) + 2.0000000;
    // End:0xEB
    if((heightDiff > maxHeightDiff) || VSizeSq2D(OirInstance(ActiveOIR).Location - pos) > 0.0500000)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function UpdateNewOIRReference(Object newOIR)
{
    //return;    
}

function RegisteredAsNext()
{
    bSetInPlace = false;
    //return;    
}

function SetNextOIRInPlace()
{
    bSetInPlace = true;
    //return;    
}

function bool GetAlternateExitFinalPosition(out Vector pos)
{
    return false;
    //return ReturnValue;    
}

function bool IsDifferentReference(OIROwnerInterface prevOIR)
{
    return NotEqual_InterfaceInterface(OIROwnerInterface(self), prevOIR);
    //return ReturnValue;    
}

function int GetHeightPostureOverride(name ActivityPoseName)
{
    return 0;
    //return ReturnValue;    
}
