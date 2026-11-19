//=============================================================================
// Dust_Puff_Ground
// Cloud of dust that puffs up quickly and slowly settles in mid air. Used For falling Objects.
//=============================================================================

class Dust_puff_Ground extends SASGenericExplosion;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'Dust_Puff_Ground.Up_dust'
    begin object name=Up_dust class=Class'Engine.SpriteEmitter'
        ProjectionNormal=(X=0.5000000,Y=1.0000000,Z=0.0000000)
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-10.0000000)
        ExtentMultiplier=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        MaxParticles=25
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=100.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=100.0000000))
        RevolutionsPerSecondRange=(X=(Min=0.1000000,Max=0.2000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        RevolutionScale=/* Array type was not detected. */
        SpinsPerSecondRange=(X=(Min=0.3000000,Max=0.3000000),Y=(Min=0.3000000,Max=0.3000000),Z=(Min=0.3000000,Max=0.3000000))
        StartSizeRange=(X=(Min=1.0000000,Max=50.0000000),Y=(Min=1.0000000,Max=50.0000000),Z=(Min=1.0000000,Max=8.0000000))
        UniformSize=true
        InitialParticlesPerSecond=250.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke02_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SubdivisionStart=5
        SubdivisionEnd=16
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=6.0000000,Max=6.0000000)
        TriggerDisabled=false
        SpawnOnTriggerPPS=500.0000000
        StartVelocityRange=(X=(Min=-10.0000000,Max=10.0000000),Y=(Min=-10.0000000,Max=10.0000000),Z=(Min=70.0000000,Max=90.0000000))
        VelocityLossRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=2.0000000,Max=3.0000000))
        UseVelocityScale=true
    end object
    Emitters[0]=Up_dust
    bAlwaysRelevant=false
}