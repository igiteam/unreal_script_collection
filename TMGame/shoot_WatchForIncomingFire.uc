class shoot_WatchForIncomingFire extends CoreTask within animscripts_shoot_behavior;

state main
{
Begin:
	endon('killanimscript');
	endon('stop_deciding_how_to_shoot');
	
	while (true)
	{
		waittill('suppression');
		
		if (suppressionMeter > suppressionThreshold)
		{
			if (readyToReturnToCover())
			{
				notify('return_to_cover');
				shouldReturnToCover = true;
			}
		}
	}
}
