//=============================================================================
// SASBulletHitFabric
// Emitter effects for bullet hitting fabric
//=============================================================================

class SASBulletHitFabric extends SASBulletHit;


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASBulletHitFabric.SpriteEmitter26'
    begin object name=SpriteEmitter26 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=1
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=0.1000000
        FadeOut=true
        MaxParticles=12
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=25.0000000,Max=25.0000000),Y=(Min=800.0000000,Max=700.0000000),Z=(Min=125.0000000,Max=125.0000000))
        InitialParticlesPerSecond=2000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Misc.FxM_spark01'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.3000000,Max=0.3000000)
        StartVelocityRange=(X=(Min=-75.0000000,Max=-125.0000000),Y=(Min=-75.0000000,Max=125.0000000),Z=(Min=-75.0000000,Max=125.0000000))
    end object
    Emitters[0]=SpriteEmitter26
    // Reference: SpriteEmitter'SASBulletHitFabric.SpriteEmitter27'
    begin object name=SpriteEmitter27 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=1
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-950.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=0.5000000
        FadeOut=true
        MaxParticles=12
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=12.0000000,Max=35.0000000),Y=(Min=120.0000000,Max=120.0000000),Z=(Min=50.0000000,Max=100.0000000))
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Misc.FxM_spark01'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.2500000,Max=0.5000000)
        StartVelocityRange=(X=(Min=-25.0000000,Max=-200.0000000),Y=(Min=-200.0000000,Max=200.0000000),Z=(Min=-200.0000000,Max=200.0000000))
    end object
    Emitters[1]=SpriteEmitter27
    AutoDestroy=true
    DrawScale=0.1000000
    Mass=4.0000000
    RemoteRole=1
    bNoDelete=false
    bTrailerSameRotation=true
}