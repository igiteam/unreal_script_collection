class init_AITurnNotifies extends CoreTask within HodAnim;

// parameter

// output

// local
var int lNumTurnsThisFrame;
var int lMaxAIPerFrame;
var AIArrayStruct ai;
var int i;
var bool lDoNothing;

state main
{
Begin:
	lNumTurnsThisFrame = 0;
	lMaxAIPerFrame = 3;
	while (true)
	{
		lDoNothing = true;
		ai = getAIArray();
		if (ai.data.length == 0)
		{
			lDoNothing = false;
			wait (0.05);
			lNumTurnsThisFrame = 0;
			continue;
		}
		for (i = 0; i < ai.data.length; i++)
		{
			if (!obj_isdefined(ai.data[i]))
				continue;
			ai.data[i].notify('do_slow_things');
			lNumTurnsThisFrame++;
			if (lNumTurnsThisFrame == lMaxAIPerFrame)
			{
				lDoNothing = false;
				wait (0.05);
				lNumTurnsThisFrame = 0;
			}
		}
		if (lDoNothing)
			wait (0);
	}
}
