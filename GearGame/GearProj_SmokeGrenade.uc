/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_SmokeGrenade extends GearProj_Grenade;

/** How long to emit smoke. */
var() protected const config float 			CloudDuration;

/** in SP/Horde, make AI temporarily go insane within this radius */
var config float AIInsanityRadius;

simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local Emit_SmokeGrenade Smoke;
	local GearTargetingVisBlocker VisBlocker;
	local GearExplosionActor GEA;
	local GearPawn P;
	local GearProj_Grenade Grenade;
	local GearPRI KillerPRI;
	local vector StartTrace, EndTrace, HitL, HitN;

	if (!bIsSimulating && !bGrenadeHasExploded)
	{
		// regular explosion
		GEA = Super.TriggerExplosion(HitLocation, HitNormal, HitActor);

 		// plus smoke!
		// @todo, if attached to a pawn, spawn the smoke at the pawns feet?
		if (SmokeEmitterClass != None)
		{
			Smoke = Spawn( SmokeEmitterClass,,, HitLocation + HitNormal*3, rotator(HitNormal) );
			if (Smoke != None)
			{
				Smoke.bTriggeredByMartyr = (MartyrVictim != None);
				Smoke.bTriggeredBySticky = (TagVictim != None && Pawn(TagVictim) == None);
				Smoke.InstigatorController = InstigatorController;
				Smoke.SetEmissionDuration(CloudDuration);
			}
		}

		VisBlocker = Spawn(class'GearTargetingVisBlocker');
		if (VisBlocker != None)
		{
			VisBlocker.LifeSpan = CloudDuration;
		}

		if (Role == ROLE_Authority)
		{
			// SP/Horde enemies go insane from smoke
			if ( AIInsanityRadius > 0.0 &&
				(!WorldInfo.GRI.IsMultiplayerGame() || WorldInfo.GRI.IsCoopMultiplayerGame()) )
			{
				foreach CollidingActors(class'GearPawn', P, AIInsanityRadius)
				{
					if (P.GetTeamNum() == 1 && P.Health > 0)
					{
						P.GoBerzerk(CloudDuration + 2.0);
					}
				}
			}

			// tagging pawns in mp makes them go dbno
			P = GearPawn(TagVictim);
			if ( P != None && P.Health > 0 && P.DrivenVehicle == None && GearPawnRidable_Base(P.Base) == None &&
				!P.IsSpecialMeleeVictim() && !P.IsAHostage() && WorldInfo.GRI.IsMultiplayerGame() )
			{
				if (P.GetMaxDownCount() >= 0 && P.DownCount >= P.GetMaxDownCount())
				{
					// kill instead, because they're out of downs
					if (InstigatorController != None)
					{
						KillerPRI = GearPRI(InstigatorController.PlayerReplicationInfo);
						if (KillerPRI != None)
						{
							KillerPRI.ScoreInstantKill(GearPRI(P.PlayerReplicationInfo), PawnTaggedDamageType, GDT_Normal);
						}
						P.Died(InstigatorController, PawnTaggedDamageType, P.Location);
					}
				}
				else
				{
					GearPawn(TagVictim).EnterDBNO(InstigatorController, PawnTaggedDamageType, -HitNormal);
				}
			}

//			FlushPersistentDebugLines();
			// forcibly explode any other grenades in the blast radius
			foreach CollidingActors(class'GearProj_Grenade', Grenade, GEA.ExplosionTemplate.CringeRadius)
			{
				if (Grenade.bIsSimulating)
				{
					continue;
				}

				// slight delay, then blow up
				StartTrace = Location + LastHitNormal * 10.f;
				if (TagVictim != None)
				{
					EndTrace = Location - GetHeadFacingDir() * 10.f;
				}

				EndTrace = Grenade.Location;
				if (Grenade.TagVictim != None)
				{
					EndTrace = Grenade.Location - Grenade.GetHeadFacingDir() * 10.f;
				}

// 				DrawDebugBox(StartTrace, vect(5,5,5), 255, 255, 0, TRUE);
// 				DrawDebugBox(EndTrace, vect(5,5,5), 255, 255, 255, TRUE);
// 				DrawDebugLine(StartTrace, EndTrace, 255, 255, 128, TRUE);
				HitActor = Trace(HitL, HitN, EndTrace, StartTrace, FALSE,,,TRACEFLAG_Bullet);
				if (HitActor == None)
				{
					// trace is clear, blow up
					Grenade.SetTimer( RandRange(0.15f,0.45f), FALSE, nameof(DoExplosion) );
				}
			}
		}
	}

	return GEA;
}

static function float GetAIEffectiveRadius()
{
	return FMax(default.CringeRadius, default.KnockdownRadius);
}

defaultproperties
{
	Damage=0
	DamageRadius=0
	MyDamageType=none
	MomentumTransfer=0

	TaggedDamageType=class'GDT_SmokeSticky'	 // Stuck to wall explosion
	PawnTaggedDamageType=class'GDT_SmokeTag' // Stuck to player explosion

	InFlightSoundTemplate=SoundCue'Weapon_Grenade.SmokeGrenade.SmokeGrenadeWhipInAirLoopCue'
	GrenadeAttachingToFoeSound=SoundCue'Weapon_Grenade.SmokeGrenade.SmokeGrenadeStickEnemyCue'
	GrenadeAttachingToWorldSound=SoundCue'Weapon_Grenade.SmokeGrenade.SmokeGrenadeStickSurfaceCue'
	BeepBeepAboutToExplodeSound=SoundCue'Weapon_Grenade.SmokeGrenade.SmokeGrenadeWarningCue'
	GrenadeBounceSound=SoundCue'Weapon_Grenade.SmokeGrenade.SmokeGrenadeBounceCue'

	Begin Object Class=SkeletalMeshComponent Name=COGGrenadeMesh0
	    SkeletalMesh=SkeletalMesh'COG_Bolo_Grenade.Smoke_Grenade'
		PhysicsAsset=PhysicsAsset'COG_Bolo_Grenade.Smoke_Grenade_Physics'
		AnimTreeTemplate=AnimTree'COG_Bolo_Grenade.Animations.AT_BoloGrenade'
		AnimSets(0)=AnimSet'COG_Bolo_Grenade.GrenadeAnims'
		BlockActors=false
		bCastDynamicShadow=false
		BlockZeroExtent=true
		BlockNonZeroExtent=false
		CollideActors=true
		BlockRigidBody=true
		RBCollideWithChannels=(Default=true,Untitled2=true)
		Scale=1.5
		LightEnvironment=MyLightEnvironment
	bAcceptsDynamicDecals=false
	End Object
	Mesh=COGGrenadeMesh0
	Components.Add(COGGrenadeMesh0)

	Begin Object Name=CollisionCylinder
		CollideActors=true
	End Object

	TrailTemplate=ParticleSystem'COG_Smoke_Grenade.Effects.Smoke_Grenade_Smoke_Trail'

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_SmokeGrenade'
		MomentumTransferScale=0.0	// Scale momentum defined in DamageType

		ContentTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.SmokeGrenade.SmokeGrenade_Proj_Explo'

		PawnKnockdownEffort=GearEffort_ImpactCough

		bAllowMovementDuringCringe=true

		FractureMeshRadius=200.0
		FracturePartVel=500.0
	End Object
	ExplosionTemplate=ExploTemplate0

	GrenadeTagPreExplosionSmokeEffect=ParticleSystem'COG_Smoke_Grenade.Effects.P_COG_Smoke_Grenade_Stick_On'
	GrenadeTagPreExplosionSmokeEffectPlanted=ParticleSystem'COG_Smoke_Grenade.Effects.P_COG_Smoke_Grenade_Tagged'
	SmokeEmitterClass=class'Emit_SmokeGrenade'
}
