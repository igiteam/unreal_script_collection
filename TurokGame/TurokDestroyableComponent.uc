class TurokDestroyableComponent extends TurokUVAnimComponent
    native
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Collision,Rendering,Lighting);

struct native DestructionSound
{
    var int threshHold;
    var @NULL mDestructionSndCue;

    structdefaultproperties
    {
        threshHold=0
        mDestructionSndCue=none
    }
};

var(Effects) @NULL mpDestructionParticleSystem;
var array mDestructionSounds;
var int mCurrDestructionLevel;
var() int mMaxHitPoints;
var int mCurHitPoints;
var int mNumResidualComponents;
var int mIndex;
var bool mDestroyed;

// Export UTurokDestroyableComponent::execIsDestroyed(FFrame&, void* const)
native function bool IsDestroyed();

// Export UTurokDestroyableComponent::execInit(FFrame&, void* const)
native function Init();

function bool TakeDamage(int Damage, @NULL HitLocation, @NULL Momentum, class<Class> pDamageType)
{
    // End:0x0B
    if(mDestroyed)
    {
        return true;
    }
    mCurHitPoints -= Damage;
    // End:0x27
    if(mCurHitPoints <= 0)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function PlayDestructionEffects(@NULL HitLocation, @NULL Momentum, class<Class> pDamageType)
{
    local @NULL emitterPool;

    // End:0x6E
    if((!IsDestroyed() && none != mpDestructionParticleSystem) && none != Owner)
    {
        emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
        emitterPool.GetEmitter(mpDestructionParticleSystem, Owner, HitLocation);
    }
    //return;    
}

simulated function DestroyComponent()
{
    SetHidden(true);
    SetTraceBlocking(false, false);
    SetActorCollision(false, false);
    SetBlockRigidBody(false);
    TermComponentRBPhys();
    mDestroyed = true;
    //return;    
}

simulated function PlayDestructionSound()
{
    local int X;
    local float pctDamage;
    local int PrevDestructionLevel;
    local @NULL daOwner;

    // End:0x0D
    if(Owner == none)
    {
        return;
    }
    daOwner = TurokDestroyableActorBase(Owner);
    PrevDestructionLevel = mCurrDestructionLevel;
    // End:0x57
    if(mCurHitPoints > 0)
    {
        pctDamage = (1.0000000 - float(mCurHitPoints / mMaxHitPoints)) * float(100);        
    }
    else
    {
        pctDamage = 100.0000000;
    }
    X = mDestructionSounds.Length - 1;
    J0x71:

    // End:0xB5 [Loop If]
    if(X > 0)
    {
        // End:0xAB
        if(pctDamage >= float(mDestructionSounds[X].threshHold))
        {
            mCurrDestructionLevel = X;
            // [Explicit Break]
            goto J0xB5;
        }
        X--;
        // [Loop Continue]
        goto J0x71;
    }
    J0xB5:

    // End:0x107
    if((mCurrDestructionLevel > PrevDestructionLevel) && mMaxHitPoints > 0)
    {
        // End:0x107
        if(daOwner != none)
        {
            daOwner.PlayDestructionSound(mDestructionSounds[mCurrDestructionLevel].mDestructionSndCue);            
        }
    }
    //return;    
}

defaultproperties
{
    mDestructionSounds=/* Array type was not detected. */
    mCurrDestructionLevel=-1
    HiddenGame=true
    CastShadow=false
    bForceDirectLightMap=true
    bCastDynamicShadow=false
    LightingChannels=(bInitialized=true,Static=true)
}