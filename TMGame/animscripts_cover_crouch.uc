class animscripts_cover_crouch extends Object within HodAI;

function main(optional bool newThread = false)
{	
	run (new(self) class'cover_crouch_main', newThread);
}
