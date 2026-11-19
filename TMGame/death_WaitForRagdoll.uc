class death_WaitForRagdoll extends CoreTask within animscripts_death;

// parameter
var float time;

// output

// local

state main
{
Begin:
	wait(time);
	startragdoll();
	animscripts_shared.DropAllAIWeapons();
	//if (isdefined(self))
	//	self startragdoll();
	//if (isdefined(self))
	//	self animscripts\shared::DropAllAIWeapons();
}
