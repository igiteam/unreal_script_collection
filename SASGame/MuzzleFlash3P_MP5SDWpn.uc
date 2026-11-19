//=============================================================================
// MuzzleFlash3P_MP5SDWpn.uc
//
//==========================================================================

class MuzzleFlash3P_MP5SDWpn extends SASEmitter;


//-----------------------------------------------------------------------------

// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'MuzzleFlash3P_MP5SDWpn.Smoke'
    begin object name=Smoke class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=3.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=0.5000000
        FadeOut=true
        MaxParticles=16
        RespawnDeadParticles=false
        UseRotationFrom=1
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-0.0500000,Max=0.0500000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSpinRange=(X=(Min=-1.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=10.0000000,Max=10.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_MuzzleSmoke_MP5_1st'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.5000000,Max=2.0000000)
    end object
    Emitters[0]=Smoke
    Mass=4.0000000
    bNoDelete=false
    bTrailerSameRotation=true
}