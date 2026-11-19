class TurokParticleNotifySound extends TurokParticleNotify
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() @NULL SoundCue;
var() bool bFollowActor;
var() bool bStopWhenOwnerDestroyed;

defaultproperties
{
    bFollowActor=true
}