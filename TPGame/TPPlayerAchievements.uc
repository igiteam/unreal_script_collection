// This class defines helper functions to track various achievement progress.
// It was moved out to its own class simply for readability

class TPPlayerAchievements extends Object within TPPlayerController
	dependson(TPAchievements);

// NOTE: This class should not have any data in and of itself, as it will not replicate properly
// Unless it's for Single Player ONLY!
var int CurrentSniperKillCount;
var int CurrentGrappleKillCount;
var float CurrentGrenadeTimer;
var int CurrentGrenadeKillCount;
var float GrenadeTimeLimit;

/** Adds to the EnemiesKilled counter */
simulated function ClientIncrementEnemiesKilled()
{
	local int ReturnVal;
	ReturnVal = ProfileSettings.IncrementEnemiesKilled();
	if (ReturnVal == 1)
		ClientUnlockAchievement(TA_COMBATEXPERIENCE);
	else if (ReturnVal == 2)
		ClientUnlockAchievement(TA_COMBATVETERAN);
	else if (ReturnVal == 3)
		ClientUnlockAchievement(TA_ONEMANARMY);
}

/** Adds to the BulletsFired counter */
simulated function ClientIncrementBulletsFired(int NumFired)
{
	ProfileSettings.IncrementBulletsFired(NumFired);
}

/** Adds to the MPEnemiesKilled counter */
simulated function ClientIncrementMPEnemiesKilled(int NumKilled)
{
	local int ReturnVal;
	ReturnVal = ProfileSettings.IncrementMPEnemiesKilled(NumKilled);
	if (ReturnVal == 1)
		ClientUnlockAchievement(TA_KILLER);
	else if (ReturnVal == 2)
		ClientUnlockAchievement(TA_KILLERINSTINCT);
	else if (ReturnVal == 3)
		ClientUnlockAchievement(TA_MAYBEISHOULDGOOUTSIDE);
}

/** Adds to the BulletsHit counter and updates accuracy*/
simulated function ClientIncrementBulletsHit(int NumHit)
{
	ProfileSettings.IncrementBulletsHit(NumHit);
}

/** Gives the client the intel in question*/
simulated function ClientGiveIntel(int IntelNum)
{
	local int ReturnVal;
	ReturnVal = ProfileSettings.GiveIntel(IntelNum);
	if (ReturnVal == 1)
		ClientUnlockAchievement(TA_SNOOP);
	else if (ReturnVal == 2)
		ClientUnlockAchievement(TA_INTELLECTUAL);
	else if (ReturnVal == 3)
		ClientUnlockAchievement(TA_MASTERSPY);
}

simulated function ClientAddToSprintTime(float Time)
{
	if (ProfileSettings.AddToSprintTime(Time))
		ClientUnlockAchievement(TA_RUN);
}

simulated function ClientCheckAccuracy()
{
	if (ProfileSettings.GetAccuracy() >= 80)
		ClientUnlockAchievement(TA_DEADEYE);
}

simulated function ClientResetSniperKillCount()
{
	CurrentSniperKillCount = 0;
}

simulated function ClientIncrementSniperKillCount()
{
	CurrentSniperKillCount++;
	if (CurrentSniperKillCount >= 10)
		ClientUnlockAchievement(TA_MASTERSNIPER);
}

simulated function ClientResetGrappleKillCount()
{
	CurrentGrappleKillCount = 0;
}

simulated function ClientIncrementGrappleKillCount()
{
	CurrentGrappleKillCount++;
	if (CurrentGrappleKillCount >= 15)
		ClientUnlockAchievement(TA_CLINGY);

	if (ProfileSettings.IncrementGrappleKills())
		ClientUnlockAchievement(TA_ENVIRONMENTALISM);
}

simulated function ClientIncrementRankedGamesWon(bool bTeamGame)
{
	local int ReturnVal;
	ReturnVal = ProfileSettings.IncrementRankedGamesWon(bTeamGame);
	if (ReturnVal + 1 == 20 && bTeamGame)
		ClientUnlockAchievement(TA_TEAMPLAYER);
	else if (!bTeamGame && ReturnVal == 2)
		ClientUnlockAchievement(TA_PH34RM3H);
}

simulated function ClientUpdateGrenadeTimer(float DeltaTime)
{
	if (CurrentGrenadeTimer != 0.0f)
	{
		CurrentGrenadeTimer -= DeltaTime;
		if (CurrentGrenadeTimer < 0.0f)
		{
			CurrentGrenadeTimer = 0.0f;
			CurrentGrenadeKillCount = 0;
		}
	}
}

simulated function ClientIncrementGrenadeKillCount()
{
	if (CurrentGrenadeTimer == 0.0f)
		CurrentGrenadeTimer = GrenadeTimeLimit;

	CurrentGrenadeKillCount++;
	if (CurrentGrenadeKillCount >= 4)
		ClientUnlockAchievement(TA_EXPLODINGMONKEY);
}

