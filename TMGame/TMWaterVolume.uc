/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMWaterVolume extends WaterVolume
	placeable;

/** effects to play based on what type of Actor you are **/
var ParticleSystem PS_EnterWaterEffect_Pawn;
var ParticleSystem PS_EnterWaterEffect_Vehicle;

var ParticleSystem ProjectileEntryEffect;

/**
 * We override this so we can play some water splash effects when a pawn enters the water
 *
 * NOTE: we don't differentiate between GroundSpeed and FallSpeed / AirSpeed
 **/
simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local ParticleSystem PS_WaterEffect;
	local ParticleSystemComponent PSC_WaterEffect;
	local float MaxSpeed;
	local float Vel;
	local float ParamValue;
	local EMoveDir MoveDir;
	local vector ParticleVect;
	local TMPawn TMP;

	Super.Touch( Other, OtherComp, HitLocation, HitNormal );

	if (WorldInfo.NetMode != NM_DedicatedServer && (WorldInfo.TimeSeconds - Other.LastRenderTime < 0.2) && Pawn(Other) != None)
	{
		//DrawDebugCoordinateSystem( HitLocation, Rotator(HitNormal), 64.f );

		TMP = TMPawn(Other);

		if( TMP != none )
		{
			if ( (TMP.Physics == PHYS_Walking) || (TMP.Physics == PHYS_Swimming) )
			{
				// no splash when walking or swimming
				return;
			}
			PS_WaterEffect = PS_EnterWaterEffect_Pawn;
			ParamValue = 1.0;
			MaxSpeed = TMP.GroundSpeed;
		}
		else if( TMVehicle(Other) != none )
		{
			PS_WaterEffect = PS_EnterWaterEffect_Vehicle;
			MaxSpeed = TMVehicle(Other).GroundSpeed;
		}
		else
		{
			PS_WaterEffect = PS_EnterWaterEffect_Vehicle;
			ParamValue = 1.0;
			MaxSpeed = class'Pawn'.default.GroundSpeed;
		}

		PSC_WaterEffect = WorldInfo.MyEmitterPool.SpawnEmitter( PS_WaterEffect, HitLocation, Rotator(HitNormal), self );

		if( PSC_WaterEffect != none )
		{
			MoveDir = Other.MovingWhichWay( Vel );
			if ( ParamValue == 0.0 )
			{
				ParamValue = 5.0 * Vel/MaxSpeed;
			}

			// this is the value between 0 and 5 which the PS desires
			//`log( "MoveDir: " $ MoveDir $ " Vel: " $ Vel $ " ParamValue: " $ ParamValue );
			switch( MoveDir )
			{
			case MD_Forward: ParticleVect = vect(1,0,0) * ParamValue; break;
			case MD_Backward: ParticleVect = vect(-1,0,0) * ParamValue; break;
			case MD_Left: ParticleVect = vect(0,-1,0) * ParamValue; break;
			case MD_Right: ParticleVect = vect(0,1,0) * ParamValue; break;
			case MD_Down: ParticleVect = vect(1,0,0) * ParamValue; break;
			case MD_Up: ParticleVect = vect(1,0,0) * ParamValue; break;
			default:  break;
			}

			PSC_WaterEffect.SetVectorParameter( 'Direction', ParticleVect );
		}
	}
}

simulated function PlayEntrySplash(Actor Other)
{
	if( EntrySound != None )
	{
		Other.PlaySound(EntrySound);
		if ( Other.Instigator != None )
			Other.MakeNoise(1.0);
	}
	if ( !WorldInfo.bDropDetail && WorldInfo.NetMode != NM_DedicatedServer && Other.IsA('Projectile')
		&& (Other.Instigator != None) && Other.Instigator.IsPlayerPawn() && Other.Instigator.IsLocallyControlled() )
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(ProjectileEntryEffect, Other.Location, rotator(vect(0,0,1)));
	}
}

