//=============================================================================
// SASModeldamageGlass
// Emitter effects for breaking glass
//=============================================================================

class SASModeldamageGlass extends SASEmitter;

//StartLocationRange			= (X=(Min=-128,Max=128),Y=(Min=0,Max=0),Z=(Min=-128,Max=128))

// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASModeldamageGlass.GlassEmitter'
    begin object name=GlassEmitter class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-750.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.8000000,Max=0.9000000),Y=(Min=0.5000000,Max=0.5000000),Z=(Min=0.2000000,Max=0.3000000))
        FadeOutStartTime=0.4000000
        FadeOut=true
        RespawnDeadParticles=false
        UseRotationFrom=1
        SpinParticles=true
        StartSpinRange=(X=(Min=0.1000000,Max=0.9000000),Y=(Min=0.1000000,Max=0.9000000),Z=(Min=0.1000000,Max=0.9000000))
        StartSizeRange=(X=(Min=1.5000000,Max=2.2000000),Y=(Min=1.5000000,Max=2.2000000),Z=(Min=1.5000000,Max=2.2000000))
        InitialParticlesPerSecond=50000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Damage.FxDM_tinyglass01'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        MinSquaredVelocity=500.0000000
        LifetimeRange=(Min=2.0000000,Max=8.0000000)
        StartVelocityRange=(X=(Min=-35.0000000,Max=35.0000000),Y=(Min=-17.0000000,Max=17.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[0]=GlassEmitter
    AutoDestroy=true
    Mass=4.0000000
    bNoDelete=false
}