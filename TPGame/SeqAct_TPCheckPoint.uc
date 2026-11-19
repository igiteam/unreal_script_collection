/**
 * Copyright ? 2006 Epic Games, Inc. All Rights Reserved.
 **/
class SeqAct_TPCheckPoint extends SequenceAction
	native;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** Scene to open to check device. */
var UIScene CheckDeviceScene;

/** Whether to display the checkpointing text on the screen **/
var() bool bDisplayCheckpointingText;

/** Whether to fire off the check poing activated event **/
var() bool bFireCheckPointActivedEvent;

/** Whether or not we should continue processing. */
var bool bIsDone;

/** Whether or not the checkpoint should actually save. */
var transient bool bShouldSave;

/**
 * Sets up the message box scene.
 */
event SetupScene(UIScene_CheckDevice Scene)
{
	Scene.OnSceneClose = OnSceneClose;
}

/**
 * Called when the device check scene closes.
 */
function OnSceneClose()
{
	bIsDone = true;
}

