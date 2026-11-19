class SeqCond_IsAWeaponUpgradeAvailable extends SequenceCondition
    hidecategories(Object);

function Activated()
{
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Yes",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="No",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Is WeaponUpgradeAvailable"
}