class ACTION_TeleportPlayer extends LatentScriptedAction;

var(Action) name	DestinationTag;	// tag of the destination
var(Action) bool	bPlaySpawnEffect;	// boolean telling to play spawn effect
var(Action) name	OptionalFocusTag;	

var Actor	Dest,
			Focus;

function bool InitActionFor(ScriptedController C)
{
	local ZombiePlayerPawn P;
	Dest = C.SequenceScript.GetMoveTarget();

	if ( DestinationTag != 'None' )
	{
		ForEach C.AllActors(class'Actor',Dest,DestinationTag)
			break;
	}
	if ( OptionalFocusTag != 'None' )
	{
		ForEach C.AllActors(class'Actor',Focus,OptionalFocusTag)
			break;
	}

	ForEach C.DynamicActors(class'ZombiePlayerPawn',P)
		break;
	
	P.SetLocation(Dest.Location);
	
	if ( Focus == None )
	{
		P.SetRotation(Dest.Rotation);
		P.OldRotYaw = P.Rotation.Yaw;
	}
	else
	{
		P.Controller.SetRotation ( Rotator ( Normal ( Focus.Location - P.Location ) ) );
	}
	
	if ( bPlaySpawnEffect )
		P.PlayTeleportEffect(false,true);

	return false;	
}
