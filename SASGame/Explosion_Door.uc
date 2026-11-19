//=============================================================================
// Explosion_Door
//
// Explosion effects blown up door.
//=============================================================================

class Explosion_Door extends SASGenericExplosion;


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
    // Reference: SpriteEmitter'Explosion_Door.Smoke1'
    begin object name=Smoke1 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=5.0000000)
        UseCollision=true
        ExtentMultiplier=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DampingFactorRange=(X=(Min=0.1000000,Max=0.1000000),Y=(Min=0.1000000,Max=0.1000000),Z=(Min=0.1000000,Max=0.1000000))
        FadeOut=true
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=-64.0000000,Max=-64.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.1000000),Z=(Min=0.0000000,Max=0.1000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=10.0000000,Max=30.0000000),Y=(Min=30.0000000,Max=70.0000000),Z=(Min=30.0000000,Max=70.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=12.0000000,Max=18.0000000)
        StartVelocityRange=(X=(Min=-200.0000000,Max=200.0000000),Y=(Min=-1000.0000000,Max=200.0000000),Z=(Min=-100.0000000,Max=100.0000000))
        VelocityLossRange=(X=(Min=8.0000000,Max=14.0000000),Y=(Min=8.0000000,Max=14.0000000),Z=(Min=2.0000000,Max=2.0000000))
        UseVelocityScale=true
        VelocityScale=/* Array type was not detected. */
    end object
    Emitters[0]=Smoke1
    // Reference: SpriteEmitter'Explosion_Door.Smoke2'
    begin object name=Smoke2 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=30.0000000)
        MaxParticles=30
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=-48.0000000,Max=48.0000000))
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=2.0000000,Max=5.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=4.0000000,Max=6.0000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1000.0000000,Max=200.0000000),Z=(Min=-100.0000000,Max=100.0000000))
        VelocityLossRange=(X=(Min=12.0000000,Max=16.0000000),Y=(Min=6.0000000,Max=12.0000000),Z=(Min=2.0000000,Max=2.0000000))
    end object
    Emitters[1]=Smoke2
    // Reference: MeshEmitter'Explosion_Door.RubbleBits'
    begin object name=RubbleBits class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Rubble.rubble02'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-600.0000000)
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=-32.0000000,Max=32.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=4.0000000),Y=(Min=0.0000000,Max=4.0000000),Z=(Min=0.0000000,Max=4.0000000))
        StartSizeRange=(X=(Min=1.0000000,Max=3.0000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.0000000))
        UniformSize=true
        InitialParticlesPerSecond=800.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.6000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=-300.0000000,Max=300.0000000),Y=(Min=-800.0000000,Max=200.0000000),Z=(Min=0.0000000,Max=300.0000000))
        VelocityLossRange=(X=(Min=3.0000000,Max=5.0000000),Y=(Min=3.0000000,Max=5.0000000),Z=(Min=3.0000000,Max=5.0000000))
    end object
    Emitters[2]=RubbleBits
    // Reference: SpriteEmitter'Explosion_Door.Flash'
    begin object name=Flash class=Class'Engine.SpriteEmitter'
        MaxParticles=2
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=20.0000000)
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-32.0000000,Max=-32.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=75.0000000,Max=75.0000000),Y=(Min=75.0000000,Max=75.0000000),Z=(Min=75.0000000,Max=75.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Explosion.FxE_01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=1.0000000)
    end object
    Emitters[3]=Flash
    // Reference: MeshEmitter'Explosion_Door.BigPlank'
    begin object name=BigPlank class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_DoorBit01'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-300.0000000)
        UseCollisionPlanes=true
        MaxParticles=5
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-32.0000000,Max=32.0000000),Z=(Min=-64.0000000,Max=64.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-0.5000000,Max=0.5000000),Y=(Min=0.0000000,Max=3.0000000),Z=(Min=-1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=25.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.8000000,Max=0.8000000)
        StartVelocityRange=(X=(Min=-64.0000000,Max=64.0000000),Y=(Min=-1000.0000000,Max=-1000.0000000),Z=(Min=0.0000000,Max=0.0000000))
        VelocityLossRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=3.0000000,Max=6.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[4]=BigPlank
    // Reference: MeshEmitter'Explosion_Door.Plankbit01'
    begin object name=Plankbit01 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_DoorBit02'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-500.0000000)
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-32.0000000,Max=32.0000000),Z=(Min=-72.0000000,Max=72.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-0.5000000,Max=0.5000000),Y=(Min=0.0000000,Max=3.0000000),Z=(Min=-1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=150.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.8000000,Max=0.8000000)
        StartVelocityRange=(X=(Min=-200.0000000,Max=200.0000000),Y=(Min=-100.0000000,Max=-500.0000000),Z=(Min=0.0000000,Max=0.0000000))
        VelocityLossRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=3.0000000,Max=6.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[5]=Plankbit01
    // Reference: MeshEmitter'Explosion_Door.Plankbit02'
    begin object name=Plankbit02 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_DoorBit03'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-500.0000000)
        MaxParticles=5
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-32.0000000,Max=32.0000000),Z=(Min=-64.0000000,Max=64.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-0.5000000,Max=0.5000000),Y=(Min=0.0000000,Max=3.0000000),Z=(Min=-1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=25.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=-64.0000000,Max=64.0000000),Y=(Min=-1000.0000000,Max=-1000.0000000),Z=(Min=0.0000000,Max=0.0000000))
        VelocityLossRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=3.0000000,Max=6.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[6]=Plankbit02
}