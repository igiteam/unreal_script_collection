/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AlwaysLoadedContent extends Object;

/** Array of assets we want to always have in memory to avoid duplication into maps. */
var array<object> AlwaysLoadedObjects;

defaultproperties
{
	AlwaysLoadedObjects(0)=texture'Engine_MI_Shaders.T_Normal'
	AlwaysLoadedObjects(1)=texture'Engine_MI_Shaders.T_Reflection'
	AlwaysLoadedObjects(2)=texture'Engine_MI_Shaders.T_Emissive'
	AlwaysLoadedObjects(3)=texture'Engine_MI_Shaders.T_Cubemap_01_tex'
	AlwaysLoadedObjects(4)=texture'Engine_MI_Shaders.T_Cubemap_01'
	AlwaysLoadedObjects(5)=texture'Engine_MI_Shaders.T_Specular'
	AlwaysLoadedObjects(6)=texture'Engine_MI_Shaders.T_Base_Tile_Variation'
	AlwaysLoadedObjects(7)=texture'Engine_MI_Shaders.T_Base_Tile_Emmisive'
	AlwaysLoadedObjects(8)=texture'Engine_MI_Shaders.T_Base_Tile_Specular'
	AlwaysLoadedObjects(9)=texture'UN_DetailTex.Materials.UN_DetailTex_Crackle7_N'
	AlwaysLoadedObjects(10)=texture'UN_DetailTex.Materials.UN_DetailTex_Crackle4_N'
	AlwaysLoadedObjects(11)=texture'UN_DetailTex2.BSP.Materials.T_HU_Metal_ND'
	AlwaysLoadedObjects(12)=material'Engine_MI_Shaders.M_ES_Phong_Opaque_Master_01'
	AlwaysLoadedObjects(13)=material'Engine_MI_Shaders.M_Shader_Simple'
}
