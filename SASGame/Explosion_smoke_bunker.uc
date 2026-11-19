//=============================================================================
// Explosion_smoke_bunker
//
// Smoke effects for bunker.
//=============================================================================

class Explosion_smoke_bunker extends SASGenericExplosion;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'Explosion_smoke_bunker.SpriteEmitter48'
    begin object name=SpriteEmitter48 class=Class'Engine.SpriteEmitter'
        DampingFactorRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.0000000))
        UseColorScale=true
        FadeOutStartTime=420.0000000
        FadeOut=true
        FadeIn=true
        MaxParticles=25
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=-96.0000000,Max=96.0000000),Y=(Min=-96.0000000,Max=96.0000000),Z=(Min=-100.0000000,Max=0.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=5
        Texture=Texture'SFXTx.Smoke.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        UseSubdivisionScale=true
        UseRandomSubdivision=true
        LifetimeRange=(Min=440.0000000,Max=440.0000000)
        SpawnOnTriggerPPS=500.0000000
        VelocityLossRange=(X=(Min=1.0000000,Max=2.0000000),Y=(Min=1.0000000,Max=2.0000000),Z=(Min=0.0000000,Max=1.5000000))
    end object
    Emitters[0]=SpriteEmitter48
}