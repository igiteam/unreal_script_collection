class PKAI_EvilMonkRich extends PKAI_EvilMonk
    config(AI)
    hidecategories(Navigation);

simulated function bool IsWeaponAimingAt(Actor ATarget, float Epsilon)
{
    local Vector Loc;
    local Rotator Rot;
    local Vector l1, l2;
    local Rotator r1, r2;

    GetPlayerViewPoint(Loc, Rot);
    r1 = Rot;
    r2 = Rotator(ATarget.Location - MyEvilPawn.GetWeaponStartTraceLocation());
    l1 = GetRotatorAxis(r1, 2);
    l2 = GetRotatorAxis(r2, 2);
    return (l1 Dot l2) >= Epsilon;
    //return ReturnValue;    
}

defaultproperties
{
    MinDelayBetweenThrow=4.0000000
    ThrowRangeMax=600.0000000
    bShouldThrowWeapon=true
    DefaultCommand=Class'PKAICmd_Base_EvilMonkRich'
    // Reference: EvilAIReactManager'Default__PKAI_EvilMonkRich.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_EvilMonk.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
}