class TurokWaterKActor extends KActor
    native
    nativereplication;

var() @NULL mpSmallParticleSystem;
var() @NULL mpBigParticleSystem;
var() float mBigParticleThreshold;
var() int mParticleDelay;
var() int mMaxParticlesPerHit;
var() float mMaxDistance;
var() float mMinHitVelocity;
var int CollisionCount;

event RigidBodyCollision(@NULL pHitComponent, @NULL pOtherComponent, const out array pContactInfos, int ContactIndex)
{
    local int I, Spawns;
    local float MoverVelocity;
    local @NULL emitterPool;

    CollisionCount++;
    // End:0x21
    if((mpSmallParticleSystem == none) || mpBigParticleSystem == none)
    {
        return;
    }
    // End:0x1E7
    if((float(CollisionCount) % float(mParticleDelay)) == float(0))
    {
        Spawns = ((pContactInfos.Length > mMaxParticlesPerHit) ? mMaxParticlesPerHit : pContactInfos.Length);
        I = 0;
        J0x63:

        // End:0x1E7 [Loop If]
        if(I < Spawns)
        {
            // End:0xBD
            if(VSizeSq(pContactInfos[I].ContactVelocity[0]) > float(0))
            {
                MoverVelocity = VSizeSq(pContactInfos[I].ContactVelocity[0]);                
            }
            else
            {
                MoverVelocity = VSizeSq(pContactInfos[I].ContactVelocity[1]);
            }
            // End:0x132
            if((Abs(pContactInfos[I].ContactPosition.Z - Location.Z) > mMaxDistance) || MoverVelocity < Square(mMinHitVelocity))
            {
                // [Explicit Continue]
                goto J0x1DD;
            }
            emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
            // End:0x1AF
            if(VSizeSq(pContactInfos[I].ContactVelocity[0]) < Square(mBigParticleThreshold))
            {
                emitterPool.GetEmitter(mpSmallParticleSystem, self, pContactInfos[I].ContactPosition);
                // [Explicit Continue]
                goto J0x1DD;
            }
            emitterPool.GetEmitter(mpBigParticleSystem, self, pContactInfos[I].ContactPosition);
            J0x1DD:

            I++;
            // [Loop Continue]
            goto J0x63;
        }
    }
    //return;    
}

defaultproperties
{
    mpSmallParticleSystem=ParticleSystem'FXFluids.ParticleSystems.SplashPS'
    mpBigParticleSystem=ParticleSystem'FXFluids.ParticleSystems.SplashPS'
    mBigParticleThreshold=750.0000000
    mParticleDelay=1
    mMaxParticlesPerHit=10
    mMaxDistance=16.0000000
    mMinHitVelocity=32.0000000
    bDamageAppliesImpulse=false
    // Reference: StaticMeshComponent'Default__TurokWaterKActor.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        StaticMesh=StaticMesh'WaterActorResources.WaterActor_Mesh'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokWaterKActor.MyLightEnvironment'
        HiddenGame=true
        bNotifyRigidBodyCollision=true
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokWaterKActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
}