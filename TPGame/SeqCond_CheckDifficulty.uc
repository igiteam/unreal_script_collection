// Tells us what difficulty level we're playing on
class SeqCond_CheckDifficulty extends SequenceCondition
	dependson(TPGameInfo);

event Activated()
{
	local OnlineProfileSettings.EProfileDifficultyOptions CurrentDifficulty;
	CurrentDifficulty = TPGameInfo(GetWorldInfo().Game).CurrentDifficulty;

	switch (CurrentDifficulty)
	{
		case PDO_Easy:
			OutputLinks[0].bHasImpulse = true;
			break;
		case PDO_Normal:
			OutputLinks[1].bHasImpulse = true;
			break;
		case PDO_Hard:
			OutputLinks[2].bHasImpulse = true;
			break;
		case PDO_Insane:
			OutputLinks[3].bHasImpulse = true;
			break;
	}

	super.Activated();
}

