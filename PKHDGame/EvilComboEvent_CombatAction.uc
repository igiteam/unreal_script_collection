class EvilComboEvent_CombatAction extends EvilComboEvent_Base
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Event);

var(CombatAction) array<EvilTypes.ECombatActionType> CombatActionTypes;
var(CombatAction) array< class<EvilWeap_Base> > WeaponFilter;

static function EvilTypes.ECombatActionType GetActionType(name EventType)
{
    switch(EventType)
    {
        // End:0x22
        case 'Melee':
            return 1;
        // End:0x31
        case 'StartFire':
            return 0;
        // End:0x40
        case 'PlasmaThrow':
            return 2;
        // End:0x4F
        case 'MeleeKick':
            return 3;
        // End:0xFFFF
        default:
            return 255;
            break;
    }
    //return ReturnValue;    
}

function bool check(name EventType, EvilPawn Instigator, EvilPawn Other, EvilPawn FirstOther, Vector Location, class<DamageType> dmgType, EvilTypes.EBodyParts BodyPart, bool directHit)
{
    local int I;
    local EvilTypes.ECombatActionType CAT;

    // End:0x80
    if((WeaponFilter.Length > 0) && (Instigator.Weapon == none) || WeaponFilter.Find(Instigator.Weapon.Class) < 0)
    {
        return false;
    }
    CAT = GetActionType(EventType);
    // End:0xB3
    if(int(CAT) > int(3))
    {
        return false;
    }
    I = 0;
    J0xBE:

    // End:0x11B [Loop If]
    if(I < CombatActionTypes.Length)
    {
        // End:0x10D
        if(int(CombatActionTypes[I]) == int(CAT))
        {
            return int(CAT) != int(1);
        }
        ++I;
        // [Loop Continue]
        goto J0xBE;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    EventID="CombatAction"
}