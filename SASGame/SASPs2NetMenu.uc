//=============================================================================
// SASPs2NetMenu.uc
//
// Placeable object that signifys (and controls) the join network game screen.
// Place in a level to make the level "the network game join level".
//=============================================================================

class SASPs2NetMenu extends Actor
	placeable;

var bool bDone;

event Tick(float aDelta)
{
	local PlayerController P;

	if (!bDone)
	{
		if (Level != None)
		{
			P = Level.GetLocalPlayerController();
			if (P != None)
			{
				// Kick off the menus.
				// We start the join game menu here for now, eventually this will be a whole suite of menus.
				P.SetPause(true);
				P.ClientOpenMenu("SASGUI.SASJoinGameMenu");
				bDone = true;
			}
		}
	}
}

