/**
 * Will pop up a screen for the player to read. 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ShowTutorialScreen extends SeqAct_Latent
	native(Sequence);

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
	virtual void DeActivated();
};

/** title of the pop up screen **/
var() string Title;

/** body text of the screen **/
var() array<string> BodyText;

/** How long to wait after this is fired to display.  (e.g. you just gained exp.  wait a lil bit before slamming up the tutorial) **/
var() float DelayTime;

/** How long the tutorial will stay up on the screen **/
var() float MinTimeForTutorialMessageToStayUp;


/** Whether or not the tutorial should pawn the game. **/
var() bool bShouldPauseGame;

/** Static mesh to spin in background during this briefing */
var()   StaticMesh          SpinMesh;

/** Sound to play when tutorial is shown */
var()   SoundCue            TutorialSound;

/** Type of message to show */
var()   ETutorialMessageType    MessageType;

/** If this tutorial action is currently active */
var bool bTutorialActive;

// filter input should then dismiss this and unpause


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 6;
}



/**
 * Called when this event is activated.
 */
event Activated()
{
	local NanoPC PC;

	bTutorialActive = true;

	PC = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetNanoPC();

	PC.MyNanoHUD.ShowTutorialAction( self );
}


defaultproperties
{
	ObjName="Show Tutorial Screen"
	ObjCategory="Nano"

	OutputLinks.Empty()
	OutputLinks[0]=(LinkDesc="A")
	OutputLinks[1]=(LinkDesc="B")

	//VariableLinks.Empty()
	bCallHandler=FALSE

	DelayTime=0.0f
	MinTimeForTutorialMessageToStayUp=2.0f

	bShouldPauseGame=TRUE
}
