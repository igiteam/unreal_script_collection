class PandoraObjectPool extends Actor
    native
    notplaceable;

const MAX_EMITTERS = 20;

struct native EmitterCacheDatum
{
    var ParticleSystem ParticleSystemType;
    var int ListIdx;
    var SPEmitter List[20];
    var int AllocEmitter;

    structdefaultproperties
    {
        ParticleSystemType=none
        ListIdx=0
        List[0]=none
        List[1]=none
        List[2]=none
        List[3]=none
        List[4]=none
        List[5]=none
        List[6]=none
        List[7]=none
        List[8]=none
        List[9]=none
        List[10]=none
        List[11]=none
        List[12]=none
        List[13]=none
        List[14]=none
        List[15]=none
        List[16]=none
        List[17]=none
        List[18]=none
        List[19]=none
        AllocEmitter=0
    }
};

var array<EmitterCacheDatum> EmitterCache;

// Export UPandoraObjectPool::execEmitterCacheFind(FFrame&, void* const)
native final function int EmitterCacheFind(ParticleSystem PS_TYPE);

final simulated event ClearEmitterCache()
{
    EmitterCache.Length = 0;
    //return;    
}

simulated event Destroyed()
{
    ClearEmitterCache();
    super.Destroyed();
    //return;    
}

final simulated event RegisterNewObject(ParticleSystem PSTemplate)
{
    CreateEmitter_Worker(PSTemplate);
    //return;    
}

final simulated event RemoveObject(ParticleSystem PSTemplate)
{
    local int Index;

    Index = EmitterCache.Find('ParticleSystemType', PSTemplate);
    // End:0x2E
    if(Index == -1)
    {        
    }
    else
    {
        EmitterCache.Remove(Index, 1);
    }
    //return;    
}

final simulated event int CreateEmitter_Worker(ParticleSystem PSTemplate)
{
    local int Idx, Index;
    local EmitterCacheDatum Items;

    // End:0x11
    if(PSTemplate == none)
    {
        return -1;
    }
    Index = EmitterCacheFind(PSTemplate);
    // End:0x1A0
    if(Index > -1)
    {
        // End:0x51
        if(EmitterCache[Index].AllocEmitter >= 20)
        {            
        }
        else
        {
            // End:0x19D
            if(EmitterCache[Index].AllocEmitter <= (20 - 5))
            {
                Idx = 0;
                J0x79:

                // End:0x19D [Loop If]
                if(Idx < 5)
                {
                    EmitterCache[Index].List[EmitterCache[Index].AllocEmitter] = Spawn(Class'SPEmitterSpawnable');
                    EmitterCache[Index].List[EmitterCache[Index].AllocEmitter].CreateObjectPool_Worker(PSTemplate);
                    EmitterCache[Index].List[EmitterCache[Index].ListIdx].bCurrentlyActive = false;
                    EmitterCache[Index].AllocEmitter++;
                    EmitterCache[Index].List[EmitterCache[Index].AllocEmitter].bKillDuringLevelTransition = true;
                    Idx++;
                    // [Loop Continue]
                    goto J0x79;
                }
            }
        }        
    }
    else
    {
        Items.ParticleSystemType = PSTemplate;
        Idx = 0;
        J0x1BD:

        // End:0x291 [Loop If]
        if(Idx < 5)
        {
            Items.List[Idx] = Spawn(Class'SPEmitterSpawnable');
            Items.List[Idx].CreateObjectPool_Worker(PSTemplate);
            Items.List[Idx].bCurrentlyActive = false;
            Items.List[Idx].bKillDuringLevelTransition = true;
            Items.AllocEmitter++;
            Items.ListIdx++;
            Idx++;
            // [Loop Continue]
            goto J0x1BD;
        }
        EmitterCache.AddItem(Items);
    }
    return Index;
    //return ReturnValue;    
}

final simulated function SPEmitter GetEmitter(ParticleSystem PS_TYPE, Vector SpawnLocation, Rotator SpawnRotation)
{
    local int Index;

    Index = EmitterCacheFind(PS_TYPE);
    // End:0x4D
    if(Index == -1)
    {
        CreateEmitter_Worker(PS_TYPE);
        Index = EmitterCacheFind(PS_TYPE);
        // End:0x4D
        if(Index == -1)
        {
            return none;
        }
    }
    return GetEmitter_Worker(Index, SpawnLocation, SpawnRotation, PS_TYPE);
    //return ReturnValue;    
}

final simulated function SPEmitter GetEmitter_Worker(int Index, Vector SpawnLocation, Rotator SpawnRotation, ParticleSystem PS_TYPE)
{
    local int Jdx;

    // End:0x4B
    if(++EmitterCache[Index].ListIdx >= EmitterCache[Index].AllocEmitter)
    {
        EmitterCache[Index].ListIdx = 0;
    }
    // End:0x177
    if((EmitterCache[Index].List[EmitterCache[Index].ListIdx] == none) || EmitterCache[Index].List[EmitterCache[Index].ListIdx].IsPendingKill())
    {
        EmitterCache[Index].List[EmitterCache[Index].ListIdx] = Spawn(Class'SPEmitterSpawnable');
        EmitterCache[Index].List[EmitterCache[Index].ListIdx].CreateObjectPool_Worker(PS_TYPE);
        EmitterCache[Index].List[EmitterCache[Index].ListIdx].bKillDuringLevelTransition = true;
    }
    // End:0x1BD
    if(EmitterCache[Index].List[EmitterCache[Index].ListIdx].bCurrentlyActive)
    {
        CreateEmitter_Worker(PS_TYPE);
    }
    EmitterCache[Index].List[EmitterCache[Index].ListIdx].bStasis = false;
    EmitterCache[Index].List[EmitterCache[Index].ListIdx].SetBase(none);
    EmitterCache[Index].List[EmitterCache[Index].ListIdx].SetLocation(SpawnLocation);
    EmitterCache[Index].List[EmitterCache[Index].ListIdx].SetRotation(SpawnRotation);
    // End:0x432
    if(PS_TYPE != none)
    {
        EmitterCache[Index].List[EmitterCache[Index].ListIdx].SetTemplate(PS_TYPE, false);
        EmitterCache[Index].List[EmitterCache[Index].ListIdx].ParticleSystemComponent.ActivateSystem();
        Jdx = 0;
        J0x344:

        // End:0x432 [Loop If]
        if(Jdx < EmitterCache[Index].List[EmitterCache[Index].ListIdx].ParticleSystemComponent.EmitterInstances.Length)
        {
            EmitterCache[Index].List[EmitterCache[Index].ListIdx].ParticleSystemComponent.SetKillOnDeactivate(Jdx, false);
            EmitterCache[Index].List[EmitterCache[Index].ListIdx].ParticleSystemComponent.SetKillOnCompleted(Jdx, false);
            ++Jdx;
            // [Loop Continue]
            goto J0x344;
        }
    }
    EmitterCache[Index].List[EmitterCache[Index].ListIdx].ClearTimer('HideSelf');
    EmitterCache[Index].List[EmitterCache[Index].ListIdx].SetHidden(false);
    EmitterCache[Index].List[EmitterCache[Index].ListIdx].SetDrawScale(1.0000000);
    return EmitterCache[Index].List[EmitterCache[Index].ListIdx];
    //return ReturnValue;    
}

simulated function OnParticleSystemFinished_Hider(ParticleSystemComponent FinishedComponent)
{
    FinishedComponent.SetHidden(true);
    //return;    
}

simulated event Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    //return;    
}
