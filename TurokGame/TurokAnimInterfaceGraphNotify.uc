interface TurokAnimInterfaceGraphNotify extends Interface
    abstract;

simulated function NotifyGraphStart(@NULL graph, byte actorType)
{
    //return;    
}

simulated function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    //return;    
}

simulated function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    //return;    
}
