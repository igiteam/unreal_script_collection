/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_CoverHeadPushed_ByMomCorpser extends GSM_CoverHeadPushed
	config(Pawn);

defaultproperties
{
	BS_Start=(Stance=((Slot=BS_FullBody,AnimName="AR_Injured_CorpserReact_Start")))
	BS_Loop=(Stance=((Slot=BS_FullBody,AnimName="AR_Injured_CorpserReact_Idle")))
	BS_End=(Stance=((Slot=BS_FullBody,AnimName="AR_Injured_CorpserReact_End")))
}
