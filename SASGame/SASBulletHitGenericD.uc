//=============================================================================
// SASBulletHitGenericD
// Emitter effects for bullet hitting akwardly compound T-page metal and wood
//=============================================================================

class SASBulletHitGenericD extends SASBulletHit;


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASBulletHitGenericD.FabricBits'
    begin object name=FabricBits class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        ProjectionNormal=(X=1.0000000,Y=1.0000000,Z=0.0000000)
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-10.0000000)
        FadeOutStartTime=0.7500000
        FadeOut=true
        CoordinateSystem=1
        MaxParticles=1
        RespawnDeadParticles=false
        UseRotationFrom=3
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=2.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=2.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=3.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=0.1000000,Max=1.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=50.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Wound.FxW_fabric02'
        LifetimeRange=(Min=1.0000000,Max=2.0000000)
        StartVelocityRange=(X=(Min=150.0000000,Max=200.0000000),Y=(Min=-60.0000000,Max=60.0000000),Z=(Min=-60.0000000,Max=60.0000000))
        VelocityLossRange=(X=(Min=6.0000000,Max=8.0000000),Y=(Min=3.0000000,Max=3.0000000),Z=(Min=3.0000000,Max=3.0000000))
    end object
    Emitters[0]=FabricBits
    // Reference: SpriteEmitter'SASBulletHitGenericD.Dust'
    begin object name=Dust class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOut=true
        CoordinateSystem=1
        MaxParticles=1
        RespawnDeadParticles=false
        SpinParticles=true
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=4.0000000,Max=4.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=10.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_MuzzleSmoke_MP5_1st'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=0.5000000,Max=0.5000000)
        StartVelocityRange=(X=(Min=1.0000000,Max=5.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[1]=Dust
    // Reference: SpriteEmitter'SASBulletHitGenericD.Spark'
    begin object name=Spark class=Class'Engine.SpriteEmitter'
        UseDirectionAs=1
        Acceleration=(X=0.0000000,Y=16.0000000,Z=16.0000000)
        FadeOutStartTime=0.0100000
        FadeOut=true
        CoordinateSystem=1
        MaxParticles=2
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=0.0000000,Max=30.0000000),Y=(Min=0.0000000,Max=100.0000000),Z=(Min=0.0000000,Max=100.0000000))
        Texture=Texture'SFXTx.Muzzle_Flashes.sparktest'
        InitialTimeRange=(Min=-0.0700000,Max=-0.0700000)
        LifetimeRange=(Min=0.0200000,Max=0.0100000)
        TriggerDisabled=false
        StartVelocityRange=(X=(Min=0.0000000,Max=100.0000000),Y=(Min=-100.0000000,Max=100.0000000),Z=(Min=-100.0000000,Max=110.0000000))
        ParticlesPerShot=4
    end object
    Emitters[2]=Spark
    // Reference: SpriteEmitter'SASBulletHitGenericD.WoodBits'
    begin object name=WoodBits class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        ProjectionNormal=(X=1.0000000,Y=1.0000000,Z=0.0000000)
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-200.0000000)
        FadeOutStartTime=0.7500000
        FadeOut=true
        RespawnDeadParticles=false
        UseRotationFrom=3
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        StartSizeRange=(X=(Min=0.1000000,Max=2.5000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=420.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Imapcts.FxI_wood'
        LifetimeRange=(Min=0.8000000,Max=1.8000000)
        StartVelocityRange=(X=(Min=-200.0000000,Max=200.0000000),Y=(Min=-200.0000000,Max=200.0000000),Z=(Min=-60.0000000,Max=180.0000000))
        VelocityLossRange=(X=(Min=5.0000000,Max=5.0000000),Y=(Min=5.0000000,Max=5.0000000),Z=(Min=0.8000000,Max=4.0000000))
    end object
    Emitters[3]=WoodBits
    // Reference: SpriteEmitter'SASBulletHitGenericD.WoodSpark'
    begin object name=WoodSpark class=Class'Engine.SpriteEmitter'
        UseDirectionAs=1
        Acceleration=(X=0.0000000,Y=16.0000000,Z=16.0000000)
        FadeOutStartTime=0.0100000
        FadeOut=true
        CoordinateSystem=1
        MaxParticles=3
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=0.0000000,Max=10.0000000),Y=(Min=0.0000000,Max=100.0000000),Z=(Min=0.0000000,Max=100.0000000))
        DrawStyle=1
        Texture=Texture'SFXTx.Imapcts.FxI_wood'
        InitialTimeRange=(Min=-0.0700000,Max=-0.0700000)
        LifetimeRange=(Min=0.0200000,Max=0.0100000)
        TriggerDisabled=false
        StartVelocityRange=(X=(Min=0.0000000,Max=100.0000000),Y=(Min=-100.0000000,Max=100.0000000),Z=(Min=-100.0000000,Max=110.0000000))
    end object
    Emitters[4]=WoodSpark
    Mass=4.0000000
    RemoteRole=1
    bNoDelete=false
    bTrailerSameRotation=true
}