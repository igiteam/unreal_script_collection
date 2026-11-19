/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class LadderMeshComponent extends StaticMeshComponent
	native(TGAI);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

struct native LadderMeshes
{
	var StaticMesh Base;
};
var editoronly array<LadderMeshes> Meshes;

/** Base offset applied to all meshes */
var vector LocationOffset;

