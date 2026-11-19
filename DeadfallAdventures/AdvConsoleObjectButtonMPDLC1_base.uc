class AdvConsoleObjectButtonMPDLC1_base extends InterpActor
    hidecategories(Navigation);

var AdvConsoleObjectMPDLC1_base ParentConsole;

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvConsoleObjectButtonMPDLC1_base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvConsoleObjectButtonMPDLC1_base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvConsoleObjectButtonMPDLC1_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
}