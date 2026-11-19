//=============================================================================
// Explosion_L2A2_Grenade
//
// Explosion effects for L2A2 anit-personnel grenade.
//=============================================================================

class Explosion_L2A2_Grenade extends SASGenericExplosion;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties
// Currently copied from BoobyTrap_Explosion

// Decompiled with UE Explorer.
defaultproperties
{
    mDamageDataList=/* Array type was not detected. */
    mExplosionSounds=/* Array type was not detected. */
    mExplosionSoundRadius=500.0000000
    mbExplosionDecal=true
    // Reference: SpriteEmitter'Explosion_L2A2_Grenade.FlashFlame'
    begin object name=FlashFlame class=Class'Engine.SpriteEmitter'
        MaxParticles=1
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        InitialParticlesPerSecond=20.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'SFXTx.Explosion.FxE_03_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.2000000,Max=0.3000000)
    end object
    Emitters[0]=FlashFlame
    // Reference: SpriteEmitter'Explosion_L2A2_Grenade.FlameBall'
    begin object name=FlameBall class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-100.0000000)
        FadeOutFactor=(W=2.0000000,X=1.0000000,Y=1.0000000,Z=1.0000000)
        FadeOutStartTime=0.1000000
        FadeOut=true
        MaxParticles=5
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=-48.0000000,Max=48.0000000),Y=(Min=-48.0000000,Max=48.0000000),Z=(Min=-48.0000000,Max=48.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=5.0000000,Max=20.0000000),Y=(Min=30.0000000,Max=60.0000000),Z=(Min=30.0000000,Max=60.0000000))
        UniformSize=true
        InitialParticlesPerSecond=100.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'SFXTx.Explosion.FxE_Frag_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.2000000,Max=0.4000000)
        StartVelocityRange=(X=(Min=-100.0000000,Max=100.0000000),Y=(Min=0.0000000,Max=-200.0000000),Z=(Min=0.0000000,Max=250.0000000))
    end object
    Emitters[1]=FlameBall
    // Reference: MeshEmitter'Explosion_L2A2_Grenade.Bits'
    begin object name=Bits class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Rubble.rubble02'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-500.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.3000000,Max=0.5000000),Y=(Min=0.3000000,Max=0.5000000),Z=(Min=0.3000000,Max=0.5000000))
        MaxParticles=15
        RespawnDeadParticles=false
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-1.0000000,Max=1.0000000),Y=(Min=-1.0000000,Max=1.0000000),Z=(Min=-1.0000000,Max=1.0000000))
        DampRotation=true
        RotationDampingFactorRange=(X=(Min=0.1000000,Max=0.1000000),Y=(Min=0.1000000,Max=0.1000000),Z=(Min=0.1000000,Max=0.1000000))
        StartSizeRange=(X=(Min=1.0000000,Max=3.0000000),Y=(Min=1.0000000,Max=3.0000000),Z=(Min=1.0000000,Max=3.0000000))
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        StartVelocityRange=(X=(Min=-500.0000000,Max=500.0000000),Y=(Min=-500.0000000,Max=500.0000000),Z=(Min=-200.0000000,Max=500.0000000))
    end object
    Emitters[2]=Bits
    // Reference: MeshEmitter'Explosion_L2A2_Grenade.BitTrails'
    begin object name=BitTrails class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Rubble.rubble02'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-600.0000000)
        MaxParticles=5
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=-32.0000000,Max=32.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=4.0000000),Y=(Min=0.0000000,Max=4.0000000),Z=(Min=0.0000000,Max=4.0000000))
        StartSizeRange=(X=(Min=1.0000000,Max=3.0000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.0000000))
        UniformSize=true
        InitialParticlesPerSecond=800.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.6000000,Max=3.0000000)
        StartVelocityRange=(X=(Min=-800.0000000,Max=800.0000000),Y=(Min=-800.0000000,Max=800.0000000),Z=(Min=0.0000000,Max=1300.0000000))
        VelocityLossRange=(X=(Min=3.0000000,Max=5.0000000),Y=(Min=3.0000000,Max=5.0000000),Z=(Min=3.0000000,Max=5.0000000))
    end object
    Emitters[3]=BitTrails
    // Reference: SpriteEmitter'Explosion_L2A2_Grenade.PlaneBurst'
    begin object name=PlaneBurst class=Class'Engine.SpriteEmitter'
        UseCollision=true
        ExtentMultiplier=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DampingFactorRange=(X=(Min=0.1000000,Max=0.1000000),Y=(Min=0.1000000,Max=0.1000000),Z=(Min=0.1000000,Max=0.1000000))
        MaxParticles=15
        RespawnDeadParticles=false
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.1000000),Z=(Min=0.0000000,Max=0.1000000))
        StartSizeRange=(X=(Min=30.0000000,Max=70.0000000),Y=(Min=30.0000000,Max=70.0000000),Z=(Min=30.0000000,Max=70.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.5000000,Max=2.5000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1000.0000000,Max=1000.0000000),Z=(Min=20.0000000,Max=60.0000000))
        VelocityLossRange=(X=(Min=3.0000000,Max=8.0000000),Y=(Min=3.0000000,Max=8.0000000),Z=(Min=3.0000000,Max=8.0000000))
        UseVelocityScale=true
        VelocityScale=/* Array type was not detected. */
    end object
    Emitters[4]=PlaneBurst
    // Reference: SpriteEmitter'Explosion_L2A2_Grenade.CloudLinger'
    begin object name=CloudLinger class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=30.0000000)
        MaxParticles=15
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=-48.0000000,Max=48.0000000))
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=2.0000000,Max=5.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=4.0000000,Max=6.0000000)
        StartVelocityRange=(X=(Min=-1000.0000000,Max=1000.0000000),Y=(Min=-1000.0000000,Max=1000.0000000),Z=(Min=-100.0000000,Max=100.0000000))
        VelocityLossRange=(X=(Min=6.0000000,Max=12.0000000),Y=(Min=6.0000000,Max=12.0000000),Z=(Min=2.0000000,Max=2.0000000))
    end object
    Emitters[5]=CloudLinger
    // Reference: SpriteEmitter'Explosion_L2A2_Grenade.Trails'
    begin object name=Trails class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.8000000
        FadeOut=true
        MaxParticles=70
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=-48.0000000,Max=48.0000000))
        AddLocationFromOtherEmitter=3
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=4.0000000,Max=10.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=80.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=2.0000000,Max=3.0000000)
    end object
    Emitters[6]=Trails
    // Reference: SpriteEmitter'Explosion_L2A2_Grenade.Flash'
    begin object name=Flash class=Class'Engine.SpriteEmitter'
        MaxParticles=2
        RespawnDeadParticles=false
        StartLocationOffset=(X=0.0000000,Y=0.0000000,Z=20.0000000)
        StartSizeRange=(X=(Min=85.0000000,Max=115.0000000),Y=(Min=85.0000000,Max=115.0000000),Z=(Min=85.0000000,Max=115.0000000))
        UniformSize=true
        InitialParticlesPerSecond=20.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Explosion.FxE_01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0000000,Max=0.3500000)
    end object
    Emitters[7]=Flash
}