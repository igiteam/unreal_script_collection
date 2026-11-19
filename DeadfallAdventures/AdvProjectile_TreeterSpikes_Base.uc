class AdvProjectile_TreeterSpikes_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

struct ShockwaveWakeBreadcrumb
{
    var() Vector Location;
    var() float Life;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Life=0.0000000
    }
};

var transient float NextShockwaveTime;
var transient array<ShockwaveWakeBreadcrumb> ShockwaveWake;
var transient int ShockwaveWakeIndex;
var() float ShockwaveInterval;
var() float ShockwaveDelay;
var() float ShockwaveArcLength;
var() int ShockwaveTraces;
var() float ShockwaveRadius;
var() float ShockwaveFractureRadius;
var() float ShockwaveDamage;
var() ParticleSystem ShockwaveContactTemplate;
var() int ShockwaveWakeLength;
var() float SpikesSpawnInterval;
var() float LastSpikesSpawnTime;
var() bool bSpawnRightSpike;
var() float SpikesWidthSpread;
var class<Actor> SpikeActorClass;

function Init(Vector Direction)
{
    LastSpikesSpawnTime = WorldInfo.TimeSeconds;
    super.Init(Direction);
    //return;    
}

simulated event Tick(float DeltaTime)
{
    local int I;
    local Vector RightDir;

    super.Tick(DeltaTime);
    // End:0x23A
    if(WorldInfo.TimeSeconds >= NextShockwaveTime)
    {
        // End:0x84
        if(!IsZero(Velocity))
        {
            EmitShockWave(Location - (Velocity * ShockwaveDelay), Rotator(Velocity));
        }
        I = 0;
        J0x8F:

        // End:0x1F7 [Loop If]
        if(I < ShockwaveWakeLength)
        {
            // End:0xD9
            if(ShockwaveWake[I].Life <= 0.0000000)
            {                
            }
            else
            {
                HurtRadius((ShockwaveDamage * ShockwaveWake[I].Life) / (ShockwaveInterval * float(ShockwaveWake.Length)), ShockwaveRadius, MyDamageType, MomentumTransfer, ShockwaveWake[I].Location, Instigator);
                DoBreakFracturedMeshes(ShockwaveWake[I].Location + vect(0.0000000, 0.0000000, 80.0000000));
                ShockwaveWake[I].Life -= DeltaTime;
            }
            ++I;
            // [Loop Continue]
            goto J0x8F;
        }
        J0x1F7:

        // End:0x23A [Loop If]
        if(NextShockwaveTime < WorldInfo.TimeSeconds)
        {
            NextShockwaveTime += ShockwaveInterval;
            // [Loop Continue]
            goto J0x1F7;
        }
    }
    // End:0x345
    if((WorldInfo.TimeSeconds >= (LastSpikesSpawnTime + SpikesSpawnInterval)) && !IsZero(Velocity))
    {
        RightDir = GetRotatorAxis(Rotation, 1);
        // End:0x2DC
        if(bSpawnRightSpike)
        {
            SpawnSpike(Location + (RightDir * SpikesWidthSpread));            
        }
        else
        {
            SpawnSpike(Location - (RightDir * SpikesWidthSpread));
        }
        bSpawnRightSpike = !bSpawnRightSpike;
        LastSpikesSpawnTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

function SpawnSpike(Vector SpawnLocation, optional Rotator Rot)
{
    Spawn(SpikeActorClass,,, SpawnLocation, Rot);
    //return;    
}

protected simulated function DoBreakFracturedMeshes(Vector ExploOrigin)
{
    local FracturedStaticMeshActor FracActor;
    local byte bWantPhysChunksAndParticles;

    // End:0x10B
    foreach CollidingActors(Class'Engine.FracturedStaticMeshActor', FracActor, ShockwaveFractureRadius, ExploOrigin, true)
    {
        // End:0x10A
        if((int(FracActor.Physics) == int(0)) && FracActor.IsFracturedByDamageType(MyDamageType))
        {
            // End:0x10A
            if(FracActor.FractureEffectIsRelevant(false, Instigator, bWantPhysChunksAndParticles))
            {
                FracActor.BreakOffPartsInRadius(ExploOrigin, ShockwaveFractureRadius, MomentumTransfer, ((int(bWantPhysChunksAndParticles) == int(1)) ? true : false));
            }
        }        
    }    
    //return;    
}

function EmitShockWave(Vector Loc, Rotator Dir)
{
    local Vector X, Y, Z, traceDir;
    local float Step, F;
    local Actor Hit;
    local Vector HitLoc, HitNorm;

    GetAxes(Dir, X, Y, Z);
    Step = ShockwaveArcLength / float(ShockwaveTraces - 1);
    F = -ShockwaveArcLength * 0.5000000;
    J0x65:

    // End:0x26C [Loop If]
    if(F <= ((ShockwaveArcLength * 0.5000000) + (0.5000000 * Step)))
    {
        traceDir = (Sin(F * 0.0174533) * Y) - (Cos(F * 0.0174533) * Z);
        Hit = Instigator.Trace(HitLoc, HitNorm, Loc + (traceDir * ShockwaveRadius), Loc, true,,, 1);
        // End:0x14D
        if(Hit == none)
        {            
        }
        else
        {
            WorldInfo.MyEmitterPool.SpawnEmitter(ShockwaveContactTemplate, HitLoc, Rotator(HitNorm),, self);
            // End:0x1C6
            if(ShockwaveWake.Length == 0)
            {
                ShockwaveWake.Add(ShockwaveWakeLength);                
            }
            ShockwaveWake[ShockwaveWakeIndex].Location = Loc;
            ShockwaveWake[ShockwaveWakeIndex].Life = ShockwaveInterval * float(ShockwaveWake.Length);
            ShockwaveWakeIndex = ++ShockwaveWakeIndex % ShockwaveWake.Length;
        }
        F += Step;
        // [Loop Continue]
        goto J0x65;
    }
    //return;    
}

defaultproperties
{
    TimeToExplode=6.0000000
    CheckRadius=10.0000000
    CustomGravityScaling=-0.0100000
    Speed=1500.0000000
    DamageRadius=400.0000000
    MyDamageType=Class'AdvDmgType_TreeterSpikes'
    // Reference: CylinderComponent'Default__AdvProjectile_TreeterSpikes_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Physics=EPhysics.PHYS_Falling
    bNetTemporary=false
    CollisionComponent=CollisionCylinder
}