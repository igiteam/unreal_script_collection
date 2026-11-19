/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** Grenade Reaction - listens for Projectile Warnings **/
class AIReactCond_Grenade extends AIReactCondition_Base;

/** GoW global macros */

event bool ShouldActivate( Actor DmgInst, AIReactChannel OrigChan )
{
	return (Super.ShouldActivate(DmgInst, OrigChan) && CanEvade() && !IsFriendlyPawn(DmgInst.Instigator) && bAllowCombatTransitions);
}

event Activate(Actor EventInstigator, AIReactChannel OriginatingChannel)
{
	local float Dist;
	local GearProjectile Proj;

	Super.Activate(EventInstigator, OriginatingChannel);

	Proj = GearProjectile(EventInstigator);

	// If we are not based on another pawn (ie reaver gunner)
	if( Pawn(Pawn.Base) == None )
	{
		if( Proj != none )
		{
			//debug
			`AILog(GetFuncName() @ Proj @ VSize2D(Pawn.Location - Proj.Location) @ (Proj.DamageRadius * 1.5f) @ FastTrace(Pawn.Location, Proj.Location));

			if (FRand() <= ChanceToEvadeGrenade * GetEvadeChanceScale())
			{
				Dist = VSize2D(Pawn.Location - Proj.Location);
				if ( Dist < Proj.DamageRadius * 1.5 &&
					// check center and head for trace since explosions in the air can hit from the other side of cover
					(Proj.bAIReactWithoutLOS || FastTrace(Pawn.Location, Proj.Location) || FastTrace(Pawn.Location - vect(0,0,1) * Pawn.GetCollisionHeight(), Proj.Location)) )
				{
					EvadeAwayFromPoint(Proj.Location);
				}
				else if (Dist < Proj.DamageRadius * 3.0 && MyGearPawn != None && (GearAI_TDM(Outer) == None || GetDifficultyLevel() < DL_Hardcore))
				{
					// if it's in the back, stumble away instead of cringe
					if ((Proj.Location - Pawn.Location) Dot vector(Pawn.Rotation) < 0.f)
					{
						MyGearPawn.Stumble();
					}
					else
					{
						MyGearPawn.Cringe(); // Cover Head
					}
				}
			}
		}
		else
		{
			Dist = VSize2D(Pawn.Location - EventInstigator.Location);
			if (FRand() <= ChanceToEvadeGrenade * GetEvadeChanceScale())
			{
				if( FastTrace(Pawn.Location, EventInstigator.Location) ||
					 FastTrace(Pawn.Location - vect(0,0,1) * Pawn.GetCollisionHeight(), EventInstigator.Location) )
				{
					EvadeAwayFromPoint(EventInstigator.Location);
				}
			}
		}
	}
}


defaultproperties
{
	AutoSubscribeChannels(0)=WarnProjExplode
}
