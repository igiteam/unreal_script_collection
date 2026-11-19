class TurokUIKeyFrame extends Object
    native;

var float KeyTime;
var byte InterpMode;
var bool KeyFired;
var bool HasDelegate;
//var delegate<@NULL> __KeyFunc__Delegate;

delegate KeyFunc()
{
    //return;    
}

function SetDelegate(delegate<@NULL> func)
{
    HasDelegate = true;
    __KeyFunc__Delegate = func;
    //return;    
}
