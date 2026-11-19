class TurokAnimTransitionGraphItemAction extends TurokAnimTransitionGraphItemAnim
    native
    hidecategories(Object,Interrupt,Object,Mirror,AngleOffset,ContactPoint);

var(Action) float mAccuratePositionPercent;
var(Action) name mAffectedBone;

event OnGraphActionLocation(@NULL playbackInterface, out @NULL pos, out @NULL Rot, byte actorType)
{
    // End:0x45
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphPlayback(playbackInterface), TurokAnimInterfaceGraphPlayback(none)))
    {
        TurokAnimInterfaceGraphPlayback(playbackInterface).OnGraphActionLocation(self, pos, Rot, actorType);        
    }
    //return;    
}

defaultproperties
{
    mAccuratePositionPercent=0.2500000
    mAffectedBone="jt_Aux1_C"
    mbHasContactPoint=true
}