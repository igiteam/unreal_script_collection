//=============================================================================
// Bullet hit Bush
//
// Particle effect for shooting foliage
//=============================================================================

class SASBulletHitBush extends SASBulletHit;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASBulletHitBush.Leaves'
    begin object name=Leaves class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-100.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        ColorScaleRepeats=2.0000000
        MaxParticles=12
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=-1.0000000,Max=1.0000000),Y=(Min=-1.0000000,Max=1.0000000),Z=(Min=-1.0000000,Max=1.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.2000000,Max=1.0000000),Y=(Min=0.2000000,Max=1.5000000),Z=(Min=0.2000000,Max=1.0000000))
        StartSizeRange=(X=(Min=0.4000000,Max=1.5000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=0
        Texture=Texture'SFXTx.Damage.FxDM_foliage'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.2500000,Max=1.5000000)
        StartVelocityRadialRange=(Min=-100.0000000,Max=-200.0000000)
        VelocityLossRange=(X=(Min=3.0000000,Max=10.0000000),Y=(Min=3.0000000,Max=10.0000000),Z=(Min=3.0000000,Max=10.0000000))
        AddVelocityMultiplierRange=(X=(Min=1.0000000,Max=20.0000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[0]=Leaves
    AutoDestroy=true
    bNoDelete=false
}