/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_RandomGUDS extends GearMutator
	config(Game);

/** range of timings for random GUD events */
var config vector2d GUDInterval;
/** list of potential GUD events */
var array<EGUDEventID> EventChoices;

event PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(RandRange(GUDInterval.X, GUDInterval.Y), false, nameof(SendRandomGUDEvent));
}

function SendRandomGUDEvent()
{
	local Pawn P, Sender, Recipient;
	local float Choices;

	// choose random Pawns to talk
	foreach WorldInfo.AllPawns(class'Pawn', P)
	{
		Choices += 1.0;
		if (FRand() < 1.0 / Choices)
		{
			Sender = P;
		}
		else if (FRand() < 1.0 / Choices)
		{
			Recipient = P;
		}
	}

	GearGame(WorldInfo.Game).UnscriptedDialogueManager.TriggerGUDEvent(EventChoices[Rand(EventChoices.length)], Sender, Recipient);

	// reset timer
	SetTimer(RandRange(GUDInterval.X, GUDInterval.Y), false, nameof(SendRandomGUDEvent));
}

defaultproperties
{
	EventChoices={(
		GUDEvent_EnteredCombat,
		GUDEvent_FoundTarget,
		GUDEvent_KilledEnemyGeneric,
		GUDEvent_KilledEnemyGenericLambent,
		GUDEvent_KilledEnemyChainsaw,
		GUDEvent_KilledEnemyHeadShot,
		GUDEvent_KilledEnemyMelee,
		GUDEvent_KilledEnemyCurbstomp,
		GUDEvent_KilledEnemyExecution,
		GUDEvent_KilledEnemyHOD,
		GUDEvent_DamagedEnemyHeavy,
		GUDEvent_DamagedEnemyHeavyLambent,
		GUDEvent_DamageTeammate,
		GUDEvent_CauseEnemyStumble,
		GUDEvent_TransToRetreatAI,			// really means "fallback"
		GUDEvent_TransToHoldAI,				// unused
		GUDEvent_TransToAdvanceAI,
		GUDEvent_TransToKamikazeAI,
		GUDEvent_TransToMeleeAI,
		GUDEvent_TransToMeleeAIOffscreen,
		GUDEvent_TransToFlankAI,			// unused
		GUDEvent_TransToFleeHODAI,			// unused
		GUDEvent_ThrowingSmokeGrenade,
		GUDEvent_ThrowingFragGrenade,
		GUDEvent_FailedActiveReload,
		GUDEvent_SucceededActiveReload,
		GUDEvent_Reloaded,
		GUDEvent_PickedUpAmmo,
		GUDEvent_PickedUpNewWeapon,
		GUDEvent_PickedUpCollectible,
		GUDEvent_PickedUpGrenades,
		GUDEvent_PlayerHasntMoved,
		GUDEvent_NeedAmmo,
		GUDEvent_NeedAmmoGrenade,
		GUDEvent_WentDBNO,
		GUDEvent_WentDBNO_Leader,
		GUDEvent_NeedsRevived,
		GUDEvent_NeedsRevived_Nearby,
		GUDEvent_Revived,
		GUDEvent_Attack,
		GUDEvent_NoticedManyEnemies,
		GUDEvent_NoticedDrone,
		GUDEvent_NoticedBoomer,
		GUDEvent_NoticedTheron,
		GUDEvent_NoticedPalaceGuard,
		GUDEvent_NoticedWretch,
		GUDEvent_NoticedHunter,
		GUDEvent_NoticedKantus,
		GUDEvent_NoticedKantusArmor,
		GUDEvent_NoticedMauler,			// flail boomer
		GUDEvent_NoticedGrinder,		// gatling boomer
		GUDEvent_NoticedDigger,
		GUDEvent_NoticedMiniCorpser,
		GUDEvent_NoticedSerapede,
		GUDEvent_NoticedBloodmounts,
		GUDEvent_NoticedTickers,
		GUDEvent_NoticedSnipers,
		GUDEvent_NoticedLambentDrone,
		GUDEvent_NoticedDrudge,
		GUDEvent_NoticedGunker,
		GUDEvent_NoticedPolyps,
		GUDEvent_NoticedEnemyGeneric,
		GUDEvent_NoticedReinforcements,
		GUDEvent_CombatLull,
		GUDEvent_EHoleOpened,
		GUDEvent_EHoleOpenReminder,
		GUDEvent_EHoleClosedWithGrenade,
		GUDEvent_EHoleGrenadeMissed,
		GUDEvent_StalkEmerging,
		GUDEvent_StalkPodsReminder,
		GUDEvent_DrudgeHeadMutating,
		GUDEvent_DrudgeLegsMutating,
		GUDEvent_DrudgeArmsMutating,
		GUDEvent_DrudgeHeadDetached,
		GUDEvent_VersusRoundBegunCOG,				// one per team to ensure both teams say something
		GUDEvent_VersusRoundBegunLocust,
		GUDEvent_PickedUpMeatShield,				// Instigator picked up Recipient as MeatShield
		GUDEvent_PickedUpMeatShield_Leader,			// Instigator picked up Recipient as MeatShield (variant for captured leaders)
		GUDEvent_KilledEnemyFlamethrower,			// Instigator killed Recipient with FlameThrower
		GUDEvent_GatlingOverheated,					// Instigator's gatling gun overheated.  No recipient.
		GUDEvent_IncomingEnemyMortarSpotted,		// Instigator launched a mortar, no recipient.
		GUDEvent_ThrowingInkGrenade,				// Instigator threw ink grenade.
		GUDEvent_StuckExplosiveToEnemy,				// Instigator stuck Recipient with explosive (e.g. grenade, arrow)
		GUDEvent_GrenadeTrapSet,					// Instigator set a sticky grenade trap to the world, no recipient.
		GUDEvent_ExecutedMeatShield,				// Instigator executed Recipient, who was his meatshield at the time
		GUDEvent_DBNOPawnCrawlingAway,				// Instigator is DBNO Pawn, no recipient
		GUDEvent_EnteredSilverback,                 // Instigator is the driver, no recipient
		GUDEvent_Silverback_PickedUpCrate,          // Instigator is the driver, no recipient
		GUDEvent_Horde_EnemyPhaseStart,
		GUDEvent_Scream,
		GUDEvent_EnemySpotted,
		GUDEvent_BagTag,
		GUDEvent_KidnapResist,
		GUDEvent_KilledMultipleWithSawedOff,
		GUDEvent_ThrowingIncendiaryGrenade,
		GUDEvent_NoticedReaver,
		GUDEvent_NoticedNakedTicker,
		GUDEvent_NoticedBrumak,
		GUDEvent_NoticedBerserker,
		GUDEvent_NoticedCorpser,
		GUDEvent_DroppedMeatShield_Leader
	)}
}
