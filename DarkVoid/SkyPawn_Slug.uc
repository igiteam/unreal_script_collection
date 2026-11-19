class SkyPawn_Slug extends SkyNPC
    native
    config(Pawn);

var(Effects) ParticleSystem DeathPopEffect;
var(Effects) bool DeathPopHidesSlug;
var(Effects) bool ImpactSquirtUsed;
var() bool bRagdollOnSpawn;
var float ImpactSquirtLastImpactTime;
var(Effects) float ImpactSquirtCooldownTime;
var(Effects) float ImpactSquirtMinVelocity;
var(Effects) Vector SlugEjectionForce;
var(Sounds) SoundCue SlugDeathPopSound;
var(Sounds) SoundCue SlugImpactSound;
var(Sounds) float SlugImpactSoundMinVel;
var float SlugImpactSoundLastImpactTime;
var(Sounds) float SlugImpactSoundCooldownTime;
var(Sounds) export editinline AudioComponent SlugWaggleSound;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x2C
    if(bRagdollOnSpawn)
    {
        SlugRagdoll();
        SetTimer(0.1000000, false, 'SlugRagdoll');
    }
    // End:0x47
    if(SlugWaggleSound != none)
    {
        SlugWaggleSound.Play();
    }
    bIsInvulnerable = true;
    SetTimer(1.5000000, false, 'FixInvuln');
    //return;    
}

function SlugRagdoll()
{
    ForceRagdoll();
    Mesh.AddImpulse(SlugEjectionForce);
    //return;    
}

function FixInvuln()
{
    bIsInvulnerable = false;
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    PopSlug(DamageType);
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function FeignDeathTimeoutTimer()
{
    //return;    
}

event PopSlug(class<DamageType> DamageType)
{
    local SkyEmitter Emit;

    // End:0x73
    if((DeathPopEffect != none) && DamageType != Class'Engine.DmgType_Suicided')
    {
        Emit = Spawn(Class'SkyEmitter', self,, Location, Rotation);
        // End:0x60
        if(Emit != none)
        {
            Emit.SetTemplate(DeathPopEffect);
        }
        // End:0x73
        if(DeathPopHidesSlug == true)
        {
            SetHidden(true);
        }
    }
    // End:0x9F
    if((SlugDeathPopSound != none) && DamageType != Class'Engine.DmgType_Suicided')
    {
        PlaySound(SlugDeathPopSound);
    }
    // End:0xBA
    if(SlugWaggleSound != none)
    {
        SlugWaggleSound.Stop();
    }
    // End:0xD3
    if(DamageType != Class'Engine.DmgType_Suicided')
    {
        TriggerBleedOut();
    }
    //return;    
}

// Export USkyPawn_Slug::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
