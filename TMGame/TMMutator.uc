/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMMutator extends Mutator
	native
	abstract;

/** if set, when this class is compiled, a menu entry for it will be automatically added/updated in its package.ini file
 * (abstract classes are skipped even if this flag is set)
 */
var bool bExportMenuData;

function bool MutatorIsAllowed()
{
	return TMGame(WorldInfo.Game) != None && Super.MutatorIsAllowed();
}

/** utility to get the next TMMutator in the mutator list, for hooks that aren't in the base engine */
function TMMutator GetNextTMMutator()
{
	local Mutator M;
	local TMMutator TMMut;

	for (M = NextMutator; M != None; M = M.NextMutator)
	{
		TMMut = TMMutator(M);
		if (TMMut != None)
		{
			return TMMut;
		}
	}

	return None;
}

/* ReplaceWith()
 * Call this function to replace an actor Other with an actor of aClass.
 * @note: doesn't destroy the original; can return false from CheckReplacement() to do that
 */
function bool ReplaceWith(actor Other, string aClassName)
{
	local Actor A;
	local class<Actor> aClass;
	local PickupFactory OldFactory, NewFactory;

	if ( aClassName == "" )
		return true;

	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if ( aClass != None )
	{
		A = Spawn(aClass,Other.Owner,,Other.Location, Other.Rotation);
		if (A != None)
		{
			OldFactory = PickupFactory(Other);
			NewFactory = PickupFactory(A);
			if (OldFactory != None && NewFactory != None)
			{
				OldFactory.ReplacementFactory = NewFactory;
				NewFactory.OriginalFactory = OldFactory;
			}
		}
	}
	return ( A != None );
}

/** parses the given player's recognized speech into bot orders, etc */
function ProcessSpeechRecognition(TMPlayerController Speaker, const out array<SpeechRecognizedWord> Words)
{
	local TMMutator TMMut;

	TMMut = GetNextTMMutator();
	if (TMMut != None)
	{
		TMMut.ProcessSpeechRecognition(Speaker, Words);
	}
}

