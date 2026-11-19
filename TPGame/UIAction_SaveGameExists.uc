/**
 * This action sees whether a savegame file exists or not.
 *
 * Copyright ? 2006 Epic Games, Inc. All Rights Reserved.
 */
class UIAction_SaveGameExists extends UIAction
	native(Sequence);

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

/** The save game filename to check to see if it exists. */
var() string Filename;

/** Whether or not the latent action has completed. */
var int bIsDone;

/** Whether or not the file exists. */
var int bExists;
var int bIsCorrupted;

