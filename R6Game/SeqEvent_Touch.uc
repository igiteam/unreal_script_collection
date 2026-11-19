class SeqEvent_Touch extends SequenceEvent
    native
    hidecategories(Object);

var() array< class<Actor> > ClassProximityTypes;
var() bool bForceOverlapping;
var() bool bUseInstigator;
var array<Actor> TouchedList;

defaultproperties
{
    ClassProximityTypes[0]=Class'Pawn'
    bForceOverlapping=true
    ReTriggerDelay=0.1000000
    OutputLinks[0]=(Links=none,LinkDesc="Touched",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="UnTouched",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    ObjName="Touch"
    ObjCategory="Physics"
}