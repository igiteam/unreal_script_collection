/**
 * Copyright ? 2006 Epic Games, Inc. All Rights Reserved.
 */

/** Used to allow level designers to issue achievements */
class SeqAct_UnlockAchievement extends SequenceAction
	dependson(TPAchievements);

/** The achievement to unlock */
var() ETPGameAchievements AchievementId;

