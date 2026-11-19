class SeqCond_CheckIsDemoGame extends SequenceCondition;

event Activated()
{
	local TPPlayerController PC;
	local bool bIsDemoMode;
	foreach GetWorldInfo().AllControllers(class'TPPlayerController', PC)
	{
		bIsDemoMode = PC.bIsDemoMode;
	}
	
	if (bIsDemoMode)
		OutputLinks[0].bHasImpulse = true;
	else
		OutputLinks[1].bHasImpulse = true;

	super.Activated();
}

