//=============================================================================
// SASBulletHitGlass
// Emitter effects for bullet hitting glass
//=============================================================================

class SASBulletHitGlass extends SASBulletHit;


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASBulletHitGlass.SpriteEmitter26'
    begin object name=SpriteEmitter26 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-750.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.8000000,Max=0.9000000),Y=(Min=0.5000000,Max=0.5000000),Z=(Min=0.2000000,Max=0.3000000))
        FadeOutStartTime=0.1000000
        FadeOut=true
        MaxParticles=4
        RespawnDeadParticles=false
        StartSizeRange=(X=(Min=1.0000000,Max=1.5000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.5000000))
        InitialParticlesPerSecond=2000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Damage.FxDM_tinyglass01'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.5000000,Max=5.0000000)
        StartVelocityRange=(X=(Min=-300.0000000,Max=300.0000000),Y=(Min=-300.0000000,Max=300.0000000),Z=(Min=-300.0000000,Max=300.0000000))
    end object
    Emitters[0]=SpriteEmitter26
    // Reference: SpriteEmitter'SASBulletHitGlass.Dust'
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
    Mass=4.0000000
    RemoteRole=1
    bNoDelete=false
    bTrailerSameRotation=true
}