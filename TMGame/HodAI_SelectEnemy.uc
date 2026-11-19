class HodAI_SelectEnemy extends CoreTask within HodAI;

state main
{
Begin:
	endon ('death');

	while (true)
	{
		pawn.MyTGAI.SelectTarget();
		if (enemy != none)
			in_combat_time = float(GetTime()) / 1000.0;
		wait (0.2);
	}
}
