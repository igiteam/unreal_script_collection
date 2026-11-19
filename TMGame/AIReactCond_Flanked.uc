/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
/** Flanked Reaction Condition - activates when we discover an enemy who is flanking us **/
class AIReactCond_Flanked extends AIReactCondition_Base;

var ESpecialMove SpecialMoveToPlay;

event bool ShouldActivate( Actor EventInstigator, AIReactChannel OriginatingChannel )
{
	local Vector	VectToEnemy, VectToKnown, X, Y, Z;
	local float		DotP;
	local Pawn		DamageInstigator;

	if(!Super.ShouldActivate(EventInstigator,OriginatingChannel))
	{
		return false;
	}

	//// Don't flinch for skorge
	//// or if we're evading
	//if (TGPawn_LocustSkorgeBase(EventInstigator) != None || (MyTGPawn != None && MyTGPawn.IsEvading()))
	//{
	//	return FALSE;
	//}

	DamageInstigator = Pawn(EventInstigator);
	SpecialMoveToPlay = SM_None;
	// Check if we should give a flank reacton
	if( MyTGPawn != None &&
		FRand() < ChanceToBeSuprisedByFlank )
	{
		VectToEnemy = Normal(DamageInstigator.Location-MyTGPawn.Location);
		VectToKnown = Normal(GetEnemyLocation( DamageInstigator )-MyTGPawn.Location);

		DotP = VectToEnemy dot VectToKnown;

		// only be surprised if they're in a different direction that we wanted them to be
		if( DotP < 0.4f ||
			PerceptionMood == AIPM_Unaware  ||
			PerceptionMood == AIPM_Oblivious )
		{
//			MessagePlayer(Outer@"FlankedCheck - dotp:"$DotP$" P:"$DamageInstigator@CombatMood@PerceptionMood);

			SpecialMoveToPlay = SM_FlankedReaction_Front;

			GetAxes(MyTGPawn.Rotation, X, Y, Z);

			// If they are actually on our flank (or behind us)
			DotP = X DOT VectToEnemy;
			if( DotP < 0.4f )
			{
				// Pick appropriate direction and play reaction
				DotP = Y DOT VectToEnemy;
				if( DotP > 0.4 )
				{
					SpecialMoveToPlay = SM_FlankedReaction_Right;
				}
				else
				if( DotP < -0.4 )
				{
					SpecialMoveToPlay = SM_FlankedReaction_Left;
				}
				else
				{
					SpecialMoveToPlay = SM_FlankedReaction_Back;
				}
			}
		}
	}

	if( SpecialMoveToPlay != SM_None )
	{
		return TRUE;
	}

	return FALSE;
}

event Activate( Actor EventInstigator, AIReactChannel OriginatingChannel )
{
	Super.Activate(EventInstigator,OriginatingChannel);
	//@note: we deliberately skip the TGAI::ProcessStimulus() as that will trigger unnecessary extra reactions
	if (Squad != None)
	{
		Squad.ProcessStimulus(Outer, Pawn(EventInstigator), PT_Force, 'Flanked');
	}
	SetEnemy( Pawn(EventInstigator) );
	NotifyFlankedByEnemy( SpecialMoveToPlay );
}


