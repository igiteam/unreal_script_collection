class AdvProjectile_BossMummySpell_Base extends EvilProjectile_Base
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

simulated event Tick(float DeltaTime)
{
    local int I;

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
    //return;    
}

function FireTakeDamageEventFracturedStaticMeshActor(FracturedStaticMeshActor FracActor, Actor InInstigator, class<DamageType> DamageType, int DamageAmount)
{
    local int Idx;
    local SeqEvent_TakeDamage dmgEvent;

    Idx = 0;
    J0x0B:

    // End:0xCB [Loop If]
    if(Idx < FracActor.GeneratedEvents.Length)
    {
        dmgEvent = SeqEvent_TakeDamage(FracActor.GeneratedEvents[Idx]);
        // End:0xBD
        if(dmgEvent != none)
        {
            dmgEvent.HandleDamage(self, InInstigator, DamageType, DamageAmount);
        }
        Idx++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

protected simulated function DoBreakFracturedMeshes(Vector ExploOrigin)
{
    local FracturedStaticMeshActor FracActor;
    local byte bWantPhysChunksAndParticles;

    // End:0x135
    foreach CollidingActors(Class'Engine.FracturedStaticMeshActor', FracActor, ShockwaveFractureRadius, ExploOrigin, true)
    {
        // End:0x134
        if((int(FracActor.Physics) == int(0)) && FracActor.IsFracturedByDamageType(MyDamageType))
        {
            // End:0x134
            if(FracActor.FractureEffectIsRelevant(false, Instigator, bWantPhysChunksAndParticles))
            {
                FracActor.BreakOffPartsInRadius(ExploOrigin, ShockwaveFractureRadius, MomentumTransfer, ((int(bWantPhysChunksAndParticles) == int(1)) ? true : false));
                FireTakeDamageEventFracturedStaticMeshActor(FracActor, Instigator, MyDamageType, 1000);
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
    MyDamageType=Class'AdvDmgType_BossMummySpell'
    // Reference: CylinderComponent'Default__AdvProjectile_BossMummySpell_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Physics=EPhysics.PHYS_Falling
    bNetTemporary=false
    CollisionComponent=CollisionCylinder
}