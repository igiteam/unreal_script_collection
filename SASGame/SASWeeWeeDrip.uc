class SASWeeWeeDrip extends SASEmitter;


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASWeeWeeDrip.SASWeeWeeDrip0'
    begin object name=SASWeeWeeDrip0 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=1
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-300.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.4000000,Max=0.5000000),Y=(Min=0.4000000,Max=0.5000000),Z=(Min=0.3000000,Max=0.6000000))
        MaxParticles=80
        RespawnDeadParticles=false
        StartLocationShape=1
        SphereRadiusRange=(Min=0.0000000,Max=3.0000000)
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=2.0000000,Max=4.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=20.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'SFXTx.Dust.FxD_Dust01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.8000000,Max=1.2000000)
        StartVelocityRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=10.0000000),Z=(Min=0.0000000,Max=0.0000000))
        VelocityScale=/* Array type was not detected. */
    end object
    Emitters[0]=SASWeeWeeDrip0
    DrawScale=0.2000000
    bNoDelete=false
    bHardAttach=true
}