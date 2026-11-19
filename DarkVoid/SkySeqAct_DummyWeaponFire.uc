class SkySeqAct_DummyWeaponFire extends SeqAct_Latent
    native;

var() int ShotsToFire;
var() SkyWeapon WeaponArchetype;
var() byte FireMode;
var() Actor Origin;
var() Actor Target;
var() Rotator MaxSpread;
var export editinline ParticleSystemComponent MuzzleFlashPSC;
var export editinline ParticleSystemComponent ImpactPSC;
var float RefireTime;
var const MaterialImpactEffect HitMaterialImpactEffect;
var const bool bEnablePhysXEffects;
var const float MuzzleFlashEndTime;
var const float CurrentTime;
var SkyProjectile DummyProj;
var const Vector HitLocation;

function CreateFireEffects()
{
    local Rotator ShootDir;
    local bool bImpact;

    ShootDir = Rotator(Target.Location - Origin.Location);
    bImpact = CreateFireEffectsNative();
    MuzzleFlashPSC = Origin.WorldInfo.MyEmitterPool.SpawnEmitter(WeaponArchetype.MuzzleFlashPSCTemplate, Origin.Location);
    // End:0xA9
    if(WeaponArchetype.ProjectileArchetype != none)
    {
        CreateProjectileEffects();        
    }
    else
    {
        // End:0x1C4
        if(bImpact)
        {
            // End:0x11F
            if(bEnablePhysXEffects && HitMaterialImpactEffect.PCParticleTemplate != none)
            {
                ImpactPSC = Target.WorldInfo.MyEmitterPool.SpawnEmitter(HitMaterialImpactEffect.PCParticleTemplate, HitLocation, ShootDir);                
            }
            else
            {
                // End:0x17E
                if(HitMaterialImpactEffect.ParticleTemplate != none)
                {
                    ImpactPSC = Target.WorldInfo.MyEmitterPool.SpawnEmitter(HitMaterialImpactEffect.ParticleTemplate, HitLocation, ShootDir);
                }
            }
            // End:0x1B9
            if(HitMaterialImpactEffect.Sound != none)
            {
                Target.PlaySound(HitMaterialImpactEffect.Sound);
            }
            // End:0x1C4
            if(ImpactPSC == none)
            {
            }
        }
    }
    RefireTime = (CurrentTime + WeaponArchetype.FireInterval[int(FireMode)]) + 0.0100000;
    //return;    
}

function CreateProjectileEffects()
{
    local Vector ProjDir;

    // End:0xC5
    if(WeaponArchetype.ProjectileArchetype != none)
    {
        DummyProj = Origin.Spawn(WeaponArchetype.ProjectileArchetype.Class, Origin,, Origin.Location, Origin.Rotation, WeaponArchetype.ProjectileArchetype);
        // End:0xC5
        if(DummyProj != none)
        {
            ProjDir = Target.Location - Origin.Location;
            DummyProj.Init(ProjDir);            
        }
    }
    //return;    
}

function UpdateFireEffects()
{
    local Rotator ShootDir;
    local bool bImpact;

    ShootDir = Rotator(Target.Location - Origin.Location);
    bImpact = UpdateFireEffectsNative();
    // End:0x83
    if(((MuzzleFlashPSC != none) && !WeaponArchetype.bMuzzleFlashPSCLoops) && CurrentTime >= MuzzleFlashEndTime)
    {
        MuzzleFlashPSC.DeactivateSystem();
        MuzzleFlashPSC = none;
    }
    // End:0x215
    if(CurrentTime >= RefireTime)
    {
        RefireTime = RefireTime + WeaponArchetype.FireInterval[int(FireMode)];
        // End:0xD8
        if(WeaponArchetype.ProjectileArchetype != none)
        {
            CreateProjectileEffects();            
        }
        else
        {
            // End:0x215
            if(bImpact)
            {
                // End:0x103
                if(ImpactPSC != none)
                {
                    ImpactPSC.DeactivateSystem();
                    ImpactPSC = none;
                }
                // End:0x170
                if(bEnablePhysXEffects && HitMaterialImpactEffect.PCParticleTemplate != none)
                {
                    ImpactPSC = Target.WorldInfo.MyEmitterPool.SpawnEmitter(HitMaterialImpactEffect.PCParticleTemplate, HitLocation, ShootDir);                    
                }
                else
                {
                    // End:0x1CF
                    if(HitMaterialImpactEffect.ParticleTemplate != none)
                    {
                        ImpactPSC = Target.WorldInfo.MyEmitterPool.SpawnEmitter(HitMaterialImpactEffect.ParticleTemplate, HitLocation, ShootDir);
                    }
                }
                // End:0x20A
                if(HitMaterialImpactEffect.Sound != none)
                {
                    Target.PlaySound(HitMaterialImpactEffect.Sound);
                }
                // End:0x215
                if(ImpactPSC == none)
                {
                }
            }
        }
    }
    //return;    
}

function CancelFireEffects()
{
    // End:0x22
    if(MuzzleFlashPSC != none)
    {
        MuzzleFlashPSC.DeactivateSystem();
        MuzzleFlashPSC = none;
    }
    // End:0x44
    if(ImpactPSC != none)
    {
        ImpactPSC.DeactivateSystem();
        ImpactPSC = none;
    }
    // End:0x63
    if(DummyProj != none)
    {
        DummyProj.Destroy();
        DummyProj = none;
    }
    //return;    
}

event Activated()
{
    // End:0x102
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x5B
        if(WeaponArchetype == none)
        {
            ScriptLog("Error: DummyWeaponFire with no WeaponArchetype");            
        }
        else
        {
            // End:0xA1
            if(Origin == none)
            {
                ScriptLog("Error: DummyWeaponFire.Activated with no Origin");                
            }
            else
            {
                // End:0xE7
                if(Target == none)
                {
                    ScriptLog("Error: DummyWeaponFire.Activated with no Target");                    
                }
                else
                {
                    // End:0xFF
                    if(true)
                    {
                        CancelFireEffects();
                        CreateFireEffects();
                    }
                }
            }
        }        
    }
    else
    {
        CancelFireEffects();
        OutputLinks[2].bHasImpulse = true;
    }
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

event bool Update(float DeltaTime)
{
    // End:0x22
    if(InputLinks[1].bHasImpulse)
    {
        CancelFireEffects();
        return false;
    }
    UpdateFireEffects();
    return true;
    //return ReturnValue;    
}

// Export USkySeqAct_DummyWeaponFire::execCreateFireEffectsNative(FFrame&, void* const)
native function bool CreateFireEffectsNative();

// Export USkySeqAct_DummyWeaponFire::execUpdateFireEffectsNative(FFrame&, void* const)
native function bool UpdateFireEffectsNative();
