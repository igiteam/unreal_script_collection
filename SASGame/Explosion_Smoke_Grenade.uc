//=============================================================================
// Explosion_Smoke_Grenade
//
// Explosion (smoke) effects for grenade grenade.
//=============================================================================

class Explosion_Smoke_Grenade extends SASGenericExplosion;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mDamageDataList=/* Array type was not detected. */
    // Reference: SpriteEmitter'Explosion_Smoke_Grenade.SpriteEmitter14'
    begin object name=SpriteEmitter14 class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=1.0000000
        FadeOut=true
        FadeInEndTime=0.5000000
        FadeIn=true
        MaxParticles=15
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=-50.0000000,Max=50.0000000),Y=(Min=-50.0000000,Max=50.0000000),Z=(Min=-50.0000000,Max=50.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.2000000,Max=0.2000000),Y=(Min=0.0500000,Max=0.0500000),Z=(Min=0.0500000,Max=0.0500000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        InitialParticlesPerSecond=100.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Explosion.FxEx_flashbang02'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.7500000,Max=0.7500000)
        StartVelocityRange=(X=(Min=-20.0000000,Max=20.0000000),Y=(Min=-20.0000000,Max=20.0000000),Z=(Min=-20.0000000,Max=20.0000000))
    end object
    Emitters[0]=SpriteEmitter14
    // Reference: SpriteEmitter'Explosion_Smoke_Grenade.SpriteEmitter15'
    begin object name=SpriteEmitter15 class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=-0.0500000
        FadeOut=true
        MaxParticles=15
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=-25.0000000,Max=25.0000000),Y=(Min=-25.0000000,Max=25.0000000),Z=(Min=-25.0000000,Max=25.0000000))
        SpinParticles=true
        SpinCCWorCW=(X=0.2500000,Y=0.2500000,Z=0.2500000)
        SpinsPerSecondRange=(X=(Min=0.1200000,Max=0.1200000),Y=(Min=0.1200000,Max=0.1200000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        InitialParticlesPerSecond=100.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Explosion.FxEx_flashbang02'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.7500000,Max=0.7500000)
        StartVelocityRange=(X=(Min=-10.0000000,Max=10.0000000),Y=(Min=-10.0000000,Max=10.0000000),Z=(Min=-10.0000000,Max=10.0000000))
    end object
    Emitters[1]=SpriteEmitter15
    bDynamicLight=true
}