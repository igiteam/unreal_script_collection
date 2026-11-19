/**
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */


class GearAnim_Wretch_JumpAttack extends GearAnim_BlendList
	dependson(GearAnim_BlendList)
	native(TGAnim);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum EWretchAttackState
{
	WAS_Init,
	WAS_AirLoop,
	WAS_Attached,
	WAS_KnockOff,
};
var EWretchAttackState AttackState;

function InitAttack( Actor Target )
{
	AttackState = WAS_Init;
}
function AttachAttack()
{
	AttackState = WAS_Attached;
}
function EndAttack()
{
	AttackState = WAS_KnockOff;
}

