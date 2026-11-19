class TurokSeqEvent_AISeeEnemy extends SequenceEvent
    native
    hidecategories(Object);

var() float MaxSightDistance;
var() bool mbHumanOnly;
var() bool mbDinoOnly;
var() bool mbBugOnly;

event bool CheckInstigatorType(@NULL Dude)
{
    // End:0x72
    if(((mbHumanOnly && !Dude.IsA('TurokPawnHuman')) || mbDinoOnly && !Dude.IsA('TurokPawnDino')) || mbBugOnly && !Dude.IsA('TurokPawnBug'))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    MaxSightDistance=2500.0000000
    ObjName="Turok AI See Enemy"
    ObjCategory="Turok AI"
}