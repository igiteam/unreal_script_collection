/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** allows an LD to pre-place a fortification that players can choose to purchase */
class GearFortificationMarker extends Actor
	native
	placeable
	hidecategories(Display,Collision);

cpptext
{
	virtual void PostLoad();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
#if WITH_EDITOR
	virtual void CheckForErrors();

	// ignore these as the fortification spawning doesn't support them so they'll just end up making the editor view diverge from the game view
	virtual void EditorApplyScale(const FVector& DeltaScale, const FMatrix& ScaleMatrix, const FVector* PivotLocation, UBOOL bAltDown, UBOOL bShiftDown, UBOOL bCtrlDown)
	{
	}

	virtual void EditorApplyMirror(const FVector& MirrorScale, const FVector& PivotLocation)
	{
	}
#endif
}

/** the type of fortification to spawn here */
var() class<GearFortification> FortificationType;
/** Light environment applied to GhostImage. */
var DynamicLightEnvironmentComponent GhostLightEnvironment;
/** component used to show players where to go */
var transient MeshComponent GhostImage;
/** reference to the spawned fortification, so we don't allow players to spawn another here */
var GearFortification SpawnedFortification;

/** materials used on the ghost image ingame depending on whether the player can buy it */
var MaterialInterface CanBuyMaterial, CannotBuyMaterial;

/** if set to a valid upgrade level for the requested fortification, will cause that fortification to be spawned at level startup */
var() byte AutoSpawnLevel;

/** if set, associated with an enemy base for the Siege gametype (one base is picked to be fortified each wave)
 * if zero, this marker is not used in Siege
 */
var() byte SiegeBaseIndex;
/** whether this marker is used in Horde */
var() bool bActiveInHorde;
/** whether this marker is used in Siege */
var() bool bActiveInSiege;

/** FLAGS ONLY - if a player is within this radius, no enemies will spawn within the same radius unless no other spawn points are available */
var() float FlagSpawnProtectionRadius;

/** updates the GhostImage to match the current FortificationType and whether we're editor or game */
native final function UpdateGhostImage();

simulated function PreBeginPlay()
{
	// some fortifications have editor-specific meshes, so we need to make sure the ghost image is up to date
	UpdateGhostImage();

	Super.PreBeginPlay();

	if (Role == ROLE_Authority && AutoSpawnLevel != 255)
	{
		// we need to wait a tick in case any .ini reloading is going to happen
		SetTimer(0.1, false, nameof(DelayedAutoSpawn));
	}
}

/** called on a timer to spawn the fortification when automatic spawn on startup is desired */
final function DelayedAutoSpawn()
{
	SpawnFortification(None, AutoSpawnLevel);
}

/** applies the proper material for whether local players can purchase this fortification */
simulated final function UpdateGhostMaterial()
{
	local MaterialInterface MaterialToUse;
	local GearPC PC;
	local int i;

	//@FIXME: need real splitscreen support
	MaterialToUse = CannotBuyMaterial;
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		if (PC.CanPayFortificationCost(FortificationType))
		{
			MaterialToUse = CanBuyMaterial;
			break;
		}
	}
	for (i = 0; i < GhostImage.GetNumElements(); i++)
	{
		GhostImage.SetMaterial(i, MaterialToUse);
	}
}

/** enables/disables the marker for fortification placement */
simulated function SetEnabled(bool bNowEnabled)
{
	local GearGRI_Horde HordeGRI;
	local GearFortification_Flag Flag;

	// we can't be enabled if we already spawned something or have nothing to spawn
	if (!bActiveInHorde || FortificationType == None || SpawnedFortification != None)
	{
		bNowEnabled = false;
	}
	if (bNowEnabled && FortificationType.default.bRequiresFlag)
	{
		HordeGRI = GearGRI_Horde(WorldInfo.GRI);
		if (HordeGRI != None && HordeGRI.bHasFortificationFlags && !ClassIsChildOf(FortificationType, class'GearFortification_Flag'))
		{
			bNowEnabled = false;
			foreach HordeGRI.FortificationFlags(Flag)
			{
				if (SiegeBaseIndex == Flag.BaseIndex)
				{
					bNowEnabled = true;
					break;
				}
			}
		}
	}

	SetCollision(bNowEnabled);
	if (bNowEnabled)
	{
		UpdateGhostMaterial();

		if (!GhostImage.bAttached)
		{
			AttachComponent(GhostImage);
		}
	}
	else if (GhostImage.bAttached)
	{
		DetachComponent(GhostImage);
	}
}

/** called to spawn a fortification using this marker
 * @param FortOwner - The controller that is attempting to construct the fortification
 * @param UpgradeLevel - The level of fortification to spawn
 * @param bFree - whether to build the fortification for free (don't reduce player cash)
 */
final function SpawnFortification(Controller FortOwner, byte UpgradeLevel, optional bool bFree)
{
	local GearPawn GP;
	local int Cost;

	if (!bFree)
	{
		Cost = FortificationType.static.GetPurchaseCost(UpgradeLevel, WorldInfo);
	}
	SpawnedFortification = Spawn(FortificationType, FortOwner);
	if (SpawnedFortification != None)
	{
		SpawnedFortification.Marker = self;
		SpawnedFortification.ApplyMarkerScale(DrawScale * DrawScale3D);
		if (GearFortification_Flag(SpawnedFortification) != None)
		{
			GearFortification_Flag(SpawnedFortification).BaseIndex = SiegeBaseIndex;
			GearFortification_Flag(SpawnedFortification).SpawnProtectionRadius = FlagSpawnProtectionRadius;
		}
		SpawnedFortification.InitializeUpgradeLevel(UpgradeLevel);
		if (SpawnedFortification != None && !SpawnedFortification.bDeleteMe)
		{
			if (FortOwner != None)
			{
				FortOwner.PlayerReplicationInfo.Score -= Cost;
				FortOwner.PlayerReplicationInfo.bForceNetUpdate = true;
				if (GearPC(FortOwner) != None)
				{
					GearPC(FortOwner).ClientFortificationInvestment(FortificationType, Cost);
				}

				// play sound if placed by player
				SpawnedFortification.PlaySound(SpawnedFortification.BuildSound);

				if (SpawnedFortification.BuiltGUDEvent != GUDEvent_None)
				{
					GearGame(WorldInfo.Game).TriggerGUDEvent(SpawnedFortification.BuiltGUDEvent, FortOwner.Pawn);
				}
			}
			SetEnabled(false);

			if (FortOwner != None)
			{
				// update markers for local player if necessary
				if (FortOwner.IsLocalPlayerController())
				{
					GearGRI_Horde(WorldInfo.GRI).UpdateFortificationGhostImages();
				}
				// play anim on builder
				GP = GearPawn(FortOwner.Pawn);
				if (GP != None && GP.CanDoSpecialMove(SM_PushButton))
				{
					GP.ServerDoSpecialMove(SM_PushButton);
				}
			}

			`RecordFortificationEvent(FortOwner,GFET_Purchased, self);
			TriggerEventClass(class'SeqEvent_FortificationNotify', FortOwner, 0);
		}
	}
}

/** called when our SpawnedFortification is destroyed */
simulated function FortificationDestroyed()
{
	SpawnedFortification = None;
	if (GearGRI_Horde(WorldInfo.GRI) != None && GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications)
	{
		SetEnabled(true);
	}
}

function OnBuildFortification(SeqAct_BuildFortification Action)
{
	local Controller FortOwner;

	if (SpawnedFortification == None)
	{
		FortOwner = Controller(Action.Builder);
		if (FortOwner == None && Pawn(Action.Builder) != None)
		{
			FortOwner = Pawn(Action.Builder).Controller;
		}
		SpawnFortification(FortOwner, Action.UpgradeLevel, true);
	}
}

defaultproperties
{
	Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnv
		bEnabled=true
		// Use cheap shadowing from the environment
		bUseBooleanEnvironmentShadowing=true
		bDynamic=false
		bForceNonCompositeDynamicLights=TRUE // needed since we are using a static light environment, otherwise dynamic lights won't have any affect
		TickGroup=TG_DuringAsyncWork
	End Object
	Components.Add(LightEnv)
	GhostLightEnvironment=LightEnv

	Begin Object Class=CylinderComponent Name=Cyl
		CollisionRadius=95.0
		CollisionHeight=72.0
		CollideActors=true
		BlockZeroExtent=false
	End Object
	CollisionComponent=Cyl
	Components.Add(Cyl)

	Begin Object Class=SpriteComponent Name=EditorSprite
		Sprite=Texture2D'EditorResources.S_Actor'
		AlwaysLoadOnClient=false
		AlwaysLoadOnServer=false
		HiddenGame=true
	End Object
	Components.Add(EditorSprite)

	RemoteRole=ROLE_None
	bNoDelete=true
	bEdShouldSnap=true

	AutoSpawnLevel=255
	bActiveInHorde=true
	bActiveInSiege=true

	FlagSpawnProtectionRadius=1500.0

	CanBuyMaterial=MaterialInstanceConstant'Effects_Gameplay.Horde.MI_GameplayObject_Horde_Green'
	CannotBuyMaterial=MaterialInstanceConstant'Effects_Gameplay.Horde.MI_GameplayObject_Horde_Red'

	SupportedEvents.Empty()
	SupportedEvents.Add(class'SeqEvent_CommandCenter')
	SupportedEvents.Add(class'SeqEvent_FortificationNotify')
}
