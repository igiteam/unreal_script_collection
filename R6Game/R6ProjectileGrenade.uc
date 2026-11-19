class R6ProjectileGrenade extends R6Projectile
    abstract
    native
    config(ProjectilesConfig)
    hidecategories(lighting);

var R6ExplosionParams m_explosionParams;
var R6SoundExplosionParams m_SoundExplosionParams;
var float m_fDelayExplosion;
var config float m_fPlayerDelayExplosion;
var config float m_fTerroDelayExplosion;
var config float m_fDampFactor;
var config float m_fDampFactorParallel;
var bool m_bExploded;
var bool m_bExplodeOnHit;
var bool m_bDisabled;
var bool m_bNotifiedPawn;
var bool m_bExplodeOnFloor;
var bool m_bOnBSPSeeThrough;
var bool m_bIsServiceRequestFinished;
var bool m_bIsServiceRequestMade;
var bool m_bHitFloorOnce;
var float m_fTime;
var Controller m_pSetBy;
var float m_fPerceptionDistance;
var array<Controller> m_aNotifyController;
var native Pointer m_pComputedAmbushData;
var R6AIServiceManager m_pAIServiceManager;
var int m_iBounceCount;

// Export UR6ProjectileGrenade::execShowObject(FFrame&, void* const)
native final function ShowObject();

// Export UR6ProjectileGrenade::execBuildNotifyControllerList(FFrame&, void* const)
native final function BuildNotifyControllerList();

// Export UR6ProjectileGrenade::execGetEffectMaxRadius(FFrame&, void* const)
native final function float GetEffectMaxRadius(class<R6Effect> EffectClass);

// Export UR6ProjectileGrenade::execMakeServiceRequest(FFrame&, void* const)
native final function MakeServiceRequest();

// Export UR6ProjectileGrenade::execBounce(FFrame&, void* const)
native final function Bounce(Vector vHitLocation, Vector vHitNormal);

// Export UR6ProjectileGrenade::execHitSomething(FFrame&, void* const)
native function HitSomething(Actor pHitActor, PrimitiveComponent pComponent, Vector vHitLocation, Vector vHitNormal);

simulated function PostBeginPlay()
{
    PostBeginPlay();
    BuildNotifyControllerList();
    return;
}

simulated event Bump(Actor other, PrimitiveComponent pComponent, Vector HitNormal)
{
    // End:0x2A
    if(other != Instigator)
    {
        HitSomething(other, pComponent, Location, HitNormal);
    }
    return;
}

simulated function Landed(Vector vHitNormal, Actor FloorActor, Vector vLocation)
{
    HitSomething(FloorActor, none, vLocation, vHitNormal);
    return;
}

defaultproperties
{
    m_fPerceptionDistance=500.0000000
    Physics=14
}