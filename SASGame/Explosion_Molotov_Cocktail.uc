//=============================================================================
// Explosion_Molotov_Cocktail
//
// Explosion effects for Molotov cocktail.
//=============================================================================

class Explosion_Molotov_Cocktail extends SASGenericExplosion;

//-----------------------------------------------------------------------------
// Functions

simulated function BlastEffects()
{
	// don't do blast decals
}

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mDamageDataList=/* Array type was not detected. */
    // Reference: SpriteEmitter'Explosion_Molotov_Cocktail.Woompf'
    begin object name=Woompf class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-5.0000000)
        FadeOutStartTime=0.2000000
        FadeOut=true
        FadeIn=true
        MaxParticles=20
        RespawnDeadParticles=false
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=-0.1000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=25.0000000,Max=35.0000000),Y=(Min=25.0000000,Max=35.0000000),Z=(Min=25.0000000,Max=35.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Fire.FxF_05_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SubdivisionEnd=15
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=-50.0000000,Max=50.0000000),Y=(Min=-50.0000000,Max=50.0000000),Z=(Min=100.0000000,Max=250.0000000))
        VelocityLossRange=(X=(Min=1.0000000,Max=2.0000000),Y=(Min=0.5000000,Max=2.0000000),Z=(Min=2.0000000,Max=3.0000000))
        UseVelocityScale=true
        VelocityScale=/* Array type was not detected. */
    end object
    Emitters[0]=Woompf
    // Reference: SpriteEmitter'Explosion_Molotov_Cocktail.Explosion'
    begin object name=Explosion class=Class'Engine.SpriteEmitter'
        MaxParticles=1
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=100.0000000)
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Fire.FxF_03_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.0000000)
    end object
    Emitters[1]=Explosion
    bDynamicLight=true
}