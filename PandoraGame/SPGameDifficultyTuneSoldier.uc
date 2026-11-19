class SPGameDifficultyTuneSoldier extends SPGameDifficultyTune
    native
    editinlinenew;

struct native SPTuneAimingMissParams
{
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty Min;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty Max;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty Height;

    structdefaultproperties
    {
        Min=(baseValue=32.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        Max=(baseValue=100.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        Height=(baseValue=64.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

struct native SPTuneAimingParams
{
    var() FloatDifficulty Distance;
    var() FloatDifficulty percentageOnTargetShots;
    var() SPTuneAimingMissParams miss;

    structdefaultproperties
    {
        Distance=(baseValue=1000.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        percentageOnTargetShots=(baseValue=50.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        miss=(Min=(baseValue=32.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))),Max=(baseValue=100.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))),Height=(baseValue=64.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))))
    }
};

struct native SPWeaponTimeAtRange
{
    var() SPFloatRange TimeAtShortRange;
    var() SPFloatRange TimeAtMediumRange;
    var() SPFloatRange TimeAtFarRange;

    structdefaultproperties
    {
        TimeAtShortRange=(Min=0.0000000,Max=0.0000000)
        TimeAtMediumRange=(Min=0.0000000,Max=0.0000000)
        TimeAtFarRange=(Min=0.0000000,Max=0.0000000)
    }
};

struct native SPWeaponCountAtRange
{
    var() SPIntRange CountAtShortRange;
    var() SPIntRange CountAtMediumRange;
    var() SPIntRange CountAtFarRange;

    structdefaultproperties
    {
        CountAtShortRange=(Min=0,Max=0)
        CountAtMediumRange=(Min=0,Max=0)
        CountAtFarRange=(Min=0,Max=0)
    }
};

struct native SPWeaponBurst
{
    var() SPWeaponTimeAtRange BurstTimeForAutomaticWeapons;
    var() SPWeaponCountAtRange BurstCountForSingleFireWeapons;

    structdefaultproperties
    {
        BurstTimeForAutomaticWeapons=(TimeAtShortRange=(Min=0.0000000,Max=0.0000000),TimeAtMediumRange=(Min=0.0000000,Max=0.0000000),TimeAtFarRange=(Min=0.0000000,Max=0.0000000))
        BurstCountForSingleFireWeapons=(CountAtShortRange=(Min=0,Max=0),CountAtMediumRange=(Min=0,Max=0),CountAtFarRange=(Min=0,Max=0))
    }
};

struct native SPWeaponBreak
{
    var() SPWeaponTimeAtRange BreakTimeForAutomaticWeapons;
    var() SPWeaponTimeAtRange BreakTimeForSingleFireWeapons;

    structdefaultproperties
    {
        BreakTimeForAutomaticWeapons=(TimeAtShortRange=(Min=0.0000000,Max=0.0000000),TimeAtMediumRange=(Min=0.0000000,Max=0.0000000),TimeAtFarRange=(Min=0.0000000,Max=0.0000000))
        BreakTimeForSingleFireWeapons=(TimeAtShortRange=(Min=0.0000000,Max=0.0000000),TimeAtMediumRange=(Min=0.0000000,Max=0.0000000),TimeAtFarRange=(Min=0.0000000,Max=0.0000000))
    }
};

struct native SPWeaponPause
{
    var() SPWeaponTimeAtRange PauseTimeForAutomaticWeapons;
    var() SPWeaponTimeAtRange PauseTimeForSingleFireWeapons;

    structdefaultproperties
    {
        PauseTimeForAutomaticWeapons=(TimeAtShortRange=(Min=0.0000000,Max=0.0000000),TimeAtMediumRange=(Min=0.0000000,Max=0.0000000),TimeAtFarRange=(Min=0.0000000,Max=0.0000000))
        PauseTimeForSingleFireWeapons=(TimeAtShortRange=(Min=0.0000000,Max=0.0000000),TimeAtMediumRange=(Min=0.0000000,Max=0.0000000),TimeAtFarRange=(Min=0.0000000,Max=0.0000000))
    }
};

struct native SPPauseOverBreakPercent
{
    var() editconst int NearRange;
    var() int MEDIUMRANGE;
    var() int FarRange;

    structdefaultproperties
    {
        NearRange=0
        MEDIUMRANGE=0
        FarRange=0
    }
};

struct native SPTargettingRangeWeight
{
    var() float InNearRangeWeight;
    var() float InMediumRangeWeight;
    var() float InFarRangeWeight;

    structdefaultproperties
    {
        InNearRangeWeight=0.0000000
        InMediumRangeWeight=0.0000000
        InFarRangeWeight=0.0000000
    }
};

struct native SPGrenadeDelayRange
{
    var() FloatDifficulty Min;
    var() FloatDifficulty Max;

    structdefaultproperties
    {
        Min=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        Max=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

/** VARIABLE DECLARATIONS */
var(EnemyRange) float EnemyMaxNearRange;
var(EnemyRange) float EnemyMaxMediumRange;
var(FiringBreak) SPWeaponBurst WeaponBurst;
/** breaks are for separate animations to play as an alternative to firing */
var(FiringBreak) SPWeaponBreak WeaponBreak;
/** pauses are for short breaks in firing, but maintains the aim */
var(FiringBreak) SPWeaponPause WeaponPause;
var(FiringBreak) SPPauseOverBreakPercent PauseOverBreakPercent;
var(FiringBreakOLDDONTUSE) SPFloatRange BreakTimeAtFarRange;
var(FiringBreakOLDDONTUSE) SPFloatRange BreakTimeAtMedRange;
var(FiringBreakOLDDONTUSE) SPFloatRange BurstTimeAtFarRange;
var(FiringBreakOLDDONTUSE) SPFloatRange BurstTimeAtMedRange;
var(Common) FloatDifficulty HeadShotDamageMultiplier;
var(Aiming) SPTuneAimingParams MinRange;
var(Aiming) SPTuneAimingParams MaxRange;
/** this is the maximum angular difference between the direction we are pointing the weapon and the direction to our target that which we can still fire */
var(Aiming) float MaxHorizontalAngleDifferenceForFiring;
/** this is the maximum angular difference between the direction we are pointing the weapon and the direction to our target that which we can still fire */
var(Aiming) float MaxVerticalAngleDifferenceForFiring;
var(AI) FloatDifficulty MinShootDist;
var(AI) FloatDifficulty MaxShootDist;
var(AI) float MinDistToStandNearPlayerHostile;
var(AI) float MinDistToStandNearNPCHostile;
var(AI) float MinDistToStandNearWerewolfHostile;
var(AI) float MinDistToStandNearDefaultCreatureHostile;
var(AI) float PreferredAttackRange;
var(AI) float PreferredDistanceToMove;
/** var(AI)floatMinDistanceToMove;var(AI)floatMaxDistanceToMove; */
var(AI) float MaxDistanceToMoveToCover;
/** half-width and half-height of line check used to check for friendlies in the way before firing.  Make sure x and y are same value. */
var(AI) Vector CheckForFriendliesBeforeFiringExtent;
/** this is really the maximum distance from us to add weight.  it doesn't exclude out of this range, which is why it should be a lower value */
var(AI) float MaxDistanceToMoveToNonCover;
/** minimum time for a SuggestReevaluate to occur (internal use only please) */
var(AI) float MinSuggestReevaluateTime;
/** maximum time for a SuggestReevaluate to occur (internal use only please) */
var(AI) float MaxSuggestReevaluateTime;
/** the minimum time to wait when we periodically call EvaluateSituation while moving to a destination (only used when not moving to cover) */
var(AI) float MinMoveToGoalReevaluateCheckTime;
/** the maximum time to wait when we periodically call EvaluateSituation while moving to a destination (only used when not moving to cover) */
var(AI) float MaxMoveToGoalReevaluateCheckTime;
/** minimum time to sleep for after we fail our firing chck (internal use only please) */
var(AI) float MinFailedFiringCheckSleepTime;
/** maximum time to sleep for after we fail our firing chck (internal use only please) */
var(AI) float MaxFailedFiringCheckSleepTime;
/** a delay to prevent us from reevaluating too often and bogging down CPU (internal use only) */
var(AI) float EnemyTooCloseReevaluateDelay;
/** if true, enemy AI will try and not run past the player (not fool-proof), unless the player gets too close */
var(AI) bool bTryToPreventRunningByPlayerUnlessPlayerTooClose;
/** if true, enemy AI will try and not run past the player (not fool-proof) */
var(AI) bool bAlwaysTryToPreventRunningByPlayer;
/** only use high aggression against the player */
var(Aggression) bool bOnlyUseHighAggressionVsPlayer;
/** turn on to only allow player damage to cause cover to become invalid */
var(DamagedAtCover) bool bOnlyReactToPlayerBullets;
/** turn on to prevent soldiers leaving cover they were damaged at when there are no other coverpoints to move to */
var(DamagedAtCover) bool bAllowedToUseCoverWeWereDamagedAtIfNoOtherCover;
/** turns on the functionality to not use coverpoints a squad member died at for the duration specified by DurationToInvalidateCoverWeDiedAt */
var(DamagedAtCover) bool bAllowedToUseCoverOthersDiedAtIfNoOtherCover;
/** percetage value between 0 and 1 that favors how much we sidestep vs how much we back up when the player gets in cose (high values here can cause the enemy to think its OK to run past the player when cornered) */
var(AI) float PlayerTooCloseSidestepPercentage;
/** this is the maximum angular difference between our current rotation and the direction to our target before we decide to turn and face the target during standing attack */
var(AI) int StandAttackMaxHalfAngleBeforeTurning;
/** maximum number of squad mates that can be in high aggression at once (can be exceeded if designer uses Kismet commands to force high aggression) */
var(Aggression) int MaxSquadMembersToUseHighAggressionAtOnce;
/** only start looking for our enemy if we are at least this far away from them */
var(Aggression) float MinDistanceFromEnemyToEngageSearching;
/** only start looking for our enemy if we haven't seen them for this amount of time (time only starts after we've engaged the enemy) */
var(Aggression) float SearchForEnemyIfNotSeenForThisDuration;
/** the amount of time we mark a paired spot (our loc comboed with our enemy's loc) as bad when we cant see our enemy in high aggression.  Defaults to forever */
var(Aggression) float CantSeeEnemyInHighAggressionBadPairDuration;
/** if the soldier is in high aggression, but hasn't had a valid target to use high aggression on for this duration, he will fall back to normal aggression */
var(Aggression) float TimeOutOfHighAggressionIfNotValidTargetDuration;
/** when our under fire meter reaches this threshold, we consider ourselves suppressed.  VALUE SHOULD BE BETWEEN 0 and 1.0 */
var(Suppression) float UnderFireMeterAtWhichWeAreSuppressed;
/** the amount to udjust our under fire meter each time we take damage. VALUE SHOULD BE BETWEEN 0 and 1.0 */
var(Suppression) float UnderFireAdjustmentForBeingHit;
/** the amount to udjust our under fire meter each a bullet comes close to us. VALUE SHOULD BE BETWEEN 0 and 1.0 */
var(Suppression) float UnderFireAdjustmentForNearMiss;
/** random chance to reset under fire.  VALUE SHOULD BE BETWEEN 0 and 1.0.  This happens every 0.5 seconds */
var(Suppression) float DefaultRandomChanceToResetUnderFireMeter;
/** random chance to reset under fire when moving.  VALUE SHOULD BE BETWEEN 0 and 1.0.  This happens every 0.5 seconds */
var(Suppression) float RandomChanceToResetUnderFireMeterWhileMoving;
/**  
 *this controls how fast the UnderFireMeter decays.  It does not decay linearly.  A value of 0 would never decay.  A
 *value of 1.0 would take about a second.  A value of 2.0 would be almost instant
 */
var(Suppression) float DefaultUnderFireMeterDecayValue;
/**  
 *this controls how fast the UnderFireMeter decays when moving.  It does not decay linearly.  A value of 0 would never decay.  A
 *value of 1.0 would take about a second.  A value of 2.0 would be almost instant
 */
var(Suppression) float UnderFireMeterDecayValueWhileMoving;
/** when we get shot, we prevent the UnderFireMeter from decaying for this length of time */
var(Suppression) float DefaultUnderFireMeterPreventDecayForDurationAfterBeingShot;
/** when we get shot while moving, we prevent the UnderFireMeter from decaying for this length of time */
var(Suppression) float UnderFireMeterPreventDecayForDurationAfterBeingShotWhileMoving;
var(Movement) FloatDifficulty MaxTimeToStrafe;
/** allows us to ignore the MaxTimeToStrafe if we are close to our destination so we don't turn unnecessarily */
var(Movement) FloatDifficulty PercentChanceToStrafeAtBeginningOfMove;
var(Movement) float DistanceFromDestinationAtWhichToIgnoreStrafeTime;
var(FindDestWeights) float RangeToTargetWeight;
var(FindDestWeights) float DistanceToMoveWeight;
var(FindDestWeights) float CurrentDestinationWeight;
var(FindDestWeights) float HostileTooCloseWeight;
var(FindDestWeights) float HostilePlayerTooCloseWeight;
var(FindDestWeights) float HostileBehindUsWeight;
var(FindDestWeights) float ICanShootThemWeight;
var(FindDestWeights) float ICantShootThemWeight;
var(FindDestWeights) float TheyCanShootMeWeight;
var(FindDestWeights) float TheyCantShootMeWeight;
var(FindDestWeights) float CurrentCoverWeight;
var(FindDestWeights) float PreviousCoverWeight;
var(FindDestWeights) float CantShootRatingBiasPerSecond;
var(FindDestWeights) float MinCantShootRatingBias;
var(FindDestWeights) float OutsideOfAimProfileWeight;
var(FindDestWeights) float SidednessWeight;
/** weight of our current destination (if not at cover) */
var(FindDestWeights) float CurrentNonCoverDestinationWeight;
var(Cover) float BreakCoverDistanceForExposure;
var(Cover) float BreakCoverLastPerceivedDurationForExposure;
var(Cover) float BreakCoverIfHumanIsWithinDistance;
var(Cover) float BreakCoverIfWerewolfIsWithinDistance;
var(Cover) float BreakCoverIfDefaultCreatureIsWithinDistance;
var(Cover) float BreakCoverLastDamagedDurationForExposure;
var(Cover) float SuggestedMinTimeAtCoverIfNoVisibleEnemy;
/** this is a percent chance that we should stop firing and hide when we are fired upon at cover.  Not 100% accurate because it can be checked multiple times when UnderFire */
var(Cover) FloatDifficulty UnderFireSoWeShouldHidePercent;
/** minimum amount of time to sleep for if we choose to hide at cover when fired upon */
var(Cover) float MinHideFromFiringSleepTime;
/** maximum amount of time to sleep for if we choose to hide at cover when fired upon */
var(Cover) float MaxHideFromFiringSleepTime;
/** the amount of damage we need to sustain before we consider our current coverpoint invalid */
var(DamagedAtCover) float MinDamageTakenAtCoverToInvalidate;
/** the amount of time to invalidate a coverpoint, for ourselves only, that we were damaged at */
var(DamagedAtCover) float DurationToInvalidateCoverWeWereDamagedAt;
/** the amount of time a coverpoint will be considered invalid for other members of the squad if somebody dies at that cover */
var(DamagedAtCover) float DurationToInvalidateCoverWeDiedAt;
/** maximum time to weight before updating our targetting weights */
var(Targetting) float MaxUpdateTargetInterval;
/** weights our current enemy by this amount */
var(Targetting) float CurrentEnemyWeight;
/** weight applied if the player is in certain range */
var(Targetting) SPTargettingRangeWeight PlayerTargetRangeWeight;
/** weight applied if an NPC is in certain range */
var(Targetting) SPTargettingRangeWeight NPCTargetRangeWeight;
/** weight applied if the werewolf is in certain range */
var(Targetting) SPTargettingRangeWeight WerewolfTargetRangeWeight;
/** weight applied if the unspecified creature is in certain range */
var(Targetting) SPTargettingRangeWeight DefaultTargetRangeWeight;
/** treats a suppression message as doing this amount of damage (helps soldiers react to being shot at as opposed to just hit) */
var(Targetting) float TreatSuppressionAsDamageAmount;
/** broadcasts damage inflicted to nearby squad members in this range */
var(Targetting) FloatDifficulty BroadcastDamageToSquadMemberRange;
/** value above which a threat is considered 'imminent' and can't be ignored */
var(Targetting) float MinImminentThreatRating;
/** minimim time to fire at a target before switching if we don't have an imminent threat */
var(Targetting) float MinTimeToFireAtNonImminentThreatAtCover;
/** if shot in the back within this time period, that threat is considered 'imminent' */
var(Targetting) float ImminentThreatFromBeingShotInBackTimeOut;
/** how much weight due to damage decays per second */
var(Targetting) float DamageWeightDecayPerSecond;
/** maximum weight that damage accrual can be (can be larger than actual health since suppression is treated as damage for targeting weight) */
var(Targetting) float MaxWeightDueToDamage;
/** if any friendlies are within this circle, we can't throw a grenade */
var(Grenades) float FriendliesInGrenadeRangeCylinderRadius;
/** if any friendlies are within this height, we can't throw a grenade */
var(Grenades) float FriendliesInGrenadeRangeCylinderHeight;
/** specifies a random range of time to wait before the squad allows members to throw grenades again */
var(Grenades) SPGrenadeDelayRange MinTimeBetweenSquadGrenadeThrows;
/** specifies a random range of time to wait before the an individual soldier tries throw grenades again */
var(Grenades) SPGrenadeDelayRange MinTimeBetweenIndividualGrenadeThrows;
/** maximum soldiers in a squad that can throw grenades at the same time */
var(Grenades) FloatDifficulty MaxSquadMembersThrowingGrenadesAtOnce;
/** pitch differential in rotator units that classifies a target as being 'on higher ground' */
var(Grenades) int GrenadeThrowToHigherTargetPitchDifferential;
/** pitch adjustment used when throwing at a target on 'higher ground' */
var(Grenades) int GrenadeThrowHigherTargetPitchAdjustment;
/** pitch differential in rotator units that classifies a target as being 'on lower ground' */
var(Grenades) int GrenadeThrowToLowerTargetPitchDifferential;
/** pitch adjustment used when throwing at a target on 'lower ground' */
var(Grenades) int GrenadeThrowLowerTargetPitchAdjustment;
/** pitch adjustment used when throwing at a target on 'level ground' */
var(Grenades) int GrenadeThrowLevelTargetPitchAdjustment;
/** minimum distance from the target we must be to throw grenades */
var(Grenades) float MinDistanceToThrowGrenade;
/** maximum distance from the target we must be to throw grenades */
var(Grenades) float MaxDistanceToThrowGrenade;
/** if the target has moved more than this distance from their last seen location, then we can't throw */
var(Grenades) float MaxDistanceFromLastSeenLocationForGrenadeThrow;
/** the minimum cosine of the angle between our facing dir and the dir to the target */
var(Grenades) float MinGrenadeThrowAngleCosine;
/** scales velocity into a distance we need to come up short by on our throws to account for friction */
var(Grenades) float GrenadeHorizontalVelocityToFrictionScale;
/** a timout period used to reduce geometry checks for performance reasons */
var(Grenades) float GrenadeThrowTimeOutWhenGeometryChecksFail;
var(Grenades) FloatDifficulty PercentGrenadeThrowsOnTarget;
var(Grenades) FloatDifficulty GrenadeAccuracyRadiusMediumRange;
var(Grenades) FloatDifficulty GrenadeAccuracyRadiusLongRange;
/** Once we start running from a grenade, we will keep running until the grenade explodes or we are this far from the EDGE of the explosion radius */
var(ReactionToGrenades) float MinDistanceFromExplosionRadiusToIgnoreGrenade;
/** This is the maximum amount of time to pause before reacting to a grenade, so that there is some randomness.  Otherwise everybody would react at exactly the same time */
var(ReactionToGrenades) float MaxTimeToWaitForGrenadeReaction;
/** This value controls how the upper body is blend with the lower body when using wild fire.  Please dont touch, unless you know what you're doing */
var(animation) float UpperBodyBlendModifierDuringWildfire;
/** This controls the frequency that the flame guy needs to reload.  He will consume this much ammo in his magazine per second */
var(HeaveWeaponFlame) float AmmoConsumedPerSecond;
/** this value is for internal use only and should not be modified */
var(StepAside) float DesiredStepAsideGoalStopConditionPercentage;
/** the desired distance we wish to step aside when bumped by somebody that can make us stepaside */
var(StepAside) float DesiredStepAsideDistance;

function float GetHeadShotDamageMultiplier()
{
    return GetValue(HeadShotDamageMultiplier);
    //return ReturnValue;    
}

private final function Convert(SPTuneAimingParams tparam, out SPAimingParams Param)
{
    Param.Distance = GetValue(tparam.Distance);
    Param.percentageOnTargetShots = float(Clamp(int(GetValue(tparam.percentageOnTargetShots)), 0, 100));
    Param.miss.Min = float(Clamp(int(GetValue(tparam.miss.Min)), 32, 500));
    Param.miss.Max = float(Clamp(int(GetValue(tparam.miss.Max)), 32, 500));
    Param.miss.Height = GetValue(tparam.miss.Height);
    // End:0x198
    if(Param.miss.Height < float(0))
    {
        Param.miss.Height = -Param.miss.Height;
    }
    //return;    
}

function GetMinRange(out SPAimingParams Param)
{
    Convert(MinRange, Param);
    //return;    
}

function GetMaxRange(out SPAimingParams Param)
{
    Convert(MaxRange, Param);
    //return;    
}

function float GetMinShootDist()
{
    return GetValue(MinShootDist);
    //return ReturnValue;    
}

function float GetMaxShootDist()
{
    return GetValue(MaxShootDist);
    //return ReturnValue;    
}

function float TimeFromRange(SPFloatRange Range)
{
    return RandRange(Range.Min, Range.Max);
    //return ReturnValue;    
}

function int CountFromRange(SPIntRange Range)
{
    return int(RandRange(float(Range.Min), float(Range.Max) + 0.9900000));
    //return ReturnValue;    
}

function bool ShouldPauseInsteadOfBreak(bool bIsAutomaticWeapon, SPPawn.EEnemyRange rangeToEnemy)
{
    local int randNum;

    randNum = Rand(100);
    switch(rangeToEnemy)
    {
        // End:0x2F
        case 0:
            return PauseOverBreakPercent.NearRange > randNum;
        // End:0x4C
        case 1:
            return PauseOverBreakPercent.MEDIUMRANGE > randNum;
        // End:0x69
        case 2:
            return PauseOverBreakPercent.FarRange > randNum;
        // End:0xFFFF
        default:
            return PauseOverBreakPercent.NearRange > randNum;
            break;
    }
    //return ReturnValue;    
}

function float GetBreakTime(bool bIsAutomaticWeapon, SPPawn.EEnemyRange rangeToEnemy)
{
    local float Time;

    switch(rangeToEnemy)
    {
        // End:0x72
        case 0:
            // End:0x44
            if(bIsAutomaticWeapon)
            {
                Time = TimeFromRange(WeaponBreak.BreakTimeForAutomaticWeapons.TimeAtShortRange);                
            }
            else
            {
                Time = TimeFromRange(WeaponBreak.BreakTimeForSingleFireWeapons.TimeAtShortRange);
            }
            // End:0x1AE
            break;
        // End:0xDC
        case 1:
            // End:0xAE
            if(bIsAutomaticWeapon)
            {
                Time = TimeFromRange(WeaponBreak.BreakTimeForAutomaticWeapons.TimeAtMediumRange);                
            }
            else
            {
                Time = TimeFromRange(WeaponBreak.BreakTimeForSingleFireWeapons.TimeAtMediumRange);
            }
            // End:0x1AE
            break;
        // End:0x146
        case 2:
            // End:0x118
            if(bIsAutomaticWeapon)
            {
                Time = TimeFromRange(WeaponBreak.BreakTimeForAutomaticWeapons.TimeAtFarRange);                
            }
            else
            {
                Time = TimeFromRange(WeaponBreak.BreakTimeForSingleFireWeapons.TimeAtFarRange);
            }
            // End:0x1AE
            break;
        // End:0xFFFF
        default:
            // End:0x180
            if(bIsAutomaticWeapon)
            {
                Time = TimeFromRange(WeaponBreak.BreakTimeForAutomaticWeapons.TimeAtFarRange);                
            }
            else
            {
                Time = TimeFromRange(WeaponBreak.BreakTimeForSingleFireWeapons.TimeAtFarRange);
            }
            // End:0x1AE
            break;
            break;
    }
    return Time;
    //return ReturnValue;    
}

function float GetPauseTime(bool bIsAutomaticWeapon, SPPawn.EEnemyRange rangeToEnemy)
{
    local float Time;

    switch(rangeToEnemy)
    {
        // End:0x72
        case 0:
            // End:0x44
            if(bIsAutomaticWeapon)
            {
                Time = TimeFromRange(WeaponPause.PauseTimeForAutomaticWeapons.TimeAtShortRange);                
            }
            else
            {
                Time = TimeFromRange(WeaponPause.PauseTimeForSingleFireWeapons.TimeAtShortRange);
            }
            // End:0x1AE
            break;
        // End:0xDC
        case 1:
            // End:0xAE
            if(bIsAutomaticWeapon)
            {
                Time = TimeFromRange(WeaponPause.PauseTimeForAutomaticWeapons.TimeAtMediumRange);                
            }
            else
            {
                Time = TimeFromRange(WeaponPause.PauseTimeForSingleFireWeapons.TimeAtMediumRange);
            }
            // End:0x1AE
            break;
        // End:0x146
        case 2:
            // End:0x118
            if(bIsAutomaticWeapon)
            {
                Time = TimeFromRange(WeaponPause.PauseTimeForAutomaticWeapons.TimeAtFarRange);                
            }
            else
            {
                Time = TimeFromRange(WeaponPause.PauseTimeForSingleFireWeapons.TimeAtFarRange);
            }
            // End:0x1AE
            break;
        // End:0xFFFF
        default:
            // End:0x180
            if(bIsAutomaticWeapon)
            {
                Time = TimeFromRange(WeaponPause.PauseTimeForAutomaticWeapons.TimeAtFarRange);                
            }
            else
            {
                Time = TimeFromRange(WeaponPause.PauseTimeForSingleFireWeapons.TimeAtFarRange);
            }
            // End:0x1AE
            break;
            break;
    }
    return Time;
    //return ReturnValue;    
}

function float GetBurstTime(SPPawn.EEnemyRange rangeToEnemy)
{
    local float Time;

    switch(rangeToEnemy)
    {
        // End:0x3B
        case 0:
            Time = TimeFromRange(WeaponBurst.BurstTimeForAutomaticWeapons.TimeAtShortRange);
            // End:0xD2
            break;
        // End:0x6E
        case 1:
            Time = TimeFromRange(WeaponBurst.BurstTimeForAutomaticWeapons.TimeAtMediumRange);
            // End:0xD2
            break;
        // End:0xA1
        case 2:
            Time = TimeFromRange(WeaponBurst.BurstTimeForAutomaticWeapons.TimeAtFarRange);
            // End:0xD2
            break;
        // End:0xFFFF
        default:
            Time = TimeFromRange(WeaponBurst.BurstTimeForAutomaticWeapons.TimeAtFarRange);
            // End:0xD2
            break;
            break;
    }
    return Time;
    //return ReturnValue;    
}

function int GetBurstCount(SPPawn.EEnemyRange rangeToEnemy)
{
    local float Time;

    switch(rangeToEnemy)
    {
        // End:0x3D
        case 0:
            Time = float(CountFromRange(WeaponBurst.BurstCountForSingleFireWeapons.CountAtShortRange));
            // End:0xDA
            break;
        // End:0x72
        case 1:
            Time = float(CountFromRange(WeaponBurst.BurstCountForSingleFireWeapons.CountAtMediumRange));
            // End:0xDA
            break;
        // End:0xA7
        case 2:
            Time = float(CountFromRange(WeaponBurst.BurstCountForSingleFireWeapons.CountAtFarRange));
            // End:0xDA
            break;
        // End:0xFFFF
        default:
            Time = float(CountFromRange(WeaponBurst.BurstCountForSingleFireWeapons.CountAtFarRange));
            // End:0xDA
            break;
            break;
    }
    return int(Time);
    //return ReturnValue;    
}
