class SkyBeam extends Actor
    native
    notplaceable;

var(Damage) float DamagePerSecond;
var(Damage) float MinimumDamage;
var float SavedDamage;
var(Ammo) float AmmoUsePerSecond;
var float PartialAmmo;
var float SavedAmmoUse;
var() class<DamageType> MyDamageType;
var(Physics) float DefaultImpulse;
var(Physics) float DefaultDeathImpulse;
var Actor HitActor;
var(Effects) ParticleSystem BeamTemplate;
var export editinline transient SkyParticleSystemComponent BeamEmitter;
var(Effects) name StartPointParamName;
var(Effects) name EndPointParamName;
var Vector StartLoc;
var Vector EndLoc;
var(Effects) ParticleSystem EndPointTemplate;
var SkyEmitter EndPointEmitter;
var SkyWeapon Weapon;
var(Physics) float MomentumTransfer;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

function Init(SkyWeapon Weap)
{
    Weapon = Weap;
    BeamEmitter = new (self) Class'SkyParticleSystemComponent';
    // End:0x3B
    if(BeamEmitter != none)
    {
        BeamEmitter.SetTemplate(BeamTemplate);
    }
    EndPointEmitter = Spawn(Class'SkyEmitter', self);
    // End:0x8C
    if(EndPointEmitter != none)
    {
        EndPointEmitter.SetTemplate(EndPointTemplate);
        EndPointEmitter.LifeSpan = 0.0000000;
    }
    //return;    
}

// Export USkyBeam::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(float Amount);

// Export USkyBeam::execUpdateBeamEmitter(FFrame&, void* const)
native simulated function UpdateBeamEmitter(Vector FlashLocation, Vector HitNormal, Actor HitTarget);
