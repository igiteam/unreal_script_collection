//=============================================================================
// SASBulletHitFleshExit
// Emitter effects for bullet hitting flesh (exitwound)
//=============================================================================

class SASBulletHitFleshSpurtC extends SASBulletHitWithGravity;


// Decompiled with UE Explorer.
defaultproperties
{
    mbNotInGermanBuild=true
    // Reference: SpriteEmitter'SASBulletHitFleshSpurtC.SpriteEmitterSpurt'
    begin object name=SpriteEmitterSpurt class=Class'Engine.SpriteEmitter'
        UseDirectionAs=1
        FadeOut=true
        FadeInEndTime=1.0000000
        CoordinateSystem=1
        MaxParticles=16
        RespawnDeadParticles=false
        UseRevolution=true
        RevolutionsPerSecondRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-0.8000000,Max=0.8000000),Z=(Min=-0.8000000,Max=0.8000000))
        UseRevolutionScale=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.4000000),Y=(Min=0.0000000,Max=0.4000000),Z=(Min=0.0000000,Max=0.4000000))
        RotationNormal=(X=1.0000000,Y=1.0000000,Z=1.0000000)
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=4.0000000),Y=(Min=8.0000000,Max=8.0000000),Z=(Min=0.0000000,Max=0.0000000))
        InitialParticlesPerSecond=96.0000000
        AutomaticInitialSpawning=false
        DrawStyle=2
        Texture=Texture'SFXTx.Wound.FxW_BloodSpurt'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.2500000,Max=0.2500000)
        ResetOnTrigger=true
        StartVelocityRange=(X=(Min=40.0000000,Max=40.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[0]=SpriteEmitterSpurt
    AutoDestroy=true
    Mass=4.0000000
    RemoteRole=1
    bNoDelete=false
    bTrailerSameRotation=true
}