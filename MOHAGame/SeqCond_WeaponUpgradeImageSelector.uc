class SeqCond_WeaponUpgradeImageSelector extends SequenceCondition
    hidecategories(Object);

var() class<EALAWeapon> SelectedWeaponClass;
var MOHAPlayerController Player;

function Activated()
{
    local int AllowedWeaponUpgradeLevel;
    local MOHAPlayerController localPlayerController;
    local editinline MOHAWeaponExperienceComponent LocalWeaponExperienceComponent;

    // End:0x42
    foreach GetWorldInfo().DynamicActors(Class'MOHAPlayerController', localPlayerController)
    {
        // End:0x41
        if(NetConnection(localPlayerController.Player) == none)
        {
            Player = localPlayerController;
            // End:0x42
            break;
        }        
    }    
    LocalWeaponExperienceComponent = Player.playerStats.GetWeaponExpComponent(SelectedWeaponClass);
    AllowedWeaponUpgradeLevel = LocalWeaponExperienceComponent.ExperienceLevel;
    OutputLinks[AllowedWeaponUpgradeLevel].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="No Upgrades",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Upgrade 1",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Upgrade 2",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[3]=(Links=none,LinkDesc="Upgrade 3",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[4]=(Links=none,LinkDesc="Upgrade 4",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Weapon Image Select"
}