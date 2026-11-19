class TurokAnimTransitionGraphItemEvent extends TurokAnimTransitionGraphItem
    native
    hidecategories(Object,Object);

var(Event) name mEvent;
var(Event) bool mHideSecondaryPawn;
var(Event) name mCamera;

event GraphEvent(@NULL aiInterface, byte actorType)
{
    // End:0x38
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphEvents(aiInterface), TurokAnimInterfaceGraphEvents(none)))
    {
        TurokAnimInterfaceGraphEvents(aiInterface).GraphEvent(self, actorType);
    }
    //return;    
}
