class EvilExplosionHelper extends Actor
    notplaceable
    hidecategories(Navigation);

var() array<MaterialInstanceTimeVarying> BloodMITVs;
var() array<MaterialInstanceTimeVarying> PlasmaMITVs;
var() array<Vector> RandVectors;
var() float Width;
var() float Height;
var() float RandWidth;
var() float RandHeight;
var() bool bWaterActor;

simulated function PostBeginPlay()
{
    RandVectors.AddItem(vect(1.0000000, 0.0000000, 0.0000000));
    RandVectors.AddItem(vect(-1.0000000, 0.0000000, 0.0000000));
    RandVectors.AddItem(vect(0.0000000, 1.0000000, 0.0000000));
    RandVectors.AddItem(vect(0.0000000, -1.0000000, 0.0000000));
    RandVectors.AddItem(vect(0.0000000, 0.0000000, 1.0000000));
    RandVectors.AddItem(vect(0.0000000, 0.0000000, -1.0000000));
    RandVectors.AddItem(vect(1.0000000, 0.0000000, 1.0000000));
    RandVectors.AddItem(vect(1.0000000, 0.0000000, -1.0000000));
    RandVectors.AddItem(vect(1.0000000, 1.0000000, 0.0000000));
    RandVectors.AddItem(vect(1.0000000, -1.0000000, 0.0000000));
    RandVectors.AddItem(vect(-1.0000000, 0.0000000, 1.0000000));
    RandVectors.AddItem(vect(-1.0000000, 0.0000000, -1.0000000));
    RandVectors.AddItem(vect(-1.0000000, 1.0000000, 0.0000000));
    RandVectors.AddItem(vect(-1.0000000, -1.0000000, 0.0000000));
    RandVectors.AddItem(vect(0.0000000, 1.0000000, 1.0000000));
    RandVectors.AddItem(vect(0.0000000, 1.0000000, -1.0000000));
    RandVectors.AddItem(vect(0.0000000, -1.0000000, 1.0000000));
    RandVectors.AddItem(vect(0.0000000, -1.0000000, -1.0000000));
    RandVectors.AddItem(vect(1.0000000, 1.0000000, 1.0000000));
    RandVectors.AddItem(vect(1.0000000, 1.0000000, -1.0000000));
    RandVectors.AddItem(vect(1.0000000, -1.0000000, 1.0000000));
    RandVectors.AddItem(vect(1.0000000, -1.0000000, -1.0000000));
    RandVectors.AddItem(vect(-1.0000000, 1.0000000, 1.0000000));
    RandVectors.AddItem(vect(-1.0000000, 1.0000000, -1.0000000));
    RandVectors.AddItem(vect(-1.0000000, -1.0000000, 1.0000000));
    RandVectors.AddItem(vect(-1.0000000, -1.0000000, -1.0000000));
    //return;    
}

simulated function bool CanSpawnDecalOnActor(Actor TraceActor, const out TraceHitInfo HitInfo)
{
    // End:0x11
    if(TraceActor == none)
    {
        return false;
    }
    // End:0x49
    if(HitInfo.PhysMaterial == PhysicalMaterial'pm_materials.PM_Water')
    {
        bWaterActor = true;
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function ThrowBloodDecalsUnderHitLocation(Vector HitLocation, optional int numDecals = 6, optional float Distance = 200.0000000, optional float Lifetime = 8.0000000)
{
    local int I;
    local float RandVal;
    local Vector out_HitLocation, randVec, out_HitNormal, TraceExtent;
    local TraceHitInfo HitInfo;
    local Actor TraceActor;
    local MaterialInstanceTimeVarying exploDecal;

    TraceExtent = vect(0.0000000, 0.0000000, 0.0000000);
    I = 0;
    J0x3A:

    // End:0x2C2 [Loop If]
    if(I < numDecals)
    {
        randVec = Normal(vect(0.0000000, 0.0000000, -1.0000000)) * Distance;
        TraceActor = Trace(out_HitLocation, out_HitNormal, HitLocation + randVec, HitLocation, false, TraceExtent, HitInfo, 1);
        // End:0x242
        if(CanSpawnDecalOnActor(TraceActor, HitInfo))
        {
            exploDecal = new (self) Class'Engine.MaterialInstanceTimeVarying';
            exploDecal.SetParent(BloodMITVs[Rand(BloodMITVs.Length)]);
            RandVal = FRand();
            WorldInfo.MyDecalManager.SpawnDecal(exploDecal, out_HitLocation, Rotator(-out_HitNormal), Width + (RandVal * RandWidth), Height + (RandVal * RandHeight), Class'EvilDecal'.default.MinExplosionThickness * float(5), false,, none, true, false, 'None', -1, -1);
            exploDecal.SetScalarStartTime('DissolveAmount', Lifetime);            
        }
        else
        {
            // End:0x2B4
            if(bWaterActor)
            {
                WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'ps_Water.Effects.ps_BloodWater', out_HitLocation, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));
                bWaterActor = false;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x3A;
    }
    //return;    
}

simulated function ThrowRandomBloodDecals(Vector HitLocation, optional int numDecals = 6, optional float Distance = 200.0000000, optional float Lifetime = 8.0000000)
{
    local int I;
    local float RandVal;
    local Vector out_HitLocation, randVec, out_HitNormal, TraceExtent;
    local TraceHitInfo HitInfo;
    local Actor TraceActor;
    local MaterialInstanceTimeVarying exploDecal;

    TraceExtent = vect(0.0000000, 0.0000000, 0.0000000);
    I = 0;
    J0x3A:

    // End:0x2B7 [Loop If]
    if(I < numDecals)
    {
        randVec = Normal(VRand()) * Distance;
        TraceActor = Trace(out_HitLocation, out_HitNormal, HitLocation + randVec, HitLocation, false, TraceExtent, HitInfo, 1);
        // End:0x237
        if(CanSpawnDecalOnActor(TraceActor, HitInfo))
        {
            exploDecal = new (self) Class'Engine.MaterialInstanceTimeVarying';
            exploDecal.SetParent(BloodMITVs[Rand(BloodMITVs.Length)]);
            RandVal = FRand();
            WorldInfo.MyDecalManager.SpawnDecal(exploDecal, out_HitLocation, Rotator(-out_HitNormal), Width + (RandVal * RandWidth), Height + (RandVal * RandHeight), Class'EvilDecal'.default.MinExplosionThickness * float(5), false,, none, true, false, 'None', -1, -1);
            exploDecal.SetScalarStartTime('DissolveAmount', Lifetime);            
        }
        else
        {
            // End:0x2A9
            if(bWaterActor)
            {
                WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'ps_Water.Effects.ps_BloodWater', out_HitLocation, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));
                bWaterActor = false;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x3A;
    }
    //return;    
}

simulated function ThrowRandomPlasmaDecals(Vector HitLocation, optional int numDecals = 6, optional float Distance = 200.0000000, optional float Lifetime = 1.5000000)
{
    local int I;
    local float RandVal;
    local Vector out_HitLocation, randVec, out_HitNormal, TraceExtent;
    local TraceHitInfo HitInfo;
    local Actor TraceActor;
    local MaterialInstanceTimeVarying exploDecal;

    TraceExtent = vect(0.0000000, 0.0000000, 0.0000000);
    I = 0;
    J0x3A:

    // End:0x244 [Loop If]
    if(I < numDecals)
    {
        randVec = RandVectors[Rand(RandVectors.Length)] * Distance;
        TraceActor = Trace(out_HitLocation, out_HitNormal, HitLocation + randVec, HitLocation, false, TraceExtent, HitInfo, 1);
        // End:0x236
        if(TraceActor != none)
        {
            exploDecal = new (self) Class'Engine.MaterialInstanceTimeVarying';
            exploDecal.SetParent(PlasmaMITVs[Rand(PlasmaMITVs.Length)]);
            RandVal = FRand();
            WorldInfo.MyDecalManager.SpawnDecal(exploDecal, out_HitLocation, Rotator(-out_HitNormal), Width + (RandVal * RandWidth), Height + (RandVal * RandHeight), Class'EvilDecal'.default.MinExplosionThickness * float(5), false,, none, true, false, 'None', -1, -1);
            exploDecal.SetScalarStartTime('DissolveAmount', Lifetime);
        }
        I++;
        // [Loop Continue]
        goto J0x3A;
    }
    //return;    
}

defaultproperties
{
    BloodMITVs[0]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver1'
    BloodMITVs[1]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver2'
    BloodMITVs[2]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver3'
    BloodMITVs[3]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver4'
    Width=64.0000000
    Height=64.0000000
    RandWidth=48.0000000
    RandHeight=48.0000000
    CollisionType=ECollisionType.COLLIDE_CustomDefault
}