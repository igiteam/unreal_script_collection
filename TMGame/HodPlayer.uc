class HodPlayer extends HodSentient
	native(TG);

var HDPawn pawn;

function Construct()
{
	Super.Construct();
	level.player = self;
}

function Initialize(HDPawn iPawn)
{
	pawn = iPawn;
}

function vector GetShootAtPos()
{
	// need fixed
	return pawn.GetPawnViewLocation();
}

function Actor GetActor()
{
	return pawn;
}

function name GetStance()
{
	if ( pawn.bIsCrouched )
	   return 'crouch';
	if ( pawn.bIsProne )
	   return 'prone';
	return 'stand';
}

function vector GetEye()
{
	return pawn.GetPawnViewLocation();
}
