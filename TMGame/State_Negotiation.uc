class State_Negotiation extends CoreTask within HodAI;

// input
var HDNegoReachSpec iPath;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');

	switch (iPath.Agent.Type)
	{
	case NT_Climb:
		run (new(self) class'StateNegotiation_Climb', false);
		break;

	case NT_Jump:
		run (new(self) class'StateNegotiation_Jump', false);
		break;

	case NT_Over:
	case NT_ClimbOver:
		run (new(self) class'StateNegotiation_Over', false);
		break;
	}

	notify ('state negotiation end');
}
