class TurokAnimTransitionGraphItemWeaponAnim extends TurokAnimTransitionGraphItemAnim
    native
    hidecategories(Object,Interrupt,Object);

var(WeaponAttachment) transient class<Class> mAttachmentPreview;
var(WeaponAttachment) transient bool mbPreviewRelaxed;

event @NULL OnGraphSpatialTarget(@NULL playbackInterface)
{
    // End:0x33
    if(NotEqual_InterfaceInterface(TurokAnimInterfaceGraphPlayback(playbackInterface), TurokAnimInterfaceGraphPlayback(none)))
    {
        return TurokAnimInterfaceGraphPlayback(playbackInterface).OnGraphSpatialTarget();
    }
    return vect(0.0000000, 0.0000000, 0.0000000);
    //return ReturnValue;    
}
