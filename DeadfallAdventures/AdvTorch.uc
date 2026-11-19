class AdvTorch extends EvilWeap_Base
    config(Weapon)
    hidecategories(Navigation);

var bool bIsActive;
var() private const export editinline ParticleSystemComponent Fire;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(0.2000000, true, 'FuelUpdate');
    //return;    
}

function Refill()
{
    AmmoCount = LockerAmmoCount;
    bIsActive = true;
    Fire.SetActive(true);
    SetTimer(0.1000000, true, 'FuelUpdate');
    //return;    
}

function FuelUpdate()
{
    AmmoCount--;
    // End:0x5B
    if(AmmoCount <= 0)
    {
        bIsActive = false;
        Fire.SetActive(false);
        ClearTimer('FuelUpdate');
    }
    //return;    
}

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__AdvTorch.FireParticles'
    begin object name=FireParticles class=Class'Engine.ParticleSystemComponent'
        ReplacementPrimitive=none
    end object
    Fire=FireParticles
    LockerAmmoCount=100
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvTorch.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=4
    GroupWeight=1.0000000
    // Reference: AudioComponent'Default__AdvTorch.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvTorch.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponColor=(R=200,G=128,B=64,A=255)
    FireOffset=(X=20.0000000,Y=5.0000000,Z=0.0000000)
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvTorch.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
        Scale=0.3000000
    end object
    Mesh=FirstPersonMesh
    ShouldFireOnRelease=/* Array type was not detected. */
    // Reference: SkeletalMeshComponent'Default__AdvTorch.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
        Scale=0.3000000
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
    Components[2]=FireParticles
}