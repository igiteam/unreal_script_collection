/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_Rebels_PublicRabbleRouser extends NanoPawn_RebelsBase;


defaultproperties
{
	ControllerClass=class'NanoGameContent.NanoAI_Rebels_RabbleRouser'

	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'NPC_CivilianProto_variants.SK_NPC_Civilian_Proto_01'
		PhysicsAsset=PhysicsAsset'MET_ShockTrooperProto.SK_MET_ShockTrooper_Proto_Physics'
		AnimTreeTemplate=AnimTree'NPC_CivilianProto.AT_Civilian'
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ShockTrooper_Proto')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto_Civilian')
		Translation=(Z=-88.0)
	End Object

}