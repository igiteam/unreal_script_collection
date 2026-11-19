class cover_wall_AngleRangeThread extends CoreTask within animscripts_cover_wall;

state main
{
Begin:
	endon ('killanimscript');
	notify ('newAngleRangeCheck');
	endon ('newAngleRangeCheck');
	endon ('return_to_cover');
	
	while (true)
	{
		if (needToChangeCoverMode())
			break;
		wait (0.1);
	}

	notify ('stopShooting'); // For changing shooting pose to compensate for player moving
}
