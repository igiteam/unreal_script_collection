class SpawnInOIRImpl extends Object
    hidecategories(Object)
    implements(OIROwnerInterface,OIRAttachmentPolicy);

var transient OIRData oir;
var transient Object OwningObject;
var transient OIRData CachedOIRData;

function Init(Object NewOwner)
{
    OwningObject = NewOwner;
    //return;    
}

function float GetArrivedAtRadius()
{
    return 100000.0000000;
    //return ReturnValue;    
}

function OIRData GetOIRData()
{
    SpawnInOIRInterface(OwningObject).SetOIRData(oir);
    return oir;
    //return ReturnValue;    
}

function bool IsDifferentOIR(Object ActiveOIR, bool bAnimsChanged)
{
    // End:0x0B
    if(bAnimsChanged)
    {
        return true;
    }
    return NotEqual_InterfaceInterface(OirInstance(ActiveOIR).OIRParent, OIROwnerInterface(self));
    //return ReturnValue;    
}

function bool ShouldAttach()
{
    return true;
    //return ReturnValue;    
}

function bool ShouldCollideWorld()
{
    return true;
    //return ReturnValue;    
}

function GetAttachData(out Actor out_Actor, optional out SkeletalMeshComponent out_SkelMesh, optional out name out_AttachName)
{
    SpawnInOIRInterface(OwningObject).SetAttachData(out_Actor, out_SkelMesh, out_AttachName);
    //return;    
}

function SkeletalMeshComponent.ERootMotionMode GetRootMotionMode()
{
    return 0;
    //return ReturnValue;    
}

function bool UseOIRPhysics()
{
    return false;
    //return ReturnValue;    
}

function InvokeAnimation(name activity, optional Pawn Target)
{
    // End:0x52
    if((Target != none) && KynapseAIController(Target.Controller) != none)
    {
        KynapseAIController(Target.Controller).SetNextOIRData(self, activity, false);
    }
    //return;    
}

function name GetActivityPose(name InName)
{
    return 'None';
    //return ReturnValue;    
}

function RegisteredAsNext()
{
    //return;    
}

function UpdateNewOIRReference(Object newOIR)
{
    //return;    
}

function SetNextOIRInPlace()
{
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
