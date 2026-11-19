class SeqAct_UnlockWeaponUpgrade extends SequenceAction
    hidecategories(Object);

var() MOHAIncludeClass.EWeaponType WeaponType;
var() int WeaponUpgradeLevel;

defaultproperties
{
    ObjName="Unlock Weapon Upgrade"
    ObjCategory="Weapon"
}