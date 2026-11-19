class ShellEject_MP5Wpn extends SASEmitter;


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: MeshEmitter'ShellEject_MP5Wpn.ShellEject_MP5Wpn0'
    begin object name=ShellEject_MP5Wpn0 class=Class'Engine.MeshEmitter'
        StaticMesh=StaticMesh'SFXSm.Shells.Pistol_Shell'
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-530.0000000)
        UseCollision=true
        DampingFactorRange=(X=(Min=0.4000000,Max=0.4000000),Y=(Min=0.4000000,Max=0.4000000),Z=(Min=0.4000000,Max=0.4000000))
        MaxParticles=40
        RespawnDeadParticles=false
        StartLocationOffset=(X=20.0000000,Y=20.0000000,Z=10.0000000)
        UseRotationFrom=1
        SpinParticles=true
        SpinsPerSecondRange=(X=(Min=-1.0000000,Max=4.0000000),Y=(Min=-2.0000000,Max=2.0000000),Z=(Min=-1.0000000,Max=2.0000000))
        DampRotation=true
        RotationDampingFactorRange=(X=(Min=0.7000000,Max=0.7000000),Y=(Min=0.7000000,Max=0.7000000),Z=(Min=0.7000000,Max=0.7000000))
        Sounds=/* Array type was not detected. */
        DeathSound=3
        DeathSoundProbability=(Min=1.0000000,Max=1.0000000)
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.5000000,Max=0.5000000)
        StartVelocityRange=(X=(Min=70.0000000,Max=100.0000000),Y=(Min=0.0000000,Max=0.0000000),Z=(Min=70.0000000,Max=100.0000000))
    end object
    Emitters[0]=ShellEject_MP5Wpn0
    Mass=4.0000000
    bNoDelete=false
    bTrailerSameRotation=true
}