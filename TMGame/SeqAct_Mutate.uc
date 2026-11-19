/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
 class SeqAct_Mutate extends SequenceAction
	native(TGSequence);
	
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum EMutateTypes
{
	MUTATE_TheronMarcus,
	MUTATE_Marcus,
	MUTATE_Dom,
 	MUTATE_TheronDom,
};

var() EMutateTypes MutateType;
var const array<string> MutateClassNames;

var class<TGPawn> PawnClass;

