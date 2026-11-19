/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearDroppedPickup_Shield extends GearDroppedPickup
	native(Weapon);

cpptext
{
	virtual UBOOL ShouldTrace(UPrimitiveComponent* Primitive,AActor *SourceActor, DWORD TraceFlags);
};

var repnotify bool bDeployed;
var repnotify bool bKicked;
var CoverLink_Spawnable DeployedLink_Rear, DeployedLink_Forward;
var SkeletalMeshComponent ShieldMeshComp;
var ParticleSystem DestructionSystem;

replication
{
	if (Role == ROLE_Authority)
		bDeployed, bKicked, DeployedLink_Rear, DeployedLink_Forward;
}

simulated event ReplicatedEvent(Name VarName)
{
	if (VarName == 'InventoryClass' && bDeployed)
	{
		// intentionally ignored
	}
	else if (VarName == 'bDeployed')
	{
		if (bDeployed)
		{
			SetPickupMesh(None);
			CreateDeployedMesh();
		}
		else
		{
			CleanUpDeployment();
		}
	}
	else if (VarName == 'bKicked')
	{
		if (bKicked)
		{
			if (ShieldMeshComp == None)
			{
				CreateDeployedMesh();
			}
			// simulate the kick over, setting up the mesh component, etc
			KickOver();
		}
		else
		{
			// otherwise hide the shield mesh component
			DetachComponent(ShieldMeshComp);
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

function PickedUpBy(Pawn P)
{
	local GearPawn GP;

	Super.PickedUpBy(P);

	bKicked = false;

	CleanUpDeployment();

	GP = GearPawn(P);
	if (GP != None && GP.EquippedShield == None)
	{
		GP.EquipShield(GearInventoryManager(GP.InvManager).Shield);
	}
	// check to see if we are an MP game
	if (Inventory == None && GearGRI(WorldInfo.GRI).IsMultiPlayerGame())
	{
		GearGame(WorldInfo.Game).GearBroadcastWeaponTakenMessage(P.Controller, class'GDT_ShieldBash');
	}

	// @STATS - Record shield pickup
	`RecordPlayerIntStat(SHIELD_PICKUP, P.Controller, 1);
}

simulated function Name FindInteractionWith(Pawn P, bool bExcludeChecks)
{
	local GearPawn GP;
	GP = GearPawn(P);
	if (GP != None && GP.CoverType != CT_None)
	{
		return 'None';
	}
	else if (bDeployed && CanKickOver(GearPawn(P), false))
	{
		return 'KickShield';
	}
	else if (!bDeployed || CanPickupDeployed(GearPawn(P)))
	{
		return 'PickupNonWeapon';
	}
	return 'None';
}

simulated function bool GetPickupAction(out ActionInfo out_PickupAction, out Name out_Interaction, Pawn P)
{
	local GearPawn GP;

	out_Interaction = FindInteractionWith(P, true);
	if (out_Interaction == 'PickupNonWeapon')
	{
		out_PickupAction = PickupAction;
		out_PickupAction.ActionName = Name;
		out_PickupAction.TooltipText = InventoryClass.default.ItemName;

		out_PickupAction.ActionIconDatas[2].ActionIcons[0] = class'GearShield'.default.PickupIcon;

		// if it is something that can be interacted with but can't be picked up, apply the NO symbol
		if (!CanBePickedUpBy(P))
		{
			out_PickupAction.ActionIconDatas[0].ActionIcons[0] = NoSymbolIcon;
		}
		return true;
	}
	else if (out_Interaction == 'KickShield')
	{
		GP = GearPawn(P);
		// Need to make sure we aren't carrying a shield so that we don't show
		// a kick icon when we actually can't kick it (CanBePickedUpBy will not allow it to happen)
		if (GP == None ||
			GP.EquippedShield == None)
		{
			out_PickupAction = class'SeqEvt_DoorOpen'.default.InteractAction;
			return true;
		}
	}

	return false;
}

/**
 * creates the component for a deployed shield
 *
 */
simulated final function CreateDeployedMesh()
{
	local class<GearShield> ShieldClass;
	local AnimNodeSequence AnimNode;

	ShieldClass = class<GearShield>(InventoryClass);
	ShieldMeshComp = new(self) ShieldClass.default.DeployedMesh.Class(ShieldClass.default.DeployedMesh);
	ShieldMeshComp.SetRotation(rot(0,-16384,0));
	ShieldMeshComp.SetLightEnvironment(MyLightEnvironment);

	CreateAndSetMICWeaponSkin( ShieldMeshComp );

	if (MIC_WeaponSkin != None)
	{
		MIC_WeaponSkin.SetScalarParameterValue('Weap_DroppedGlow', 0.0f);
		MIC_WeaponSkin.SetScalarParameterValue('Weap_DropGlowAlpha', 0.0f);
	}

	AttachComponent(ShieldMeshComp);
	AnimNode = AnimNodeSequence(ShieldMeshComp.Animations);
	AnimNode.SetAnim(ShieldClass.default.ExpandAnimName);
	AnimNode.SetPosition(AnimNode.AnimSeq.SequenceLength, false);

	// make the collision slightly bigger for catching rr->kick
	SetCollisionSize(80.0, MyCylinderComp.CollisionHeight);

	SetCollision(true, true);
	bProjTarget = TRUE;
}

function Deploy(GearPawn GP)
{
	local vector DeployLoc, HitLoc, HitNormal, FoundLocation, CheckLocation, Extent;
	local Actor HitActor;

	if (GP != None && GP.IsCarryingShield())
	{
		bDeployed = TRUE;
		DeployLoc = Location + MyCylinderComp.Translation;
		// drop down to the ground
		Extent = vect(10,10,10);
		Extent.Z = MyCylinderComp.CollisionHeight;
		HitActor = Trace(HitLoc, HitNormal, DeployLoc - vect(0,0,256), DeployLoc, true, Extent);
		if (HitActor != None && !IsZero(HitLoc))
		{
			// set slightly above the hit so that physics will still collide with the world
			DeployLoc = HitLoc + vect(0,0,8);
		}
		else
		{
			DeployLoc.Z -= 256.0;
		}
		DeployLoc -= MyCylinderComp.Translation;
		// place the shield in front of the pawn
		// ignore collision for SetLocation()
		bCollideWorld = false;
		SetLocation(DeployLoc);
		bCollideWorld = true;
		SetRotation(GP.Rotation);
		// add a mesh to block players
		CreateDeployedMesh();
		// create the two cover links for the shield
		// we always create the link where the Pawn is standing, since obviously that works
		DeployedLink_Rear = Spawn(class'CoverLink_Spawnable',,, Location - vector(Rotation) * 24.f + vect(0,0,32), Rotation,, true);
		// check if a Pawn can fit on the other side
		CheckLocation = Location + vector(Rotation) * 112.f; // needs to be this large due to mantle distance
		CheckLocation.Z = GP.Location.Z;
		FoundLocation = CheckLocation;
		Extent = GP.GetCollisionExtent();
		Extent.X *= 1.5;
		Extent.Y = Extent.X;
		if (FindSpot(Extent, FoundLocation) && VSize(FoundLocation - CheckLocation) < 0.1)
		{
			DeployedLink_Forward = Spawn(class'CoverLink_Spawnable',,, Location + vector(Rotation) * 54.f + vect(0,0,32), Rotation - rot(0,32768,0),, true);
		}
		SetupCoverLink(DeployedLink_Rear);
		if (DeployedLink_Forward != None)
		{
			SetupCoverLink(DeployedLink_Forward);
		}
		GearGame(WorldInfo.Game).DeployedShields.AddItem(self);
		bForceNetUpdate = true;
	}
}

final function SetupCoverLink(CoverLink_Spawnable NewLink)
{
	local CoverSlot Slot;

	// create and add a slot
	Slot.ForceCoverType = CT_MidLevel;
	Slot.CoverType = CT_MidLevel;
	Slot.bLeanLeft = TRUE;
	Slot.bLeanRight = TRUE;
	Slot.bCanPopUp = TRUE;
	Slot.bCanMantle = false;
	Slot.bCanCoverSlip_Left = !Slot.bCanMantle;
	Slot.bCanCoverSlip_Right = !Slot.bCanMantle;
	Slot.bCanSwatTurn_Left = FALSE;
	Slot.bCanSwatTurn_Right = FALSE;
	Slot.bEnabled = TRUE;
	Slot.LocationOffset = TransformVectorByRotation(NewLink.Rotation, vect(12.f,0,0), true);
	Slot.RotationOffset = rot(0,0,0);
//	Slot.MantleTarget.Actor = MantleTarget;
	NewLink.Slots[0] = Slot;

	// add the link the navigation network so we can take cover on it later
	NewLink.bAddToPathNetwork = TRUE;
	NewLink.UpdateCoverLink();
	NewLink.UpdateCoverSlot(0, true);
	NewLink.SetReplicatedSlot0(Slot);
}

/** Can the pawn kick this shield over?  Return TRUE if deployed and the Pawn is in front of the shield.
 * @param bIgnoreShieldRotation - if true, allow kick over from either direction; otherwise only when facing the front
 */
simulated function bool CanKickOver(GearPawn GP, bool bIgnoreShieldRotation)
{
	return ( bDeployed && !bKicked && !GP.IsCarryingAHeavyWeapon() && (bIgnoreShieldRotation || Normal(GP.Location - Location) dot vector(Rotation) > 0.2f) &&
		GP.CanDoSpecialMove(SM_DoorKick) && (vector(GP.Rotation) dot Normal(Location - GP.Location) > 0.2f) );
}

simulated function bool CanPickupDeployed(GearPawn GP)
{
	return bDeployed && (Normal(GP.Location - Location) dot vector(Rotation) < 0.2f) && (vector(GP.Rotation) dot Normal(Location - GP.Location) > 0.2f);
}

simulated function KickOver()
{
	local vector KickDir;

	KickDir = -vector(Rotation); // need to record here as the switch to PHYS_RigidBody will change it
	if (Role == ROLE_Authority)
	{
		bKicked = TRUE;
		SetLocation(Location + vect(0,0,1) * 32);
		SetRotation(Rotation - rot(0,-16384,0));
		PlaySound(GearShield(Inventory).ShieldRemoveFromGroundSound);
	}

	KnockDownPlantedShield(KickDir * 384.f + vect(0,0,64.f));
}

simulated protected function KnockDownPlantedShield(vector Impulse)
{
	CollisionComponent = ShieldMeshComp;
	ShieldMeshComp.PhysicsWeight = 1.0;
	ShieldMeshComp.SetHasPhysicsAssetInstance(true);
	SetPhysics(PHYS_RigidBody);
	SetCollision(true, false);
	bBlockActors = FALSE;
	bCollideWorld = TRUE;
	ShieldMeshComp.InitRBPhys();
	ShieldMeshComp.SetBlockRigidBody(TRUE);
	ShieldMeshComp.SetRBCollidesWithChannel(RBCC_Default,TRUE);
	ShieldMeshComp.SetRBCollidesWithChannel(RBCC_BlockingVolume,TRUE);
	ShieldMeshComp.SetRBCollidesWithChannel(RBCC_Pawn, false);
	ShieldMeshComp.SetRBChannel(RBCC_GameplayPhysics);
	ShieldMeshComp.SetRBLinearVelocity(Impulse, false);
	CleanUpDeployment(TRUE);
	SetTimer( 1.f,FALSE,nameof(TurnOffPawnCollision) );
}

simulated function TurnOffPawnCollision()
{
	if (ShieldMeshComp != None)
	{
		ShieldMeshComp.SetRBCollidesWithChannel(RBCC_Pawn,FALSE);
	}
}

simulated function CleanUpDeployment(optional bool bFromKick)
{
	local GearPC PC;
	local GearAI AI;
	local int Idx;
	local GearPawn GP;

	bDeployed = FALSE;
	if (Role == ROLE_Authority)
	{
		if (DeployedLink_Rear != None)
		{
			for (Idx = 0; Idx < DeployedLink_Rear.Claims.Length; Idx++)
			{
				GP = GearPawn(DeployedLink_Rear.Claims[Idx]);
				PC = GearPC(DeployedLink_Rear.Claims[Idx].Controller);
				if (PC != None)
				{
					PC.ClientBreakFromCover();
				}
				else
				{
					AI = GearAI(DeployedLink_Rear.Claims[Idx].Controller);
					if (AI != None)
					{
						AI.InvalidateCover();
					}
				}
				if (bFromKick && Role == ROLE_Authority && GP != None)
				{
					if (GP.IsCarryingAHeavyWeapon())
					{
						GP.ThrowActiveWeapon();
					}
					GP.DoStumbleFromMeleeSpecialMove(None);
				}
			}
			DeployedLink_Rear.Destroy();
			DeployedLink_Rear = None;
		}
		if (DeployedLink_Forward != None)
		{
			for (Idx = 0; Idx < DeployedLink_Forward.Claims.Length; Idx++)
			{
				PC = GearPC(DeployedLink_Forward.Claims[Idx].Controller);
				if (PC != None)
				{
					PC.ClientBreakFromCover();
				}
				else
				{
					AI = GearAI(DeployedLink_Forward.Claims[Idx].Controller);
					if (AI != None)
					{
						AI.InvalidateCover();
					}
				}
			}
			DeployedLink_Forward.Destroy();
			DeployedLink_Forward = None;
		}

		GearGame(WorldInfo.Game).DeployedShields.RemoveItem(self);
	}

	if (MIC_WeaponSkin != None)
	{
		MIC_WeaponSkin.SetScalarParameterValue('Weap_DroppedGlow', 1.0f);
		MIC_WeaponSkin.SetScalarParameterValue('Weap_DropGlowAlpha', 1.0f);
	}
}

event Bump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
	local GearPawn P;
	local int i;
	local bool bFriendlyShield;

	P = GearPawn(Other);
	if (P != None && GearAI(P.Controller) != None)
	{
		if (DeployedLink_Forward != None)
		{
			for (i = 0; i < DeployedLink_Forward.Claims.length; i++)
			{
				if (WorldInfo.GRI.OnSameTeam(DeployedLink_Forward.Claims[i], P))
				{
					bFriendlyShield = true;
					break;
				}
			}
		}
		if (!bFriendlyShield && DeployedLink_Rear != None)
		{
			for (i = 0; i < DeployedLink_Rear.Claims.length; i++)
			{
				if (WorldInfo.GRI.OnSameTeam(DeployedLink_Rear.Claims[i], P))
				{
					bFriendlyShield = true;
					break;
				}
			}
		}
		// AI kicks over enemy shields in its way
		//@todo: should check if can take cover here! but it needs firelinks and such...
		if (!bFriendlyShield)
		{
			if (CanKickOver(P, false))
			{
				SetTimer(0.85, false, nameof(KickOver));
				P.ServerDoSpecialMove(SM_DoorKick, true);
			}
			// see if we can pick it up
			else if ( CanPickupDeployed(P) && !P.IsDoingASpecialMove() && P.CanDoSpecialMove(SM_WeaponPickup) &&
				GearInventoryManager(P.InvManager).GetInventoryInSlot(EASlot_Holster) != None )
			{
				if (GearAI(P.Controller).FindCommandOfClass(class'AICmd_PickupWeapon') == None)
				{
					class'AICmd_PickupWeapon'.static.PickupWeaponFromPickup(GearAI(P.Controller), self);
				}
			}
			// see if the only reason we couldn't kick it over was because of shield facing and if so, ignore that and do it anyway
			else if (CanKickOver(P, true))
			{
				SetTimer(0.85, false, nameof(KickOver));
				P.ServerDoSpecialMove(SM_DoorKick, true);
			}
			// see if we can knock down shields with our standard melee attack
			else if (P.bCanMeleeShields && !P.bWantsToMelee && P.CanEngageMelee())
			{
				P.Controller.StopFiring();
				GearAI(P.Controller).bWeaponCanFire = true;
				P.StartMeleeAttack();
				SetTimer(0.85, false, nameof(KickOver));
				P.SetTimer(1.5, false, nameof(P.StopMeleeAttack));
			}
		}
	}
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	// prevent shield stacking
	if (!bScriptInitialized && Other.IsA('GearDroppedPickup_Shield') && GearDroppedPickup_Shield(Other).bDeployed)
	{
		Destroy();
	}
}

event Destroyed()
{
	Super.Destroyed();

	CleanUpDeployment(false);
}

simulated singular event BaseChange()
{
	if (Pawn(Base) != None)
	{
		SetBase(None);
	}
}

event EncroachedBy(Actor Other)
{
	// ignore this except for movers because it can happen when mantling over the shield and cause the shield to go poof
	if (InterpActor(Other) != None)
	{
		Destroy();
	}
}

auto state Pickup
{
	/** return true if Pawn can grab this pickup */
	simulated function bool CanBePickedUpBy(Pawn P)
	{
		local GearPawn MyGearPawn;

		MyGearPawn = GearPawn(P);
		return (MyGearPawn != None && MyGearPawn.EquippedShield == None && Super.CanBePickedUpBy(P));
	}
}


function TakeDamage( int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType,
			optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	// @fixme, make a flag in the damagetype or something?
	// maybe knock down shields on big explosions?
	if (DamageType == class'GDT_HeavySniperRifle')
	{
		PlayDestructionFX();
		Destroy();
	}
}

/** Play the destruction effects for the shield */
simulated function PlayDestructionFX()
{
	local ReplicatedSpawnedGearEmitter FragmentsEmitter;
	local GearShield Shield;

	Shield = GearShield(Inventory);

	if ( (Role == ROLE_Authority) && Shield != None)
	{
		FragmentsEmitter = ReplicatedSpawnedGearEmitter(Spawn(Shield.DestructionSystemClass, Self));
		if( FragmentsEmitter != None )
		{
			FragmentsEmitter.bPostUpdateTickGroup = true;
			FragmentsEmitter.SetBase( Self );
		}
	}
}

event Attach(Actor Other)
{
	Super.Attach(Other);

	if (GearPawn(Other) != None)
	{
		KickOver();
	}
}

defaultproperties
{
	Begin Object NAME=CollisionCylinder
		BlockZeroExtent=false
		Translation=(Z=40.0)
		CollisionRadius=60.0
		CollisionHeight=55.0
	End Object
	MyCylinderComp=CollisionCylinder
}
