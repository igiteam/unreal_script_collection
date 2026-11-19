/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * loads and holds references to MP character classes that were dynamically loaded based on player request 
 */
class GearMPCharacterStore extends Object
	native;

var array< class<GearPawn> > LoadedClasses;

/** list of classes currently being async loaded */
var array<string> PendingClasses;

/** loads the specified class's seekfree package
 * async in cooked builds, uses DLO in uncooked builds
 * calls LoadComplete delegate either way upon completion
 */
native final function LoadPawnClass(string ClassPath);

/** callback when loading the specified class is complete */
delegate LoadComplete(class<GearPawn> LoadedClass);
