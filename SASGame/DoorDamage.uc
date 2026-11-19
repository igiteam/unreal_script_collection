class DoorDamage extends SASEmitter;

//-----------------------------------------------------------------------------
// Default properties

// Contains parameters for exploding monitors to be used for damage states


// Decompiled with UE Explorer.
defaultproperties
{
    Emitters[0]=none
    // Reference: MeshEmitter'DoorDamage.MeshEmitter1'
    begin object name=MeshEmitter1 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'TbeSm.ECM2_OBJECTS.obt052_doorsplinter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-600.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.5000000,Max=0.5000000),Y=(Min=0.5000000,Max=0.5000000),Z=(Min=0.5000000,Max=0.5000000))
        MaxCollisions=(Min=2.0000000,Max=2.0000000)
        FadeOutStartTime=0.7000000
        FadeOut=true
        MaxParticles=40
        RespawnDeadParticles=false
        StartLocationOffset=(X=-10.0000000,Y=30.0000000,Z=60.0000000)
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-30.0000000,Max=30.0000000),Z=(Min=-30.0000000,Max=40.0000000))
        UseRotationFrom=1
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-0.1000000,Max=-1.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=0.1000000,Max=0.7000000),Y=(Min=0.1000000,Max=0.7000000),Z=(Min=0.1000000,Max=0.7000000))
        InitialParticlesPerSecond=100.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=-200.0000000,Max=-700.0000000),Y=(Min=-600.0000000,Max=600.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[1]=MeshEmitter1
    // Reference: MeshEmitter'DoorDamage.MeshEmitter2'
    begin object name=MeshEmitter2 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'TbeSm.ECM2_OBJECTS.obt052_doorsplinter'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-600.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.5000000,Max=0.5000000),Y=(Min=0.5000000,Max=0.5000000),Z=(Min=0.5000000,Max=0.5000000))
        MaxCollisions=(Min=2.0000000,Max=2.0000000)
        FadeOutStartTime=0.7000000
        FadeOut=true
        MaxParticles=40
        RespawnDeadParticles=false
        StartLocationOffset=(X=10.0000000,Y=30.0000000,Z=60.0000000)
        StartLocationRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=-30.0000000,Max=30.0000000),Z=(Min=-30.0000000,Max=40.0000000))
        UseRotationFrom=1
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=0.0000000,Max=0.0000000),Y=(Min=0.1000000,Max=1.0000000),Z=(Min=0.0000000,Max=0.0000000))
        StartSizeRange=(X=(Min=0.1000000,Max=0.7000000),Y=(Min=0.1000000,Max=0.7000000),Z=(Min=0.1000000,Max=0.7000000))
        InitialParticlesPerSecond=100.0000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=1.0000000,Max=1.0000000)
        StartVelocityRange=(X=(Min=200.0000000,Max=700.0000000),Y=(Min=-600.0000000,Max=600.0000000),Z=(Min=0.0000000,Max=0.0000000))
    end object
    Emitters[2]=MeshEmitter2
    AutoDestroy=true
    LightBrightness=230.0000000
    LightRadius=2.0000000
    LightType=1
    LightHue=116
    LightSaturation=240
    LightPeriod=10
    bNoDelete=false
}