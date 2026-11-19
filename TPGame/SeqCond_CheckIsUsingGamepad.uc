// Tells us what difficulty level we're playing on
class SeqCond_CheckIsUsingGamepad extends SequenceCondition;

event Activated()
{
	local TPPlayerController PC;
	local bool bUsingGamepad;
	foreach GetWorldInfo().AllControllers(class'TPPlayerController', PC)
	{
		bUsingGamepad = PC.PlayerInput.bUsingGamepad;
	}
	
	if (bUsingGamepad)
		OutputLinks[0].bHasImpulse = true;
	else
		OutputLinks[1].bHasImpulse = true;

	super.Activated();
}

