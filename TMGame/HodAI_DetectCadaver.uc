class HodAI_DetectCadaver extends CoreTask within HodAI;

// input
var bool iEnable;

// output

// local
var TGPawn lPawn;

state main
{
Begin:
	notify ('disable detect cadaver');
	if (!iEnable)
		_return();

	endon ('death');
	endon ('disable detect cadaver');

	while (true)
	{
		if (pawn.Health <= 0)
			break;
		if (pawn.MyTGAI != none)
		{
			foreach pawn.worldInfo.AllPawns(class'TGPawn', lPawn, pawn.Location, pawn.SightRadius)
			{
				if (pawn == lPawn)
					continue;

				if (lPawn.Health > 0)
					continue;

				if (lPawn.IsA('TGPawn_EnemyBase') != pawn.IsA('TGPawn_EnemyBase'))
					continue;

				if ((anglestoforward(angles) dot Normal(lPawn.Location - pawn.Location)) < Pawn.PeripheralVision)
					continue;

				if (!SightTracePassed(GetEye(), lPawn.Location, false))
					if (!SightTracePassed(GetEye(), lPawn.GetPawnViewLocation(), false))
						continue;

				pawn.TriggerEventClass(class'SeqEvent_DetectCadaver', lPawn);
			}
		}

		wait (0.5);
	}
}
