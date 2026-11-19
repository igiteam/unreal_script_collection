//=============================================================================
// SASHingedDoorMover.uc
//
// Mover class for hinged doors in SAS.
//=============================================================================

class SASHingedDoorMover extends SASDoorMover;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Vars

var(SASDoor) bool	mbHingeOnLeft;		// Is hinge on left of door?
var(SASDoor) bool	mbOpensOutward;		// Door opens outward?
var(SASDoor) bool	mbOpensInward;		// Door opens inward?
	

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// OpensAwayFromActor
// 
// Returns true if door can be pushed rather than pulled open from actor's
// current position.
//::function bool OpensAwayFromActor (
//::	Actor	aOther)
//::{
//::	if (ActorInFront(aOther))
//::	{
//::		return mbOpensOutward;
//::	}
//::	else
//::	{
//::		return mbOpensInward;
//::	}
//::}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mbOpensInward=true
}