//=============================================================================
// molotov_fire
//
// Editable SASFire emitter used by SASFireArea.
//=============================================================================

class molotov_fire extends SASFire
	placeable;

#exec OBJ LOAD FILE=..\Textures\SFXTx.utx PACKAGE=SFXTx

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'molotov_fire.Fire01'
    begin object name=Fire01 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=10.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        MaxParticles=24
        StartSizeRange=(X=(Min=12.0000000,Max=25.0000000),Y=(Min=12.0000000,Max=25.0000000),Z=(Min=12.0000000,Max=25.0000000))
        UniformSize=true
        ParticlesPerSecond=12.0000000
        InitialParticlesPerSecond=24.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Fire.FxF_01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        LifetimeRange=(Min=1.0000000,Max=2.0000000)
        InitialDelayRange=(Min=0.0000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=10.0000000,Max=25.0000000))
        UseVelocityScale=true
        VelocityScale=/* Array type was not detected. */
        WarmupTicksPerSecond=1.0000000
        RelativeWarmupTime=1.0000000
    end object
    Emitters[0]=Fire01
    // Reference: SpriteEmitter'molotov_fire.Smoke01'
    begin object name=Smoke01 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=40.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.2000000,Max=0.2000000),Y=(Min=0.2000000,Max=0.2000000),Z=(Min=0.2000000,Max=0.2000000))
        FadeInFactor=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)
        FadeInEndTime=3.0000000
        FadeIn=true
        MaxParticles=24
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=20.0000000)
        SphereRadiusRange=(Min=-50.0000000,Max=50.0000000)
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.1000000),Z=(Min=0.0000000,Max=0.1000000))
        StartSizeRange=(X=(Min=20.0000000,Max=50.0000000),Y=(Min=20.0000000,Max=50.0000000),Z=(Min=20.0000000,Max=50.0000000))
        UniformSize=true
        ParticlesPerSecond=12.0000000
        InitialParticlesPerSecond=24.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Fire.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=2.0000000,Max=4.0000000)
        InitialDelayRange=(Min=0.5000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=-20.0000000,Max=20.0000000),Y=(Min=-20.0000000,Max=20.0000000),Z=(Min=0.0000000,Max=0.0000000))
        WarmupTicksPerSecond=1.0000000
        RelativeWarmupTime=-1.0000000
    end object
    Emitters[1]=Smoke01
    // Reference: SpriteEmitter'molotov_fire.Fire02'
    begin object name=Fire02 class=Class'Engine.SpriteEmitter'
        MaxParticles=24
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=10.0000000)
        StartSizeRange=(X=(Min=12.0000000,Max=25.0000000),Y=(Min=12.0000000,Max=25.0000000),Z=(Min=12.0000000,Max=25.0000000))
        UniformSize=true
        ParticlesPerSecond=12.0000000
        InitialParticlesPerSecond=24.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Fire.FxF_05_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        LifetimeRange=(Min=1.0000000,Max=2.0000000)
        InitialDelayRange=(Min=0.0000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=-5.0000000,Max=5.0000000),Y=(Min=-5.0000000,Max=5.0000000),Z=(Min=0.0000000,Max=20.0000000))
        WarmupTicksPerSecond=1.0000000
        RelativeWarmupTime=1.0000000
    end object
    Emitters[2]=Fire02
    DrawScale=0.5000000
}