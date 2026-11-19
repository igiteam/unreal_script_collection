class MeleeOIRImpl extends PawnOwnedOIRImpl
    implements(OIRAttachmentPolicy);

var bool bInUse;
var MOHAPawn TargetPawn;

function AttachMeleeOIR(MOHAPawn NewTargetPawn)
{
    TargetPawn = NewTargetPawn;
    OwningPawn.MeleeTargetPawn = TargetPawn;
    //return;    
}

function DetachMeleeOIR()
{
    TargetPawn = none;
    OwningPawn.MeleeTargetPawn = none;
    //return;    
}

function bool IsDifferentOIR(Object ActiveOIR, bool bAnimsChanged)
{
    // End:0x1F
    if(OirInstance(ActiveOIR).Rotation != Rotation)
    {
        return true;
    }
    // End:0x4B
    if(bInUse)
    {
        return NotEqual_InterfaceInterface(OirInstance(ActiveOIR).OIRParent, OIROwnerInterface(self));        
    }
    else
    {
        return super.IsDifferentOIR(ActiveOIR, bAnimsChanged);
    }
    //return ReturnValue;    
}

function float GetArrivedAtRadius()
{
    return -1.0000000;
    //return ReturnValue;    
}

function OIRData GetOIRData()
{
    local OIRData oir;

    // End:0x41
    if(TargetPawn != none)
    {
        oir.OIRPosition = TargetPawn.Location;
        oir.OIRRotation = Rotation;        
    }
    else
    {
        // End:0x92
        if(bSetInPlace && OwningPawn != none)
        {
            oir.OIRPosition = OwningPawn.GetPathablePosition();
            oir.OIRRotation = Rotation;            
        }
        else
        {
            oir.OIRPosition = Position;
            oir.OIRRotation = Rotation;
        }
    }
    oir.OIRRotation.Pitch = 0;
    oir.OIRRotation.Roll = 0;
    oir.OIRAnimSet = OIRAnimSet;
    oir.OIRAnimTree = OIRAnimTree;
    oir.OIRCollideWorldRadius = OwningPawn.default.CylinderComponent.CollisionRadius;
    // End:0x14E
    if(OIRAnimTree == none)
    {
    }
    return oir;
    //return ReturnValue;    
}

function bool ShouldAttach()
{
    return false;
    //return ReturnValue;    
}

function bool ShouldCollideWorld()
{
    return true;
    //return ReturnValue;    
}

function GetAttachData(out Actor out_Actor, optional out SkeletalMeshComponent out_SkelMesh, optional out name out_AttachName)
{
    //return;    
}

function SkeletalMeshComponent.ERootMotionMode GetRootMotionMode()
{
    return 1;
    //return ReturnValue;    
}

function bool UseOIRPhysics()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    OIRAnimSet=AnimSet'Anim_AI_MeleeAnimSet.AnimSet.MeleeAnimSet_Rifle'
    OIRAnimTree=AnimTree'Anim_AI_Melee.AnimTree.MeleeAnimTree_Rifle'
}