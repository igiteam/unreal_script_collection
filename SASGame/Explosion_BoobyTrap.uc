//=============================================================================
// Explosion_BoobyTrap
//
// Explosion effects for booby trap device.
//=============================================================================

class Explosion_BoobyTrap extends SASGenericExplosion;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mDamageDataList=/* Array type was not detected. */
    mExplosionSounds=/* Array type was not detected. */
    mExplosionSoundRadius=500.0000000
    mbExplosionDecal=true
    // Reference: SpriteEmitter'Explosion_BoobyTrap.SmokeBT01'
    begin object name=SmokeBT01 class=Class'Engine.SpriteEmitter'
        UseCollision=true
        ExtentMultiplier=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DampingFactorRange=(X=(Min=0.1000000,Max=0.1000000),Y=(Min=0.1000000,Max=0.1000000),Z=(Min=0.1000000,Max=0.1000000))
        MaxParticles=50
        RespawnDeadParticles=false
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.1000000),Z=(Min=0.0000000,Max=0.1000000))
        StartSizeRange=(X=(Min=30.0000000,Max=70.0000000),Y=(Min=30.0000000,Max=70.0000000),Z=(Min=30.0000000,Max=70.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=20.0000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1000.0000000,Max=1000.0000000),Z=(Min=20.0000000,Max=60.0000000))
        VelocityLossRange=(X=(Min=3.0000000,Max=8.0000000),Y=(Min=3.0000000,Max=8.0000000),Z=(Min=3.0000000,Max=8.0000000))
        UseVelocityScale=true
        VelocityScale=/* Array type was not detected. */
    end object
    Emitters[0]=SmokeBT01
    // Reference: SpriteEmitter'Explosion_BoobyTrap.SmokeBT02'
    begin object name=SmokeBT02 class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.2000000
        FadeOut=true
        FadeIn=true
        MaxParticles=1
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=40.0000000,Max=40.0000000))
        SpinCCWorCW=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=-0.1000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=50.0000000,Max=50.0000000),Y=(Min=50.0000000,Max=50.0000000),Z=(Min=50.0000000,Max=50.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke02_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=6.0000000)
        UseVelocityScale=true
        VelocityScale=/* Array type was not detected. */
    end object
    Emitters[1]=SmokeBT02
    // Reference: SpriteEmitter'Explosion_BoobyTrap.SmokeBT03'
    begin object name=SmokeBT03 class=Class'Engine.SpriteEmitter'
        MaxParticles=2
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=90.0000000)
        StartSizeRange=(X=(Min=80.0000000,Max=80.0000000),Y=(Min=80.0000000,Max=80.0000000),Z=(Min=80.0000000,Max=80.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke04_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=6.0000000)
    end object
    Emitters[2]=SmokeBT03
    // Reference: MeshEmitter'Explosion_BoobyTrap.Rubble'
    begin object name=Rubble class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Rubble.rubble02'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-500.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.3000000,Max=0.5000000),Y=(Min=0.3000000,Max=0.5000000),Z=(Min=0.3000000,Max=0.5000000))
        MaxParticles=15
        RespawnDeadParticles=false
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-1.0000000,Max=1.0000000),Y=(Min=-1.0000000,Max=1.0000000),Z=(Min=-1.0000000,Max=1.0000000))
        DampRotation=true
        RotationDampingFactorRange=(X=(Min=0.1000000,Max=0.1000000),Y=(Min=0.1000000,Max=0.1000000),Z=(Min=0.1000000,Max=0.1000000))
        StartSizeRange=(X=(Min=1.0000000,Max=3.0000000),Y=(Min=1.0000000,Max=3.0000000),Z=(Min=1.0000000,Max=3.0000000))
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        StartVelocityRange=(X=(Min=-500.0000000,Max=500.0000000),Y=(Min=-500.0000000,Max=500.0000000),Z=(Min=-200.0000000,Max=500.0000000))
    end object
    Emitters[3]=Rubble
    // Reference: SpriteEmitter'Explosion_BoobyTrap.Flash'
    begin object name=Flash class=Class'Engine.SpriteEmitter'
        MaxParticles=2
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=20.0000000)
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
    Emitters[4]=Flash
}