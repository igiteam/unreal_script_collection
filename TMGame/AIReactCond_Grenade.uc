/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
/** Grenade Reaction - listens for Projectile Warnings **/
class AIReactCond_Grenade extends AIReactCondition_Base;

/** GoW global macros */

event bool ShouldActivate( Actor DmgInst, AIReactChannel OrigChan )
{
	if(!Super.ShouldActivate(DmgInst,OrigChan))
	{
		return false;
	}

	if( MyTGPawn == None ||
		MyTGPawn.IsDoingASpecialMove() ||
		MyTGPawn.Health <= 0 ||
		MyTGPawn.IsDBNO() ||
		IsFriendlyPawn(DmgInst.Instigator) ||
		!bAllowCombatTransitions)
	{
		return false;
	}

	return true;
}

event Activate( Actor EventInstigator, AIReactChannel OriginatingChannel )
{
	local float Dist;
	local Projectile Proj;

	Super.Activate(EventInstigator,OriginatingChannel);
	Proj = Projectile(EventInstigator);

	// If we are not based on another pawn (ie reaver gunner)
	if( Pawn(Pawn.Base) == None )
	{
		//debug
		;

		if( FRand() <= ChanceToEvadeGrenade * GetEvadeChanceScale() )
		{
			Dist = VSize2D(MyTGPawn.Location - Proj.Location);
			if( Dist < Proj.DamageRadius * 1.5f &&
				FastTrace( MyTGPawn.Location, Proj.Location ) )
			{
				EvadeAwayFromPoint( Proj.Location );
			}
			else if (Dist < Proj.DamageRadius * 3.f)
			{
				MyTGPawn.Cringe(); // Cover Head
			}
		}
	}
}


