//=============================================================================
// SASBulletHitWaterJet
// Emitter effects for bullet a pipe or other water-jet projucing object
//=============================================================================

class SASBulletHitWaterJet extends SASBulletHit;


	//Physics					= PHYS_Trailer

// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASBulletHitWaterJet.SpriteEmitter0'
    begin object name=SpriteEmitter0 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-800.0000000)
        MaxParticles=12
        EffectAxis=1
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=2.0000000,Max=13.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Water.Water_splash'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.2000000)
        StartVelocityRange=(X=(Min=-5.0000000,Max=5.0000000),Y=(Min=-5.0000000,Max=5.0000000),Z=(Min=50.0000000,Max=400.0000000))
    end object
    Emitters[0]=SpriteEmitter0
    // Reference: SpriteEmitter'SASBulletHitWaterJet.SpriteEmitter2'
    begin object name=SpriteEmitter2 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-600.0000000)
        MaxParticles=3
        RespawnDeadParticles=false
        StartLocationShape=1
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.5000000),Y=(Min=0.0000000,Max=0.5000000),Z=(Min=0.0000000,Max=0.5000000))
        StartSizeRange=(X=(Min=10.0000000,Max=10.0000000),Y=(Min=10.0000000,Max=10.0000000),Z=(Min=100.0000000,Max=10.0000000))
        UniformSize=true
        InitialParticlesPerSecond=5000.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'jm-particl2.Particles.jm-xplosion'
        TextureUSubdivisions=3
        TextureVSubdivisions=3
        SubdivisionStart=6
        SubdivisionEnd=10
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.2000000)
        StartVelocityRange=(X=(Min=-50.0000000,Max=50.0000000),Y=(Min=-50.0000000,Max=50.0000000),Z=(Min=0.0000000,Max=500.0000000))
    end object
    Emitters[1]=SpriteEmitter2
    // Reference: SpriteEmitter'SASBulletHitWaterJet.SpriteEmitter3'
    begin object name=SpriteEmitter3 class=Class'Engine.SpriteEmitter'
        MaxParticles=2
        RespawnDeadParticles=false
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.1000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=100.0000000,Max=30.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'jm-particl2.Particles.jm-xplosion'
        TextureUSubdivisions=3
        TextureVSubdivisions=3
        BlendBetweenSubdivisions=true
        SubdivisionStart=7
        SubdivisionEnd=9
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=2.0000000)
    end object
    Emitters[2]=SpriteEmitter3
    AutoDestroy=true
    DrawScale=0.0100000
    Mass=4.0000000
    RemoteRole=1
    bNoDelete=false
    bTrailerSameRotation=true
}