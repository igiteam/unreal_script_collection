class AnimusManager extends Actor
    notplaceable;

var int m_AnimusCloudCount;
var array<SPLifeForceHolder> m_LFHolderPool;
var SPGameDifficultyTuneGamePlay m_GameplayGDTuneData;

function DBG_MsgAM(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

function PostBeginPlay()
{
    m_GameplayGDTuneData = Class'SPTuneManager'.default.Difficulty.GameplayGD;
    //return;    
}

function float GetClosestPlayerPawnDistSq(Vector Loc)
{
    local PlayerPawn Pawn;
    local float closest, Test;

    closest = 1000000.0000000 * 1000000.0000000;
    // End:0x83
    foreach WorldInfo.AllPawns(Class'PlayerPawn', Pawn)
    {
        // End:0x82
        if(Pawn.Health > 0)
        {
            Test = VSizeSq(Loc - Pawn.Location);
            // End:0x82
            if(Test < closest)
            {
                closest = Test;
            }
        }        
    }    
    return closest;
    //return ReturnValue;    
}

function int FindLFHolderSlot(SPLifeForceHolder LFHolder)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3C [Loop If]
    if(I < m_LFHolderPool.Length)
    {
        // End:0x32
        if(m_LFHolderPool[I] == LFHolder)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function int GetActualAnimusCloudCount()
{
    local int I, Count;

    I = 0;
    J0x07:

    // End:0x39 [Loop If]
    if(I < m_LFHolderPool.Length)
    {
        // End:0x2F
        if(m_LFHolderPool[I] != none)
        {
            Count++;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return Count;
    //return ReturnValue;    
}

function bool TakeSlot(int Index, SPLifeForceHolder LFHolder)
{
    // End:0x3A
    if((Index >= 0) && Index < m_LFHolderPool.Length)
    {
        m_LFHolderPool[Index] = LFHolder;
        ++m_AnimusCloudCount;
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool ReleaseSlot(int Index)
{
    // End:0x36
    if((Index >= 0) && Index < m_LFHolderPool.Length)
    {
        m_LFHolderPool[Index] = none;
        --m_AnimusCloudCount;
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function FindLifeForceHolderSlotAndReleaseIt(SPLifeForceHolder LFHolder)
{
    local int SlotIndex;

    SlotIndex = FindLFHolderSlot(LFHolder);
    // End:0x36
    if(SlotIndex != -1)
    {
        ReleaseSlot(SlotIndex);        
    }
    //return;    
}

function bool AddAnimus(SPLifeForceHolder LFHolder)
{
    local float FarthestDistSq, CurDistSq;
    local int SlotIndex, I;

    // End:0x81
    if(m_AnimusCloudCount < m_GameplayGDTuneData.MaxNumAnimusClouds)
    {
        SlotIndex = FindLFHolderSlot(none);
        // End:0x6F
        if(SlotIndex == -1)
        {
            // End:0x6F
            if(m_LFHolderPool.Length < m_GameplayGDTuneData.MaxNumAnimusClouds)
            {
                SlotIndex = m_LFHolderPool.Length;
                m_LFHolderPool[SlotIndex] = none;                
            }
        }
        // End:0x7E
        if(SlotIndex != -1)
        {
        }        
    }
    else
    {
        FarthestDistSq = 0.0000000;
        SlotIndex = -1;
        I = 0;
        J0x9E:

        // End:0x113 [Loop If]
        if(I < m_LFHolderPool.Length)
        {
            // End:0x109
            if(m_LFHolderPool[I] != none)
            {
                CurDistSq = GetClosestPlayerPawnDistSq(m_LFHolderPool[I].Location);
                // End:0x109
                if(CurDistSq > FarthestDistSq)
                {
                    FarthestDistSq = CurDistSq;
                    SlotIndex = I;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x9E;
        }
        // End:0x135
        if(SlotIndex != -1)
        {
            m_LFHolderPool[SlotIndex].Destroy();
        }
    }
    // End:0x16F
    if(SlotIndex != -1)
    {
        TakeSlot(SlotIndex, LFHolder);
        LFHolder.m_bAddedAnimusToManager = true;
        return true;        
    }
    else
    {
        LFHolder.m_bAddedAnimusToManager = false;
        LFHolder.Destroy();
        return false;
    }
    //return ReturnValue;    
}

function SpawnDroppedAnimus(PlayerPawn Player)
{
    local AnimusHealthPack AnimusHP;

    // End:0x74
    if(Player.LifeForce > 0.0000000)
    {
        AnimusHP = Spawn(Class'AnimusHealthPack', none,, Player.Location, Player.Rotation);
        AnimusHP.LifeForceAmount = Player.LifeForce / 2.0000000;
    }
    //return;    
}

function RequestSiphon(PlayerPawn Player, SPLifeForceHolder Target)
{
    Target.SetTargetPawn(Player);
    //return;    
}

function RequestUnSiphon(PlayerPawn Player, SPLifeForceHolder Target)
{
    // End:0x6A
    if((Target != none) && Target.GetTargetPawn() != none)
    {
        // End:0x6A
        if(Target.GetTargetPawn() == Player)
        {
            // End:0x6A
            if(int(Role) == int(ROLE_Authority))
            {
                Target.SetTargetPawn(none);
            }
        }
    }
    //return;    
}
