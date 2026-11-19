class BillboardDamage extends SASEmitter;

//-----------------------------------------------------------------------------
// Default properties

// Contains parameters for exploding monitors to be used for damage states


// Decompiled with UE Explorer.
defaultproperties
{
    Emitters[0]=none
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter1'
    begin object name=SpriteEmitter1 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-7000.0000000)
        FadeOutStartTime=0.0500000
        FadeOut=true
        FadeInEndTime=0.0500000
        FadeIn=true
        MaxParticles=4
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=-2.0000000,Z=0.0000000)
        UseRotationFrom=1
        UseSizeScale=true
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=1.0000000,Max=10.0000000),Z=(Min=1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=4.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark1'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=0.1000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1.0000000,Max=-1000.0000000),Z=(Min=1.0000000,Max=700.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[1]=SpriteEmitter1
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter2'
    begin object name=SpriteEmitter2 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-7000.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=0.1000000
        FadeOut=true
        FadeInEndTime=0.1000000
        FadeIn=true
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=-2.0000000,Z=0.0000000)
        UseRotationFrom=1
        UseSizeScale=true
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=1.0000000,Max=10.0000000),Z=(Min=1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=20.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark1'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=0.1000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1.0000000,Max=-1000.0000000),Z=(Min=1.0000000,Max=700.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[2]=SpriteEmitter2
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter3'
    begin object name=SpriteEmitter3 class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.0300000
        FadeOut=true
        FadeInEndTime=0.0300000
        FadeIn=true
        MaxParticles=4
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=-2.0000000,Z=0.0000000)
        UseRotationFrom=1
        SpinParticles=true
        StartSizeRange=(X=(Min=1.0000000,Max=30.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        BlendBetweenSubdivisions=true
        SubdivisionStart=1
        SubdivisionEnd=4
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.1000000,Max=0.3000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=100.0000000))
    end object
    Emitters[3]=SpriteEmitter3
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter4'
    begin object name=SpriteEmitter4 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-7000.0000000)
        FadeOutStartTime=0.0500000
        FadeOut=true
        FadeInEndTime=0.0500000
        FadeIn=true
        MaxParticles=4
        RespawnDeadParticles=false
        StartLocationOffset=(X=-20.0000000,Y=-2.0000000,Z=35.0000000)
        UseRotationFrom=1
        UseSizeScale=true
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=1.0000000,Max=10.0000000),Z=(Min=1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=4.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark1'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=0.1000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1.0000000,Max=-1000.0000000),Z=(Min=1.0000000,Max=700.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[4]=SpriteEmitter4
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter5'
    begin object name=SpriteEmitter5 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-7000.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=0.1000000
        FadeOut=true
        FadeInEndTime=0.1000000
        FadeIn=true
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationOffset=(X=-20.0000000,Y=-2.0000000,Z=35.0000000)
        UseRotationFrom=1
        UseSizeScale=true
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=1.0000000,Max=10.0000000),Z=(Min=1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=20.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark1'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=0.1000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1.0000000,Max=-1000.0000000),Z=(Min=1.0000000,Max=700.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[5]=SpriteEmitter5
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter6'
    begin object name=SpriteEmitter6 class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.0300000
        FadeOut=true
        FadeInEndTime=0.0300000
        FadeIn=true
        MaxParticles=4
        RespawnDeadParticles=false
        StartLocationOffset=(X=-20.0000000,Y=-2.0000000,Z=35.0000000)
        UseRotationFrom=1
        SpinParticles=true
        StartSizeRange=(X=(Min=1.0000000,Max=30.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        BlendBetweenSubdivisions=true
        SubdivisionStart=1
        SubdivisionEnd=4
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.1000000,Max=0.3000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=100.0000000))
    end object
    Emitters[6]=SpriteEmitter6
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter7'
    begin object name=SpriteEmitter7 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-7000.0000000)
        FadeOutStartTime=0.0500000
        FadeOut=true
        FadeInEndTime=0.0500000
        FadeIn=true
        MaxParticles=4
        RespawnDeadParticles=false
        StartLocationOffset=(X=-10.0000000,Y=-2.0000000,Z=-20.0000000)
        UseRotationFrom=1
        UseSizeScale=true
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=1.0000000,Max=10.0000000),Z=(Min=1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=4.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark1'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=0.1000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1.0000000,Max=-1000.0000000),Z=(Min=1.0000000,Max=700.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[7]=SpriteEmitter7
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter8'
    begin object name=SpriteEmitter8 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-7000.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=0.1000000
        FadeOut=true
        FadeInEndTime=0.1000000
        FadeIn=true
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationOffset=(X=-10.0000000,Y=-2.0000000,Z=-20.0000000)
        UseRotationFrom=1
        UseSizeScale=true
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=1.0000000,Max=10.0000000),Z=(Min=1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=20.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark1'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=0.1000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1.0000000,Max=-1000.0000000),Z=(Min=1.0000000,Max=700.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[8]=SpriteEmitter8
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter9'
    begin object name=SpriteEmitter9 class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.0300000
        FadeOut=true
        FadeInEndTime=0.0300000
        FadeIn=true
        MaxParticles=4
        RespawnDeadParticles=false
        StartLocationOffset=(X=-10.0000000,Y=-2.0000000,Z=-20.0000000)
        UseRotationFrom=1
        SpinParticles=true
        StartSizeRange=(X=(Min=1.0000000,Max=30.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        BlendBetweenSubdivisions=true
        SubdivisionStart=1
        SubdivisionEnd=4
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.1000000,Max=0.3000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=100.0000000))
    end object
    Emitters[9]=SpriteEmitter9
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter10'
    begin object name=SpriteEmitter10 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-7000.0000000)
        FadeOutStartTime=0.0500000
        FadeOut=true
        FadeInEndTime=0.0500000
        FadeIn=true
        MaxParticles=4
        RespawnDeadParticles=false
        StartLocationOffset=(X=20.0000000,Y=-2.0000000,Z=10.0000000)
        UseRotationFrom=1
        UseSizeScale=true
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=1.0000000,Max=10.0000000),Z=(Min=1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=4.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark1'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=0.1000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1.0000000,Max=-1000.0000000),Z=(Min=1.0000000,Max=700.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[10]=SpriteEmitter10
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter11'
    begin object name=SpriteEmitter11 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-7000.0000000)
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=0.1000000
        FadeOut=true
        FadeInEndTime=0.1000000
        FadeIn=true
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationOffset=(X=20.0000000,Y=-2.0000000,Z=10.0000000)
        UseRotationFrom=1
        UseSizeScale=true
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=1.0000000,Max=10.0000000),Z=(Min=1.0000000,Max=1.0000000))
        InitialParticlesPerSecond=20.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark1'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=0.1000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1.0000000,Max=-1000.0000000),Z=(Min=1.0000000,Max=700.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[11]=SpriteEmitter11
    // Reference: SpriteEmitter'BillboardDamage.SpriteEmitter12'
    begin object name=SpriteEmitter12 class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.0300000
        FadeOut=true
        FadeInEndTime=0.0300000
        FadeIn=true
        MaxParticles=4
        RespawnDeadParticles=false
        StartLocationOffset=(X=20.0000000,Y=-2.0000000,Z=10.0000000)
        UseRotationFrom=1
        SpinParticles=true
        StartSizeRange=(X=(Min=1.0000000,Max=30.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1.0000000
        Texture=Texture'SFXTx.Misc.FxBH_spark2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        BlendBetweenSubdivisions=true
        SubdivisionStart=1
        SubdivisionEnd=4
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.1000000,Max=0.3000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=100.0000000))
    end object
    Emitters[12]=SpriteEmitter12
    AutoDestroy=true
    LightBrightness=230.0000000
    LightRadius=2.0000000
    LightType=1
    LightHue=116
    LightSaturation=240
    LightPeriod=10
    bNoDelete=false
}