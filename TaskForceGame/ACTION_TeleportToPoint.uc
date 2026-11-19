class ACTION_TeleportToPoint extends LatentScriptedAction;

var(Action) name	DestinationTag;	// tag of destination - if none, then use the ScriptedSequence
var(Action) bool	bPlaySpawnEffect;
var(Action) name	OptionalFocusTag;	

var Actor	Dest,
			Focus;

function bool InitActionFor(ScriptedController C)
{
	local Pawn P;
	Dest = C.SequenceScript.GetMoveTarget();

	if ( DestinationTag != '' )
	{
		ForEach C.AllActors(class'Actor',Dest,DestinationTag)
			break;
	}
	if ( OptionalFocusTag != '' )
	{
		ForEach C.AllActors(class'Actor',Focus,OptionalFocusTag)
			break;
	}
	P = C.GetInstigator();
	P.SetLocation(Dest.Location);
	if ( Focus == None )
	{
		P.SetRotation(Dest.Rotation);
	}
	else
	{
        P.SetRotation ( Rotator ( Normal ( Focus.Location - P.Location ) ) );
		C.ScriptedFocus = Focus;
	}
	P.OldRotYaw = P.Rotation.Yaw;

	if ( bPlaySpawnEffect )
		P.PlayTeleportEffect(false,true);
	return false;	
}
