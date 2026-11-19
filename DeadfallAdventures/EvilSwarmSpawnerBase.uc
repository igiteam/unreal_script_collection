class EvilSwarmSpawnerBase extends EvilDestroyPackBase;

var() Vector SpawnOffset;

simulated event Destroyed()
{
    super.Destroyed();
    //return;    
}

defaultproperties
{
    ForceMeleeAction=false
    ShowMeleeMessage=false
    // Reference: CylinderComponent'Default__EvilSwarmSpawnerBase.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilSwarmSpawnerBase.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilSwarmSpawnerBase.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__EvilSwarmSpawnerBase.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=CollisionCylinder
    CollisionComponent=StaticMeshComponent0
}