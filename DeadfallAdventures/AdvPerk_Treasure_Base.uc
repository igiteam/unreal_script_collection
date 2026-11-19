class AdvPerk_Treasure_Base extends AdvPerk_Base
    config(Perks)
    notplaceable
    hidecategories(Navigation);

struct TSkillUpgradesPerLevel
{
    var config string UpgradeName;
    var config float UpgradePerc;

    structdefaultproperties
    {
        UpgradeName=""
        UpgradePerc=0.0000000
    }
};

struct TSkillUpgradesPerPath
{
    var config array<config TSkillUpgradesPerLevel> SkillUpgradesPerLevel;

    structdefaultproperties
    {
        SkillUpgradesPerLevel=none
    }
};

var const localized string NotifyMessage;
var config array<config TSkillUpgradesPerPath> SkillUpgradesPerPath;

static function ActivateTreasurePerk(AdvPlayerController PC, int PerkPath, int PathLevel)
{
    //return;    
}
