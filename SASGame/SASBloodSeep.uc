//=============================================================================
// SASBulletHitFlesh
// Emitter effects for bullet hitting flesh (exitwound)
//=============================================================================

class SASBloodSeep extends Emitter;

//	Physics					= PHYS_Trailer
//	bTrailerSameRotation	= true
//	Mass					= +4.0


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASBloodSeep.SeepEmitter01'
    begin object name=SeepEmitter01 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=4
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        MaxParticles=5
        StartLocationRange=(X=(Min=-20.0000000,Max=20.0000000),Y=(Min=-20.0000000,Max=20.0000000),Z=(Min=0.0000000,Max=0.0000000))
        SpinParticles=true
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=15.0000000,Max=40.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=30.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Bullet_Hole.FxBH_metal01'
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=20.0000000,Max=20.0000000)
        StartVelocityRadialRange=(Min=-3.0000000,Max=-15.0000000)
        VelocityLossRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=0.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[0]=SeepEmitter01
    // Reference: SpriteEmitter'SASBloodSeep.SeepEmitter02'
    begin object name=SeepEmitter02 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=4
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        MaxParticles=1
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.2500000,Max=10.0000000))
        SpinParticles=true
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=25.0000000,Max=45.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=30.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Bullet_Hole.FxBH_metal04'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=20.0000000,Max=20.0000000)
        StartVelocityRadialRange=(Min=-3.0000000,Max=-15.0000000)
        VelocityLossRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[1]=SeepEmitter02
    AutoDestroy=true
    RemoteRole=1
    bNoDelete=false
}