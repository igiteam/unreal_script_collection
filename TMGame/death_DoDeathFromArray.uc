class death_DoDeathFromArray extends CoreTask within animscripts_death;

// parameter
var array<name> iDeathArray;

state main
{
Begin:
	playDeathAnim(iDeathArray[randomint(iDeathArray.length)]);
	//nate - adding my own special death flag on top of special death. 
	if (deathanimscript != none)
		deathanimscript.Execute();
}
