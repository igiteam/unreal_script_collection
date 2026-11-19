class UIDataProvider_MOHAWeaponUpgrades extends UIDataProvider_MOHAResource
    transient
    native
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var config string UpgradeNameMarkup;
var config string UpgradeImageMarkup;
var config string UpgradeLockedImageMarkup;
var config string UpgradeDescription;
var config string FriendlyName;
var config int DamageDelta;
var config int AccuracyDelta;
var config int RateOfFireDelta;
var config int RecoilDelta;
var config int ReloadRateDelta;
var config int ClipSizeDelta;
var config int ProficiencyLevel;

defaultproperties
{
    bUseUpgradeFilter=true
}