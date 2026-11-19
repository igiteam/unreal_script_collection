//=============================================================================
// SASBulletHitLitter
// Emitter effects for bullet hitting paper
//=============================================================================

class SASBulletHitLitter extends SASBulletHit;


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASBulletHitLitter.SpriteEmitter2'
    begin object name=SpriteEmitter2 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=6
        ProjectionNormal=(X=0.5000000,Y=1.0000000,Z=0.0000000)
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-40.0000000)
        ExtentMultiplier=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RespawnDeadParticles=false
        UseRevolution=true
        RevolutionsPerSecondRange=(X=(Min=0.1000000,Max=0.2000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseRevolutionScale=true
        RevolutionScale=/* Array type was not detected. */
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.3000000,Max=0.3000000),Y=(Min=0.3000000,Max=0.3000000),Z=(Min=0.3000000,Max=0.3000000))
        StartSizeRange=(X=(Min=1.0000000,Max=8.0000000),Y=(Min=1.0000000,Max=8.0000000),Z=(Min=1.0000000,Max=8.0000000))
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Damage.FxDM_littershower'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionStart=4
        SubdivisionEnd=1
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=6.0000000,Max=6.0000000)
        StartVelocityRange=(X=(Min=-10.0000000,Max=10.0000000),Y=(Min=-10.0000000,Max=10.0000000),Z=(Min=180.0000000,Max=220.0000000))
        VelocityLossRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=1.0000000,Max=2.0000000))
        UseVelocityScale=true
    end object
    Emitters[0]=SpriteEmitter2
    AutoDestroy=true
    Mass=4.0000000
    RemoteRole=1
    bNoDelete=false
    bTrailerSameRotation=true
}