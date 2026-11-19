class ActorFactoryAmbientSound extends ActorFactory
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() /*0x04000000-0x00000000*/ SoundCue AmbientSoundCue;

defaultproperties
{
    MenuName="Add AmbientSound"
    NewActorClass=Class'AmbientSound'
}