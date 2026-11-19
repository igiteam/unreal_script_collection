class ACTION_ShootTarget extends ScriptedAction;

var(Action) int NumShots;
var(Action) name FiringMode;
var(Action) bool bSpray;
var(Action) bool bEmptyClip;

function bool InitActionFor(ScriptedController C)
{
	C.NumShots = NumShots;
	C.FiringMode = FiringMode;
	C.bShootTarget = true;
	C.bShootSpray = bSpray;
	C.bEmptyClip = bEmptyClip;
	return false;	
}


// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="shoot target"
}