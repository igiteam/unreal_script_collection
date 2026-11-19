class UIAction_EndMovie extends UIAction
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