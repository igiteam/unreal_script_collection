/**
 * Interface for actors that can be pinged
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_PingAffectable extends Interface;


/** Called when the ping has affected this object.  The object should now do some sweet effects! **/
function DoPingEffects( bool bActiveReloadPing );

/** Helper function to fix up the effects from being affected by the ping **/
function RestoreFromPingAffected();

