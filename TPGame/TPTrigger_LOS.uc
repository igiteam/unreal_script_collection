class TPTrigger_LOS extends Trigger;

 // PI / 180.0



/**
 * Overridden to check for any players looking at this
 * trigger, based on the angle
 */
simulated function Tick(float DeltaTime)
{
	local array<SequenceEvent> losEvents;
	local SeqEvent_TPLOS evt;
	local PlayerController Player;
	local int idx;
	local vector  cameraLoc;
	local rotator cameraRot;
    local vector  TriggerToPlayer;
	local float   Angle;

	// if any valid los events are attached,
	if (FindEventsOfClass(class'SeqEvent_TPLOS',losEvents))
	{
		// look through each player
		foreach WorldInfo.AllControllers(class'PlayerController', Player)
		{
			if (Player.Pawn != None)
			{
				player.GetPlayerViewPoint(cameraLoc, cameraRot);
                TriggerToPlayer = Normal(location - Player.Pawn.Location);

				Angle = vector(cameraRot) dot TriggerToPlayer;

                // iterate through each event and see if this meets the activation requirements
				for (idx = 0; idx < losEvents.Length; idx++)
				{
					evt = SeqEvent_TPLOS(losEvents[idx]);
					if (Angle >= cos(evt.AngleCenterDegrees*0.0174533) &&
						VSize(player.Pawn.Location-Location) <= evt.TriggerDistance &&
						(!evt.bCheckForObstructions ||
						 player.LineOfSightTo(self,cameraLoc)))
					{
						// attempt to activate the event
						losEvents[idx].CheckActivate(self,player.Pawn,false);
					}
				}
			}
		}
	}
}

