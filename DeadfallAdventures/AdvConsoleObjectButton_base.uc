class AdvConsoleObjectButton_base extends InterpActor
    hidecategories(Navigation);

var AdvConsoleObject_base ParentConsole;

event Destroyed()
{
    ParentConsole = none;
    super(Actor).Destroyed();
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvConsoleObjectButton_base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvConsoleObjectButton_base.MyLightEnvironment'
        Scale=0.1000000
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvConsoleObjectButton_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    CollisionType=ECollisionType.COLLIDE_BlockAll
    bCollideWhenPlacing=true
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    CollisionComponent=StaticMeshComponent0
}