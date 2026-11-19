class TechPointCache extends SkyBonusPickupFactory
    native;

var(Effects) ParticleSystem TechPointCacheParticleSystem;
var SkyEmitter TechPointCacheEmitter;
var(Bonus) int Points;
var(Bonus) int cacheID;
var(Sounds) SoundCue PickupSound;
var bool bEffectDestroyed;
var(TechPointMagnetism) bool bMagnetismOffsetLooping;
var bool bMagnetismSpiralClockwise;
var(TechPoint) DroppedTechPoints.ETechPointState StartingState;
var DroppedTechPoints.ETechPointState CurrState;
var(TechPointMagnetism) DroppedTechPoints.ETechPointOffsetType OffsetType;
var DroppedTechPoints.ETechPointScaleState ScaleState;
var(TechPointBobbing) float RotateToZeroTime;
var(TechPointBobbing) float DelayBeforeBob;
var(TechPointBobbing) float BobHeight;
var(TechPointBobbing) float BobRate;
var(TechPointBobbing) Rotator BobRotationRate;
var(TechPointBobbing) Rotator BobRotationFadeRate;
var Vector BobBaseLoc;
var float BobStartTime;
var Rotator BobInitialRotation;
var(TechPointMagnetism) float MagnetismDistWalking;
var(TechPointMagnetism) float MagnetismDistFlying;
var(TechPointMagnetism) float MagnetismDistAAGun;
var(TechPointMagnetism) float MagnetismAccelRate;
var(TechPointMagnetism) float MagnetismAccelRateFlying;
var(TechPointMagnetism) float MagnetismOffsetPeriod;
var(TechPointMagnetism) float MagnetismOffsetLength;
var(TechPointMagnetism) float MagnetismSpiralGrowTime;
var(TechPointMagnetism) name MagnetismSocket;
var(TechPointMagnetism) array<SVisualEffectParams> CollectionEffects;
var(TechPointMagnetism) editinline ForceFeedbackWaveform CollectionRumble;
var Vector MagnetismBaseLocation;
var float MagnetismStartTime;
var(TechPointScaling) float SpawnScaleMin;
var(TechPointScaling) float SpawnScaleMax;
var(TechPointScaling) float SpawnScaleUpTime;
var float SpawnScaleUpTimer;
var(TechPointScaling) float CollectScaleMin;
var(TechPointScaling) float ScaleDownDistStart;
var(TechPointScaling) float ScaleDownDistEnd;
var transient Vector PrevTargetLocation;

// Export UTechPointCache::execChangeState(FFrame&, void* const)
native function ChangeState(DroppedTechPoints.ETechPointState NewState);

// Export UTechPointCache::execIsDisabled(FFrame&, void* const)
native function bool IsDisabled();

function BeginStartingState()
{
    ChangeState(StartingState);
    //return;    
}

event bool BonusIsValid(SkyPlayerControllerBase C)
{
    // End:0x27
    if(C != none)
    {
        return !C.HasTechPointCache(cacheID);
    }
    return true;
    //return ReturnValue;    
}

function OnPickupBonus(SkyPlayerControllerBase C)
{
    local SkyPawn SP;

    // End:0x136
    if(C != none)
    {
        Class'SkyHUD'.static.OpenPickupTutorial('TechPointCache', SkyPlayerController(C));
        // End:0x5A
        if(TechPointCacheEmitter != none)
        {
            bEffectDestroyed = true;
            TechPointCacheEmitter.LifeSpan = 0.0001000;
        }
        C.AddTechPoints(Points, cacheID);
        C.PlaySound(PickupSound);
        C.ClientPlayForceFeedbackWaveform(CollectionRumble);
        SP = SkyPawn(C.Pawn);
        // End:0x136
        if(SP != none)
        {
            SP.AddEffectVisualEffect(CollectionEffects, self);
            // End:0x136
            if(SkyPawnSoundGroup(SP.SoundGroup) != none)
            {
                SP.PlayVoiceOver(SkyPawnSoundGroup(SP.SoundGroup).VO_FoundTechPointCache);
            }
        }
    }
    //return;    
}

event GiveEvent(Pawn P)
{
    //return;    
}

auto state Pickup
{
    simulated event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        TechPointCacheEmitter = Spawn(Class'SkyEmitter', self,, Location, Rotation);
        // End:0x5C
        if((TechPointCacheEmitter != none) && TechPointCacheParticleSystem != none)
        {
            TechPointCacheEmitter.SetTemplate(TechPointCacheParticleSystem, true);
        }
        SetTimer(0.1000000, false, 'BeginStartingState');
        //return;        
    }

    event GiveEvent(Pawn P)
    {
        Give(P);
        //return;        
    }

    function bool ValidTouch(Pawn Other)
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}
