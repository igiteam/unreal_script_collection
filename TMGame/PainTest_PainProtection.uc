class PainTest_PainProtection extends DelegatePainTest;

function bool Execute(HodAI hod)
{
	return hod.maps__gameskill.pain_protection();
}
