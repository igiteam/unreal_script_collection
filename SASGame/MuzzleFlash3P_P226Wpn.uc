//=============================================================================
// MuzzleFlash3P_P226Wpn.uc

//=============================================================================

class MuzzleFlash3P_P226Wpn extends SASEmitter;


//-----------------------------------------------------------------------------

// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'MuzzleFlash3P_P226Wpn.FlashA'
    begin object name=FlashA class=Class'Engine.SpriteEmitter'
        CoordinateSystem=1
        MaxParticles=1
        RespawnDeadParticles=false
        UseRotationFrom=3
        SpinParticles=true
        StartSpinRange=(X=(Min=-5.0000000,Max=5.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=12.0000000,Max=15.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_3PFlash'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0500000,Max=0.0500000)
    end object
    Emitters[0]=FlashA
    // Reference: SpriteEmitter'MuzzleFlash3P_P226Wpn.FlashB'
    begin object name=FlashB class=Class'Engine.SpriteEmitter'
        CoordinateSystem=1
        MaxParticles=1
        RespawnDeadParticles=false
        UseRotationFrom=3
        SpinParticles=true
        StartSpinRange=(X=(Min=-5.0000000,Max=5.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=7.0000000,Max=9.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_3PFlash'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0500000,Max=0.0500000)
        RelativeStartLocationOffset=(X=5.0000000,Y=0.0000000,Z=0.0000000)
    end object
    Emitters[1]=FlashB
    // Reference: SpriteEmitter'MuzzleFlash3P_P226Wpn.Smoke'
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
    Emitters[2]=Smoke
    Mass=4.0000000
    bNoDelete=false
    bTrailerSameRotation=true
}