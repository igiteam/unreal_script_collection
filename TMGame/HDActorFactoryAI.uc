//-----------------------------------------------------------
//  ?????
//-----------------------------------------------------------
class HDActorFactoryAI extends TMActorFactoryAI;

//`define BY_TMBOT

/**
  * Initialize factory created bot
  */
simulated event PostCreateActor(Actor NewActor)
{
	local HDBot Bot;
	local HDPawn NewPawn;
	local int idx;

	NewPawn = HDPawn(NewActor);
	if ( NewPawn != None )
	{
		//????ControllerClass???Controller?????PostCreateActor???????????
		Bot = NewPawn.Spawn(class'HDBot',,, NewPawn.Location, NewPawn.Rotation);
		if ( Bot != None )
		{
			// handle the team assignment
			Bot.SetTeam(TeamIndex);
			// force the controller to possess, etc
			Bot.Possess(newPawn, false);

			Bot.WorldInfo.Game.Numbots++;

          














			if (Bot.PlayerReplicationInfo != None && PawnName != "" )
				Bot.PlayerReplicationInfo.SetPlayerName(PawnName);
		}

		// create any inventory
		if (bGiveDefaultInventory && newPawn.WorldInfo.Game != None)
		{
			newPawn.WorldInfo.Game.AddDefaultInventory(newPawn);
		}
		for ( idx=0; idx<InventoryList.Length; idx++ )
		{
			newPawn.CreateInventory( InventoryList[idx], false  );
		}
	}
}

