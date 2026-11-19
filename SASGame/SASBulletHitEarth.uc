//=============================================================================
// SASBulletHitEarth
// Emitter effects for Mud
//=============================================================================

class SASBulletHitEarth extends SASBulletHit;


	//Physics					= PHYS_Trailer









// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASBulletHitEarth.SpriteEmitter1'
    begin object name=SpriteEmitter1 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-50.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        MaxParticles=7
        EffectAxis=1
        RespawnDeadParticles=false
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.1000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=2.0000000,Max=4.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Earth.Dry_mud_Impact'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=2.0000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=-20.0000000,Max=20.0000000),Y=(Min=-20.0000000,Max=20.0000000),Z=(Min=50.0000000,Max=250.0000000))
        VelocityLossRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=3.0000000,Max=10.0000000))
    end object
    Emitters[0]=SpriteEmitter1
    // Reference: SpriteEmitter'SASBulletHitEarth.SpriteEmitter4'
    begin object name=SpriteEmitter4 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-800.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        MaxParticles=4
        RespawnDeadParticles=false
        StartLocationShape=1
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.5000000),Y=(Min=0.0000000,Max=0.5000000),Z=(Min=0.0000000,Max=0.5000000))
        StartSizeRange=(X=(Min=2.0000000,Max=3.0000000),Y=(Min=2.0000000,Max=3.0000000),Z=(Min=2.0000000,Max=3.0000000))
        UniformSize=true
        InitialParticlesPerSecond=5000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Earth.Dry_mud_Impact'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.2000000)
        StartVelocityRange=(X=(Min=-50.0000000,Max=50.0000000),Y=(Min=-50.0000000,Max=50.0000000),Z=(Min=0.0000000,Max=500.0000000))
    end object
    Emitters[1]=SpriteEmitter4
    // Reference: SpriteEmitter'SASBulletHitEarth.Dust'
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
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.5000000,Max=0.5000000)
        StartVelocityRange=(X=(Min=1.0000000,Max=5.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[2]=Dust
    // Reference: SpriteEmitter'SASBulletHitEarth.FabricBits'
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
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=2.0000000)
        StartVelocityRange=(X=(Min=150.0000000,Max=200.0000000),Y=(Min=-60.0000000,Max=60.0000000),Z=(Min=-60.0000000,Max=60.0000000))
        VelocityLossRange=(X=(Min=6.0000000,Max=8.0000000),Y=(Min=3.0000000,Max=3.0000000),Z=(Min=3.0000000,Max=3.0000000))
    end object
    Emitters[3]=FabricBits
    AutoDestroy=true
    DrawScale=0.0100000
    Mass=4.0000000
    RemoteRole=1
    bNoDelete=false
    bTrailerSameRotation=true
}