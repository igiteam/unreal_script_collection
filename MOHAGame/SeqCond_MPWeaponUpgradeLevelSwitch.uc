class SeqCond_MPWeaponUpgradeLevelSwitch extends SequenceCondition
    native
    hidecategories(Object);

var() MOHAIncludeClass.eWeaponClass WeaponClass;

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="No upgrades",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Level 1",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Level 2",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[3]=(Links=none,LinkDesc="Level 3",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="MP Weapon Upgrade Level Switch"
}