class AdvActionHands_Base extends Actor
    abstract
    notplaceable
    hidecategories(Navigation);

var() protected export editinline SkeletalMeshComponent Hands;

function PlayAnimation(name AnimName, float Duration, float BlendInTime, float BlendOutTime, bool bLooping, bool bOverride, float StartTime)
{
    local AnimNodeSlot AnimNodeS;

    AnimNodeS = AnimNodeSlot(Hands.FindAnimNode('CustomAnim'));
    // End:0xA6
    if(Duration > float(0))
    {
        AnimNodeS.PlayCustomAnimByDuration(AnimName, Duration, BlendInTime, BlendOutTime, bLooping, bOverride);        
    }
    else
    {
        Duration = Hands.GetAnimLength(AnimName) - StartTime;
        AnimNodeS.PlayCustomAnim(AnimName, 1.0000000, BlendInTime, BlendOutTime, bLooping, bOverride, StartTime);
    }
    // End:0x16D
    if(!bLooping)
    {
        SetTimer(Duration - 0.1000000, false, 'HideHands');
    }
    //return;    
}

function HideHands()
{
    SetHidden(true);
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvActionHands_Base.Hands0'
    begin object name=Hands0 class=Class'Engine.SkeletalMeshComponent'
        ReplacementPrimitive=none
        CanBlockCamera=false
    end object
    Hands=Hands0
    Components[0]=Hands0
    Physics=EPhysics.PHYS_Interpolating
}