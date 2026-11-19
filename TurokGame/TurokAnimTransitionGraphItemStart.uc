class TurokAnimTransitionGraphItemStart extends TurokAnimTransitionGraphItem
    native
    hidecategories(Object,Object);

var(TransitionGraph) name mGraphName;
var(Locomotion) editconst array mStartParams;

event OnGraphStart(@NULL playbackInterface)
{
    // End:0x33
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphPlayback(playbackInterface), TurokAnimInterfaceGraphPlayback(none)))
    {
        TurokAnimInterfaceGraphPlayback(playbackInterface).OnGraphStart(self);
    }
    //return;    
}

event NotifyGraphStart(@NULL aiInterface, @NULL graph, byte actorType)
{
    // End:0x3C
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphNotify(aiInterface), TurokAnimInterfaceGraphNotify(none)))
    {
        TurokAnimInterfaceGraphNotify(aiInterface).NotifyGraphStart(graph, actorType);
    }
    //return;    
}
