class EvilWeaponUpgradeInfo extends Object
    hidecategories(Object);

struct TUpgradeInfo
{
    var() float BaseSpreadModifier;
    var() float ReloadSpeedModifier;
    var() float FireIntervalModifier;

    structdefaultproperties
    {
        BaseSpreadModifier=1.0000000
        ReloadSpeedModifier=1.0000000
        FireIntervalModifier=1.0000000
    }
};

var(UpgradeInfoGlobal) array<TUpgradeInfo> GlobalUpgradeLevels;
var(UpgradeInfoGlobal) bool UseOnlyGlobalUpgradeLevels;
var(UpgradeInfo) array<float> BaseSpreadUpgradeLevels;
var(UpgradeInfo) array<float> ReloadSpeedUpgradeLevels;
var(UpgradeInfo) array<float> FireIntervalUpgradeLevels;

simulated function TUpgradeInfo GetGlobalUpgradeInfoForLevel(int Level)
{
    local TUpgradeInfo NullInfo;

    // End:0x2C
    if(GlobalUpgradeLevels.Length > Level)
    {
        return GlobalUpgradeLevels[Level];
    }
    return NullInfo;
    //return ReturnValue;    
}

simulated function float GetBaseSpreadForLevel(int Level)
{
    // End:0x40
    if((BaseSpreadUpgradeLevels.Length > Level) && !UseOnlyGlobalUpgradeLevels)
    {
        return BaseSpreadUpgradeLevels[Level];        
    }
    else
    {
        // End:0x7F
        if(GlobalUpgradeLevels.Length > Level)
        {
            return GlobalUpgradeLevels[Level].BaseSpreadModifier;
        }
    }
    // End:0xD6
    if(((BaseSpreadUpgradeLevels.Length > 0) && BaseSpreadUpgradeLevels.Length >= GlobalUpgradeLevels.Length) && !UseOnlyGlobalUpgradeLevels)
    {
        return BaseSpreadUpgradeLevels[BaseSpreadUpgradeLevels.Length - 1];        
    }
    else
    {
        // End:0x129
        if((BaseSpreadUpgradeLevels.Length < GlobalUpgradeLevels.Length) || UseOnlyGlobalUpgradeLevels)
        {
            return GlobalUpgradeLevels[GlobalUpgradeLevels.Length - 1].BaseSpreadModifier;
        }
    }
    return 1.0000000;
    //return ReturnValue;    
}

simulated function float GetReloadSpeedForLevel(int Level)
{
    // End:0x40
    if((ReloadSpeedUpgradeLevels.Length > Level) && !UseOnlyGlobalUpgradeLevels)
    {
        return ReloadSpeedUpgradeLevels[Level];        
    }
    else
    {
        // End:0x7F
        if(GlobalUpgradeLevels.Length > Level)
        {
            return GlobalUpgradeLevels[Level].ReloadSpeedModifier;
        }
    }
    // End:0xD6
    if(((ReloadSpeedUpgradeLevels.Length > 0) && ReloadSpeedUpgradeLevels.Length >= GlobalUpgradeLevels.Length) && !UseOnlyGlobalUpgradeLevels)
    {
        return ReloadSpeedUpgradeLevels[ReloadSpeedUpgradeLevels.Length - 1];        
    }
    else
    {
        // End:0x129
        if((ReloadSpeedUpgradeLevels.Length < GlobalUpgradeLevels.Length) || UseOnlyGlobalUpgradeLevels)
        {
            return GlobalUpgradeLevels[GlobalUpgradeLevels.Length - 1].ReloadSpeedModifier;
        }
    }
    return 1.0000000;
    //return ReturnValue;    
}

simulated function float GetFireIntervalForLevel(int Level)
{
    // End:0x40
    if((FireIntervalUpgradeLevels.Length > Level) && !UseOnlyGlobalUpgradeLevels)
    {
        return FireIntervalUpgradeLevels[Level];        
    }
    else
    {
        // End:0x7F
        if(GlobalUpgradeLevels.Length > Level)
        {
            return GlobalUpgradeLevels[Level].FireIntervalModifier;
        }
    }
    // End:0xD6
    if(((FireIntervalUpgradeLevels.Length > 0) && FireIntervalUpgradeLevels.Length >= GlobalUpgradeLevels.Length) && !UseOnlyGlobalUpgradeLevels)
    {
        return FireIntervalUpgradeLevels[FireIntervalUpgradeLevels.Length - 1];        
    }
    else
    {
        // End:0x129
        if((FireIntervalUpgradeLevels.Length < GlobalUpgradeLevels.Length) || UseOnlyGlobalUpgradeLevels)
        {
            return GlobalUpgradeLevels[GlobalUpgradeLevels.Length - 1].FireIntervalModifier;
        }
    }
    return 1.0000000;
    //return ReturnValue;    
}
