class PainTest_AlwaysPain extends DelegatePainTest;

function bool Execute(HodAI hod)
{
	return hod.maps__gameskill.always_pain();
}
