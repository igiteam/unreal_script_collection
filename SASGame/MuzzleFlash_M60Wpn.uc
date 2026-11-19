//=============================================================================
// Muzzleflash_M60Wpn.uc
//=============================================================================

class Muzzleflash_M60Wpn extends SASEmitter;


//-----------------------------------------------------------------------------

// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'MuzzleFlash_M60Wpn.MF_Flash'
    begin object name=MF_Flash class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.1000000
        FadeOut=true
        CoordinateSystem=1
        MaxParticles=1
        RespawnDeadParticles=false
        SpinParticles=true
        StartSpinRange=(X=(Min=-0.0100000,Max=0.0100000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=15.0000000,Max=28.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_Muzzle_M60_1st'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0500000,Max=0.0500000)
    end object
    Emitters[0]=MF_Flash
    // Reference: SpriteEmitter'MuzzleFlash_M60Wpn.MF_spark'
    begin object name=MF_spark class=Class'Engine.SpriteEmitter'
        UseDirectionAs=1
        Acceleration=(X=0.0000000,Y=16.0000000,Z=16.0000000)
        FadeOutStartTime=0.0100000
        FadeOut=true
        CoordinateSystem=1
        MaxParticles=1
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=0.0000000,Max=15.0000000),Y=(Min=0.0000000,Max=70.0000000),Z=(Min=0.0000000,Max=70.0000000))
        Texture=Texture'SFXTx.Muzzle_Flashes.sparktest'
        InitialTimeRange=(Min=-0.0700000,Max=-0.0700000)
        LifetimeRange=(Min=0.0200000,Max=0.0100000)
        TriggerDisabled=false
        StartVelocityRange=(X=(Min=0.0000000,Max=150.0000000),Y=(Min=-100.0000000,Max=100.0000000),Z=(Min=-100.0000000,Max=160.0000000))
    end object
    Emitters[1]=MF_spark
    // Reference: SpriteEmitter'MuzzleFlash_M60Wpn.MF_Smoke'
    begin object name=MF_Smoke class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=8.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=1.1000000
        CoordinateSystem=1
        MaxParticles=6
        RespawnDeadParticles=false
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-0.0500000,Max=0.0500000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSpinRange=(X=(Min=-1.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_MuzzleSmoke_MP5_1st'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=70.0000000,Max=90.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=10.0000000,Max=10.0000000))
        VelocityLossRange=(X=(Min=3.0000000,Max=3.0000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.0000000))
        AddVelocityFromOtherEmitter=0
    end object
    Emitters[2]=MF_Smoke
    // Reference: SpriteEmitter'MuzzleFlash_M60Wpn.wisp_smoke'
    begin object name=wisp_smoke class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=8.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=1.1000000
        MaxParticles=12
        RespawnDeadParticles=false
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-0.0500000,Max=0.0500000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSpinRange=(X=(Min=-1.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_MuzzleSmoke_MP5_1st'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=2.0000000,Max=2.0000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=10.0000000,Max=10.0000000))
        AddVelocityFromOtherEmitter=0
    end object
    Emitters[3]=wisp_smoke
    DrawScale=0.1000000
    Mass=4.0000000
    bNoDelete=false
    bTrailerSameRotation=true
}