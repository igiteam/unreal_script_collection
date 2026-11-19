class SkyVWeap_AirRemote_Flashbang extends SkyVWeap
    native
    config(Game);

var() ParticleSystem DetonationTemplate;
var() float DetonationDamage;
var() float DetonationRadius;
var() float DetonationMomentum;
var() SoundCue DetonationSound;
var class<SkyExplosionLight> DetonationLightClass;
var() float FlashLength;
var() float FlashMinRadius;
var() float FlashMaxRadius;
var() bool bFlashUsesLOS;

simulated function PostBeginPlay()
{
    super(SkyVehicleWeapon).PostBeginPlay();
    //return;    
}

function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    //return;    
}

// Export USkyVWeap_AirRemote_Flashbang::execFireAmmunition(FFrame&, void* const)
native simulated function FireAmmunition();

reliable server event Detonate()
{
    ClientDetonate();
    HurtRadius(DetonationDamage, DetonationRadius, 0.0000000, Class'SkyDmgType_SmallExplosives', DetonationMomentum, Instigator.Location);
    FlashRadius(Owner, FlashLength, FlashMinRadius, FlashMaxRadius, bFlashUsesLOS);
    SkyVehicle(Instigator).DriverLeave(true);
    SkyVehicle(Instigator).Died(Instigator.Controller, Class'Engine.DmgType_Suicided', Instigator.Location);
    //return;    
}

reliable client simulated function ClientDetonate()
{
    local Emitter ProjExplosion;
    local editinline SkyExplosionLight L;

    ProjExplosion = Spawn(Class'SkyEmitter', self,, Instigator.Location, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));
    // End:0xA3
    if(ProjExplosion != none)
    {
        ProjExplosion.SetTemplate(DetonationTemplate, true);
        // End:0xA3
        if((DetonationLightClass != none) && !WorldInfo.bDropDetail)
        {
            L = new (Outer) DetonationLightClass;
            ProjExplosion.AttachComponent(L);
        }
    }
    // End:0xBE
    if(DetonationSound != none)
    {
        PlaySound(DetonationSound, true);
    }
    //return;    
}

simulated function DrawAmmoCount(HUD H)
{
    //return;    
}
