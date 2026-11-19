/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** a deployable defensive Actor */
class GearFortification extends GearMeleeTarget
	abstract
	native
	config(Game);

/** Light environment applied to DisplayComponents. */
var DynamicLightEnvironmentComponent FortificationLightEnvironment;
/** primary visual component for each upgrade level, used for the pre-placement ghost image */
var array<MeshComponent> DisplayComponent;
/** component used to represent this fortification in the editor (if None, DisplayComponent[0] is used instead) */
var editoronly MeshComponent EditorDisplayComponent;
/** whether the DisplayComponent should be set as the CollisionComponent when initializing the fortification */
var bool bDisplayCompIsCollisionComp;

/** what upgrade level this fortification is (for indexing into various attribute arrays) */
var protectedwrite repnotify byte UpgradeLevel;
/** how many points this fortification costs to deploy at each upgrade level */
var config array<int> Cost;
/** maximum portion of the cost that can be recovered (i.e. you get Cost * this if you immediately tear down after spawning) */
var config float TearDownRecoveryPct;
/** percentage of cost to repair a fortification */
var config float RepairCostPct;
/** points/XP awarded for destroying this fortification (split amongst all who damage it) */
var config int ScoringValue;
/** starting health values at each upgrade level */
var config array<int> StartingHealth;
/** how much damage this fortification can take before it is destroyed */
var repnotify int Health;
/** replicated flag so client enters/leaves Crippled state */
var repnotify bool bCrippled;
/** set when InitializeUpgradeLevel() has been called locally */
var bool bInitializedUpgradeLevel;

/** copy of display component visible when in the deployment phase and this fortification needs to be repaired */
var MeshComponent RepairGlow;
/** materials used on the repair glow depending on whether the player can repair it */
var MaterialInterface CanRepairMaterial, CannotRepairMaterial;

/** sound played when the fortification is constructed */
var SoundCue BuildSound;
/** sound played when the fortification is repaired */
var SoundCue RepairSound;
/** sound played when the fortification explodes; i.e, is destroyed by damage */
var SoundCue ExplosionSound;
/** explosion when destroyed */
var ParticleSystem ExplosionEffect;
/** array of sounds of which one is chosen when the fortification is upgraded */
var SoundCue UpgradeSound;

/** marker used to spawn this fortification (if any) */
var repnotify GearFortificationMarker Marker;
/** player(s) who have built or upgraded this fortification */
var array<Controller> Builders;
/** last time this fortification was built, upgraded, or repaired (used to prevent multiple simultaneous actions) - server only */
var float LastModifyTime;

/** button display to show on HUD when the player is in range to activate a special effect of this fortification */
var ActionInfo InteractAction;
/** button display to show on HUD when the player can build this fortification */
var ActionInfo BuildAction;
var localized string BuildActionTooltip;
/** button display to show on HUD when the player can repair/rebuild this fortification */
var ActionInfo RepairAction;
var localized string RepairActionTooltip, RebuildActionTooltip;
/** button display to show on HUD when the player can reload this fortification */
var ActionInfo ReloadAction;
var localized string ReloadActionTooltip;
/** button display to show on HUD when the player can upgrade this fortification */
var ActionInfo UpgradeAction;
var localized string UpgradeActionTooltip, UpgradeLockedTooltip;
/** human readable name of fortification to display on HUD */
var localized string DisplayName;

/** GUD to play when the fortification is built */
var EGUDEventID BuiltGUDEvent;
/** GUD to play when the fortification is upgraded */
var EGUDEventID UpgradedGUDEvent;
/** GUD to play when the fortification is repaired */
var EGUDEventID RepairedGUDEvent;
/** GUD to play when the fortification is destroyed */
var EGUDEventID DestroyedGUDEvent;

/** if set, cannot build this fortification unless the flag fortification that matches the marker is present */
var bool bRequiresFlag;

/** whether damage caused by this fortification is credited to the builder(s) */
var bool bScoreDamageCaused;

/** base name of stat entry in GearStatManager */
var name StatName;

replication
{
	if (bNetDirty)
		Health, TearDownRecoveryPct, bCrippled;
	if (bNetInitial)
		Marker, UpgradeLevel;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// add to GRI
	if (GearGRI_Horde(WorldInfo.GRI) != None)
	{
		GearGRI_Horde(WorldInfo.GRI).Fortifications.AddItem(self);
	}

	AddHUDLocator();

	if (Role == ROLE_Authority)
	{
		Builders[0] = Controller(Owner);
		// start out being able to sell for full value until this deployment phase has passed
		// this allows players to correct accidental placement without being penalized
		TearDownRecoveryPct = 1.0;

		LastModifyTime = WorldInfo.TimeSeconds;
	}
}

/** add HUD locator icon for all local players */
simulated function AddHUDLocator()
{
	local GearPC PC;
	local GearHUD_Base HUD;

	// tell the HUD for all local players to add a locator for us
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		HUD = GearHUD_Base(PC.myHUD);
		if (HUD != None)
		{
			HUD.AddHUDLocator(class'GearHUDLocator_Fortification', self);
		}
	}
}

simulated event Destroyed()
{
	if (Marker != None && Marker.SpawnedFortification == self)
	{
		Marker.FortificationDestroyed();
	}
	if (GearGRI_Horde(WorldInfo.GRI) != None)
	{
		GearGRI_Horde(WorldInfo.GRI).Fortifications.RemoveItem(self);
	}

	Super.Destroyed();
}

/** called to allow the fortification to optionally handle any scaling applied by the LD on the marker used to spawn this fortification
 * @note: not called for upgrades, pass along any values via UpgradedWith()
 */
function ApplyMarkerScale(vector InScale);

/** sets up the fortification's values and components for the specified upgrade level
 * @note: it is OK to fail here by destroying the fortification (the player will not be charged the cost if that happens)
 */
simulated function InitializeUpgradeLevel(byte NewLevel)
{
	UpgradeLevel = NewLevel;
	if (Role == ROLE_Authority)
	{
		Health = StartingHealth[NewLevel];
	}
	DisplayComponent[NewLevel].SetLightEnvironment(FortificationLightEnvironment);
	AttachComponent(DisplayComponent[NewLevel]);
	if (bDisplayCompIsCollisionComp)
	{
		CollisionComponent = DisplayComponent[NewLevel];
		//@hack: toggle collision on and off to update touching actors and such
		//	should change CollisionComponent to be set by a native so that's automatic
		SetCollision(false);
		SetCollision(true);
	}

	bInitializedUpgradeLevel = true;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(Marker))
	{
		// update the marker on the client instead of having the fortification marker itself replicated
		// besides saving on replicated Actors, this also guarantees that the marker's enabled state
		// is in sync with the presence of the actual fortification on the client
		if (Marker != None)
		{
			Marker.SpawnedFortification = self;
			Marker.SetEnabled(false);
		}
	}
	else if (VarName == nameof(UpgradeLevel))
	{
		InitializeUpgradeLevel(UpgradeLevel);
		// in case Health was already handled before UpgradeLevel
		UpdateRepairGlow();
		UpdateDamagedEffects();
	}
	else if (VarName == nameof(Health))
	{
		// InitializeUpgradeLevel() might not have happened yet so check for that
		if (bInitializedUpgradeLevel)
		{
			UpdateRepairGlow();
			UpdateDamagedEffects();
		}
	}
	else if (VarName == nameof(bCrippled))
	{
		if (bCrippled)
		{
			Explode(false);
		}
		else
		{
			GotoState('Auto');
		}
	}
}

simulated event byte ScriptGetTeamNum()
{
	// only COG can place fortifications
	return 0;
}

function TakeDamage( int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum,
			class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	local GearPRI PRI;
	local GearAI AI;
	local GearPawn GP;
	local class<GearDamageType> GDT;
	local float Score;

	if (!WorldInfo.GRI.OnSameTeam(EventInstigator, self) && (GearFortification(DamageCauser) == None || !WorldInfo.GRI.OnSameTeam(DamageCauser, self)))
	{
		// apply scaling from damagetype
		GDT = class<GearDamageType>(DamageType);
		if (GDT != None)
		{
			DamageAmount *= GDT.default.FortificationDamageScale;
		}
		if (EventInstigator != None)
		{
			// check for enemy type that causes instant destruction
			GP = GearPawn(EventInstigator.Pawn);
			if (GP != None && GP.bInstakillsFortifications)
			{
				DamageAmount = Max(DamageAmount, Health);
			}
			// award score
			PRI = GearPRI(EventInstigator.PlayerReplicationInfo);
			if (PRI != None)
			{
				Score = PRI.ModifyScore(Max(1, ScoringValue * (FMin(float(DamageAmount), float(Health)) / float(StartingHealth[UpgradeLevel]))), eEXP_Kills);
				if (Score > 0 && GearPC(EventInstigator) != None)
				{
					GearPC(EventInstigator).ClientAddKillPoints(Score);
				}
			}
		}
		// deal the damage
		Health -= DamageAmount;
		`RecordFortificationEvent(EventInstigator, GFET_Damaged, Marker);
		if (Health <= 0)
		{
			Explode(false);
			if (GearPC(EventInstigator) != None)
			{
				GearPC(EventInstigator).ClientModifyStat(name(StatName$"Destroyed"), 1);
			}
		}
		UpdateDamagedEffects();
		bForceNetUpdate = true;

		// notify friendly AI
		if (EventInstigator != None && EventInstigator.Pawn != None)
		{
			foreach WorldInfo.AllControllers(class'GearAI', AI)
			{
				if (WorldInfo.GRI.OnSameTeam(AI, self))
				{
					AI.ProcessStimulus(EventInstigator.Pawn, PT_Heard, 'FortHurtNotify');
				}
			}
		}
	}
}

/** called after taking/repairing damage to update any effects that are health related */
simulated function UpdateDamagedEffects();

/** @return whether this fortification cannot be built by TestPawn because it is too close and is encroaching on where we would be built */
static function bool IsEncroachingOnBuildLocation(Pawn TestPawn, vector BuildLoc, rotator BuildRot);

/** retrieves the HUD action icon info for building this fortification */
static final function GetBuildActionInfo(GearPC PC, out ActionInfo Action)
{
	Action = default.BuildAction;
	if (!PC.CanPayFortificationCost(default.Class))
	{
		Action.ActionIconDatas[0].ActionIcons[0] = class'GearPickupFactory'.default.NoSymbolIcon;
	}
	Action.TooltipText = default.BuildActionTooltip @ default.DisplayName $ ":" @ GetPurchaseCost(0, PC.WorldInfo);
}

/** used when a Pawn bumps into us; if it's an AI enemy, make it melee the target to damage it */
static final function CheckAIBumpMeleeAttack(GearPawn GP, Actor Target)
{
	if ( !GP.IsDoingRun2CoverSpecialMove() && GP.MyGearAI != None && !GP.MyGearAI.IgnoreNotifies() && !GP.bWantsToMelee &&
		!GP.WorldInfo.GRI.OnSameTeam(GP, Target) &&
		GP.MyGearAI.FindCommandOfClass(class'AICmd_Melee_Forced') == None &&
		GP.MyGearAI.FindCommandOfClass(class'AICmd_Attack_Melee') == None )
	{
		// have AIs with heavy weapons shoot us down instead, so they don't have to worry about dropping it and picking it up again
		if (GP.IsCarryingAHeavyWeapon())
		{
			GP.MyGearAI.FireTarget = Target;
			GP.MyGearAI.Focus = Target;
			class'AICmd_Attack_FireFromOpen'.static.FireFromOpen(GP.MyGearAI);
		}
		else
		{
			class'AICmd_Melee_Forced'.static.ForceMelee(GP.MyGearAI, Target, true);
		}
	}
}

event Bump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
	local GearPawn GP;

	GP = GearPawn(Other);
	if (GP != None)
	{
		if (GP.bInstakillsFortifications)
		{
			// no need to melee, simple bump from this enemy will kill us
			TakeDamage(Health, GP.Controller, GP.Location, Normal(GP.Velocity), class'GearDamageType');
		}
		else
		{
			CheckAIBumpMeleeAttack(GP, self);
		}
	}
}

simulated function UpdateRepairGlow()
{
	local MaterialInterface MaterialToUse;
	local GearPC PC;
	local int i;
	local float PlayerRepairPct;

	if ( GearGRI_Horde(WorldInfo.GRI) != None && GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications &&
		GetConditionPct() < 1.0 )
	{
		if (RepairGlow == None)
		{
			RepairGlow = new(self) DisplayComponent[UpgradeLevel].Class(DisplayComponent[UpgradeLevel]);
			RepairGlow.SetHidden(false);
			RepairGlow.SetScale(1.05);
		}

		//@FIXME: need real splitscreen support
		MaterialToUse = CannotRepairMaterial;
		foreach LocalPlayerControllers(class'GearPC', PC)
		{
			PC.GetFortificationUpgradeLevel(Class, PlayerRepairPct);
			if (PC.PlayerReplicationInfo.Score >= GetRepairCost() * PlayerRepairPct)
			{
				MaterialToUse = CanRepairMaterial;
				break;
			}
		}
		for (i = 0; i < RepairGlow.GetNumElements(); i++)
		{
			RepairGlow.SetMaterial(i, MaterialToUse);
		}

		if (!RepairGlow.bAttached)
		{
			AttachComponent(RepairGlow);
		}
	}
	else if (RepairGlow != None)
	{
		DetachComponent(RepairGlow);

		LastModifyTime = WorldInfo.TimeSeconds;
	}
}

/** notification that the deployment phase is starting or ending
 * @param bPhaseStarting - if true, phase is starting, otherwise it is ending
 */
function NotifyDeploymentPhase(bool bPhaseStarting)
{
	if (!bPhaseStarting)
	{
		// from this point on, you take a hit for selling this
		TearDownRecoveryPct = default.TearDownRecoveryPct;
	}
}

/** plays particles/audio/etc for death explosion */
simulated function PlayExplosionEffect()
{
	WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionEffect, DisplayComponent[UpgradeLevel].GetPosition(), rotator(vect(0,0,1)));
	PlaySound(ExplosionSound, true);
}

/** blows up the fortification
 * @param bCompletelyDestroy - if true, fortification ceases to exist and a new one must be built
 *				if false, fortification goes into an inactive state from which it can be repaired
 */
simulated function Explode(bool bCompletelyDestroy)
{
	local GearProj_Grenade Grenade;
	local array<GearProj_Grenade> GrenadesToExplode;

	// fortifications can only be repaired in Horde, so if we're playing something else, always destroy them
	if (Role == ROLE_Authority && GearGameHorde_Base(WorldInfo.Game) == None)
	{
		bCompletelyDestroy = true;
	}

	if (bCompletelyDestroy)
	{
		bTearOff = true;
		SetHidden(true);
		SetCollision(false);
		LifeSpan = 0.25;
		GotoState('Exploding');

		`RecordFortificationEvent(None, GFET_Destroyed, Marker);
		if (Marker != None)
		{
			Marker.TriggerEventClass(class'SeqEvent_FortificationNotify', Owner, 2);
		}
	}
	else
	{
		GotoState('Crippled');
	}

	bForceNetUpdate = true;

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		PlayExplosionEffect();
	}

	// blow up any attached grenades
	foreach BasedActors(class'GearProj_Grenade', Grenade)
	{
		// we need to add to a list and explode later as otherwise the list iteration will break
		GrenadesToExplode.AddItem(Grenade);
	}
	foreach GrenadesToExplode(Grenade)
	{
		Grenade.DoExplosion();
	}

	if (WorldInfo.Game != None && DestroyedGUDEvent != GUDEvent_None)
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(DestroyedGUDEvent, None);
	}
}

simulated event TornOff()
{
	Explode(true);
}

/** called when the specified Controller wants to salvage this fortification, destroying it but recovering some of the cost */
function TearDown(Controller InstigatedBy)
{
	local GearPawn GP;

	`RecordFortificationEvent(InstigatedBy, GFET_Sold, Marker);
	InstigatedBy.PlayerReplicationInfo.Score += int((Cost[UpgradeLevel] - GetRepairCost()) * TearDownRecoveryPct);
	InstigatedBy.PlayerReplicationInfo.bForceNetUpdate = true;
	// play anim on builder
	GP = GearPawn(InstigatedBy.Pawn);
	if (GP != None && GP.CanDoSpecialMove(SM_PushButton))
	{
		GP.ServerDoSpecialMove(SM_PushButton);
	}

	Destroy();
}

/** @return cost to buy a fortification that does not yet exist */
static simulated function int GetPurchaseCost(int Level, WorldInfo WI)
{
	return default.Cost[Level];
}

/** @return the amount it will cost a player to fully repair this fortification */
simulated function int GetRepairCost()
{
	return (Cost[UpgradeLevel] * ((1.0 - GetConditionPct()) * RepairCostPct));
}

/** called when the specified Controller wants to repair this fortification */
function Repair(Controller InstigatedBy, float PlayerRepairPct)
{
	local float AmountToRepair;
	local int RepairCost;
	local GearPawn GP;

	RepairCost = GetRepairCost() * PlayerRepairPct;
	// get percentage of needed repairs player can afford
	AmountToRepair = FMin(InstigatedBy.PlayerReplicationInfo.Score / float(RepairCost), 1.0);
	if (AmountToRepair > 0.0)
	{
		InstigatedBy.PlayerReplicationInfo.Score -= RepairCost * AmountToRepair;
		InstigatedBy.PlayerReplicationInfo.bForceNetUpdate = true;
		if (GearPC(InstigatedBy) != None)
		{
			GearPC(InstigatedBy).ClientFortificationInvestment(Class, RepairCost * AmountToRepair);
		}

		if (RepairedGUDEvent != GUDEvent_None)
		{
			GearGame(WorldInfo.Game).TriggerGUDEvent(RepairedGUDEvent, InstigatedBy.Pawn);
		}

		// convert amount from relative to needed to absolute repair percentage and apply it
		RepairPct(AmountToRepair * (1.0 - GetConditionPct()));
		`RecordFortificationEvent(InstigatedBy, GFET_Repaired, Marker);
		// update markers for local player if necessary
		if (InstigatedBy.IsLocalPlayerController())
		{
			GearGRI_Horde(WorldInfo.GRI).UpdateFortificationGhostImages();
		}
		else
		{
			UpdateRepairGlow();
		}
		UpdateDamagedEffects();
		PlaySound(RepairSound);
		// play anim on builder
		GP = GearPawn(InstigatedBy.Pawn);
		if (GP != None && GP.CanDoSpecialMove(SM_PushButton))
		{
			GP.ServerDoSpecialMove(SM_PushButton);
		}
	}
}

/** opportunity for subclasses to pass on information to a new upgrade of this fortification before it is destroyed */
function UpgradedWith(GearFortification NewFortification);

/** upgrades the fortification to the next level and consumes the required cost
 * fails if the passed in player doesn't have enough
 */
function Upgrade(Controller InstigatedBy)
{
	local GearFortification NewFortification;
	local int UpgradeCost;
	local GearPawn GP;

	if (UpgradeLevel + 1 < Cost.length)
	{
		UpgradeCost = Cost[UpgradeLevel + 1] - float(Cost[UpgradeLevel]) * GetConditionPct();
		if (InstigatedBy.PlayerReplicationInfo.Score >= UpgradeCost)
		{
			NewFortification = Spawn(Class, Owner,, Location, Rotation,, true);
			if (NewFortification != None)
			{
				NewFortification.InitializeUpgradeLevel(UpgradeLevel + 1);
				if (!NewFortification.bDeleteMe)
				{
					NewFortification.PlaySound(UpgradeSound);
					NewFortification.Builders = Builders;
					NewFortification.Builders.AddItem(InstigatedBy);
					NewFortification.TearDownRecoveryPct = (TearDownRecoveryPct + 1.0) / 2.0;
					`RecordFortificationEvent(InstigatedBy, GFET_Destroyed, Marker);
					`RecordFortificationEvent(InstigatedBy, GFET_Upgraded, Marker);
					if (Marker != None)
					{
						Marker.TriggerEventClass(class'SeqEvent_FortificationNotify', Owner, 1);
						// transfer marker to new fortification
						NewFortification.Marker = Marker;
						Marker.SpawnedFortification = NewFortification;
						Marker = None;
					}
					UpgradedWith(NewFortification);
					InstigatedBy.PlayerReplicationInfo.Score -= UpgradeCost;
					InstigatedBy.PlayerReplicationInfo.bForceNetUpdate = true;
					if (GearPC(InstigatedBy) != None)
					{
						GearPC(InstigatedBy).ClientFortificationInvestment(Class, UpgradeCost);
					}

					if (NewFortification.UpgradedGUDEvent != GUDEvent_None)
					{
						GearGame(WorldInfo.Game).TriggerGUDEvent(NewFortification.UpgradedGUDEvent, InstigatedBy.Pawn);
					}

					// update markers for local player if necessary
					if (InstigatedBy.IsLocalPlayerController())
					{
						GearGRI_Horde(WorldInfo.GRI).UpdateFortificationGhostImages();
					}
					// play anim on builder
					GP = GearPawn(InstigatedBy.Pawn);
					if (GP != None && GP.CanDoSpecialMove(SM_PushButton))
					{
						GP.ServerDoSpecialMove(SM_PushButton);
					}

					Destroy();
				}
			}
		}
	}
}

/** recovers the specified percentage of the fortification's condition */
protected function RepairPct(float AmountToRepair)
{
	Health = Min(StartingHealth[UpgradeLevel], Health + StartingHealth[UpgradeLevel] * AmountToRepair);
	bForceNetUpdate = true;
	UpdateRepairGlow();
	UpdateDamagedEffects();
	LastModifyTime = WorldInfo.TimeSeconds;
}

/** @return the condition of this fortification as a value between 0 and 1
 *		generally health but could also indicate something else such as remaining supplies
 */
simulated function float GetConditionPct()
{
	return FMax(0.0, float(Health) / float(StartingHealth[UpgradeLevel]));
}

/** @return whether the repair action on this fortification reloads it (e.g. replenishes ammo) instead of repairing damage
 * used for audio/visual effects to distinguish the difference to the player
 */
simulated function bool RepairIsReload();

/** @return whether the given Pawn can interact with this fortification in some way */
simulated function bool CanBeUsedBy(Pawn User);

/** @return whether the passed in AI should seek out and activate this fortification */
function bool ShouldBeUsedBy(GearAI AI)
{
	return (VSize(Location - AI.Pawn.Location) < 1200.0 && CanBeUsedBy(AI.Pawn));
}

/** @return Controller that should receive credit for kills, or None if no one should */
final function Controller GetDamageInstigator()
{
	return (bScoreDamageCaused ? Controller(Owner) : None);
}

/** called when fortification causes damage; allows crediting fortification builders with some of the damage caused */
function bool ModifyDamageScoring(GearPRI DamagedPRI, GearPRI InstigatorPRI, float Damage, class<GearDamageType> DamageType)
{
	local int i;

	if (!bScoreDamageCaused)
	{
		// override with nothing since no one should get credit
		return true;
	}
	else
	{
		Builders.RemoveItem(None); // in case players have left the game
		if (Builders.length == 0)
		{
			return false;
		}
		else
		{
			// give builders credit for all damage
			// primary instigator of damage will get the kill bonus points
			for (i = 0; i < Builders.length; i++)
			{
				DamagedPRI.AddPlayerDamage(GearPRI(Builders[i].PlayerReplicationInfo), FMax(Damage / Builders.length, 1.0), DamageType);
			}
			return true;
		}
	}
}

/** @return whether a player should WANT to melee this fortification (i.e, it works and won't damage/kill them in return) */
simulated function bool IsDesirableMeleeTarget(GearPawn AskingPawn)
{
	return IsValidMeleeTarget(AskingPawn);
}

simulated final function GetRepairActionInfo(GearPC PC, out ActionInfo Action)
{
	local float PlayerRepairPct;

	if (RepairIsReload())
	{
		Action = ReloadAction;
		Action.TooltipText = ReloadActionTooltip;
	}
	else if (Health <= 0)
	{
		Action = RepairAction;
		Action.TooltipText = RebuildActionTooltip;
	}
	else
	{
		Action = RepairAction;
		Action.TooltipText = RepairActionTooltip;
	}
	PC.GetFortificationUpgradeLevel(Class, PlayerRepairPct);
	Action.TooltipText @= DisplayName $ ":" @ string(int(GetRepairCost() * PlayerRepairPct));

	if (PC.PlayerReplicationInfo.Score <= 0)
	{
		Action.ActionIconDatas[0].ActionIcons[0] = class'GearPickupFactory'.default.NoSymbolIcon;
	}
}

simulated final function GetUpgradeActionInfo(GearPC PC, out ActionInfo Action)
{
	local int UpgradeCost;

	Action = UpgradeAction;

	if (PC.GetFortificationUpgradeLevel(Class) <= UpgradeLevel)
	{
		Action.TooltipText = UpgradeLockedTooltip;
		Action.ActionIconDatas[0].ActionIcons[0] = class'GearPickupFactory'.default.NoSymbolIcon;
	}
	else
	{
		UpgradeCost = Cost[UpgradeLevel + 1] - Cost[UpgradeLevel];
		Action.TooltipText = UpgradeActionTooltip @ DisplayName $ ":" @ string(UpgradeCost);
		if (PC.PlayerReplicationInfo.Score < UpgradeCost)
		{
			Action.ActionIconDatas[0].ActionIcons[0] = class'GearPickupFactory'.default.NoSymbolIcon;
		}
	}
}

/** state used while exploding due to complete destruction */
state Exploding
{
	ignores TakeDamage;
}

/** state used while disabled because of damage, but can be repaired */
state Crippled
{
	ignores TakeDamage, Bump, Touch, TearDown, CanBeUsedBy, Tick, IsValidMeleeTarget;

	simulated function Explode(bool bCompletelyDestroy)
	{
		if (Role == ROLE_Authority)
		{
			Health = 0;
		}
	}

	function Repair(Controller InstigatedBy, float PlayerRepairPct)
	{
		Global.Repair(InstigatedBy, PlayerRepairPct);

		GotoState('Auto');
	}

	function NotifyDeploymentPhase(bool bPhaseStarting)
	{
		// any disabled fortification not repaired in the subsequent deployment phase is lost and must be rebuilt from scratch
		if (!bPhaseStarting)
		{
			Destroy();
		}
	}

	simulated event BeginState(name PreviousStateName)
	{
		if (Role == ROLE_Authority)
		{
			bCrippled = true;
			Health = 0;
			SetCollision(true, false);
			bProjTarget = false;
		}
		if (DisplayComponent[UpgradeLevel] != None)
		{
			DisplayComponent[UpgradeLevel].SetHidden(true);
		}
	}
	simulated event EndState(name NextStateName)
	{
		if (Role == ROLE_Authority)
		{
			bCrippled = false;
			SetCollision(true, default.bBlockActors);
			bProjTarget = default.bProjTarget;
		}
		if (DisplayComponent[UpgradeLevel] != None)
		{
			DisplayComponent[UpgradeLevel].SetHidden(false);
		}
	}
}

defaultproperties
{
	Begin Object Class=CylinderComponent Name=Cyl
		CollisionRadius=90.0
		CollisionHeight=72.0
		CollideActors=true
		BlockZeroExtent=false
	End Object
	CollisionComponent=Cyl
	Components.Add(Cyl)

	Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnv
		bEnabled=true
		// Use cheap shadowing from the environment
		bUseBooleanEnvironmentShadowing=true
		bDynamic=false
		bForceNonCompositeDynamicLights=true // needed since we are using a static light environment, otherwise dynamic lights won't have any effect
		TickGroup=TG_DuringAsyncWork
	End Object
	Components.Add(LightEnv)
	FortificationLightEnvironment=LightEnv

	RemoteRole=ROLE_SimulatedProxy
	NetPriority=2.7
	NetUpdateFrequency=1.0
	bReplicateMovement=false
	bUpdateSimulatedPosition=false
	bNetInitialRotation=true
	bAlwaysRelevant=true
	bCollideActors=true
	bBlockActors=true
	bProjTarget=true
	bRequiresFlag=true
	UpgradeLevel=255 // to force replication when it's zero

	CanRepairMaterial=MaterialInstanceConstant'Effects_Gameplay.Horde.MI_GameplayObject_Horde_Yellow'
	CannotRepairMaterial=MaterialInstanceConstant'Effects_Gameplay.Horde.MI_GameplayObject_Horde_Red'

	BuiltGUDEvent=GUDEvent_None
	UpgradedGUDEvent=GUDEvent_None
	RepairedGUDEvent=GUDEvent_None
	DestroyedGUDEvent=GUDEvent_None

	BuildAction={( ActionName=FortAction,FontIndex=0,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64))), // Y Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=360,V=0,UL=58,VL=55))),
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=343,V=437,UL=44,VL=59))) ) )}
	RepairAction={( ActionName=FortAction,FontIndex=0,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64))), // Y Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=360,V=0,UL=58,VL=55))),
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=343,V=437,UL=44,VL=59))) ) )}
	ReloadAction={( ActionName=FortAction,FontIndex=0,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64))), // Y Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=360,V=0,UL=58,VL=55))),
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=343,V=437,UL=44,VL=59))) ) )}
	UpgradeAction={( ActionName=FortAction,FontIndex=0,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64))), // Y Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=360,V=0,UL=58,VL=55))),
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=343,V=437,UL=44,VL=59))) ) )}
}
