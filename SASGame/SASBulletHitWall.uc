//=============================================================================
// SASBulletHitWall
// Emitter effects for bullet hitting wall
//=============================================================================

class SASBulletHitWall extends SASBulletHit;



// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: MeshEmitter'SASBulletHitWall.MeshTracer01'
    begin object name=MeshTracer01 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_ceramicspliter01'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-300.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.0000000,Max=0.5000000),Y=(Min=0.0000000,Max=0.5000000),Z=(Min=0.0000000,Max=0.5000000))
        MaxParticles=1
        RespawnDeadParticles=false
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.5000000),Y=(Min=0.0000000,Max=0.5000000),Z=(Min=0.0000000,Max=0.5000000))
        StartSizeRange=(X=(Min=0.1000000,Max=0.2000000),Y=(Min=0.1000000,Max=0.2000000),Z=(Min=0.1000000,Max=0.2000000))
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=2.0000000)
        StartVelocityRange=(X=(Min=-160.0000000,Max=160.0000000),Y=(Min=-160.0000000,Max=160.0000000),Z=(Min=-50.0000000,Max=50.0000000))
        VelocityLossRange=(X=(Min=1.0000000,Max=2.0000000),Y=(Min=1.0000000,Max=2.0000000),Z=(Min=0.0000000,Max=0.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[0]=MeshTracer01
    // Reference: MeshEmitter'SASBulletHitWall.MeshTracer02'
    begin object name=MeshTracer02 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_ceramicspliter03'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-300.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.0000000,Max=0.5000000),Y=(Min=0.0000000,Max=0.5000000),Z=(Min=0.0000000,Max=0.5000000))
        MaxParticles=1
        RespawnDeadParticles=false
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=3.0000000),Y=(Min=0.0000000,Max=3.0000000),Z=(Min=0.0000000,Max=3.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        StartSizeRange=(X=(Min=0.5000000,Max=0.5000000),Y=(Min=0.5000000,Max=0.5000000),Z=(Min=0.5000000,Max=0.5000000))
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=2.0000000)
        StartVelocityRange=(X=(Min=-200.0000000,Max=200.0000000),Y=(Min=-200.0000000,Max=200.0000000),Z=(Min=-50.0000000,Max=50.0000000))
        VelocityLossRange=(X=(Min=2.0000000,Max=3.0000000),Y=(Min=2.0000000,Max=3.0000000),Z=(Min=0.0000000,Max=0.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[1]=MeshTracer02
    // Reference: MeshEmitter'SASBulletHitWall.MeshSplinters'
    begin object name=MeshSplinters class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Damage.FxDm_ceramicspliter03'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-300.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.5000000,Max=0.5000000),Y=(Min=0.0000000,Max=0.5000000),Z=(Min=0.0000000,Max=0.5000000))
        MaxParticles=20
        RespawnDeadParticles=false
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=3.0000000),Y=(Min=0.0000000,Max=3.0000000),Z=(Min=0.0000000,Max=4.0000000))
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        StartSizeRange=(X=(Min=0.0000000,Max=0.5000000),Y=(Min=0.5000000,Max=0.5000000),Z=(Min=0.5000000,Max=0.5000000))
        UniformSize=true
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=2.0000000)
        StartVelocityRange=(X=(Min=-200.0000000,Max=200.0000000),Y=(Min=-200.0000000,Max=200.0000000),Z=(Min=-50.0000000,Max=50.0000000))
        VelocityLossRange=(X=(Min=1.0000000,Max=4.0000000),Y=(Min=1.0000000,Max=4.0000000),Z=(Min=0.0000000,Max=0.0000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[2]=MeshSplinters
    // Reference: SpriteEmitter'SASBulletHitWall.SpritePlume01'
    begin object name=SpritePlume01 class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.0500000
        FadeOut=true
        MaxParticles=20
        RespawnDeadParticles=false
        AddLocationFromOtherEmitter=1
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.1000000),Z=(Min=0.0000000,Max=0.1000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=3.0000000,Max=5.0000000),Y=(Min=3.0000000,Max=5.0000000),Z=(Min=3.0000000,Max=5.0000000))
        UniformSize=true
        InitialParticlesPerSecond=30.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Explosion.FxEx_plaster_spray01'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.7000000,Max=1.5000000)
        StartVelocityRange=(X=(Min=-25.0000000,Max=25.0000000),Y=(Min=-25.0000000,Max=25.0000000),Z=(Min=-25.0000000,Max=25.0000000))
        AddVelocityFromOtherEmitter=2
        AddVelocityMultiplierRange=(X=(Min=0.2000000,Max=0.2000000),Y=(Min=0.2000000,Max=0.2000000),Z=(Min=0.2000000,Max=0.2000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[3]=SpritePlume01
    // Reference: SpriteEmitter'SASBulletHitWall.SpritePlume02'
    begin object name=SpritePlume02 class=Class'Engine.SpriteEmitter'
        FadeOutStartTime=0.0500000
        FadeOut=true
        MaxParticles=20
        RespawnDeadParticles=false
        AddLocationFromOtherEmitter=0
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.1000000),Y=(Min=0.0000000,Max=0.1000000),Z=(Min=0.0000000,Max=0.1000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=3.0000000,Max=5.0000000),Y=(Min=3.0000000,Max=5.0000000),Z=(Min=3.0000000,Max=5.0000000))
        UniformSize=true
        InitialParticlesPerSecond=200.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
        Texture=Texture'SFXTx.Explosion.FxEx_plaster_spray01'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.7000000,Max=1.5000000)
        StartVelocityRange=(X=(Min=-25.0000000,Max=25.0000000),Y=(Min=-25.0000000,Max=25.0000000),Z=(Min=-25.0000000,Max=25.0000000))
        AddVelocityFromOtherEmitter=0
        AddVelocityMultiplierRange=(X=(Min=0.2000000,Max=0.2000000),Y=(Min=0.2000000,Max=0.2000000),Z=(Min=0.2000000,Max=0.2000000))
        GetVelocityDirectionFrom=3
    end object
    Emitters[4]=SpritePlume02
    // Reference: SpriteEmitter'SASBulletHitWall.Dust'
    begin object name=Dust class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOut=true
        CoordinateSystem=1
        MaxParticles=1
        RespawnDeadParticles=false
        SpinParticles=true
        StartSpinRange=(X=(Min=0.0000000,Max=1.0000000),Y=(Min=0.0000000,Max=1.0000000),Z=(Min=0.0000000,Max=1.0000000))
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        StartSizeRange=(X=(Min=4.0000000,Max=4.0000000),Y=(Min=100.0000000,Max=100.0000000),Z=(Min=100.0000000,Max=100.0000000))
        UniformSize=true
        InitialParticlesPerSecond=10.0000000
        AutomaticInitialSpawning=false
        DrawStyle=6
        Texture=Texture'SFXTx.Muzzle_Flashes.FxM_MuzzleSmoke_MP5_1st'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=0.5000000,Max=0.5000000)
        StartVelocityRange=(X=(Min=1.0000000,Max=5.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[5]=Dust
    AutoDestroy=true
    DrawScale=0.1000000
    Mass=4.0000000
    RemoteRole=1
    bNoDelete=false
    bTrailerSameRotation=true
}