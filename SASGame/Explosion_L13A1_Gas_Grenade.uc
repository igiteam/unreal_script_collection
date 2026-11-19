//=============================================================================
// Explosion_L13A1_Gas_Grenade
//
// Explosion (gas) effects for L13A1 gas grenade.
//=============================================================================

class Explosion_L13A1_Gas_Grenade extends SASGenericExplosion;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mDamageDataList=/* Array type was not detected. */
    mExplosionSounds=/* Array type was not detected. */
    mExplosionSoundVolume=0.6000000
    mExplosionSoundRadius=500.0000000
    // Reference: SpriteEmitter'Explosion_L13A1_Gas_Grenade.Target'
    begin object name=Target class=Class'Engine.SpriteEmitter'
        UseDirectionAs=2
        FadeOut=true
        MaxParticles=4
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=2.0000000,Z=-10.0000000)
        UseRevolution=true
        RevolutionsPerSecondRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=2.0000000,Max=2.0000000))
        StartSizeRange=(X=(Min=0.1000000,Max=0.1000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=50.0000000
        AutomaticInitialSpawning=false
        DrawStyle=2
        Texture=Texture'SFXTx.Wound.FxW_BloodSpurt'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=20.0000000,Max=20.0000000)
    end object
    Emitters[0]=Target
    // Reference: SpriteEmitter'Explosion_L13A1_Gas_Grenade.Swirl'
    begin object name=Swirl class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=100.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        MaxParticles=128
        RespawnDeadParticles=false
        AddLocationFromOtherEmitter=0
        SpinParticles=true
        StartSpinRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=3.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=64.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_MuzzleSmoke_MP5_1st'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.5000000)
        StartVelocityRange=(X=(Min=120.0000000,Max=150.0000000),Y=(Min=120.0000000,Max=150.0000000),Z=(Min=-15.0000000,Max=-18.0000000))
        AddVelocityFromOtherEmitter=0
        GetVelocityDirectionFrom=1
    end object
    Emitters[1]=Swirl
    // Reference: SpriteEmitter'Explosion_L13A1_Gas_Grenade.SpriteEmitter14'
    begin object name=SpriteEmitter14 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=15.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=1.1000000
        FadeOut=true
        MaxParticles=190
        EffectAxis=1
        RespawnDeadParticles=false
        UseRotationFrom=1
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-0.1000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSpinRange=(X=(Min=-1.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=8.0000000,Max=8.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=14.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_MuzzleSmoke_MP5_1st'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=4.0000000,Max=8.0000000)
        InitialDelayRange=(Min=1.0000000,Max=1.0000000)
        ResetOnTrigger=true
        StartVelocityRange=(X=(Min=-40.0000000,Max=40.0000000),Y=(Min=-40.0000000,Max=40.0000000),Z=(Min=10.0000000,Max=15.0000000))
        VelocityLossRange=(X=(Min=3.0000000,Max=3.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[2]=SpriteEmitter14
    bDynamicLight=true
}