/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class DifficultySettings extends Object
	abstract
	native
	config(Game);

// player health modifiers
var() config bool bCanDBNO;
var() config float PlayerHealthMod;
var() config float PlayerHealthRechargeDelayMod;
var() config float PlayerHealthRechargeSpeedMod;

/* Multiplier for health when Guardian Angel is active */
var() config float GuardianAngelHealthMod;

// player weapon modifiers
var() config float PlayerDamageMod;
var() config float PlayerActiveReloadWindowMod;
/* Multiplier for damage dealth when Guardian Angel is active */
var() config float GuardianAngelDamageMod;
/* If set, this overrides the PlayerDamageMod for radial damage only, to compare to old settings */
var() config float PlayerOverrideRadialDamageMod;

// friendly ai modifiers
var() config float FriendHealthMod;
var() config float FriendHealthRechargeDelayMod;
var() config float FriendHealthRechargeSpeedMod;

// friendly ai modifiers
var() config float FriendDamageMod;

/** modifier to amount of time before AI pays attention to revive/execute */
var() config float ReviveAndExecuteDelayMod;

/** aiming modifier applied to MP bots */
var() config float MPBotAimErrorMultiplier;
/** active reload attempt/success multiplier for MP bots */
var() config float MPBotActiveReloadMultiplier;
/** hearing radius multiplier for MP bots */
var() config float MPBotHearingMultiplier;
/** rotation rate multiplier for MP bots */
var() config float MPBotRotationRateMultiplier;
/** basic movement speed multiplier for MP bots */
var() config float MPBotBasicMovementMultiplier;

/** Scales AI's chance to evade */
var() config float EnemyEvadeChanceScale;

/** whether the ally AI COG guys can be killed/bleedout while they're DBNO */
var() config bool bAllowAICOGDeathWhenDBNO;
/** whether human COG players can be executed while they're DBNO */
var() config bool bHumanCOGCanBeExecuted;
/** distance away from other human controlled squad mates a human controlled pawn needs to be before they're valid execution targets */
var() config float DistFromHumanSquadMatesBeforeEligibleForExecution;

/** Horde score multiplier for playing on this difficulty */
var() config float HordeScoreMultiplier;
/** bleedout time of Pawns in Horde when playing on this difficulty */
var() config float HordeBleedOutTime;
/** bleedout time of Pawns in SP when playing on this difficulty */
var() config float SPBleedOutTime;
/** Max number of downs allowed in SP on this difficulty, -1 for infinite */
var() config int SPMaxDownCount;
/** If true, player will self-revive at end of bleed out timer */
var() config bool bSPSelfRevive;

/** whether to allow locust dudes to blind fire when in cover */
var() config bool bAllowLocustBlindFire;

/** How many assist points are required before activating the Guardian Angel assists */
var() config int GuardianAngelThreshold;

var() const EDifficultyLevel DifficultyLevel;

/** the name of the difficulty setting */
var localized string DifficultyName;


static function ApplyDifficultySettings(Controller C)
{
	local GearPawn GP;
	local GearAI AI;

	Assert(C.Role == ROLE_Authority);

	AI = GearAI(C);
	if (AI != None && (C.WorldInfo.GRI.IsMultiplayerGame() || AI.GetTeamNum() != 0))
	{
		AI.ReviveDelay = AI.default.ReviveDelay + default.ReviveAndExecuteDelayMod;
		// remove the execute delay if we're playing an execution gametype as otherwise the AI looks unreasonably stupid
		if (GearGameMP_Base(C.WorldInfo.Game) != None && GearGameMP_Base(C.WorldInfo.Game).bExecutionRules)
		{
			AI.ExecuteDelay = 0.0;
		}
		else
		{
			AI.ExecuteDelay = AI.default.ExecuteDelay + default.ReviveAndExecuteDelayMod;
		}
	}

	if ( ((GearGameSP_Base(C.WorldInfo.Game) != None || GearGameHorde_Base(C.WorldInfo.Game) != None) && C.GetTeamNum() == 0) ||
		(GearGameSiege_Base(C.WorldInfo.Game) != None && C.GetTeamNum() == 1) )
	{
		if (C.IsA('PlayerController') || C.IsA('GearAI_TDM'))
		{
			GP = GearPawn(C.Pawn);
			if (GP != None)
			{
				GP.PlayerDamageMod = default.PlayerDamageMod;

				// If guardian angel is active, increase the health and damage dealt.
				if (!C.WorldInfo.GRI.IsMultiplayerGame() && GearPC(C).IsGuardianAngelActive())
				{
					GP.ScaleDefaultHealth(default.PlayerHealthMod * default.GuardianAngelHealthMod, true);
					GP.PlayerDamageMod *= default.GuardianAngelDamageMod;
				}
				else
				{
					GP.ScaleDefaultHealth(default.PlayerHealthMod, true);
				}

				// Set SP maxdowns/revival. It's here so join in progress works correctly
				if (!C.WorldInfo.GRI.IsMultiplayerGame())
				{
					GP.MaxDownCount = default.SPMaxDownCount;
					GP.OverrideRevivalTime = default.SPBleedOutTime;
				}

				if (GearGame(C.WorldInfo.Game).AllowHealthRecharge(GP))
				{
					GP.HealthRechargeDelay = GP.default.HealthRechargeDelay * default.PlayerHealthRechargeDelayMod;
					GP.HealthRechargePercentPerSecond = GP.default.HealthRechargePercentPerSecond * default.PlayerHealthRechargeSpeedMod;
				}
			}
			else if (GearVehicle(C.Pawn) != None)
			{
				GearVehicle(C.Pawn).ScaleDefaultHealth(default.PlayerHealthMod);
			}
		}
		else
		{
			GP = GearPawn(C.Pawn);
			if (GP != None)
			{
				GP.ScaleDefaultHealth(default.FriendHealthMod, true);
				GP.PlayerDamageMod = default.PlayerDamageMod;
				if (GearGame(C.WorldInfo.Game).AllowHealthRecharge(GP))
				{
					GP.HealthRechargeDelay = GP.default.HealthRechargeDelay * default.FriendHealthRechargeDelayMod;
					GP.HealthRechargePercentPerSecond = GP.default.HealthRechargePercentPerSecond * default.FriendHealthRechargeSpeedMod;
				}
			}
		}
	}

	if (C.WorldInfo.GRI.IsMultiplayerGame() && C.IsA('GearAI_TDM'))
	{
		AI.BaseAimError = AI.default.BaseAimError * default.MPBotAimErrorMultiplier;
		AI.RotationRateMultiplier = default.MPBotRotationRateMultiplier;
		AI.BasicMovementMultiplier = default.MPBotBasicMovementMultiplier;
		AI.ActiveReloadAttemptPct = AI.default.ActiveReloadAttemptPct * default.MPBotActiveReloadMultiplier;
		AI.ActiveReloadSweetPct = AI.default.ActiveReloadSweetPct * default.MPBotActiveReloadMultiplier;
		AI.ActiveReloadJamPct = AI.default.ActiveReloadJamPct / default.MPBotActiveReloadMultiplier;
		if (AI.Pawn != None)
		{
			AI.Pawn.HearingThreshold = AI.Pawn.default.HearingThreshold * default.MPBotHearingMultiplier;
		}
	}
}

/** finds the human player with the lowest (easiest) difficulty setting */
static final function class<DifficultySettings> GetLowestPlayerDifficultyLevel(WorldInfo WI)
{
	local GearPC PC;
	local EDifficultyLevel Lowest;
	local class<DifficultySettings> LowestSettings;
	local GearPRI PCPRI;

	Lowest = DL_Insane;
	LowestSettings = class'GearPRI'.default.Difficulty;
	foreach WI.AllControllers(class'GearPC', PC)
	{
		PCPRI = GearPRI(PC.PlayerReplicationInfo);
		if ( PCPRI != None )
		{
			if (PCPRI.Difficulty.default.DifficultyLevel < Lowest)
			{
				Lowest = PCPRI.Difficulty.default.DifficultyLevel;
				LowestSettings = PCPRI.Difficulty;
			}
			else if(PCPRI.Difficulty.default.DifficultyLevel == Lowest)
			{
				LowestSettings = PCPRI.Difficulty;
			}
		}
	}

	return LowestSettings;
}

/**
 * Turn off Guardian Angel assists for this PlayerController
 *
 * @param PC - The player controller to assist
 */
static final function ResetGuardianAngel(PlayerController PC)
{
	local GearPawn GP;

	if (!PC.WorldInfo.GRI.IsMultiplayerGame() && PC.WorldInfo.NetMode != NM_Client)
	{
		GP = GearPawn(PC.Pawn);

		GP.ScaleDefaultHealth(default.PlayerHealthMod, false);
		GP.PlayerDamageMod = default.PlayerDamageMod;
	}
}

/**
 * Turn on Guardian Angel assists for this PlayerController
 *
 * @param PC - The player controller to assist
 */
static final function EnableGuardianAngel(PlayerController PC)
{
	local GearPawn GP;

	if (!PC.WorldInfo.GRI.IsMultiplayerGame() && PC.WorldInfo.NetMode != NM_Client)
	{
		GP = GearPawn(PC.Pawn);

		`log("GA: Enabled!" @ `showvar(default.GuardianAngelHealthMod) @ `showvar(default.GuardianAngelDamageMod));

		GP.ScaleDefaultHealth(default.PlayerHealthMod * default.GuardianAngelHealthMod, true);
		GP.PlayerDamageMod = default.PlayerDamageMod * default.GuardianAngelDamageMod;
	}
}

