class UTVehicleDeathPiece extends UTGib_Vehicle
    config(Game)
    notplaceable
    hidecategories(Navigation);

var export editinline ParticleSystemComponent PSC;

simulated event PreBeginPlay()
{
    super(Actor).PreBeginPlay();
    //return;    
}

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__UTVehicleDeathPiece.Particles'
    begin object name=Particles class=Class'Engine.ParticleSystemComponent'
        ReplacementPrimitive=none
    end object
    PSC=Particles
    // Reference: DynamicLightEnvironmentComponent'Default__UTVehicleDeathPiece.GibLightEnvironmentComp'
    begin object name=GibLightEnvironmentComp
    end object
    GibLightEnvironment=GibLightEnvironmentComp
    // Reference: EvilGibStaticMeshComponent'Default__UTVehicleDeathPiece.VehicleGibStaticMeshComp'
    begin object name=VehicleGibStaticMeshComp class=Class'EvilGibStaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__UTVehicleDeathPiece.GibLightEnvironmentComp'
        CachedMaxDrawDistance=8000.0000000
        CollideActors=true
        RBCollideWithChannels=(Pawn=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        ScriptRigidBodyCollisionThreshold=1.0000000
    end object
    GibMeshComp=VehicleGibStaticMeshComp
    Components[0]=GibLightEnvironmentComp
    Components[1]=VehicleGibStaticMeshComp
    Components[2]=Particles
    CollisionComponent=VehicleGibStaticMeshComp
}