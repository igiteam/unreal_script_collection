class SPLocalMessage extends LocalMessage
    abstract;

static function string GetTeamTag(int TeamIndex)
{
    // End:0x11
    if(TeamIndex == 1)
    {
        return "[1]";
    }
    // End:0x23
    if(TeamIndex == 2)
    {
        return "[2]";
    }
    return "";
    //return ReturnValue;    
}

static function string GetKilledByTag(name ObjectName)
{
    local string DamageTypeString;

    switch(ObjectName)
    {
        // End:0x2C
        case 'SPDamageTypeDesertEagle':
            DamageTypeString = "[DesertEagle]";
            // End:0x1A4
            break;
        // End:0x4C
        case 'SPDamageTypeShotgun':
            DamageTypeString = "[Shotgun]";
            // End:0x1A4
            break;
        // End:0x68
        case 'SPDamageTypeHK_UMP':
            DamageTypeString = "[UMP]";
            // End:0x1A4
            break;
        // End:0x84
        case 'SPDamageTypeSaw':
            DamageTypeString = "[Saw]";
            // End:0x1A4
            break;
        // End:0xA9
        case 'SPDamageTypeAssaultRifle':
            DamageTypeString = "[AssaultRifle]";
            // End:0x1A4
            break;
        // End:0xC5
        case 'SPDamageType9MM':
            DamageTypeString = "[9MM]";
            // End:0x1A4
            break;
        // End:0xE5
        case 'SPDamageTypeExplosionGrenade':
            DamageTypeString = "[Grenade]";
            // End:0x1A4
            break;
        // End:0xF1
        case 'SPDamageTypeMeleeAny':
        // End:0xFD
        case 'SPDamageTypeMelee_Bite':
        // End:0x109
        case 'SPDamageTypeMelee_Slash':
        // End:0x12F
        case 'SPDamageTypeMelee_Hit':
            DamageTypeString = "[WerewolfSlash]";
            // End:0x1A4
            break;
        // End:0x14D
        case 'SPDamageTypeImpactFlame':
            DamageTypeString = "[Flame]";
            // End:0x1A4
            break;
        // End:0x159
        case 'SPDamageTypeRigidBody':
        // End:0x17D
        case 'SPDamageTypeImpactAny':
            DamageTypeString = "[HitByObject]";
            // End:0x1A4
            break;
        // End:0x1A1
        case 'SPDamageTypeFall':
            DamageTypeString = "[FellToDeath]";
            // End:0x1A4
            break;
        // End:0xFFFF
        default:
            break;
    }
    return DamageTypeString;
    //return ReturnValue;    
}

defaultproperties
{
    Lifetime=6.0000000
    PosY=2.0000000
}