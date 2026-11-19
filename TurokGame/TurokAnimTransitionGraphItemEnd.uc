class TurokAnimTransitionGraphItemEnd extends TurokAnimTransitionGraphItem
    native
    hidecategories(Object,Object);

var(blend) float mBlendTime;
var(TransitionGraph) name mGraphName;
var(Locomotion) editconst array mEndParams;

event OnGraphEndToLoco(@NULL playbackInterface, @NULL locoAsset, @NULL Params, float residualTick, byte actorType)
{
    // End:0x47
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphPlayback(playbackInterface), TurokAnimInterfaceGraphPlayback(none)))
    {
        TurokAnimInterfaceGraphPlayback(playbackInterface).OnGraphEndToLoco(self, locoAsset, Params, residualTick, actorType);
    }
    //return;    
}

event NotifyGraphEndToLoco(@NULL aiInterface, @NULL graph, @NULL locoAsset, byte actorType)
{
    // End:0x41
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphNotify(aiInterface), TurokAnimInterfaceGraphNotify(none)))
    {
        TurokAnimInterfaceGraphNotify(aiInterface).NotifyGraphEndToLoco(graph, locoAsset, actorType);
    }
    //return;    
}

event OnGraphEndToGraph(@NULL playbackInterface, @NULL graph, float residualTick, byte actorType, @NULL aiInterface)
{
    // End:0x47
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphPlayback(playbackInterface), TurokAnimInterfaceGraphPlayback(none)))
    {
        TurokAnimInterfaceGraphPlayback(playbackInterface).OnGraphEndToGraph(self, graph, residualTick, actorType, aiInterface);
    }
    //return;    
}

event NotifyGraphEndToGraph(@NULL aiInterface, @NULL prevGraph, @NULL newGraph, byte actorType)
{
    // End:0x41
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphNotify(aiInterface), TurokAnimInterfaceGraphNotify(none)))
    {
        TurokAnimInterfaceGraphNotify(aiInterface).NotifyGraphEndToGraph(prevGraph, newGraph, actorType);
    }
    //return;    
}

defaultproperties
{
    mBlendTime=0.2000000
}