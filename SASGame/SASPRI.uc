//=============================================================================
// SASPRI.uc
//=============================================================================

class SASPRI extends PlayerReplicationInfo
	native;

const DOUBLE_TAP_FIRING_SEPERATION_MAX		= 0.5;
const DOUBLE_TAP_FIRING_SEPERATION_TIMEOUT	= 0.5; 

///////////////////////////////////////////////////////////////////////////////

// Player firing and kill stats
var float				mScore;

// Stats on firing and hit location
var int					mPlayerBulletsFired;
var int					mPlayerWeaponsFired;
var int					mPlayerBulletsHitEnemy;
var int					mPlayerBulletsHitEnemyHead;
var int					mPlayerBulletsHitEnemyBody;
var int					mPlayerBulletsHitEnemyLimbs;
var int					mPlayerDoubleTaps;

var float				mPrevFireTime;
var float				mPrevFiringSeperation;
var bool				mbPreviousFireWasDoubleTap;

var float				mLastGrenadeKillTime;
var int					mSingleGrenadeKills;

/*
// Stats on kills
var int					mPlayerKills;
var int					mPlayerHeadShotKills;
var int					mPlayerEnemiesIncapacitated;
var int					mPlayerKnifeKills;
var int					mPlayerNinjaCount;
var bool				mPlayerBowler;
var int					mPlayerArrests;
var int					mPlayerKilledCaptive;
*/

var int					mSpecialAwards [NUM_SPECIAL_AWARDS];

enum ESabreSquadPromoteDemoteStatus
{
	PDSTATUS_None,					// No change
	PDSTATUS_PromotedKiller,		// Promoted because killed SAS
	PDSTATUS_DemotedKilled,			// Demoted because killed by terrorist 
	PDSTATUS_DemotedTeamKiller,		// Demoted because killed teammate
	PDSTATUS_PromotedBalance,		// Promoted to balance teams
	PDSTATUS_DemotedBalance,		// Demoted to balance teams
};
var ESabreSquadPromoteDemoteStatus	mSSquadPromoteDemoteStatus;
var SASPRI				mSSquadPromoteDemoteOtherPRI;

///////////////////////////////////////////////////////////////////////////////
//
// No idea how much of the above data will need to be replicated

replication
{
	reliable if ( bNetDirty && ( Role == ROLE_Authority ) )
		mPlayerBulletsHitEnemy,
		mPlayerBulletsHitEnemyHead,
		mPlayerBulletsHitEnemyBody,
		mPlayerBulletsHitEnemyLimbs,
		mSSquadPromoteDemoteStatus,
		mSSquadPromoteDemoteOtherPRI;
		// POSSIBLE SCREWUP....this wasnt commented here!
		//auronafix why have they commented this out?
		/*mPlayerKills,
		mPlayerHeadShotKills,
		mPlayerEnemiesIncapacitated,
		mPlayerKnifeKills,
		mPlayerNinjaCount,
		mPlayerBowler,
		mPlayerArrests,
		mbPlayerKilledCaptive;*/

	reliable if ( bNetDirty && ( Role < ROLE_Authority ) )
		mPlayerBulletsFired;
}

// extract data to player profile 
native simulated function UpdatePlayerProfile ();

///////////////////////////////////////////////////////////////////////////////

// Fired a bullet
simulated function BulletFired(
	bool bCheckDoubleTap )
{
	local float		newFiringSeperation;

	if (	Level.GetLocalPlayerController().GameReplicationInfo != None &&
			SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo ).mbRecordStats )
	{
		mPlayerBulletsFired+=Level.GetLocalPlayerController().Pawn.Weapon.mRoundsPerShot;;
		mPlayerWeaponsFired+=1;
		
		if ( bCheckDoubleTap )
		{
			if ( mPrevFireTime == 0.0 )
			{
				newFiringSeperation = 999.9;
			}
			else
			{
				newFiringSeperation = Level.TimeSeconds - mPrevFireTime;
			}

			// Have we recorded a firing seperation yet?
			if ( mPrevFiringSeperation > 0.0 )
			{
				// First check if we had recorded a double tap between the previous 2 rounds.
				if ( mPrevFiringSeperation < DOUBLE_TAP_FIRING_SEPERATION_TIMEOUT )
				{
					// If we've fired again too quickly then need to de-record the previous double tap.
					if (	mbPreviousFireWasDoubleTap &&
							(newFiringSeperation < DOUBLE_TAP_FIRING_SEPERATION_TIMEOUT) )
					{
						mPlayerDoubleTaps--;
						mbPreviousFireWasDoubleTap = false;
					}
				}
				// Now check to see if this bullet is the second in a double tap.
				else if ( newFiringSeperation < DOUBLE_TAP_FIRING_SEPERATION_MAX )
				{
					mPlayerDoubleTaps++;
					mbPreviousFireWasDoubleTap = true;
				}
			}
			
			// Record firing seperation for next time. 
			mPrevFiringSeperation = newFiringSeperation;
			mPrevFireTime = Level.TimeSeconds;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// Called when an enemy is killed with a grenade. Used to check for attaining
// 'bowler' reward (>=2 kills with 1 grenade).
function KilledEnemyWithGrenade()
{
	if ( mPlayerBowler )
	{
		return;
	}

	if ( mLastGrenadeKillTime < Level.TimeSeconds )
	{
		mSingleGrenadeKills = 1;
	}
	else
	{
		mSingleGrenadeKills++;
		if ( mSingleGrenadeKills > 2 )
		{
			mPlayerBowler = true;
		}
	}

	mLastGrenadeKillTime = Level.TimeSeconds;
}

///////////////////////////////////////////////////////////////////////////////

// We've hit an enemy
event BulletHitNME (ESASBodyParts location)
{
	if ( SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo ).mbRecordStats )
	{
		mPlayerBulletsHitEnemy++;

		switch (location)
		{
			case BODYPART_HEAD :
				mPlayerBulletsHitEnemyHead++;
				break;

			case BODYPART_BODY :
				mPlayerBulletsHitEnemyBody++;
				break;

			case BODYPART_LARM :
			case BODYPART_RARM :
			case BODYPART_LLEG :
			case BODYPART_RLEG :
				mPlayerBulletsHitEnemyLimbs++;
				break;
		} // switch
	}
}
///////////////////////////////////////////////////////////////////////////////

// Update Scores
simulated function UpdateScore ()
{
	local SASGRI		gri;
	local SASLevelData	levelData;

	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );
	levelData = gri.mLevelData;

	mScore = levelData.mInitialScore;
	LOG( "PRI Scoring: Initial = "$mScore ); 

	mScore = mScore + ( mPlayerBulletsFired - mPlayerBulletsHitEnemy ) * levelData.mScorePerShotMissed;
	LOG( "PRI Scoring: to "$mScore$" after applying missed shots" ); 

	mScore = mScore + mPlayerBulletsHitEnemy  * levelData.mScorePerShotHit;
	LOG( "PRI Scoring: to "$mScore$" after applying hit shots" ); 

	mScore = mScore + gri.mSquadMembersKilled * levelData.mDeathScoreSAS;
	LOG( "PRI Scoring: to "$mScore$" after applying squaddies killed" ); 

	mScore = mScore + gri.mHostagesKilled     * levelData.mDeathScoreHostage;
	LOG( "PRI Scoring: to "$mScore$" after applying hostages killed" ); 

	mScore = mScore + gri.mTerroristsKilled   * levelData.mDeathScoreTerrorist;
	LOG( "PRI Scoring: to "$mScore$" after applying terrorists killed" ); 

	mScore = mScore + gri.mTerroristsCaptured * levelData.mCaptureScoreTerrorist;
	LOG( "PRI Scoring: to "$mScore$" after applying terrorists captured" ); 

	mScore = mScore + gri.mTerroristsSurrenderedAndKilled * levelData.mDeathScoreTerroristSurrendered;
	LOG( "PRI Scoring: to "$mScore$" after applying terrorists captured and killed" );
}
///////////////////////////////////////////////////////////////////////////////

// Update and return score
simulated function float GetUpdatedScore()
{
	UpdateScore ();
	updateSpecialAwards ();
	UpdatePlayerProfile ();
		
	return mScore;
}

///////////////////////////////////////////////////////////////////////////////

simulated function updateSpecialAwards ()
{
//	eSpecialAwards a;
	local int playerCasualties;
	local float percent;

	Log ("--UPDATING SPECIAL AWARDS--");

	// Awards are calculated against total of kills and incaps
	playerCasualties = mPlayerKills + mPlayerEnemiesIncapacitated;

	if ( playerCasualties > 0 )
	{
		// Headshots
		percent = float (mPlayerHeadShotKills) / float (playerCasualties);
		Log ("Headshot = " $percent);
		if (percent >= 0.9)
		{
			mSpecialAwards [AWARD_HeadshotHoncho] = 1;
		} // if
		else if (percent >= 0.5)
		{
			mSpecialAwards [AWARD_HeadHunter] = 1;
		} // if

		// Incapacitations
		percent = float (mPlayerEnemiesIncapacitated) / float (playerCasualties);
		Log ("Incap = " $percent);
		if (	mPlayerRuthlessKiller &&
				playerCasualties > 0 &&
				mPlayerEnemiesIncapacitated == 0)
		{
			mSpecialAwards [AWARD_Executor] = 1;
		} // if
		else if (percent >= 0.9)
		{
			mSpecialAwards [AWARD_Brutaliser] = 1;
		} // else if
		else if (percent >= 0.5)
		{
			mSpecialAwards [AWARD_Incapacitator] = 1;
		} // else if

		// Knife kills
		if (mPlayerKnifeKills > 0)
		{
			mSpecialAwards [AWARD_HatchetMan] = 1;

			percent = float (mPlayerKnifeKills) / float (playerCasualties);
			Log ("Knife = " $percent);
			if (percent >= 0.5)
			{
				mSpecialAwards [AWARD_Frosty] = 1;
			} // if
		} // if

		// Killing enemies before they fire
		percent = float (mPlayerNinjaCount) / float (playerCasualties);
		Log ("Ninja = " $percent);
		if (percent >= 0.5)
		{
			mSpecialAwards [AWARD_Ninja] = 1;
		} // if

		// Special case grenade award - not likely to ever be achieved
		if (mPlayerBowler)
		{
			mSpecialAwards [AWARD_Bowler] = 1;
		} // if
	}

	// Capturing more terrorists than killed.
	if ( (mPlayerArrests > 0) && (mPlayerArrests >= mPlayerKills) && (mPlayerKilledCaptive == 0) )
	{
		mSpecialAwards [AWARD_ClearConscience] = 1;
	}

	// Double tap firing
	percent = float( mPlayerDoubleTaps ) / (float( mPlayerBulletsFired ) * 0.5);
	if ( percent > 0.5 )
	{
		mSpecialAwards[AWARD_DoubleTapper] = 1;
	}
} // updateSpecialAwards

///////////////////////////////////////////////////////////////////////////////

