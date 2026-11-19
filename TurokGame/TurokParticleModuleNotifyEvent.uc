class TurokParticleModuleNotifyEvent extends TurokParticleModuleEvent
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

struct native ParticleNotifyEvent
{
    var() float Time;
    var() editinline @NULL Notify;
    var() name Comment;

    structdefaultproperties
    {
        Time=0.0000000
        Notify=none
        Comment="None"
    }
};

var() editinline array Notifies;

defaultproperties
{
    bUpdateModule=true
}