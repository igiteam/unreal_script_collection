class TurokProjFlareNative extends TurokStickyProjectile
    abstract
    native
    config(Projectile)
    hidecategories(Navigation);

var @NULL mLastController;
var array mTrackingControllers;
var(Flare) export editinline @NULL FlareLight;
var export editinline @NULL mFlarePS;
var export editinline @NULL mSmokePS;
var config float mFlickerRate;
var config @NULL mMaxFlickerColor;
var config @NULL mMinFlickerColor;
var config float mMaxRadius;
var config float mMinRadius;
var(Terror) int mTerrorAmt;
var(Terror) int mTerrorThres;
var private bool mExplodeOnce;
var() private bool mAttractAll;
var private @NULL mAttachedController;
var private @NULL mAttachedPawn;
var(Flare) float mStuckToHumanShutOffTime;
var config float mBeginFallDistance;

// Export UTurokProjFlareNative::execAttractAll(FFrame&, void* const)
native function bool AttractAll();

simulated event PostBeginPlay()
{
    // End:0x22
    if(mFlickerRate > 0.0000000)
    {
        SetTimer(mFlickerRate, true, 'FlickerTimer');
    }
    super.PostBeginPlay();
    //return;    
}

function ()
{
    local int I, Index;
    local @NULL ctrl;

    super.Destroyed();
    // End:0x94
    if(mTrackingControllers.Length > 0)
    {
        I = 0;
        J0x19:

        // End:0x87 [Loop If]
        if(I < mTrackingControllers.Length)
        {
            ctrl = mTrackingControllers[I];
            // End:0x7D
            if(ctrl != none)
            {
                Index = ctrl.mFlareCandidates.Find(@NULL);
                @NULL
                @NULL
                ctrl.mFlareCandidates
                Index
                1
                I++;
                // [Loop Continue]
                goto J0x19;
                mTrackingControllers.Remove(0, mTrackingControllers.Length);
            }
        }
        // End:0xBA
        if(mAttachedController != none)
        {
            mAttachedController.DetachFlare(self);
        }
        mAttachedController = none;
        /* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
            
        */

        // End:0xDF
        /*@Error*/
        mAttachedPawn.FlareRemoved();
    }
    mAttachedPawn = none;
    //return;    
    @NULL
    default.@NULL
    @NULL
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    // End:0x3B
    if((TurokPawnRazorWingNative(mStuckToPawn) != none) && mStuckToPawn.bPendingDelete)
    {
        SetPhysics(2);
        mStuckToPawn = none;
    }
    //return;    
}

simulated function Explode(@NULL HitLocation, @NULL HitNormal)
{
    local int Index;
    local @NULL turokCtrl, tPawn;

    // End:0x0B
    if(mExplodeOnce)
    {
        return;
    }
    mExplodeOnce = true;
    Index = 0;
    J0x1A:

    // End:0x52 [Loop If]
    if(Index < mTrackingControllers.Length)
    {
        mTrackingControllers[Index].SeeFlareExploded(ImpactedActor);
        Index++;
        // [Loop Continue]
        goto J0x1A;
    }
    super.Explode(HitLocation, HitNormal);
    tPawn = TurokPawn(ImpactedActor);
    // End:0x13B
    if(tPawn != none)
    {
        mAttachedPawn = tPawn;
        tPawn.FlareAttached();
        // End:0xE8
        if((TurokPawnHuman(tPawn) != none) && !mbIsMultiPlayer || mbIsMultiPlayer && TurokPawnPlayer(tPawn) == none)
        {
            SetTimer(mStuckToHumanShutOffTime, false, 'SwitchToSmokeTimer');
        }
        // End:0x13B
        if(tPawn.Controller != none)
        {
            turokCtrl = TurokAIController(tPawn.Controller);
            // End:0x13B
            if(turokCtrl != none)
            {
                mAttachedController = turokCtrl;
                turokCtrl.mAttachedFlare = self;
            }
        }
    }
    //return;    
}

simulated function SwitchToSmokeTimer()
{
    mFlarePS.KillParticlesForced();
    ClearTimer('FlickerTimer');
    FlareLight.SetEnabled(false);
    //return;    
}

simulated function FlickerTimer()
{
    // End:0x63
    if(FlareLight != none)
    {
        FlareLight.LightColor = Add_ColorColor(mMinFlickerColor, Multiply_FloatColor(FRand(), Subtract_ColorColor(mMaxFlickerColor, mMinFlickerColor)));
        FlareLight.Radius = mMinRadius + (FRand() * (mMaxRadius - mMinRadius));
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokProjFlareNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokRadialShakeComponent'Default__TurokProjFlareNative.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjFlareNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjFlareNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}