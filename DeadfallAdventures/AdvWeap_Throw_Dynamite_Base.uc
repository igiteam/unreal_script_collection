class AdvWeap_Throw_Dynamite_Base extends EvilWeap_Throw_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var export editinline ParticleSystemComponent FuseParticleSystem;
var protected export editinline AudioComponent FuseAudioComp;
var() MaterialInstanceConstant FuseMaterial;
var() float FuseTime;

simulated function PostBeginPlay()
{
    super(EvilWeap_Melee_Base).PostBeginPlay();
    UDKSkeletalMeshComponent(Mesh).AttachComponentToSocket(FuseParticleSystem, 'Lont');
    //return;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super(Actor).PostInitAnimTree(SkelComp);
    // End:0x2A
    if(SkelComp == Mesh)
    {
    }
    //return;    
}

function FuseMaterial_T()
{
    FuseMaterial.SetScalarParameterValue('LontTime', FuseTime);
    FuseTime += 0.0110000;
    //return;    
}

function STARTFIREFUSEPARTICLE()
{
    FuseParticleSystem.ActivateSystem();
    FuseMaterial = UDKSkeletalMeshComponent(Mesh).CreateAndSetMaterialInstanceConstant(0);
    FuseTime = -0.0300000;
    FuseMaterial.SetScalarParameterValue('LontTime', FuseTime);
    SetTimer(0.1000000, true, 'FuseMaterial_T');
    //return;    
}

function STOPFIREFUSEPARTICLE()
{
    //return;    
}

function FIREFUSE()
{
    FuseAudioComp.Play();
    //return;    
}

simulated function Projectile SpawnProjectile(optional bool bSpawnOnDeath = false)
{
    local Projectile Dynamite;

    Dynamite = super.SpawnProjectile(bSpawnOnDeath);
    // End:0x4E
    if(IsTimerActive('FuseMaterial_T'))
    {
        ClearTimer('FuseMaterial_T');
    }
    bReleaseGrenade = false;
    FuseAudioComp.Stop();
    return Dynamite;
    //return ReturnValue;    
}

simulated function Activate()
{
    local AdvPlayerPawnMP P;

    P = AdvPlayerPawnMP(Owner);
    // End:0xBA
    if(P != none)
    {
        P.PlayShoutSound(class<AdvFamilyInfo_MP_Hero_Base>(AdvPRI(P.Controller.PlayerReplicationInfo).static.GetCharClassInfo()).default.DynamiteShouts);
    }
    super(EvilWeap_Melee_Base).Activate();
    //return;    
}

simulated state WeaponPuttingDown
{
    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        bReleaseGrenade = false;
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        FuseParticleSystem.DeactivateSystem();
        FuseAudioComp.Stop();
        //return;        
    }
    stop;    
}

defaultproperties
{
    MaxHoldTime=6.0000000
    BothHandWeapon=true
    bSplashJump=true
    bRecommendSplashDamage=true
    DefaultAmmoCount=1
    MaxAmmoCount=5
    WeaponDamage=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Throw_Dynamite_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=50
    // Reference: AudioComponent'Default__AdvWeap_Throw_Dynamite_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Throw_Dynamite_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Dynamite"
    PlayerViewOffset=(X=10.0000000,Y=5.0000000,Z=-5.0000000)
    CurrentRating=0.0000000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.2000000
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Throw_Dynamite_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.0000000
    ItemName="TNT"
    MaxDesireability=0.0000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Throw_Dynamite_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}