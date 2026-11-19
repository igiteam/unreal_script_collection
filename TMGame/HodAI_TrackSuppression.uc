class HodAI_TrackSuppression extends CoreTask within HodAI;

var float lDelta;

state main
{
Begin:
	endon ('death');

	lDelta = 0.01;
	if (team == 'allies')
		lDelta = 0.02;

	while (true)
	{
		waittill('suppression');

		while (suppressionMeter > 0)
		{
			suppressionMeter = FMax(suppressionMeter - lDelta, 0);
			wait (0.05);
		}
	}
}
