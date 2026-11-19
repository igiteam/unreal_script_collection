//=============================================================================
// Explosion_Collapsed_Hall
//
// Explosion effects Explosion Collapsed Hallway in parliment.
//=============================================================================

class Explosion_Collapsed_Hall extends SASGenericExplosion;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mExplosionSounds=/* Array type was not detected. */
    mExplosionSoundRadius=500.0000000
    mbExplosionDecal=true
    // Reference: SpriteEmitter'Explosion_Collapsed_Hall.SpriteEmitter0'
    begin object name=SpriteEmitter0 class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=10.0000000
        FadeOut=true
        MaxParticles=200
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=50.0000000),Y=(Min=-30.0000000,Max=30.0000000),Z=(Min=-100.0000000,Max=0.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UniformSize=true
        InitialParticlesPerSecond=30000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=4
        Texture=Texture'SFXTx.Smoke.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=10.0000000,Max=24.0000000)
        SpawnOnTriggerPPS=5000.0000000
        StartVelocityRange=(X=(Min=200.0000000,Max=6000.0000000),Y=(Min=-100.0000000,Max=100.0000000),Z=(Min=-250.0000000,Max=100.0000000))
        VelocityLossRange=(X=(Min=4.0000000,Max=10.0000000),Y=(Min=0.5000000,Max=1.0000000),Z=(Min=0.8000000,Max=1.5000000))
    end object
    Emitters[0]=SpriteEmitter0
    // Reference: MeshEmitter'Explosion_Collapsed_Hall.MeshEmitter0'
    begin object name=MeshEmitter0 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'TbeSm.Rubble.obt220V10_Rubble10'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-600.0000000)
        UseCollision=true
        MaxParticles=40
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-50.0000000,Max=50.0000000),Z=(Min=-25.0000000,Max=25.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-2.0000000,Max=4.0000000),Y=(Min=-2.0000000,Max=4.0000000),Z=(Min=-2.0000000,Max=4.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        StartSizeRange=(X=(Min=0.0100000,Max=0.2000000),Y=(Min=0.1000000,Max=0.2000000),Z=(Min=0.1000000,Max=0.2000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        StartVelocityRange=(X=(Min=800.0000000,Max=2000.0000000),Y=(Min=-200.0000000,Max=200.0000000),Z=(Min=-500.0000000,Max=100.0000000))
        VelocityLossRange=(X=(Min=1.0000000,Max=5.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[1]=MeshEmitter0
    // Reference: SpriteEmitter'Explosion_Collapsed_Hall.SpriteEmitter1'
    begin object name=SpriteEmitter1 class=Class'Engine.SpriteEmitter'
        MaxParticles=2
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=20.0000000)
        StartSizeRange=(X=(Min=90.0000000,Max=90.0000000),Y=(Min=90.0000000,Max=90.0000000),Z=(Min=90.0000000,Max=90.0000000))
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
    Emitters[2]=SpriteEmitter1
}