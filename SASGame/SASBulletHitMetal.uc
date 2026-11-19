//=============================================================================
// SASBulletHitMetal
// Emitter effects for bullet hitting metal
//=============================================================================

class SASBulletHitMetal extends SASBulletHit;
//,PTDU_Up

// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASBulletHitMetal.Spark'
    begin object name=Spark class=Class'Engine.SpriteEmitter'
        UseDirectionAs=1
        Acceleration=(X=0.0000000,Y=16.0000000,Z=16.0000000)
        FadeOutStartTime=0.0100000
        FadeOut=true
        CoordinateSystem=1
        MaxParticles=7
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=0.0000000,Max=30.0000000),Y=(Min=0.0000000,Max=100.0000000),Z=(Min=0.0000000,Max=100.0000000))
        Texture=Texture'SFXTx.Muzzle_Flashes.sparktest'
        SecondsBeforeInactive=0.0000000
        InitialTimeRange=(Min=-0.0700000,Max=-0.0700000)
        LifetimeRange=(Min=0.0200000,Max=0.0100000)
        TriggerDisabled=false
        StartVelocityRange=(X=(Min=0.0000000,Max=100.0000000),Y=(Min=-100.0000000,Max=100.0000000),Z=(Min=-100.0000000,Max=110.0000000))
        ParticlesPerShot=4
    end object
    Emitters[0]=Spark
    // Reference: SpriteEmitter'SASBulletHitMetal.Dust'
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
    Emitters[1]=Dust
    AutoDestroy=true
    DrawScale=0.1000000
    Mass=4.0000000
    RemoteRole=1
    bNoDelete=false
    bTrailerSameRotation=true
}