class SPKActorSpawnable extends SPKActor;

simulated function Initialize()
{
    SetHidden(false);
    StaticMeshComponent.SetHidden(false);
    SetPhysics(10);
    //return;    
}

simulated function Recycle()
{
    SetHidden(true);
    StaticMeshComponent.SetHidden(true);
    SetPhysics(0);
    ClearTimer('Recycle');
    //return;    
}
