/**
 * This is just a Faux SpecialMove which allows us to display ActionInfos on the HUD
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class GSM_EvadeFromCoverStanding extends GSM_EvadeFromCoverBase
	DependsOn(TGPawn);

/** GoW global macros */

protected function bool InternalCanDoSpecialMove()
{
	return CanEvadeFromCover(CT_Standing);
}

