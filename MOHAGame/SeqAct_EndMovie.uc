class SeqAct_EndMovie extends SequenceAction
    hidecategories(Object);

event Activated()
{
    Class'Engine.MoviePlayer'.static.StopMovie();
    //return;    
}

defaultproperties
{
    ObjName="End Movie"
    ObjCategory="MoviePlayer"
}