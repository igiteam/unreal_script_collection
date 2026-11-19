class SkySpawner extends Actor
    native
    notplaceable;

struct native SpawnerSlot
{
    var() bool bEnabled;
    var SkyPawn SpawningPawn;
    var() Vector LocationOffset;
    var() Rotator RotationOffset;

    structdefaultproperties
    {
        bEnabled=true
        SpawningPawn=none
        LocationOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RotationOffset=(Pitch=0,Yaw=0,Roll=0)
    }
};

var() bool bActive;
var() bool bAutoDeActivate;
var array<SeqAct_AIFactory> Factories;
var() editinline array<editinline SpawnerSlot> SpawnSlots;
var Actor Killer;

event HandleSpawn(SkyPawn NewSpawn, int SlotIdx)
{
    SpawnSlots[SlotIdx].SpawningPawn = NewSpawn;
    //return;    
}

event bool GetSpawnSlot(out int out_SpawnSlotIdx, out Vector out_SpawnLocation, out Rotator out_SpawnRotation)
{
    local int BaseIdx, Idx;
    local array<int> Indices;

    // End:0x216
    if(bActive)
    {
        Indices[Indices.Length] = int(RandRange(0.0000000, float(SpawnSlots.Length - 1)));
        BaseIdx = 0;
        Idx = Indices[BaseIdx];
        J0x46:

        // End:0xAC [Loop If]
        if(--Idx >= 0)
        {
            // End:0x85
            if(FRand() > 0.5000000)
            {
                Indices.Insert(BaseIdx + 1, 1);
                Indices[BaseIdx + 1] = Idx;                
            }
            else
            {
                Indices.Insert(BaseIdx, 1);
                Indices[BaseIdx] = Idx;
                BaseIdx++;
            }
            // [Loop Continue]
            goto J0x46;
        }
        Idx = Indices[BaseIdx];
        J0xBD:

        // End:0x128 [Loop If]
        if(++Idx < SpawnSlots.Length)
        {
            // End:0x101
            if(FRand() > 0.5000000)
            {
                Indices.Insert(BaseIdx + 1, 1);
                Indices[BaseIdx + 1] = Idx;                
            }
            else
            {
                Indices.Insert(BaseIdx, 1);
                Indices[BaseIdx] = Idx;
                BaseIdx++;
            }
            // [Loop Continue]
            goto J0xBD;
        }
        BaseIdx = 0;
        J0x12F:

        // End:0x216 [Loop If]
        if(BaseIdx < Indices.Length)
        {
            Idx = Indices[BaseIdx];
            // End:0x20C
            if(SpawnSlots[Idx].bEnabled && (SpawnSlots[Idx].SpawningPawn == none) || SpawnSlots[Idx].SpawningPawn.Health <= 0)
            {
                out_SpawnLocation = Location + (SpawnSlots[Idx].LocationOffset >> Rotation);
                out_SpawnRotation = Rotation + SpawnSlots[Idx].RotationOffset;
                out_SpawnSlotIdx = Idx;
                return true;
            }
            BaseIdx++;
            // [Loop Continue]
            goto J0x12F;
        }
    }
    return false;
    //return ReturnValue;    
}

function OnToggle(SeqAct_Toggle Action)
{
    local bool bWasActive;

    bWasActive = bActive;
    // End:0x38
    if(Action.InputLinks[0].bHasImpulse)
    {
        bActive = true;        
    }
    else
    {
        // End:0x63
        if(Action.InputLinks[1].bHasImpulse)
        {
            bActive = false;            
        }
        else
        {
            // End:0x93
            if(Action.InputLinks[2].bHasImpulse)
            {
                bActive = !bActive;
            }
        }
    }
    // End:0xB6
    if(bActive && !bWasActive)
    {
        Activated();        
    }
    else
    {
        // End:0xD6
        if(!bActive && bWasActive)
        {
            Deactivated();
        }
    }
    //return;    
}

function Activated()
{
    //return;    
}

function Deactivated()
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0x4D [Loop If]
    if(Idx < Factories.Length)
    {
        // End:0x43
        if(Factories[Idx] != none)
        {
            Factories[Idx].NotifySpawnerDisabled(self);
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event RegisterFactory(SeqAct_AIFactory Factory)
{
    local int Idx;

    Idx = Factories.Find(Factory);
    // End:0x34
    if(Idx == -1)
    {
        Factories[Factories.Length] = Factory;
    }
    //return;    
}

event UnRegisterFactory(SeqAct_AIFactory Factory)
{
    local int Idx;

    Idx = Factories.Find(Factory);
    // End:0x2E
    if(Idx != -1)
    {
        Factories.Remove(Idx, 1);
    }
    // End:0x55
    if(bAutoDeActivate)
    {
        // End:0x55
        if(Factories.Length == 0)
        {
            bActive = false;
            Deactivated();
        }
    }
    //return;    
}
