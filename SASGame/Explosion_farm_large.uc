//=============================================================================
// Explosion_farm_large
//
// Explosion effects for barn in the farm.
//=============================================================================

class Explosion_farm_large extends SASGenericExplosion;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mDamageDataList=/* Array type was not detected. */
    mExplosionSounds=/* Array type was not detected. */
    mExplosionSoundRadius=700.0000000
    mbExplosionDecal=true
    // Reference: MeshEmitter'Explosion_farm_large.MeshEmitter0'
    begin object name=MeshEmitter0 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'TbeSm.Rubble.obt220V10_Rubble10'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-800.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.0000000,Max=0.5000000),Y=(Min=0.0000000,Max=0.5000000),Z=(Min=0.0000000,Max=0.5000000))
        MaxParticles=50
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=50.0000000),Y=(Min=0.0000000,Max=50.0000000),Z=(Min=0.0000000,Max=70.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        DampRotation=true
        RotationDampingFactorRange=(X=(Min=0.1000000,Max=0.1000000),Y=(Min=0.1000000,Max=0.1000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=0.0100000,Max=0.8000000),Y=(Min=0.1000000,Max=0.8000000),Z=(Min=0.1000000,Max=0.2000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=0
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=4.0000000,Max=50.0000000)
        StartVelocityRange=(X=(Min=-500.0000000,Max=500.0000000),Y=(Min=100.0000000,Max=-2000.0000000),Z=(Min=-100.0000000,Max=750.0000000))
        VelocityLossRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[0]=MeshEmitter0
    // Reference: SpriteEmitter'Explosion_farm_large.SpriteEmitter0'
    begin object name=SpriteEmitter0 class=Class'Engine.SpriteEmitter'
        DampingFactorRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.0000000))
        FadeOutStartTime=10.0000000
        FadeOut=true
        MaxParticles=250
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=50.0000000),Y=(Min=0.0000000,Max=50.0000000),Z=(Min=-100.0000000,Max=0.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=9.0000000,Max=15.0000000)
        SpawnOnTriggerPPS=500.0000000
        StartVelocityRange=(X=(Min=-350.0000000,Max=350.0000000),Y=(Min=0.0000000,Max=-1000.0000000),Z=(Min=-250.0000000,Max=300.0000000))
        VelocityLossRange=(X=(Min=1.0000000,Max=2.0000000),Y=(Min=0.5000000,Max=1.0000000),Z=(Min=0.8000000,Max=1.5000000))
    end object
    Emitters[1]=SpriteEmitter0
    // Reference: SpriteEmitter'Explosion_farm_large.SpriteEmitter14'
    begin object name=SpriteEmitter14 class=Class'Engine.SpriteEmitter'
        MaxParticles=1
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        StartSizeRange=(X=(Min=250.0000000,Max=250.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=20.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'SFXTx.Explosion.FxE_03_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.6000000,Max=0.6000000)
    end object
    Emitters[2]=SpriteEmitter14
    // Reference: SpriteEmitter'Explosion_farm_large.SpriteEmitter15'
    begin object name=SpriteEmitter15 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-100.0000000)
        FadeOutFactor=(W=2.0000000,X=1.0000000,Y=1.0000000,Z=1.0000000)
        FadeOutStartTime=0.1000000
        FadeOut=true
        MaxParticles=20
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=30.0000000,Max=60.0000000),Y=(Min=30.0000000,Max=60.0000000),Z=(Min=30.0000000,Max=60.0000000))
        UniformSize=true
        InitialParticlesPerSecond=5000.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'SFXTx.Explosion.FxE_03_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=-100.0000000,Max=100.0000000),Y=(Min=0.0000000,Max=-200.0000000),Z=(Min=0.0000000,Max=250.0000000))
    end object
    Emitters[3]=SpriteEmitter15
    // Reference: SpriteEmitter'Explosion_farm_large.SpriteEmitter16'
    begin object name=SpriteEmitter16 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-30.0000000)
        MaxParticles=75
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=-150.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseRevolution=true
        RevolutionsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.1000000),Z=(Min=0.0000000,Max=0.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.2000000),Y=(Min=0.0000000,Max=0.2000000),Z=(Min=0.0000000,Max=0.2000000))
        StartSizeRange=(X=(Min=5.0000000,Max=12.0000000),Y=(Min=5.0000000,Max=10.0000000),Z=(Min=5.0000000,Max=10.0000000))
        UniformSize=true
        InitialParticlesPerSecond=250.0000000
        AutomaticInitialSpawning=false
        DrawStyle=0
        Texture=Texture'SFXTx.Dust.FxD_Dust02_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=3.0000000,Max=6.0000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=100.0000000,Max=-250.0000000),Z=(Min=10.0000000,Max=800.0000000))
        VelocityLossRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=3.0000000))
    end object
    Emitters[4]=SpriteEmitter16
}