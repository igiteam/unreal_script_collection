//=============================================================================
// SASBulletHitSteamJet
// Emitter effects for bullet hitting an object that emits steam (like the fire 
// extinguisher)
//=============================================================================

class SASBulletHitSteamJet extends SASBulletHit;


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASBulletHitSteamJet.SpriteEmitterSteam0'
    begin object name=SpriteEmitterSteam0 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=5.0000000)
        FadeOut=true
        MaxParticles=35
        RespawnDeadParticles=false
        UseRotationFrom=1
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-0.1000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSpinRange=(X=(Min=-1.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1.0000000
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_MuzzleSmoke_MP5_1st'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.0000000)
        ResetOnTrigger=true
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=45.0000000,Max=80.0000000),Z=(Min=10.0000000,Max=10.0000000))
        VelocityLossRange=(X=(Min=3.0000000,Max=3.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[0]=SpriteEmitterSteam0
    // Reference: SpriteEmitter'SASBulletHitSteamJet.SpriteEmitterSteam1'
    begin object name=SpriteEmitterSteam1 class=Class'Engine.SpriteEmitter'
        FadeOut=true
        RespawnDeadParticles=false
        UseRotationFrom=1
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.1000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSpinRange=(X=(Min=-1.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1.0000000
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_MuzzleSmoke_MP5_1st'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=3.0000000,Max=3.0000000)
        InitialDelayRange=(Min=0.7000000,Max=0.7000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=20.0000000,Max=40.0000000),Z=(Min=0.0000000,Max=0.0000000))
        VelocityLossRange=(X=(Min=3.0000000,Max=3.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[1]=SpriteEmitterSteam1
    AutoDestroy=true
    Mass=4.0000000
    RemoteRole=1
    bNoDelete=false
    bTrailerSameRotation=true
}