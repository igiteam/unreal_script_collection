/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_Checkpoint extends SeqAct_Latent
	native(Sequence);

/** classes of pawns in the player's squad to teleport. If empty, all squad members are teleported. */
var() array< class<Pawn> > TeleportClasses;
/** if squadmates are NOT in one of these volumes, they will be teleported */
var() array<Volume> TeleportVolumes;
/** array of fallback actors to teleport to if no teleport location found on nav mesh */
var() array<Actor> FallbackTeleportActors;

/** when using the "Force Game Over" input, this is the reason the player(s) will be given
 * mapped to a key in Level_Objectives.int section [FAILURE CONDITONS]
 */
var() string FailureReason;

var() bool bOverrideSavedChapter;

//This is only here to maintain backwards content compatibilty
var deprecated EChapterPoint SavedChapterOverride;

var() int OverrideSavedChapter;


/** human player to use as teleport target for squadmates that are too far away */
var Actor TeleportTargetPlayer;

/** time we were activated - for waiting one tick before triggering "Finished" output */
var transient float ActivationTime;

/** This is used by SeqEvent_CheckpointLoaded to find a checkpoint anywhere in the levels sequence */
var() Name CheckpointName;

var bool bOnlyTeleported;

cpptext
{
public:
	/** File I/O */
	virtual void Serialize( FArchive& Ar );
	virtual FString GetDisplayTitle() const;

	
	virtual void DeActivated();

#if WITH_EDITOR
	virtual void CheckForErrors();
#endif
}


event Activated()
{
	local WorldInfo WorldInfo;
	local GearGameSP_Base Game;
	local GearPC PC;
	local string ObjPathname;

	WorldInfo = GetWorldInfo();
	Game = GearGameSP_Base(WorldInfo.Game);

	bOnlyTeleported = FALSE;

	ObjPathname = PathName(self);
	if( InputLinks[0].bHasImpulse )
	{
		if (bOverrideSavedChapter)
		{
			Game.CurrentChapter = OverrideSavedChapter-1;
			GearGRI_SP(Game.GameReplicationInfo).ChapterNum = Game.CurrentChapter;
		}

		// @STATS - Record checkpoint save point
		`RecordGameStringStat(CHECKPOINT_SAVE, ObjComment != "" ? (ObjPathname$":"$ObjComment) : ObjPathname);

		foreach GetWorldInfo().LocalPlayerControllers(class'GearPC', PC)
		{
			PC.OnCheckpoint(self);
			break;
		}
	}
	else if (InputLinks[1].bHasImpulse)
	{
		// @STATS - Record checkpoint force failure
		`RecordGameStringStat(CHECKPOINT_FAILURE, ObjComment != "" ? (ObjPathname$":"$ObjComment$":"$FailureReason) : ObjPathname$":"$FailureReason);

		foreach GetWorldInfo().AllControllers(class'GearPC', PC)
		{
			PC.GuardianAngelWasKilled();
			PC.ClientGameOver("Level_Objectives.FAILURE CONDITIONS." $ FailureReason, None);
		}
	}
	else if( InputLinks[2].bHasImpulse )
	{
		foreach GetWorldInfo().LocalPlayerControllers(class'GearPC', PC)
		{
			PC.OnCheckpoint(self);
			break;
		}
		bOnlyTeleported = TRUE;
		OutputLinks[2].bHasImpulse = TRUE;
	}

	if( !bOnlyTeleported )
	{
		if (Game != None)
		{
			// @STATS - End then start logging due to checkpoint
			Game.EndLogging("SaveCheckpoint");
			Game.StartLogging();
		}

		OutputLinks[0].bHasImpulse = true;
	}
	ActivationTime = GetWorldInfo().TimeSeconds;
}

event Deactivated()
{
	if (OutputLinks.length > 1) // compat check
	{
		if( !bOnlyTeleported )
		{
			OutputLinks[1].bHasImpulse = true;
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 5;
}

/** @return whether the given Pawn is in one of the teleport volumes */
final function bool ShouldTeleport(Pawn TestPawn, vector TeleportLocation)
{
	local int i;
	local bool bHasValidTeleportVolume;

	if (TeleportVolumes.length > 0)
	{
		bHasValidTeleportVolume = false;
		for (i = 0; i < TeleportVolumes.length; i++)
		{
			if (TeleportVolumes[i] != None)
			{
				bHasValidTeleportVolume = true;
				if (TeleportVolumes[i].Encompasses(TestPawn))
				{
					return false;
				}
			}
		}
		return bHasValidTeleportVolume;
	}

	return false;
}

event bool Update(float DeltaTime)
{
	return (ActivationTime == GetWorldInfo().TimeSeconds);
}

defaultproperties
{
	ObjName="Checkpoint"
	ObjCategory="Gear"
	bCallHandler=false
	bAutoActivateOutputLinks=false

	InputLinks(0)=(LinkDesc="Save")
	InputLinks(1)=(LinkDesc="Force Game Over")
	InputLinks(2)=(LinkDesc="Teleport Only")
	OutputLinks(0)=(LinkDesc="Out")
	OutputLinks(1)=(LinkDesc="Finished")
	OutputLinks(2)=(LinkDesc="Only Teleported")
	VariableLinks.Empty()
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Teleport Target",PropertyName=TeleportTargetPlayer,MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Teleport Volumes",PropertyName=TeleportVolumes)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Fallback Destinations",PropertyName=FallbackTeleportActors)	

	ActivationTime=-100000.0
}
