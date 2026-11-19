class DeathOIRImpl extends Object
    implements(OIROwnerInterface,OIREventListener);

var AnimSet OIRAnimSet;
var AnimTree OIRAnimTree;
var transient MOHAAIPawn OwnerPawn;

function Init(MOHAAIPawn Owner)
{
    OwnerPawn = Owner;
    //return;    
}

function OIRData GetOIRData()
{
    local OIRData od;

    od.OIRPosition = OwnerPawn.Location;
    od.OIRRotation = OwnerPawn.Rotation;
    od.OIRAnimSet = OIRAnimSet;
    od.OIRAnimTree = OIRAnimTree;
    od.OIRCollideWorldRadius = 5.0000000;
    return od;
    //return ReturnValue;    
}

function RegisteredAsNext()
{
    //return;    
}

function OIROwnerInterface GetOIRForDeath()
{
    local OirInstance oir;
    local bool UseDeathOIR;

    oir = OwnerPawn.ActiveOIR;
    // End:0xD6
    if((oir != none) && NotEqual_InterfaceInterface(oir.OIRParent, OIROwnerInterface(none)))
    {
        // End:0x5D
        if(!oir.m_bPawnIsAttached)
        {
            UseDeathOIR = true;            
        }
        else
        {
            // End:0xA7
            if((oir.m_ActivityNode == none) || oir.m_ActivityNode.Children[1].Anim == none)
            {
                UseDeathOIR = true;                
            }
            else
            {
                // End:0xD3
                if(oir.m_ActivityNode.NodeTotalWeight < 1.0000000)
                {
                    UseDeathOIR = true;                    
                }
            }
        }        
    }
    else
    {
        UseDeathOIR = true;
    }
    // End:0xEC
    if(UseDeathOIR)
    {
        return self;        
    }
    else
    {
        return oir.OIRParent;
    }
    //return ReturnValue;    
}

function float GetArrivedAtRadius()
{
    return 1000000.0000000;
    //return ReturnValue;    
}

function name GetActivityPose(name InName)
{
    return 'None';
    //return ReturnValue;    
}

function bool IsDifferentOIR(Object ActiveOIR, bool bAnimsChanged)
{
    return NotEqual_InterfaceInterface(OirInstance(ActiveOIR).OIRParent, OIROwnerInterface(self));
    //return ReturnValue;    
}

function bool IsDifferentReference(OIROwnerInterface prevOIR)
{
    return NotEqual_InterfaceInterface(OIROwnerInterface(self), prevOIR);
    //return ReturnValue;    
}

function OnAttach()
{
    OwnerPawn.SetCollision(false, false, true);
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

function OnEntryFinish()
{
    //return;    
}

function OnExitBegin()
{
    //return;    
}

function OnDetach()
{
    //return;    
}

function bool OnPreAttachUpdateOIRRotation()
{
    return false;
    //return ReturnValue;    
}

function int GetHeightPostureOverride(name ActivityPoseName)
{
    return 0;
    //return ReturnValue;    
}

defaultproperties
{
    OIRAnimSet=AnimSet'Anim_AI_DeathAnimSet.AnimSet.DeathAnimSet_Rifle'
    OIRAnimTree=AnimTree'Anim_Death.Death_Rifle'
}