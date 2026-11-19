class cmd_cover_arrival extends AICommand within TGAI;

var HodAI hod;

static function bool Start(HodAI iHod)
{
	local cmd_cover_arrival Cmd;
	local TGAI AI;

	AI = iHod.pawn.MyTGAI;
	if (AI != None)
	{
		Cmd = new(AI) class'cmd_cover_arrival';
		if(Cmd != None)
		{
			Cmd.hod = iHod;

			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}

function Tick(float DeltaTime)
{
	local NavigationPoint NewAnchor;
	local int Idx;

	if (hod.a.movement == 'stop')
	{
		Status = 'Success';
		NewAnchor = NavigationPoint(hod.node.data);
		if (NewAnchor != None)
		{
			// Update pawn's anchor
			Pawn.SetAnchor(NewAnchor);

			// Remove anything in the route cache up to our new movetarget
			Idx = RouteCache.Find(NewAnchor);
			if(Idx != INDEX_NONE)
			{
				RouteCache_RemoveIndex(0, Idx + 1);
			}
		}
		PopCommand(self);
	}
}
