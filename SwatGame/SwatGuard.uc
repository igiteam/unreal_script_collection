///////////////////////////////////////////////////////////////////////////////

class SwatGuard extends SwatEnemy;

///////////////////////////////////////////////////////////////////////////////

protected function ConstructCharacterAIHook(AI_Resource characterResource)
{
    // Guards can attack, but not flee, regroup, threaten hostages, or
    // converse with hostages. See SwatEnemy::ConstructCharacterAIHook
    characterResource.addAbility(new class'SwatAICommon.AttackOfficerAction');
	characterResource.addAbility(new class'SwatAICommon.TakeCoverAndAttackAction');
}

///////////////////////////////////////////////////////////////////////////////

// Decompiled with UE Explorer.
defaultproperties
{
    LimbIdleTime=8.0000000
}