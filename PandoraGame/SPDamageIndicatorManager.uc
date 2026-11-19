class SPDamageIndicatorManager extends Object;

struct DamageInfo
{
    var Actor Actor;
    var bool bUseActor;
    var Vector DamageLocation;
    var float Lifetime;

    structdefaultproperties
    {
        Actor=none
        bUseActor=false
        DamageLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Lifetime=2.0000000
    }
};

var private array<DamageInfo> DamageEntry;
var private int MaxIndicators;

final simulated function Tick(float DeltaTime)
{
    local int Count;

    Count = 0;
    J0x07:

    // End:0xA9 [Loop If]
    if(Count < DamageEntry.Length)
    {
        DamageEntry[Count].Lifetime -= DeltaTime;
        // End:0x9F
        if((DamageEntry[Count].Lifetime <= float(0)) || (DamageEntry[Count].Actor == none) && DamageEntry[Count].bUseActor)
        {
            DamageEntry.Remove(Count, 1);
            Count--;
        }
        Count++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

final simulated function AddNewDamageFromActor(Actor TheActor)
{
    local int Count;
    local DamageInfo theDamageEntry;

    Count = 0;
    J0x07:

    // End:0x50 [Loop If]
    if(Count < DamageEntry.Length)
    {
        // End:0x46
        if(DamageEntry[Count].Actor == TheActor)
        {
            DamageEntry.Remove(Count, 1);
            // [Explicit Break]
            goto J0x50;
        }
        Count++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x50:

    // End:0x68
    if(DamageEntry.Length >= MaxIndicators)
    {
        DamageEntry.Remove(0, 1);
    }
    theDamageEntry.Actor = TheActor;
    theDamageEntry.bUseActor = true;
    DamageEntry.AddItem(theDamageEntry);
    //return;    
}

final simulated function AddNewDamageFromLocation(Vector Loc)
{
    local DamageInfo theDamageEntry;

    // End:0x18
    if(DamageEntry.Length >= MaxIndicators)
    {
        DamageEntry.Remove(0, 1);
    }
    theDamageEntry.Actor = none;
    theDamageEntry.bUseActor = false;
    theDamageEntry.DamageLocation = Loc;
    DamageEntry.AddItem(theDamageEntry);
    //return;    
}

final simulated function int GetNumDamageIndicators()
{
    return DamageEntry.Length;
    //return ReturnValue;    
}

final simulated function Vector GetDamageIndicatorLocation(int Index)
{
    // End:0x3E
    if(DamageEntry[Index].bUseActor)
    {
        return DamageEntry[Index].Actor.Location;        
    }
    else
    {
        return DamageEntry[Index].DamageLocation;
    }
    //return ReturnValue;    
}

defaultproperties
{
    MaxIndicators=4
}