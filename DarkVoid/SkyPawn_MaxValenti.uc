class SkyPawn_MaxValenti extends SkyPawn_Adept
    native
    config(Game);

var const float InteractionCheckPeriod;
var transient float InteractionCheckTimer;
var transient CheckpointStart LoadedFromCPStart;
var(Sounds) SoundCue DeathStinger;
var transient float CurrVOTimeRemaining;
var string DrivenVehicleName;
var bool bCPRocketpacking;
var bool bCPRocketpackOn;
var transient string StoredWeapArchName;
var transient string StoredBackWeapArchName;
var transient string StoredSecondaryWeapArchName;
var transient string StoredPreviousWeapArchName;
var transient int StoredWeapAmmo;
var transient int StoredBackWeapAmmo;
var transient int StoredSecondaryWeapAmmo;
var transient int StoredPreviousWeapAmmo;
var transient int StoredWeapAdditionalAmmo;
var transient int StoredBackWeapAdditionalAmmo;
var transient int StoredSecondaryWeapAdditionalAmmo;
var transient int StoredPreviousWeapAdditionalAmmo;
var transient string StoredRocketpackArchName;
var transient string StoredRocketpackInstanceName;
var init transient array<init string> StoredObjectives;
var transient int TechPointsSinceLastCheckpoint;
var export editinline transient SkeletalMeshComponent PriWeaponMeshCompAtCheckpoint;
var() float TriggerPlayerVUpDangleCooldownTime;
var transient float TriggerPlayerVUpDangleLastTime;

// Export USkyPawn_MaxValenti::execEnableForceWeaponMips(FFrame&, void* const)
native function EnableForceWeaponMips();

// Export USkyPawn_MaxValenti::execDisableForceWeaponMips(FFrame&, void* const)
native function DisableForceWeaponMips();

simulated function PostBeginPlay()
{
    local SkyGame_Story SGame;

    super.PostBeginPlay();
    SetTimer(0.2500000, true, 'UpdateGroundMaterialType');
    SGame = SkyGame_Story(WorldInfo.Game);
    // End:0x71
    if((SGame != none) && SGame.MusicManager != none)
    {
        SGame.MusicManager.bPlayedDeathStinger = false;
    }
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    local SkyPawn_Archon Archon;
    local Vector Momentum;

    Momentum.X = 0.0000000;
    Momentum.Y = 0.0000000;
    Momentum.Z = 0.0000000;
    Archon = SkyPawn_Archon(Other);
    // End:0x13F
    if(((((((Archon != none) && Archon.Health <= 0) && OtherComp == Archon.Mesh) && int(Physics) == int(1)) && HitNormal.Z < -0.7070000) && Location.Z < Archon.Location.Z) && Archon.Mesh.bPauseAnims == false)
    {
        TakeDamage(10000, Archon.Controller, Location, Momentum, Class'Engine.DmgType_Crushed');
    }
    super(Actor).Bump(Other, OtherComp, HitNormal);
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local SkyGame_Story SGame;
    local SkyPlayerControllerBase PC;

    PC = SkyPlayerControllerBase(Controller);
    // End:0x59
    if(PC != none)
    {
        PC.AddTechPoints(-TechPointsSinceLastCheckpoint);
        Class'Engine.SkySeqAct_TrophyBookkeeping'.static.TechPointAcquired(-TechPointsSinceLastCheckpoint);
        TechPointsSinceLastCheckpoint = 0;
    }
    SGame = SkyGame_Story(WorldInfo.Game);
    // End:0x146
    if((SGame != none) && SGame.MusicManager != none)
    {
        // End:0xDA
        if(SGame.MusicManager.ActiveKismetAction != none)
        {
            SGame.MusicManager.ActiveKismetAction.bIsRequestingKill = true;
        }
        // End:0x146
        if((DeathStinger != none) && !SGame.MusicManager.bPlayedDeathStinger)
        {
            SGame.MusicManager.PlaySound(DeathStinger);
            SGame.MusicManager.bPlayedDeathStinger = true;
        }
    }
    EnableForceWeaponMips();
    return super(SkyPawn).Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

event SetCurrVOTimeRemaining(float Time)
{
    CurrVOTimeRemaining = FMax(Time, CurrVOTimeRemaining);
    //return;    
}

function CheckForceDamage(SkyProj_SecondaryItemBase Proj)
{
    // End:0xA8
    if((IsInCover()) && int(GetCoverOrientation()) == int(1))
    {
        // End:0xA8
        if(Proj.Instigator == self)
        {
            TakeRadiusDamage(Controller, Proj.Damage, Proj.DamageRadius, Proj.DamageRadiusInner, Proj.MyDamageType, Proj.DefaultImpulse, Proj.Location, true, Proj);
        }
    }
    //return;    
}
