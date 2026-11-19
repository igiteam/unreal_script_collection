interface TurokAnimInterfaceGraphPlayback extends Interface
    abstract;

simulated function OnGraphStart(@NULL Start)
{
    //return;    
}

simulated function OnGraphEndToLoco(@NULL End, @NULL locoAsset, @NULL Params, float residualTick, byte actorType)
{
    //return;    
}

simulated function OnGraphEndToGraph(@NULL End, @NULL graph, float residualTick, byte actorType, @NULL aiInterface)
{
    //return;    
}

simulated function @NULL OnGraphSpatialTarget()
{
    //return ReturnValue;    
}

simulated function OnGraphActionLocation(@NULL Action, out @NULL pos, out @NULL Rot, byte actorType)
{
    //return;    
}
