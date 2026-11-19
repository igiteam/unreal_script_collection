/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/
class AIReactCond_CoverExposed extends AIReactCond_Conduit_Base
	within TGAI_Cover;


event bool ShouldActivate( Actor EventInstigator, AIReactChannel OrigChan )
{
	if (!Super.ShouldActivate(EventInstigator,OrigChan))
	{
		return false;
	}

	if(HasValidCover() && IsCoverExposedToAnEnemy(Cover,Pawn(EventInstigator)))
	{
		return TRUE;
	}

	return FALSE;
}

