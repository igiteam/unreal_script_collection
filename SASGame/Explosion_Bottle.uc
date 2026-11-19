//=============================================================================
// Exploding bottle
//
// Particle effects for shooting bottles
//=============================================================================

class Explosion_Bottle extends SASEmitter;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'Explosion_Bottle.SPARKLEdust'
    begin object name=SPARKLEdust class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        ColorScaleRepeats=5.0000000
        FadeOutStartTime=0.9000000
        FadeOut=true
        MaxParticles=16
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=-8.0000000,Max=8.0000000),Y=(Min=-8.0000000,Max=8.0000000),Z=(Min=4.0000000,Max=30.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0100000,Max=0.0300000),Y=(Min=0.0100000,Max=0.0300000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=5.0000000,Max=32.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'SFXTx.Dust.FxEx_DustMotes'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=4.0000000)
        InitialDelayRange=(Min=0.3000000,Max=0.3000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=-3.0000000,Max=-5.0000000))
    end object
    Emitters[0]=SPARKLEdust
    // Reference: SpriteEmitter'Explosion_Bottle.EXPLOSIONsmoke1'
    begin object name=EXPLOSIONsmoke1 class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.5000000
        FadeOut=true
        MaxParticles=2
        RespawnDeadParticles=false
        StartSizeRange=(X=(Min=10.0000000,Max=32.0000000),Y=(Min=16.0000000,Max=32.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=4
        Texture=Texture'SFXTx.Smoke.FxF_Smoke03_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SubdivisionStart=3
        SubdivisionEnd=16
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.2500000,Max=0.5000000)
    end object
    Emitters[1]=EXPLOSIONsmoke1
    // Reference: SpriteEmitter'Explosion_Bottle.HANGsmoke'
    begin object name=HANGsmoke class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOut=true
        MaxParticles=5
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=-8.0000000,Max=8.0000000),Y=(Min=-8.0000000,Max=8.0000000),Z=(Min=0.0000000,Max=24.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.0500000),Y=(Min=0.0000000,Max=0.0500000),Z=(Min=0.0000000,Max=0.1000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=8.0000000,Max=16.0000000),Y=(Min=8.0000000,Max=16.0000000),Z=(Min=24.0000000,Max=32.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=4
        Texture=Texture'SFXTx.Explosion.FxEx_smoke01'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.5000000,Max=2.0000000)
    end object
    Emitters[2]=HANGsmoke
    // Reference: SpriteEmitter'Explosion_Bottle.glassbits'
    begin object name=glassbits class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-1000.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        ColorScaleRepeats=3.0000000
        MaxParticles=50
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=-4.0000000,Max=4.0000000),Y=(Min=-4.0000000,Max=4.0000000),Z=(Min=0.0000000,Max=14.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.2000000,Max=1.0000000),Y=(Min=0.2000000,Max=1.5000000),Z=(Min=0.2000000,Max=1.0000000))
        StartSizeRange=(X=(Min=0.4000000,Max=1.5000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=4
        Texture=Texture'SFXTx.Damage.FxDM_largeglass01'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.2500000,Max=1.0000000)
        StartVelocityRadialRange=(Min=-300.0000000,Max=-400.0000000)
        VelocityLossRange=(X=(Min=1.0000000,Max=10.0000000),Y=(Min=1.0000000,Max=10.0000000),Z=(Min=1.0000000,Max=10.0000000))
        AddVelocityMultiplierRange=(X=(Min=1.0000000,Max=20.0000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.0000000))
        GetVelocityDirectionFrom=3
        RelativeWarmupTime=1.0000000
    end object
    Emitters[3]=glassbits
    AutoDestroy=true
    bNoDelete=false
}