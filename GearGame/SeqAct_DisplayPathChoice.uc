/**
 * USeqAct_DisplayPathChoice - Action that will freeze the game and display a choice scene
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_DisplayPathChoice extends SequenceAction
	native(Sequence);


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** Markup for the title label on the dialog. */
var() string TitleLookup;

/** Markup for the Left Choice Description label on the dialog. */
var() string LeftDescLookup;

/** Markup for the Right Choice Description label on the dialog. */
var() string RightDescLookup;

/** Type of path arrow to draw for the left path icon */
var() EPathDirectionIcon    LeftPathIconType;

/** Type of path arrow to draw for the right path icon */
var() EPathDirectionIcon    RightPathIconType;

/** Whether or not the latent action is done executing. */
var bool bIsDone;

/** Result of the message box, whether the user chose OK or Cancel. */
var transient bool bIsLeftChoiceResult;

/** The instance of the opened scene */
var UIScene_PathChoice PathChoiceSceneInstance;

/** music stinger to play for all players when the action is triggered */
var SoundCue StingerSound;

/************************************************************************/
/* C++ functions                                                        */
/************************************************************************/
cpptext
{
	virtual void Activated();

	/**
	 * Polls to see if the async action is done
	 * @param ignored
	 * @return TRUE if the operation has completed, FALSE otherwise
	 */
	UBOOL UpdateOp(FLOAT);
}


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

event Activated()
{
	local GearPC PC;

	foreach GetWorldInfo().AllControllers(class'GearPC', PC)
	{
		PC.ClientPlaySound(StingerSound);
	}
}

/**
 * Initializes the path choice data and freezes the player
 */
event InitializePathChoice( UIScene_PathChoice Scene, LocalPlayer LocPlayer )
{
	PathChoiceSceneInstance = Scene;
	if ( PathChoiceSceneInstance != None )
	{
		PathChoiceSceneInstance.InitializeScene( self, TitleLookup, LeftDescLookup, RightDescLookup );

		// Freeze player
		FreezePlayer( true, LocPlayer );
	}
}

/**
 * Uninitializes the path choice data and unfreezes the game
 */
event UninitializePathChoice()
{
	// Unfreeze player
	FreezePlayer( false, PathChoiceSceneInstance.GetLP() );
}

/** Freeze the player */
final function FreezePlayer( bool bFreeze, LocalPlayer LocPlayer )
{
	local GearPC MyGearPC;

	MyGearPC = GearPC(LocPlayer.Actor);
	if ( MyGearPC != None )
	{
		if ( bFreeze )
		{
			MyGearPC.DisableInput( true, true, true );
		}
		else
		{
			MyGearPC.EnableInput( true, true, true );
		}
	}
}


defaultproperties
{
	ObjName="Display Path Choice"
	ObjCategory="Gear"

	TitleLookup="ChoosePathTitle"
	LeftDescLookup="GENERIC_LeftPathDesc"
	RightDescLookup="GENERIC_RightPathDesc"

	LeftPathIconType=PID_Left
	RightPathIconType=PID_Right

	bAutoActivateOutputLinks=false
	bLatentExecution=true

	OutputLinks(0)=(LinkDesc="Left")
	OutputLinks(1)=(LinkDesc="Right")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target",PropertyName=Targets)

	StingerSound=SoundCue'Music_Stingers.stinger_positive05Cue'
}
