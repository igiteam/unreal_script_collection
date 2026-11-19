class UIDataProvider_MOHAWeapon extends UIDataProvider_MOHAResource
    transient
    native
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var config string WeaponNameMarkup;
var config string WeaponImageMarkup;
var config string SmallWeaponImageMarkup;
var config string WeaponDescMarkup;
var config string FriendlyName;
var config int Damage;
var config int Accuracy;
var config int RateOfFire;
var config int Recoil;
var config int ReloadRate;
var config int ClipSize;
var config int UpgradeFilter;
var config int WeaponType;
var transient Surface UpgradeButton;
var transient int DamageTotal;
var transient int AccuracyTotal;
var transient int RateOfFireTotal;
var transient int RecoilTotal;
var transient int ReloadRateTotal;
var transient int ClipSizeTotal;

event PostConstruct()
{
    DamageTotal = Damage;
    AccuracyTotal = Accuracy;
    RateOfFireTotal = RateOfFire;
    RecoilTotal = Recoil;
    ReloadRateTotal = ReloadRate;
    ClipSizeTotal = ClipSize;
    //return;    
}

defaultproperties
{
    UpgradeButton=Texture2D'UI_TX_Rank.Rank_Axis_Corporal'
}