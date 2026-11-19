/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_JuggleTarget extends Interface;

/** Whether this target is a valid juggle target */
simulated function bool IsValidJuggleTarget();
/** Give interface object a chance to fudge the numbers */
simulated function ResolveJuggleVars( Controller InstigatedBy, out float out_JuggleMag, out float out_JuggleZ, out Vector out_JuggleDir, bool bShootingFromAbove );

/** Called when bouldered into by a pawn */
function ApplyJuggle( float JuggleMag, float JuggleZ, Vector Dir, optional NanoPawn Juggler, optional bool bDoKnockBack );

