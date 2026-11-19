//=============================================================================
// SASBulletHitFleshExit
// Emitter effects for bullet hitting flesh (exitwound)
//=============================================================================

class SASBulletHitFleshExitB extends SASBulletHit;


// Decompiled with UE Explorer.
defaultproperties
{
    mbNotInGermanBuild=true
    // Reference: SpriteEmitter'SASBulletHitFleshExitB.SpriteEmitterBHFE'
    begin object name=SpriteEmitterBHFE class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=3.0000000)
        FadeInEndTime=1.0000000
        CoordinateSystem=1
        MaxParticles=1
        RespawnDeadParticles=false
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.4000000),Y=(Min=0.0000000,Max=0.4000000),Z=(Min=0.0000000,Max=0.4000000))
        RotationNormal=(X=1.0000000,Y=1.0000000,Z=1.0000000)
        StartSizeRange=(X=(Min=12.0000000,Max=24.0000000),Y=(Min=6.0000000,Max=12.0000000),Z=(Min=6.0000000,Max=12.0000000))
        UniformSize=true
        InitialParticlesPerSecond=11.0000000
        AutomaticInitialSpawning=false
        DrawStyle=2
        Texture=Texture'SFXTx.Wound.FxW_Bloodmist_4x4_2'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=2.0000000,Max=2.0000000)
        ResetOnTrigger=true
        MaxAbsVelocity=(X=0.0000000,Y=11.0000000,Z=0.0000000)
        AddVelocityMultiplierRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=11.0000000,Max=11.0000000),Z=(Min=1.0000000,Max=1.0000000))
    end object
    Emitters[0]=SpriteEmitterBHFE
    // Reference: SpriteEmitter'SASBulletHitFleshExitB.FabricBits'
    begin object name=FabricBits class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        ProjectionNormal=(X=1.0000000,Y=1.0000000,Z=0.0000000)
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-10.0000000)
        FadeOutStartTime=0.7500000
        FadeOut=true
        MaxParticles=7
        RespawnDeadParticles=false
        UseRotationFrom=3
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=2.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=2.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=3.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=0.1000000,Max=1.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=50.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Wound.FxW_fabric02'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=2.0000000)
        StartVelocityRange=(X=(Min=150.0000000,Max=200.0000000),Y=(Min=-60.0000000,Max=60.0000000),Z=(Min=-60.0000000,Max=60.0000000))
        VelocityLossRange=(X=(Min=6.0000000,Max=8.0000000),Y=(Min=3.0000000,Max=3.0000000),Z=(Min=3.0000000,Max=3.0000000))
    end object
    Emitters[1]=FabricBits
    // Reference: SpriteEmitter'SASBulletHitFleshExitB.Shower'
    begin object name=Shower class=Class'Engine.SpriteEmitter'
        UseDirectionAs=5
        ProjectionNormal=(X=1.0000000,Y=1.0000000,Z=0.0000000)
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-200.0000000)
        FadeOutStartTime=0.5000000
        FadeOut=true
        FadeInEndTime=0.2000000
        FadeIn=true
        MaxParticles=40
        RespawnDeadParticles=false
        UseRotationFrom=3
        SpinCCWorCW=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        UseSizeScale=true
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=0.0100000,Max=2.0000000),Y=(Min=0.1000000,Max=4.5000000),Z=(Min=0.1000000,Max=2.0000000))
        InitialParticlesPerSecond=300.0000000
        AutomaticInitialSpawning=false
        DrawStyle=2
        Texture=Texture'SFXTx.Wound.FxW_BloodDrop'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.1000000,Max=0.5000000)
        StartVelocityRange=(X=(Min=-120.0000000,Max=120.0000000),Y=(Min=-120.0000000,Max=120.0000000),Z=(Min=-120.0000000,Max=120.0000000))
        VelocityLossRange=(X=(Min=2.0000000,Max=2.0000000),Y=(Min=2.0000000,Max=2.0000000),Z=(Min=2.0000000,Max=2.0000000))
    end object
    Emitters[2]=Shower
    AutoDestroy=true
    Mass=4.0000000
    RemoteRole=1
    bNoDelete=false
    bTrailerSameRotation=true
}