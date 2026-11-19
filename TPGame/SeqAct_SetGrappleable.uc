/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SetGrappleable extends SequenceAction;

var() enum eGrappleable
{
    Grappleable,
    NotGrappleable,
    AlwaysBreaks
} Grappleable;

var() bool bNoHumanShield;

