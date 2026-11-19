class UTAmbientSoundComponent extends AudioComponent
    editinlinenew
    collapsecategories
    hidecategories(Object,ActorComponent);

event OcclusionChanged(bool bNowOccluded)
{
    super.OcclusionChanged(bNowOccluded);
    //return;    
}

defaultproperties
{
    bStopWhenOwnerDestroyed=true
    bShouldRemainActiveIfDropped=true
    OcclusionCheckInterval=1.0000000
}