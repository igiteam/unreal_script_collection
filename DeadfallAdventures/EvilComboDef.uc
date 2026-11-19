class EvilComboDef extends Object
    hidecategories(Object)
    autoexpandcategories(Combo);

var(Combo) string LocModule;
var(Combo) string LocSection;
var(Combo) string LocNameKey;
var(Combo) string LocDescriptionKey;
var(Combo) int PlasmaBonus;
var(Combo) editinline array<editinline EvilComboEvent_Base> Events;
var(Combo) editinline array<editinline EvilComboAction_Base> Actions;
var(Combo) array< class<Pawn> > IncludePawnClasses;
var(Combo) bool bInvertPawnClassFilter;
var(Combo) bool bOnlyOneTarget;

function EvilComboManager.EComboEventResult HandleEvent(out ComboState S, name EventType, EvilPawn Instigator, EvilPawn Other, optional Vector Location, optional class<DamageType> dmgType, optional EvilTypes.EBodyParts BodyPart, optional bool directHit)
{
    local int check;

    // End:0x56
    if((S.Step < 0) || S.Step >= Events.Length)
    {
        return 0;
    }
    // End:0x123
    if((Other != none) && IncludePawnClasses.Length > 0)
    {
        check = 0;
        J0x82:

        // End:0xF7 [Loop If]
        if(check < IncludePawnClasses.Length)
        {
            // End:0xD6
            if(!ClassIsChildOf(Other.Class, IncludePawnClasses[check]))
            {                
            }
            else
            {
                // End:0xE6
                if(bInvertPawnClassFilter)
                {
                    return 0;
                }
                // [Explicit Break]
                goto J0xF7;
            }
            ++check;
            // [Loop Continue]
            goto J0x82;
        }
        J0xF7:

        // End:0x123
        if((check >= IncludePawnClasses.Length) && !bInvertPawnClassFilter)
        {
            return 0;
        }
    }
    // End:0x16B
    if(S.Step == 0)
    {
        S.FirstOther = Other;
    }
    // End:0x293
    if((S.Step > 0) && (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - S.Time) > Events[S.Step - 1].TimeOut)
    {
        S.Step = 0;
        S.Time = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
    }
    check = S.Step;
    J0x2B9:

    // End:0x44A [Loop If]
    if(Events[check].check(EventType, Instigator, Other, S.FirstOther, Location, dmgType, BodyPart, directHit))
    {
        S.Time = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
        J0x392:

        ++check;
        // End:0x392
        if(!((check >= Events.Length) || !Events[check - 1].bOrNextOne))
            goto J0x392;
        // End:0x421
        if(check >= Events.Length)
        {
            S.Step = 0;
            return 2;
        }
        S.Step = check;
        return 1;
    }
    ++check;
    // End:0x2B9
    if(!((check >= Events.Length) || !Events[check - 1].bOrNextOne))
        goto J0x2B9;
    return 0;
    //return ReturnValue;    
}

defaultproperties
{
    LocModule="EvilGame"
    LocSection="Combos"
}