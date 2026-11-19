class TurokAnimNotify_Sound extends AnimNotify
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() @NULL SoundCue;
var() bool bFollowActor;
var() bool replicated;
var() bool repToOwner;
var() bool bAutoDestroy;
var() name BoneName;

defaultproperties
{
    bFollowActor=true
    bAutoDestroy=true
}