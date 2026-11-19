class SPActorFactorySPPickup extends ActorFactory
    native
    config(Editor)
    editinlinenew
    collapsecategories;

struct native FloatSettingOverride
{
    var() bool Override;
    var() float Value;

    structdefaultproperties
    {
        Override=false
        Value=0.0000000
    }
};

struct native IntSettingOverride
{
    var() bool Override;
    var() int Value;

    structdefaultproperties
    {
        Override=false
        Value=0
    }
};

struct native SPPickupSettingsOverride
{
    var() FloatSettingOverride RespawnTimeOverride;
    var() IntSettingOverride AmmoAmount;

    structdefaultproperties
    {
        RespawnTimeOverride=(Override=false,Value=0.0000000)
        AmmoAmount=(Override=false,Value=0)
    }
};

var() SPPickupSettingsOverride SPPickupOverride;
var() /*0x80000000-0x00000000*/ class<SPPickup> SPPickupClass;

defaultproperties
{
    bPlaceable=false
}