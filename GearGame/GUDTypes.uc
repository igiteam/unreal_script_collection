/**
 * Class: GUDTypes
 * Various enums and decalarations universal to the GUDS system.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GUDTypes extends Object
	abstract
	native;


/** 
 * CAUTION: These values are serialized to MCP, any additions must go to the end 
 */
enum EGUDEventID
{
	GUDEvent_None,
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
	GUDEvent_CommandCenterTriggered,			// Instigator triggered command center fortification, no recipient.
	GUDEvent_ThrowingInkGrenade,				// Instigator threw ink grenade.
	GUDEvent_StuckExplosiveToEnemy,				// Instigator stuck Recipient with explosive (e.g. grenade, arrow)
	GUDEvent_GrenadeTrapSet,					// Instigator set a sticky grenade trap to the world, no recipient.
	GUDEvent_ExecutedMeatShield,				// Instigator executed Recipient, who was his meatshield at the time
	GUDEvent_DBNOPawnCrawlingAway,				// Instigator is DBNO Pawn, no recipient
	GUDEvent_EnteredSilverback,                 // Instigator is the driver, no recipient
	GUDEvent_Silverback_PickedUpCrate,          // Instigator is the driver, no recipient
	// Coop interactions
	GUDEvent_SwapWeaponsAnnounce,
	GUDEvent_SwapWeaponsAccepted,
	GUDEvent_GiveMoney,
	GUDEvent_GiveAmmo,
	GUDEvent_GiveAmmoRefused,
	GUDEvent_Horde_BuildPhaseStart,
	GUDEvent_Horde_TurretBuilt,
	GUDEvent_Horde_TurretUpgraded,
	GUDEvent_Horde_TurretRepaired,
	GUDEvent_Horde_TurretDestroyed,
	GUDEvent_Horde_SentryBuilt,
	GUDEvent_Horde_SentryUpgraded,
	GUDEvent_Horde_SentryRepaired,
	GUDEvent_Horde_SentryDestroyed,
	GUDEvent_Horde_DecoyBuilt,
	GUDEvent_Horde_DecoyUpgraded,
	GUDEvent_Horde_DecoyRepaired,
	GUDEvent_Horde_DecoyDestroyed,
	GUDEvent_Horde_CommandCenterBuilt,
	GUDEvent_Horde_CommandCenterUpgraded,
	GUDEvent_Horde_CommandCenterRepaired,
	GUDEvent_Horde_CommandCenterDestroyed,
	GUDEvent_Horde_SilverbackBuilt,
	GUDEvent_Horde_SilverbackRepaired,
	GUDEvent_Horde_SilverbackDestroyed,
	GUDEvent_Horde_WallLevel1Built,
	GUDEvent_Horde_WallLevel2Built,
	GUDEvent_Horde_WallLevel3Built,
	GUDEvent_Horde_WallLevel4Built,
	GUDEvent_Horde_WallRepaired,
	GUDEvent_Horde_WallDestroyed,
	GUDEvent_Horde_FlagBuilt,
	GUDEvent_Horde_EnemyPhaseStart,
	GUDEvent_Horde_FiveLeft,
	GUDEvent_Horde_FourLeft,
	GUDEvent_Horde_ThreeLeft,
	GUDEvent_Horde_TwoLeft,
	GUDEvent_Horde_OneLeft,
	GUDEvent_Scream,
	GUDEvent_CoopDoorHelpRequest,
	GUDEvent_CoopDoorDisabled,
	GUDEvent_EnemySpotted,
	GUDEvent_BagTag,
	GUDEvent_KidnapResist,
	GUDEvent_KilledMultipleWithSawedOff,
	GUDEvent_ThrowingIncendiaryGrenade,
	GUDEvent_Horde_WallLevel1Repaired,
	GUDEvent_Horde_WallLevel1Destroyed,
	GUDEvent_NoticedReaver,
	GUDEvent_NoticedNakedTicker,
	GUDEvent_NoticedBrumak,
	GUDEvent_NoticedBerserker,
	GUDEvent_NoticedCorpser,
	GUDEvent_DroppedMeatShield_Leader,
};


/**
 * To avoid confusion re who is the instigator and whatnot, think of it like so:
 *		"Event happened to RECIPIENT, caused by INSTIGATOR, observed by WITNESS"
 *
 * Which role an action is designed for is denoted by a suffix on the action name:
 *		I = Instigator
 *		R = Recipient
 *		TW = Teammate Witness (same team as Instigator)
 *		EW = Enemy Witness (different team as Instigator)
 *
 * Note that an "action" conceptually is essentially a bundle of lines.  Actions need
 * not be associated with an event, although events do play actions.
 */
enum EGUDActionID
{
	// this is going to be a long list, but ok
	GUDAction_None,

	GUDAction_EnteredCombat_I,
	GUDAction_FoundTarget_I,
	GUDAction_FoundTarget_R,
	GUDAction_KilledEnemyGeneric_I,
	GUDAction_KilledEnemyGenericLambent_I,
	GUDAction_KilledEnemyChainsaw_I,
	GUDAction_KilledEnemyChainsaw_TW,
	GUDAction_KilledEnemyHeadShot_I,
	GUDAction_KilledEnemyHeadShot_TW,
	GUDAction_KilledEnemyMelee_I,
	GUDAction_KilledEnemyMelee_TW,
	GUDAction_KilledEnemyCurbstomp_I,
	GUDAction_KilledEnemyExecution_I,
	GUDAction_KilledEnemyHOD_I,
	GUDAction_KilledEnemyHOD_TW,
	GUDAction_DamagedEnemyHeavy_I,
	GUDAction_DamagedEnemyHeavy_R,
	GUDAction_DamagedEnemyHeavyLambent_I,
	GUDAction_DamageTeammate_I,
	GUDAction_DamageTeammate_R,
	GUDAction_CauseEnemyStumble_I,
	GUDAction_CauseEnemyStumble_R,
	GUDAction_TransToFleeAI_I,
	GUDAction_TransToFleeAI_EW,
	GUDAction_TransToRetreatAI_I,
	GUDAction_TransToRetreatAI_EW,
	GUDAction_TransToHoldAI_I,
	GUDAction_TransToHoldAI_EW,
	GUDAction_TransToAdvanceAI_I,
	GUDAction_TransToAdvanceAI_EW,
	GUDAction_TransToKamikazeAI_I,
	GUDAction_TransToKamikazeAI_EW,
	GUDAction_TransToMeleeAI_I,
	GUDAction_TransToMeleeAI_EW,
	GUDAction_TransToFlankAI_I,
	GUDAction_TransToFlankAI_EW,
	GUDAction_TransToFleeHODAI_I,
	GUDAction_TransToFleeHODAI_EW,
	GUDAction_ThrowingSmokeGrenade_I,
	GUDAction_ThrowingSmokeGrenade_EW,
	GUDAction_ThrowingFragGrenade_I,
	GUDAction_ThrowingFragGrenade_EW,
	GUDAction_BlockingMovement_I,
	GUDAction_BlockingMovement_R,
	GUDAction_BlockingMovement_TW,
	GUDAction_NoRecentDamage_I,
	GUDAction_FailedActiveReload_I,
	GUDAction_SucceededActiveReload_I,
	GUDAction_Reloaded_I,
	GUDAction_PickedUpAmmo_I,
	GUDAction_PickedUpNewWeapon_I,
	GUDAction_PickedUpCollectible_I,
	GUDAction_PickedUpGrenades_I,
	GUDAction_PlayerHasntMoved_I,
	GUDAction_PlayerHasntMoved_TW,
	GUDAction_MysteriousEvent_TW,
	GUDAction_SurprisingEvent_TW,
	GUDAction_DangerousEvent_TW,
	GUDAction_NeedAmmo_I,
	GUDAction_NeedAmmoGrenade_I,

	GUDAction_WentDBNO_I,
	GUDAction_WentDBNO_TW,
	GUDAction_WentDBNO_Leader_TW,
	GUDAction_WentDBNO_Leader_EW,
	GUDAction_NeedsRevived_I,
	GUDAction_Revived_I,
	GUDAction_Revived_R,

	GUDAction_Attack_I,

	/** Enemy spotted notifications.  Instigator is None, Recipient is the enemy that was spotted. */
	GUDAction_NoticedTwoEnemies_TW,
	GUDAction_NoticedThreeEnemies_TW,
	GUDAction_NoticedFourEnemies_TW,
	GUDAction_NoticedManyEnemies_TW,
	GUDAction_NoticedDrone_TW,
	GUDAction_NoticedBoomer_TW,
	GUDAction_NoticedTheron_TW,
	GUDAction_NoticedPalaceGuard_TW,
	GUDAction_NoticedWretch_TW,
	GUDAction_NoticedHunter_TW,
	GUDAction_NoticedKantus_TW,
	GUDAction_NoticedKantusArmor_TW,
	GUDAction_NoticedMauler_TW,			// flail boomer
	GUDAction_NoticedGrinder_TW,		// gatling boomer
	GUDAction_NoticedDigger_TW,
	GUDAction_NoticedMiniCorpser_TW,
	GUDAction_NoticedSerapede_TW,
	GUDAction_NoticedBloodmounts_TW,
	GUDAction_NoticedTickers_TW,
	GUDAction_NoticedSnipers_TW,
	GUDAction_NoticedLambentDrone_TW,
	GUDAction_NoticedDrudge_TW,
	GUDAction_NoticedGunker_TW,
	GUDAction_NoticedPolyps_TW,
	GUDAction_NoticedEnemyGeneric_TW,
	GUDAction_NoticedReinforcements_TW,

	GUDAction_EnemiesReducedToZero_TW,
	GUDAction_EnemiesReducedToOne_TW,
	GUDAction_EnemiesReducedToTwo_TW,
	GUDAction_EnemiesReducedToThree_TW,
	GUDAction_EnemiesReducedToFour_TW,
	GUDAction_CombatLull_TW,
	GUDAction_CombatLull_EW,
	GUDAction_EHoleOpened_TW,
	GUDAction_EHoleOpenReminder_TW,
	GUDAction_EHoleClosedWithGrenade_I,
	GUDAction_EHoleClosedWithGrenade_TW,
	GUDAction_EHoleGrenadeMissed_I,
	GUDAction_EHoleGrenadeMissed_TW,

	GUDAction_StalkEmerging_TW,
	GUDAction_StalkPodsReminder_TW,

	GUDAction_DrudgeHeadMutating_TW,
	GUDAction_DrudgeLegsMutating_TW,
	GUDAction_DrudgeArmsMutating_TW,
	GUDAction_DrudgeHeadDetached_TW,

	GUDAction_VersusRoundBegunCOG_TW,
	GUDAction_VersusRoundBegunLocust_EW,

	GUDAction_EnemySpottedResponse_TW,
	GUDAction_EnemyDirAnnouncedResponse_TW,

	GUDAction_EnemyLocationCallout_Above,
	GUDAction_EnemyLocationCallout_Below,
	GUDAction_EnemyLocationCallout_Right,
	GUDAction_EnemyLocationCallout_Left,
	GUDAction_EnemyLocationCallout_Ahead,
	GUDAction_EnemyLocationCallout_Behind,

	GUDAction_EnemyLocationCallout_InWindow,
	GUDAction_EnemyLocationCallout_InDoorway,
	GUDAction_EnemyLocationCallout_BehindCar,
	GUDAction_EnemyLocationCallout_BehindTruck,
	GUDAction_EnemyLocationCallout_OnTruck,
	GUDAction_EnemyLocationCallout_BehindBarrier,
	GUDAction_EnemyLocationCallout_BehindColumn,
	GUDAction_EnemyLocationCallout_BehindCrate,
	GUDAction_EnemyLocationCallout_BehindWall,
	GUDAction_EnemyLocationCallout_BehindStatue,
	GUDAction_EnemyLocationCallout_BehindSandbags,
	GUDAction_EnemyLocationCallout_InTheOpen,

	GUDAction_PickedUpMeatShield_I,
	GUDAction_PickedUpMeatShield_R,

	GUDAction_KilledEnemyFlamethrower_I,
	GUDAction_KilledEnemyFlamethrower_TW,

	GUDAction_GatlingOverheated_I,

	GUDAction_IncomingEnemyMortarSpotted_I,
	GUDAction_ThrowingInkGrenade_I,
	GUDAction_ThrowingInkGrenade_EW,
	GUDAction_StuckExplosiveToEnemy_I,
	GUDAction_StuckExplosiveToEnemy_R,
	GUDAction_GrenadeTrapSet_I,
	GUDAction_ExecutedMeatShield_I,

	GUDAction_DBNOPawnCrawlingAway_EW,

	GUDAction_EnteredSilverback_I,
	GUDAction_Silverback_PickedUpCrate_I,

	// actions that aren't associated with an event, triggered manually
	GUDAction_NotifyHODEnabled,
	GUDAction_NotifyHODDisabled,
	GUDAction_NoticedACollectible,
	GUDAction_MeatFlagRoundBegun,
		
	GUDAction_PickedUpMeatShield_Leader_I,
	GUDAction_PickedUpMeatShield_Leader_TW,
	GUDAction_PickedUpMeatShield_Leader_EW,

	// coop interactions
	GUDAction_SwapWeaponsAnnounce_I,
	GUDAction_SwapWeaponsAccepted_I,
	GUDAction_GiveMoney_I,
	GUDAction_GiveAmmo_I,
	GUDAction_GiveAmmoRefused_I,

	GUDAction_Horde_BuildPhaseStart_TW,
	GUDAction_Horde_TurretBuilt_I,
	GUDAction_Horde_TurretUpgraded_I,
	GUDAction_Horde_TurretRepaired_I,
	GUDAction_Horde_TurretDestroyed_TW,
	GUDAction_Horde_SentryBuilt_I,
	GUDAction_Horde_SentryUpgraded_I,
	GUDAction_Horde_SentryRepaired_I,
	GUDAction_Horde_SentryDestroyed_TW,
	GUDAction_Horde_DecoyBuilt_I,
	GUDAction_Horde_DecoyUpgraded_I,
	GUDAction_Horde_DecoyRepaired_I,
	GUDAction_Horde_DecoyDestroyed_TW,
	GUDAction_Horde_CommandCenterBuilt_I,
	GUDAction_Horde_CommandCenterUpgraded_I,
	GUDAction_Horde_CommandCenterRepaired_I,
	GUDAction_Horde_CommandCenterDestroyed_TW,
	GUDAction_Horde_SilverbackBuilt_I,
	GUDAction_Horde_SilverbackRepaired_I,
	GUDAction_Horde_SilverbackDestroyed_TW,
	GUDAction_Horde_WallLevel1Built_I,
	GUDAction_Horde_WallLevel2Built_I,
	GUDAction_Horde_WallLevel3Built_I,
	GUDAction_Horde_WallLevel4Built_I,
	GUDAction_Horde_WallRepaired_I,
	GUDAction_Horde_WallDestroyed_TW,
	GUDAction_Horde_FlagBuilt_I,

	GUDAction_Horde_EnemyPhaseStart_TW,
	GUDAction_Horde_FiveLeft_TW,
	GUDAction_Horde_FourLeft_TW,
	GUDAction_Horde_ThreeLeft_TW,
	GUDAction_Horde_TwoLeft_TW,
	GUDAction_Horde_OneLeft_TW,

	GUDAction_Scream_I,

	GUDAction_CoopDoorHelpRequest_I,
	GUDAction_CoopDoorDisabled_I,
	
	GUDAction_EnemySpotted_I,

	GUDAction_BagTag_I,
	GUDAction_KidnapResist_I,

	GUDAction_KilledMultipleWithSawedOff_I,

	GUDAction_ThrowingIncendiaryGrenade_I,
	GUDAction_ThrowingIncendiaryGrenade_EW,

	GUDAction_Horde_WallLevel1Repaired_I,
	GUDAction_Horde_WallLevel1Destroyed_TW,

	GUDAction_NoticedReaver_TW,
	GUDAction_NoticedNakedTicker_TW,
	GUDAction_NoticedBrumak_TW,
	GUDAction_NoticedBerserker_TW,
	GUDAction_NoticedCorpser_TW,

	GUDAction_DroppedMeatShield_R,
};

enum EGUDRole
{
	GUDRole_None,
	GUDRole_Instigator,			// the instigator CAUSED the event
	GUDRole_Recipient,			// the event HAPPENED TO the recipient
	GUDRole_EnemyWitness,		// the EW witnessed the event and IS NOT on the instigators team
	GUDRole_TeammateWitness,	// the TW witnessed the event and IS on the instigators team
	GUDRole_ReferencedPawn,		// the event happened in reference to the ReferencedPawn (used mainly for responses)
};


defaultproperties
{
}

