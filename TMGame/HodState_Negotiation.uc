class HodState_Negotiation extends HodState;

var HodAI iHod;
var HDNegoReachSpec iPath;

static function bool Run(HodAI lHod, HDNegoReachSpec lPath)
{
	local HodState_Negotiation Cmd;
	local TGAI AI;

	AI = lHod.pawn.MyTGAI;
	if (AI != None)
	{
		Cmd = new(AI) class'HodState_Negotiation';
		if( Cmd != None )
		{
			Cmd.iHod = lHod;
			Cmd.iPath = lPath;

			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();
	iHod.notify ('killanimscript');
	pawn.ZeroMovementVariables();
	iHod.DoNegotiation(self);
	iHod.ignore_pain = TRUE;
}

function Popped()
{
	local int Idx;
	local NavigationPoint NewAnchor;
	Super.Popped();
	if (Status == 'Success')
	{
		NewAnchor = NavigationPoint(iPath.End.Actor);
		MyTGPawn.SetAnchor(NewAnchor);
		// Remove anything in the route cache up to our new movetarget
		Idx = RouteCache.Find( NewAnchor );
		if( Idx != INDEX_NONE )
		{
			RouteCache_RemoveIndex( 0, Idx + 1 );
		}
	}
	MyTGPawn.SetCollision(TRUE, TRUE);
	MyTGPawn.SetCollisionType(COLLIDE_BlockAllButWeapons);

	MyTGPawn.SetCollisionSize(MyTGPawn.default.CylinderComponent.CollisionRadius, MyTGPawn.default.CylinderComponent.CollisionHeight);
	MyTGPawn.SetPhysics(PHYS_Walking);
	iHod.ignore_pain = FALSE;
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	Status = ChildStatus;
	PopCommand(self);
}

function Finish(optional name iState = 'Success')
{
	Status = iState;
	PopCommand(self);
}
