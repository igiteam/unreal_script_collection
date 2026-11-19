class corner_AngleRangeThread extends CoreTask within animscripts_corner;

state main
{
Begin:
	endon ('killanimscript');
	notify ('newAngleRangeCheck');
	endon ('newAngleRangeCheck');
	endon ('take_cover_at_corner');
	
	while (true)
	{
		if (shootPosOutsideLegalYawRange())
			break;
		wait (0.1);
	}

	notify ('stopShooting'); // For changing shooting pose to compensate for player moving
}
