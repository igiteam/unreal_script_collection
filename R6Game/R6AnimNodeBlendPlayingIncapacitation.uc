class R6AnimNodeBlendPlayingIncapacitation extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var transient float m_fTimeSinceLastRandom;
var transient R6GameEnums.EIncapaciteState m_ePrevState;
var transient bool m_bPlayingRandom;
var transient bool m_bLastWasReach;
var() bool m_bFirstPerson;

defaultproperties
{
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}