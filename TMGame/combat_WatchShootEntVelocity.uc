class combat_WatchShootEntVelocity extends CoreTask within animscripts_combat;

// local
var HodEntity lPrevShootEnt;
var vector lPrevPos;
var float lInterval;
var vector lCurPos;

state main
{
Begin:
	endon('killanimscript');

	shootEntVelocity = vect(0,0,0);

	lPrevShootEnt = obj_undefined;
	lPrevPos = origin;
	
	lInterval = 0.15;
	
	while (true)
	{
		if (obj_isdefined(shootEnt) && obj_isdefined(lPrevShootEnt) && shootEnt == lPrevShootEnt)
		{
			lCurPos = shootEnt.origin;
			shootEntVelocity = vectorScale(lCurPos - lPrevPos, 1.0 / lInterval);
			lPrevPos = lCurPos;
		}
		else
		{
			if (obj_isdefined(shootEnt))
				lPrevPos = shootEnt.origin;
			else
				lPrevPos = origin;
			lPrevShootEnt = shootEnt;
			
			shootEntVelocity = vect(0,0,0);
		}
		
		wait (lInterval);
	}
}
