//=============================================================================
// Breach_DoorVC (V3)
//
// Particle effects for breaching proceadure on a door V3 (white).
//=============================================================================

class Breach_DoorVC extends SASGenericExplosion;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mExplosionSounds=/* Array type was not detected. */
    mExplosionSoundRadius=450.0000000
    mbExplosionDecal=true
    // Reference: MeshEmitter'Breach_DoorVC.BigPlank'
    begin object name=BigPlank class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_DoorBit01V3'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-900.0000000)
        UseCollisionPlanes=true
        MaxParticles=5
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-32.0000000,Max=32.0000000),Z=(Min=0.0000000,Max=128.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-0.5000000,Max=0.5000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=-1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=25.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.6000000,Max=0.6000000)
        StartVelocityRange=(X=(Min=-500.0000000,Max=500.0000000),Y=(Min=-500.0000000,Max=500.0000000),Z=(Min=0.0000000,Max=200.0000000))
        VelocityLossRange=(X=(Min=5.0000000,Max=5.0000000),Y=(Min=5.0000000,Max=5.0000000),Z=(Min=0.0000000,Max=3.0000000))
    end object
    Emitters[0]=BigPlank
    // Reference: MeshEmitter'Breach_DoorVC.Plankbit01'
    begin object name=Plankbit01 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_DoorBit02V3'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-900.0000000)
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-32.0000000,Max=32.0000000),Z=(Min=0.0000000,Max=128.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-0.5000000,Max=0.5000000),Y=(Min=0.0000000,Max=3.0000000),Z=(Min=-1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=150.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.8000000,Max=0.8000000)
        StartVelocityRange=(X=(Min=-500.0000000,Max=500.0000000),Y=(Min=-500.0000000,Max=500.0000000),Z=(Min=0.0000000,Max=200.0000000))
        VelocityLossRange=(X=(Min=6.0000000,Max=9.0000000),Y=(Min=6.0000000,Max=9.0000000),Z=(Min=3.0000000,Max=3.0000000))
    end object
    Emitters[1]=Plankbit01
    // Reference: MeshEmitter'Breach_DoorVC.Plankbit02'
    begin object name=Plankbit02 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_DoorBit03V3'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-900.0000000)
        MaxParticles=5
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-32.0000000,Max=32.0000000),Z=(Min=0.0000000,Max=128.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-0.5000000,Max=0.5000000),Y=(Min=0.0000000,Max=3.0000000),Z=(Min=-1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=25.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.7000000,Max=0.7000000)
        StartVelocityRange=(X=(Min=-500.0000000,Max=500.0000000),Y=(Min=-500.0000000,Max=500.0000000),Z=(Min=0.0000000,Max=300.0000000))
        VelocityLossRange=(X=(Min=6.0000000,Max=9.0000000),Y=(Min=6.0000000,Max=9.0000000),Z=(Min=3.0000000,Max=3.0000000))
    end object
    Emitters[2]=Plankbit02
}