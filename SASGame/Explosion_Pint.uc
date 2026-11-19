//=============================================================================
// Exploding Pint 
//
// Particle effects for shooting pint glasses
//=============================================================================

class Explosion_Pint extends SASEmitter;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'Explosion_Pint.GLASSbitsPINT'
    begin object name=GLASSbitsPINT class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-1000.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        ColorScaleRepeats=5.0000000
        MaxParticles=50
        RespawnDeadParticles=false
        AutoResetTimeRange=(Min=5.0000000,Max=5.0000000)
        StartLocationRange=(X=(Min=-4.0000000,Max=4.0000000),Y=(Min=-4.0000000,Max=4.0000000),Z=(Min=0.0000000,Max=8.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.2000000,Max=1.0000000),Y=(Min=0.2000000,Max=1.5000000),Z=(Min=0.2000000,Max=1.0000000))
        StartSizeRange=(X=(Min=0.4000000,Max=1.5000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
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
    Emitters[0]=GLASSbitsPINT
    // Reference: SpriteEmitter'Explosion_Pint.SPARKLEdustPINT'
    begin object name=SPARKLEdustPINT class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        ColorScaleRepeats=5.0000000
        FadeOutStartTime=0.9000000
        FadeOut=true
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=-8.0000000,Max=8.0000000),Y=(Min=-8.0000000,Max=8.0000000),Z=(Min=1.0000000,Max=20.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0100000,Max=0.0300000),Y=(Min=0.0100000,Max=0.0300000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=5.0000000,Max=24.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'SFXTx.Dust.FxEx_DustMotes'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=4.0000000)
        InitialDelayRange=(Min=0.3000000,Max=0.3000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=-3.0000000,Max=-5.0000000))
    end object
    Emitters[1]=SPARKLEdustPINT
    // Reference: SpriteEmitter'Explosion_Pint.FLASHsmokePINT'
    begin object name=FLASHsmokePINT class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=0.5000000
        FadeOut=true
        MaxParticles=2
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=4.0000000)
        StartSizeRange=(X=(Min=8.0000000,Max=24.0000000),Y=(Min=10.0000000,Max=24.0000000),Z=(Min=100.0000000,Max=100.0000000))
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
    Emitters[2]=FLASHsmokePINT
    // Reference: SpriteEmitter'Explosion_Pint.HANGsmokePINT'
    begin object name=HANGsmokePINT class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOut=true
        MaxParticles=2
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=-8.0000000,Max=8.0000000),Y=(Min=-8.0000000,Max=8.0000000),Z=(Min=0.0000000,Max=16.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.0500000),Y=(Min=0.0000000,Max=0.0500000),Z=(Min=0.0000000,Max=0.1000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=8.0000000,Max=16.0000000),Y=(Min=8.0000000,Max=16.0000000),Z=(Min=16.0000000,Max=24.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=4
        Texture=Texture'SFXTx.Explosion.FxEx_smoke01'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.5000000,Max=1.5000000)
    end object
    Emitters[3]=HANGsmokePINT
    AutoDestroy=true
    bNoDelete=false
}