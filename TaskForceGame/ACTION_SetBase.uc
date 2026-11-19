class ACTION_SetBase extends ScriptedAction;

var()	Actor	NewBase;

function bool InitActionFor(ScriptedController C)
{
	if ( C.Pawn == None )
		return false;

	C.Pawn.bRotateToDesired = (NewBase == None);

	C.Pawn.SetBase(NewBase,vect(0,0,1));
	
	return false;	
}
