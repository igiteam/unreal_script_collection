class AdvConsoleObjectMPDLC1_base extends InterpActor
    hidecategories(Navigation);

simulated function InitializeButtons()
{
    //return;    
}

simulated function ButtonClick(Pawn InInstigator, Actor ActorHit)
{
    //return;    
}

simulated function ButtonUnclick(Pawn InInstigator)
{
    //return;    
}

function bool OverButton(Actor ActorHit)
{
    return false;
    //return ReturnValue;    
}

function UpdateKismet(Pawn InInstigator)
{
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvConsoleObjectMPDLC1_base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvConsoleObjectMPDLC1_base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvConsoleObjectMPDLC1_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
}