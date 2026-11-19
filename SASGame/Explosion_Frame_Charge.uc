//=============================================================================
// Explosion_farm_large
//
// Explosion effects for barn in the farm.
//=============================================================================

class Explosion_Frame_Charge extends SASGenericExplosion;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mDamageDataList=/* Array type was not detected. */
    mExplosionSounds=/* Array type was not detected. */
    mExplosionSoundRadius=700.0000000
    mbExplosionDecal=true
    // Reference: SpriteEmitter'Explosion_Frame_Charge.SpriteEmitter1'
    begin object name=SpriteEmitter1 class=Class'Engine.SpriteEmitter'
        ProjectionNormal=(X=0.0000000,Y=1.0000000,Z=0.0000000)
        DampingFactorRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.1000000,Max=0.2000000))
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=40.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=55.0000000))
        ZTest=false
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=10.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        DampRotation=true
        RotationDampingFactorRange=(X=(Min=0.5000000,Max=1.0000000),Y=(Min=0.5000000,Max=1.0000000),Z=(Min=0.5000000,Max=1.0000000))
        UseSizeScale=true
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=400.0000000,Max=500.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Explosion.FxEx_flashbang02'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.0000000)
        UseVelocityScale=true
    end object
    Emitters[0]=SpriteEmitter1
    // Reference: SpriteEmitter'Explosion_Frame_Charge.SpriteEmitter2'
    begin object name=SpriteEmitter2 class=Class'Engine.SpriteEmitter'
        ProjectionNormal=(X=0.0000000,Y=1.0000000,Z=0.0000000)
        DampingFactorRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.1000000,Max=0.2000000))
        MaxParticles=250
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=40.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=55.0000000))
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=10.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        DampRotation=true
        RotationDampingFactorRange=(X=(Min=0.5000000,Max=1.0000000),Y=(Min=0.5000000,Max=1.0000000),Z=(Min=0.5000000,Max=1.0000000))
        StartSizeRange=(X=(Min=10.0000000,Max=70.0000000),Y=(Min=5.0000000,Max=5.0000000),Z=(Min=5.0000000,Max=5.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Smoke.FxF_Smoke01_4x4'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=20.0000000,Max=20.0000000)
        StartVelocityRange=(X=(Min=-200.0000000,Max=200.0000000),Y=(Min=0.0000000,Max=250.0000000),Z=(Min=-20.0000000,Max=20.0000000))
        VelocityLossRange=(X=(Min=0.5000000,Max=1.0000000),Y=(Min=0.5000000,Max=1.0000000),Z=(Min=0.0000000,Max=0.0000000))
        UseVelocityScale=true
    end object
    Emitters[1]=SpriteEmitter2
    // Reference: SpriteEmitter'Explosion_Frame_Charge.SpriteEmitter3'
    begin object name=SpriteEmitter3 class=Class'Engine.SpriteEmitter'
        ProjectionNormal=(X=0.0000000,Y=1.0000000,Z=0.0000000)
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-700.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.1000000,Max=0.2000000),Y=(Min=0.2000000,Max=0.1000000),Z=(Min=0.1000000,Max=0.2000000))
        MaxParticles=400
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=40.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=55.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=10.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        DampRotation=true
        RotationDampingFactorRange=(X=(Min=0.5000000,Max=1.0000000),Y=(Min=0.5000000,Max=1.0000000),Z=(Min=0.5000000,Max=1.0000000))
        StartSizeRange=(X=(Min=2.0000000,Max=5.0000000),Y=(Min=5.0000000,Max=5.0000000),Z=(Min=5.0000000,Max=5.0000000))
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Damage.FxDM_largeglass01'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=10.0000000,Max=10.0000000)
        AddVelocityFromOtherEmitter=1
    end object
    Emitters[2]=SpriteEmitter3
    // Reference: SpriteEmitter'Explosion_Frame_Charge.SpriteEmitter4'
    begin object name=SpriteEmitter4 class=Class'Engine.SpriteEmitter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-500.0000000)
        MaxParticles=25
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=20.0000000,Max=20.0000000),Z=(Min=30.0000000,Max=30.0000000))
        StartSizeRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=5000.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        StartVelocityRange=(X=(Min=-100.0000000,Max=100.0000000),Y=(Min=0.0000000,Max=1000.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[3]=SpriteEmitter4
    // Reference: MeshEmitter'Explosion_Frame_Charge.MeshEmitter5'
    begin object name=MeshEmitter5 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Rubble.rubble02'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-500.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.0000000,Max=0.5000000),Y=(Min=0.0000000,Max=0.5000000),Z=(Min=0.0000000,Max=0.5000000))
        MaxParticles=5
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=30.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=50.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        DampRotation=true
        RotationDampingFactorRange=(X=(Min=0.5000000,Max=1.0000000),Y=(Min=0.5000000,Max=1.0000000),Z=(Min=0.5000000,Max=1.0000000))
        StartSizeRange=(X=(Min=1.0000000,Max=5.0000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.0000000))
        UniformSize=true
        InitialParticlesPerSecond=500.0000000
        AutomaticInitialSpawning=false
        DrawStyle=4
        SecondsBeforeInactive=0.0000000
        StartVelocityRange=(X=(Min=-25.0000000,Max=25.0000000),Y=(Min=0.0000000,Max=1000.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[4]=MeshEmitter5
    // Reference: SpriteEmitter'Explosion_Frame_Charge.SpriteEmitter5'
    begin object name=SpriteEmitter5 class=Class'Engine.SpriteEmitter'
        UseDirectionAs=3
        ProjectionNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-150.0000000)
        DampingFactorRange=(X=(Min=0.2000000,Max=0.3000000),Y=(Min=0.1000000,Max=0.3000000),Z=(Min=0.1000000,Max=0.3000000))
        MaxParticles=150
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=0.0000000,Max=40.0000000),Y=(Min=0.0000000,Max=100.0000000),Z=(Min=0.0000000,Max=50.0000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.5000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
        DampRotation=true
        RotationDampingFactorRange=(X=(Min=0.1000000,Max=0.5000000),Y=(Min=0.1000000,Max=0.5000000),Z=(Min=0.1000000,Max=0.5000000))
        StartSizeRange=(X=(Min=0.1000000,Max=4.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=5000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Damage.FxDM_largeglass01'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        UseRandomSubdivision=true
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=3.0000000)
        StartVelocityRange=(X=(Min=-50.0000000,Max=50.0000000),Y=(Min=0.0000000,Max=250.0000000),Z=(Min=-100.0000000,Max=100.0000000))
    end object
    Emitters[5]=SpriteEmitter5
}