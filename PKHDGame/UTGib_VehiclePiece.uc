class UTGib_VehiclePiece extends UTGib_Vehicle
    config(Game)
    notplaceable
    hidecategories(Navigation);

simulated event PreBeginPlay()
{
    super(Actor).PreBeginPlay();
    //return;    
}

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__UTGib_VehiclePiece.GibLightEnvironmentComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'GibLightEnvironmentComp'
    // Archetype: DynamicLightEnvironmentComponent'Default__UTGib_Vehicle.GibLightEnvironmentComp'
    begin object name="GibLightEnvironmentComp"
    end object
    GibLightEnvironment=GibLightEnvironmentComp
    Components[0]=GibLightEnvironmentComp
}