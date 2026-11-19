//=============================================================================
// Exploding Vase 
//
// Particle effects for shooting large vases
//=============================================================================

class Explosion_Vase extends SASEmitter;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'Explosion_Vase.SPARKLEdustVASE'
    begin object name=SPARKLEdustVASE class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.9000000
        FadeOut=true
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=24.0000000)
        StartLocationRange=(X=(Min=-8.0000000,Max=8.0000000),Y=(Min=-8.0000000,Max=8.0000000),Z=(Min=1.0000000,Max=20.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0100000,Max=0.0300000),Y=(Min=0.0100000,Max=0.0300000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=16.0000000,Max=48.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'SFXTx.Dust.FxEx_DustMotes'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.5000000)
        InitialDelayRange=(Min=0.3000000,Max=0.3000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=-3.0000000,Max=-5.0000000))
    end object
    Emitters[0]=SPARKLEdustVASE
    // Reference: SpriteEmitter'Explosion_Vase.FLASHsmokeVASE'
    begin object name=FLASHsmokeVASE class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=0.5000000
        FadeOut=true
        MaxParticles=2
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=24.0000000)
        StartSizeRange=(X=(Min=20.0000000,Max=48.0000000),Y=(Min=20.0000000,Max=48.0000000),Z=(Min=100.0000000,Max=100.0000000))
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
    Emitters[1]=FLASHsmokeVASE
    // Reference: SpriteEmitter'Explosion_Vase.HANGsmokeVASE'
    begin object name=HANGsmokeVASE class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=0.5000000
        FadeOut=true
        MaxParticles=8
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=24.0000000)
        StartLocationRange=(X=(Min=-16.0000000,Max=16.0000000),Y=(Min=-16.0000000,Max=16.0000000),Z=(Min=-8.0000000,Max=32.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.0500000),Y=(Min=0.0000000,Max=0.0500000),Z=(Min=0.0000000,Max=0.1000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=12.0000000,Max=24.0000000),Y=(Min=12.0000000,Max=24.0000000),Z=(Min=32.0000000,Max=48.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=4
        Texture=Texture'SFXTx.Explosion.FxEx_smoke01'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.5000000,Max=1.5000000)
    end object
    Emitters[2]=HANGsmokeVASE
    // Reference: MeshEmitter'Explosion_Vase.SHARDS_01'
    begin object name=SHARDS_01 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_Vaseshard01'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-2000.0000000)
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=20.0000000)
        StartLocationRange=(X=(Min=-16.0000000,Max=16.0000000),Y=(Min=-16.0000000,Max=16.0000000),Z=(Min=-12.0000000,Max=32.0000000))
        StartLocationShape=3
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=2.0000000),Y=(Min=0.0000000,Max=2.0000000),Z=(Min=0.0000000,Max=2.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        StartSizeRange=(X=(Min=0.2500000,Max=1.0000000),Y=(Min=0.2500000,Max=1.0000000),Z=(Min=0.2500000,Max=1.0000000))
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.5000000,Max=1.5000000)
        StartVelocityRadialRange=(Min=-500.0000000,Max=-500.0000000)
        VelocityLossRange=(X=(Min=1.0000000,Max=5.0000000),Y=(Min=1.0000000,Max=5.0000000),Z=(Min=6.0000000,Max=15.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[3]=SHARDS_01
    // Reference: MeshEmitter'Explosion_Vase.SHARDS_02'
    begin object name=SHARDS_02 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_Vaseshard02'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-2000.0000000)
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=20.0000000)
        StartLocationRange=(X=(Min=-16.0000000,Max=16.0000000),Y=(Min=-16.0000000,Max=16.0000000),Z=(Min=-12.0000000,Max=32.0000000))
        StartLocationShape=3
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=2.0000000),Y=(Min=0.0000000,Max=2.0000000),Z=(Min=0.0000000,Max=2.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        StartSizeRange=(X=(Min=0.2500000,Max=1.0000000),Y=(Min=0.2500000,Max=1.0000000),Z=(Min=0.2500000,Max=1.0000000))
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.5000000,Max=1.5000000)
        StartVelocityRadialRange=(Min=-500.0000000,Max=-500.0000000)
        VelocityLossRange=(X=(Min=1.0000000,Max=5.0000000),Y=(Min=1.0000000,Max=5.0000000),Z=(Min=6.0000000,Max=15.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[4]=SHARDS_02
    // Reference: MeshEmitter'Explosion_Vase.SHARDS_03'
    begin object name=SHARDS_03 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_Vaseshard03'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-2000.0000000)
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=20.0000000)
        StartLocationRange=(X=(Min=-16.0000000,Max=16.0000000),Y=(Min=-16.0000000,Max=16.0000000),Z=(Min=-12.0000000,Max=32.0000000))
        StartLocationShape=3
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=2.0000000),Y=(Min=0.0000000,Max=2.0000000),Z=(Min=0.0000000,Max=2.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        StartSizeRange=(X=(Min=0.2500000,Max=1.0000000),Y=(Min=0.2500000,Max=1.0000000),Z=(Min=0.2500000,Max=1.0000000))
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.5000000,Max=1.5000000)
        StartVelocityRadialRange=(Min=-500.0000000,Max=-500.0000000)
        VelocityLossRange=(X=(Min=1.0000000,Max=5.0000000),Y=(Min=1.0000000,Max=5.0000000),Z=(Min=6.0000000,Max=15.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[5]=SHARDS_03
    AutoDestroy=true
    bNoDelete=false
}