class PlatformMonitorDamageE extends SASEmitter;

//-----------------------------------------------------------------------------
// Default properties

// Contains parameters for exploding monitors to be used for damage states


// Decompiled with UE Explorer.
defaultproperties
{
    Emitters[0]=none
    // Reference: SpriteEmitter'PlatformMonitorDamageE.SpriteEmitter1'
    begin object name=SpriteEmitter1 class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.1000000
        FadeOut=true
        FadeIn=true
        MaxParticles=16
        RespawnDeadParticles=false
        StartLocationOffset=(X=10.0000000,Y=-10.0000000,Z=40.0000000)
        UseRotationFrom=1
        UseRegularSizeScale=false
        StartSizeRange=(X=(Min=20.0000000,Max=30.0000000),Y=(Min=20.0000000,Max=30.0000000),Z=(Min=20.0000000,Max=30.0000000))
        UniformSize=true
        InitialParticlesPerSecond=0.1000000
        Texture=Texture'SFXTx.Explosion.FxE_04_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SubdivisionStart=16
        SubdivisionEnd=1
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.2000000,Max=0.3000000)
    end object
    Emitters[1]=SpriteEmitter1
    // Reference: SpriteEmitter'PlatformMonitorDamageE.SpriteEmitter2'
    begin object name=SpriteEmitter2 class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.5000000
        FadeOut=true
        FadeInEndTime=0.1000000
        FadeIn=true
        MaxParticles=40
        RespawnDeadParticles=false
        StartLocationOffset=(X=10.0000000,Y=-10.0000000,Z=40.0000000)
        UseRotationFrom=1
        SpinParticles=true
        SpinCCWorCW=(X=0.2000000,Y=0.0000000,Z=0.0000000)
        SpinsPerSecondRange=(X=(Min=0.1000000,Max=0.2000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        StartSizeRange=(X=(Min=20.0000000,Max=30.0000000),Y=(Min=20.0000000,Max=30.0000000),Z=(Min=20.0000000,Max=30.0000000))
        UniformSize=true
        InitialParticlesPerSecond=10.0000000
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SubdivisionStart=1
        SubdivisionEnd=16
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.0000000)
        InitialDelayRange=(Min=0.1000000,Max=0.1000000)
        StartVelocityRange=(X=(Min=-10.0000000,Max=10.0000000),Y=(Min=-10.0000000,Max=10.0000000),Z=(Min=0.0000000,Max=100.0000000))
    end object
    Emitters[2]=SpriteEmitter2
    // Reference: SpriteEmitter'PlatformMonitorDamageE.SpriteEmitter3'
    begin object name=SpriteEmitter3 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-400.0000000)
        RespawnDeadParticles=false
        StartLocationOffset=(X=10.0000000,Y=-10.0000000,Z=40.0000000)
        StartLocationRange=(X=(Min=-5.0000000,Max=5.0000000),Y=(Min=-5.0000000,Max=5.0000000),Z=(Min=-10.0000000,Max=10.0000000))
        UseRotationFrom=1
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=2.1000000,Max=2.0000000),Y=(Min=2.1000000,Max=2.0000000),Z=(Min=2.0000000,Max=2.0000000))
        UseSizeScale=true
        StartSizeRange=(X=(Min=2.0000000,Max=4.0000000),Y=(Min=2.0000000,Max=4.0000000),Z=(Min=2.0000000,Max=4.0000000))
        UniformSize=true
        InitialParticlesPerSecond=100.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Damage.FxDM_largeglass01'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SubdivisionStart=16
        SubdivisionEnd=1
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-100.0000000,Max=-200.0000000),Z=(Min=-50.0000000,Max=50.0000000))
    end object
    Emitters[3]=SpriteEmitter3
    // Reference: SpriteEmitter'PlatformMonitorDamageE.SpriteEmitter4'
    begin object name=SpriteEmitter4 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-300.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        ColorScaleRepeats=1.0000000
        MaxParticles=30
        RespawnDeadParticles=false
        StartLocationOffset=(X=10.0000000,Y=-10.0000000,Z=40.0000000)
        StartLocationRange=(X=(Min=-5.0000000,Max=5.0000000),Y=(Min=-5.0000000,Max=5.0000000),Z=(Min=-5.0000000,Max=5.0000000))
        UseRotationFrom=1
        StartSizeRange=(X=(Min=0.5000000,Max=0.5000000),Y=(Min=1.7000000,Max=2.0000000),Z=(Min=0.5000000,Max=0.5000000))
        InitialParticlesPerSecond=100.0000000
        Texture=Texture'SFXTx.Damage.FxDM_sparks'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.1000000,Max=0.4000000)
        StartVelocityRange=(X=(Min=-50.0000000,Max=50.0000000),Y=(Min=-180.0000000,Max=-190.0000000),Z=(Min=1.0000000,Max=50.0000000))
    end object
    Emitters[4]=SpriteEmitter4
    AutoDestroy=true
    LightBrightness=230.0000000
    LightRadius=2.0000000
    LightType=1
    LightHue=116
    LightSaturation=240
    LightPeriod=10
    bNoDelete=false
    bDynamicLight=true
}