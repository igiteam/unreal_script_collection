/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_TattlerBotDock extends Interface;

/** Return the actor this interface is bound to */
simulated function Actor GetInterfaceActor();

/** Retrieve location that tattler bot should dock */
simulated function Vector GetDockLocation(NanoPawn_MetaCorp_SentryBotBase InBot, optional bool bFinalDock);

/** Retrieve direction that tattlr bot should look */
simulated function Vector GetDockLookDir(NanoPawn_MetaCorp_SentryBotBase InBot);

/** Bot is returning to the dock */
simulated function PrepareReturnToDock(NanoPawn_MetaCorp_SentryBotBase InBot);

/** Undock the tattler from this dock */
simulated function PrepareToUndockBot(NanoPawn_MetaCorp_SentryBotBase InBot);

/** Dock the tattler bot to in this dock */
simulated function PrepareToDockBot(NanoPawn_MetaCorp_SentryBotBase InBot);

/** Any fixup to be done when bot has finished moving to the dock location */
simulated function CompleteDock( NanoPawn_MetaCorp_SentryBotBase InBot );

/** Tattler Bot AI has entered Docked state... handle any upkeep */
function HandleNewDock(NanoPawn_MetaCorp_SentryBotBase InBot);

/** This will spawn a new bot from this Dock **/
simulated function SpawnABot();

/** This gets called when the bot this camera has spawned has been killed **/
simulated function BotHasBeenKilled();



