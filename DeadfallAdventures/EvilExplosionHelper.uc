class EvilExplosionHelper extends Actor
    notplaceable
    hidecategories(Navigation);

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
    local MaterialInstanceTimeVarying exploDecal, ParentBloodDecal;

    TraceExtent = vect(0.0000000, 0.0000000, 0.0000000);
    I = 0;
    J0x3A:

    // End:0x2B2 [Loop If]
    if(I < numDecals)
    {
        randVec = Normal(vect(0.0000000, 0.0000000, -1.0000000)) * Distance;
        TraceActor = Trace(out_HitLocation, out_HitNormal, HitLocation + randVec, HitLocation, false, TraceExtent, HitInfo, 1);
        // End:0x28B
        if(CanSpawnDecalOnActor(TraceActor, HitInfo))
        {
            ParentBloodDecal = EvilGameReplicationInfo(WorldInfo.GRI).GetRandomDecalMaterialsFromMapInfo();
            // End:0x288
            if(ParentBloodDecal != none)
            {
                exploDecal = new (self) Class'Engine.MaterialInstanceTimeVarying';
                exploDecal.SetParent(ParentBloodDecal);
                RandVal = FRand();
                WorldInfo.MyDecalManager.SpawnDecal(exploDecal, out_HitLocation, Rotator(-out_HitNormal), Width + (RandVal * RandWidth), Height + (RandVal * RandHeight), Class'EvilDecal'.default.MinExplosionThickness * float(5), false,, none, true, false, 'None', -1, -1);
                exploDecal.SetScalarStartTime('DissolveAmount', Lifetime);
            }            
        }
        else
        {
            // End:0x2A4
            if(bWaterActor)
            {
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
    local MaterialInstanceTimeVarying exploDecal, ParentBloodDecal;

    TraceExtent = vect(0.0000000, 0.0000000, 0.0000000);
    I = 0;
    J0x3A:

    // End:0x2A7 [Loop If]
    if(I < numDecals)
    {
        randVec = Normal(VRand()) * Distance;
        TraceActor = Trace(out_HitLocation, out_HitNormal, HitLocation + randVec, HitLocation, false, TraceExtent, HitInfo, 1);
        // End:0x280
        if(CanSpawnDecalOnActor(TraceActor, HitInfo))
        {
            ParentBloodDecal = EvilGameReplicationInfo(WorldInfo.GRI).GetRandomDecalMaterialsFromMapInfo();
            // End:0x27D
            if(ParentBloodDecal != none)
            {
                exploDecal = new (self) Class'Engine.MaterialInstanceTimeVarying';
                exploDecal.SetParent(ParentBloodDecal);
                RandVal = FRand();
                WorldInfo.MyDecalManager.SpawnDecal(exploDecal, out_HitLocation, Rotator(-out_HitNormal), Width + (RandVal * RandWidth), Height + (RandVal * RandHeight), Class'EvilDecal'.default.MinExplosionThickness * float(5), false,, none, true, false, 'None', -1, -1);
                exploDecal.SetScalarStartTime('DissolveAmount', Lifetime);
            }            
        }
        else
        {
            // End:0x299
            if(bWaterActor)
            {
                bWaterActor = false;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x3A;
    }
    //return;    
}

defaultproperties
{
    Width=64.0000000
    Height=64.0000000
    RandWidth=48.0000000
    RandHeight=48.0000000
    CollisionType=ECollisionType.COLLIDE_CustomDefault
}