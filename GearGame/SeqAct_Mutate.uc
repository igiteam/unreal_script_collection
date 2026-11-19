/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 class SeqAct_Mutate extends SequenceAction
	native(Sequence);
	
cpptext
{
	void SetTheHardReferences();
	virtual void PostLoad();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
}

enum EMutateTypes
{
	MUTATE_TheronMarcus,
	MUTATE_Marcus,
	MUTATE_Dom,
 	MUTATE_TheronDom,
};

var() EMutateTypes MutateType;
var const array<string> MutateClassNames;

var class<GearPawn> PawnClass;

defaultproperties
{
	ObjName="Mutate Character"

	MutateClassNames(MUTATE_TheronMarcus)="GearPawn_COGMarcusTheron"
	MutateClassNames(MUTATE_Marcus)="GearPawn_COGMarcus"
	MutateClassNames(MUTATE_Dom)="GearPawn_COGDom"
	MutateClassNames(MUTATE_TheronDom)="GearPawn_COGDomTheron"
}