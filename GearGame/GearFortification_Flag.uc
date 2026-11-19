/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearFortification_Flag extends GearFortification
	abstract;

/** all fortifications with this base index become buildable after this flag has been built */
var repnotify byte BaseIndex;

/** if a player is within this radius, no enemies will spawn within the same radius unless no other spawn points are available */
var float SpawnProtectionRadius;

/** MIC with a parameter to show base index on the flag */
var MaterialInstanceConstant FlagMIC;

replication
{
	if (bNetInitial)
		BaseIndex;
}

// flags are invulnerable
function TakeDamage( int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum,
			class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser );
simulated function bool IsValidMeleeTarget(Pawn AskingPawn);

simulated function AddHUDLocator()
{
	// a little hacky: don't show on taccom in Siege since we are invulnerable
	if (WorldInfo.GRI == None || !ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSiege_Base'))
	{
		Super.AddHUDLocator();
	}
}

simulated function InitializeUpgradeLevel(byte NewLevel)
{
	local GearGRI_Horde HordeGRI;
	local GearFortificationMarker OtherMarker;

	Super.InitializeUpgradeLevel(NewLevel);

	SetupMIC();

	// add to GRI flag-only list
	HordeGRI = GearGRI_Horde(WorldInfo.GRI);
	if (HordeGRI != None)
	{
		HordeGRI.FortificationFlags.AddItem(self);
		if (HordeGRI.bCanPlaceFortifications)
		{
			foreach HordeGRI.FortificationMarkers(OtherMarker)
			{
				if (OtherMarker.SiegeBaseIndex == BaseIndex)
				{
					OtherMarker.SetEnabled(true);
				}
				else if (OtherMarker.FortificationType == Class)
				{
					// since flag cost changes based on how many there are, players may no longer be able to afford them
					OtherMarker.UpdateGhostMaterial();
				}
			}
		}
	}
}

/** sets up the MIC for the flag to show the base index */
simulated final function SetupMIC()
{
	if (FlagMIC == None)
	{
		FlagMIC = DisplayComponent[UpgradeLevel].CreateAndSetMaterialInstanceConstant(1);
	}
	FlagMIC.SetScalarParameterValue(name("Num" $ BaseIndex), 1.0);
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(BaseIndex) && UpgradeLevel != 255)
	{
		SetupMIC();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated event Destroyed()
{
	if (GearGRI_Horde(WorldInfo.GRI) != None)
	{
		GearGRI_Horde(WorldInfo.GRI).FortificationFlags.RemoveItem(self);
	}

	Super.Destroyed();
}

static simulated function int GetPurchaseCost(int Level, WorldInfo WI)
{
	local GearGRI_Horde GRI;
	local int BaseCost;

	BaseCost = Super.GetPurchaseCost(Level, WI);

	GRI = GearGRI_Horde(WI.GRI);
	return ((GRI != None) ? (BaseCost * GRI.FortificationFlags.length) : BaseCost);
}

defaultproperties
{
	StatName=Flag
	SpawnProtectionRadius=1500.0

	BuiltGUDEvent=GUDEvent_Horde_FlagBuilt
}
