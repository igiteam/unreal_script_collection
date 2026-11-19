class TurokBombActionVolume extends TurokActionVolume
    native
    nativereplication
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,ActionVolume,ActionVolume);

var(ActionVolume) protected const float mDamage;
var(ActionVolume) protected const float mDamageRadius;
var(ActionVolume) protected const float mPlantTime;
var(ActionVolume) protected const float mDefuseTime;
var(ActionVolume) protected const float mFuseLength;
var(ActionVolume) protected const float mFuseCountdownMin;
var(ActionVolume) protected const float mFuseCountdownMax;
var(ActionVolume) protected const float mMaxAllowedDistanceForDefuse;
var(ActionVolume) protected const float mMaxExplosionEffectTime;
var protected const float mFuseCountdownInterval;
var protected class<Class> mBombType;
var protected @NULL mBombPlantLocation;
var protected @NULL mBombPlantRotation;
var protected repnotify bool mBombPlanted;
var protected repnotify bool mBombExplosionTrigger;
var protected repnotify bool mHideBomb;
var protected bool mBombExploded;
var protected @NULL mBombSimActor;
var protected float mFuseStartTime;
var protected float mFuseLastBeepTime;
var private float mProgress;
var protected @NULL mBomb;
var protected int mBombTeamIndex;

replication
{
    // Pos:0x000
    if(bNetDirty
        mBombExplosionTrigger, mBombPlantLocation, 
        mBombPlantRotation, mBombPlanted, 
        mBombType, mHideBomb, 
        mProgress;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x28
    if(VarName == 'mBombPlanted')
    {
        OnSimulatedBombPlanted(mBombPlanted);
        return;        
    }
    else
    {
        // End:0x50
        if(VarName == 'mHideBomb')
        {
            OnSimulatedDefuseHideBomb(mHideBomb);
            return;            
        }
        else
        {
            // End:0x6F
            if(VarName == 'mBombExplosionTrigger')
            {
                OnSimulatedBombExploded();
                return;
            }
        }
    }
    super(Actor).ReplicatedEvent(VarName);
    //return;    
}

// Export UTurokBombActionVolume::execGetActionObject(FFrame&, void* const)
native function @NULL GetActionObject(@NULL Controller);

// Export UTurokBombActionVolume::execIsBombSet(FFrame&, void* const)
native function bool IsBombSet();

// Export UTurokBombActionVolume::execIsValidActionController(FFrame&, void* const)
native function bool IsValidActionController(@NULL Controller);

// Export UTurokBombActionVolume::execGetProgress(FFrame&, void* const)
native function float GetProgress();

// Export UTurokBombActionVolume::execUpdateProgress(FFrame&, void* const)
native function UpdateProgress(float DeltaTime);

// Export UTurokBombActionVolume::execSetProgress(FFrame&, void* const)
native function SetProgress(float Value);

// Export UTurokBombActionVolume::execIsLookingRightDirection(FFrame&, void* const)
native function bool IsLookingRightDirection(@NULL Controller);

// Export UTurokBombActionVolume::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

function Reset()
{
    super(Actor).Reset();
    // DebugMode: 0
    assert(mBombPlanted == false);
    // DebugMode: 0
    assert(mBombSimActor == none);
    mBombTeamIndex = 255;
    mBombPlanted = false;
    mBombExploded = false;
    mBombExplosionTrigger = false;
    mHideBomb = false;
    //return;    
}

event OnBombPlanted(@NULL bomb, optional bool saveGameRestore = false)
{
    // DebugMode: 0
    assert(mBomb == none);
    mBombTeamIndex = int(bomb.GetTeamNum());
    mBomb = bomb;
    mBombType = bomb.Class;
    mBombPlantLocation = mBomb.Location;
    mBombPlantRotation = mBomb.Rotation;
    mHideBomb = false;
    mBombExploded = false;
    mBombExplosionTrigger = false;
    OnSimulatedBombPlanted(true);
    RefreshBombAction();
    // End:0xB9
    if(!saveGameRestore)
    {
        TriggerEventClass(Class'TurokSeqEvent_BombPlanted', self);
    }
    //return;    
}

event OnBombDefused()
{
    // DebugMode: 0
    assert(mBomb != none);
    OnSimulatedBombPlanted(false);
    mBomb = none;
    RefreshBombAction();
    switch(mBombTeamIndex)
    {
        // End:0x39
        case 0:
            mBombTeamIndex = 1;
            // End:0x4F
            break;
        // End:0x47
        case 1:
            mBombTeamIndex = 0;
            // End:0x4F
            break;
        // End:0xFFFF
        default:
            // DebugMode: 0
            assert(false);
            break;
    }
    TriggerEventClass(Class'TurokSeqEvent_BombDefused', self);
    OnSimulatedDefuseHideBomb(false);
    //return;    
}

event OnBombExploded()
{
    // DebugMode: 0
    assert(mBomb != none);
    RefreshBombAction();
    OnSimulatedBombPlanted(false);
    // End:0x8D
    if(!WorldInfo.Game.bGameEnded)
    {
        OnSimulatedBombExploded();
        Instigator = none;
        HurtRadius(mDamage, mDamageRadius, mBomb.mBombDamageType, 0.0000000, mBombPlantLocation);
        TriggerEventClass(Class'TurokSeqEvent_BombDetonated', self);
    }
    mBomb.Destroy();
    mBomb = none;
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x1E
    if(mBombPlanted)
    {
        OnSimulatedCountdown();
    }
    //return;    
}

simulated function bool GetIsBombPlanted()
{
    return mBombPlanted;
    //return ReturnValue;    
}

simulated function OnSimulatedBombPlanted(bool bPlanted)
{
    mBombPlanted = bPlanted;
    // End:0xA5
    if(mBombPlanted)
    {
        // DebugMode: 0
        assert(mBombSimActor == none);
        mBombSimActor = __NFUN_278__(Class'TurokMPSimulatedSMActor',,, mBombPlantLocation, mBombPlantRotation);
        mBombSimActor.SetStaticMesh(StaticMeshComponent(mBombType.default.mBombMesh.Clone(self)));
        mFuseStartTime = WorldInfo.TimeSeconds;
        mFuseLastBeepTime = 0.0000000;
        SetTimer(mFuseLength, false, 'OnSimulatedCountdownCompleted');        
    }
    else
    {
        ClearTimer('OnSimulatedCountdownCompleted');
        mFuseStartTime = 0.0000000;
        mFuseLastBeepTime = 0.0000000;
        // DebugMode: 0
        assert(mBombSimActor != none);
        mBombSimActor.Destroy();
        mBombSimActor = none;
    }
    //return;    
}

simulated function OnSimulatedCountdown()
{
    local float ElapsedTime, ElapsedSlot, TotalSlots, BeepRate;

    ElapsedTime = float(Max(0, int(WorldInfo.TimeSeconds - mFuseStartTime)));
    ElapsedSlot = float(int(ElapsedTime / mFuseCountdownInterval)) * 1.0000000;
    TotalSlots = float(Max(int(float(int(mFuseLength / mFuseCountdownInterval)) - 1.0000000), 1));
    BeepRate = Lerp(mFuseCountdownMin, mFuseCountdownMax, ElapsedSlot / TotalSlots);
    // End:0xD7
    if(BeepRate <= (WorldInfo.TimeSeconds - mFuseLastBeepTime))
    {
        mFuseLastBeepTime = WorldInfo.TimeSeconds;
        // End:0xD7
        if(mBombType != none)
        {
            PlaySound(mBombType.default.mCountdownSoundCue, true);
        }
    }
    // End:0x10E
    if((int(Role) == int(ROLE_Authority)) && WorldInfo.Game.bGameEnded)
    {
        OnBombExploded();
    }
    //return;    
}

simulated function OnSimulatedCountdownCompleted()
{
    // End:0x1A
    if(int(Role) == int(ROLE_Authority))
    {
        OnBombExploded();
    }
    //return;    
}

simulated function OnSimulatedBombExploded()
{
    local @NULL explosionEmitter, TPC;

    // End:0x0B
    if(mBombExploded)
    {
        return;
    }
    // DebugMode: 0
    assert(mBombType != none);
    mBombExplosionTrigger = true;
    mBombExploded = true;
    // End:0x8A
    foreach LocalPlayerControllers(TPC)
    {
        // End:0x89
        if(TPC.Pawn != none)
        {
            TurokPawn(TPC.Pawn).mSoundController.TryPlayLocalSoundAt(mBombType.default.mExplosionSoundCue, mBombPlantLocation);
        }        
    }    
    explosionEmitter = __NFUN_278__(Class'TurokEmitter',,, mBombPlantLocation, mBombPlantRotation);
    explosionEmitter.SetTemplate(mBombType.default.mExplosionTemplate, true);
    // End:0xEC
    if(int(Role) == int(ROLE_Authority))
    {
        SetTimer(mMaxExplosionEffectTime, false, 'OnBombExplosionExpired');
    }
    //return;    
}

private final function OnBombExplosionExpired()
{
    mBombExplosionTrigger = false;
    mBombExploded = false;
    //return;    
}

simulated event OnSimulatedDefuseHideBomb(bool Hide)
{
    mHideBomb = Hide;
    // End:0x36
    if(mBombSimActor != none)
    {
        mBombSimActor.StaticMeshComponent.SetHidden(Hide);
    }
    //return;    
}

private final function RefreshBombAction()
{
    local int I;

    // End:0x5D
    if(mAllowMultipleActors)
    {
        I = 0;
        J0x10:

        // End:0x5D [Loop If]
        if(I < mControllers.Length)
        {
            TurokPlayerController(mControllers[I]).SetContextAction(GetActionObject(mControllers[I]));
            ++I;
            // [Loop Continue]
            goto J0x10;
        }
    }
    //return;    
}

defaultproperties
{
    mDamage=400.0000000
    mDamageRadius=600.0000000
    mPlantTime=5.0000000
    mDefuseTime=5.0000000
    mFuseLength=60.0000000
    mFuseCountdownMin=2.0000000
    mFuseCountdownMax=0.2500000
    mMaxAllowedDistanceForDefuse=60.0000000
    mMaxExplosionEffectTime=1.5000000
    mFuseCountdownInterval=5.0000000
    mBombTeamIndex=255
    // Reference: DrawSphereComponent'Default__TurokBombActionVolume.LookDirMarker'
    begin object name=LookDirMarker
    end object
    mLookDirMarker=LookDirMarker
    mMaxAllowedLookDirOffset=60.0000000
    // Reference: BrushComponent'Default__TurokBombActionVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    bStatic=false
    bAlwaysRelevant=true
    bReplicateMovement=false
    bOnlyDirtyReplication=true
    bMovable=false
    Components[0]=BrushComponent0
    Components[1]=LookDirMarker
    RemoteRole=1
    CollisionComponent=BrushComponent0
    SupportedEvents=/* Array type was not detected. */
}