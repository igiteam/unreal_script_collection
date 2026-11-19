class SeqCond_WeaponUpgradeStatus extends SequenceCondition
    hidecategories(Object);

var() MOHAIncludeClass.EWeaponType SelectedWeaponType;
var() int CurrentUpgradeNumber;

function Activated()
{
    local int iAppliedUpgradeLevel;
    local MOHAPlayerController PC;
    local MOHAPlayerPawn PlayerPawn;

    // End:0x37
    foreach GetWorldInfo().DynamicActors(Class'MOHAPlayerController', PC)
    {
        // End:0x36
        if(NetConnection(PC.Player) == none)
        {
            // End:0x37
            break;
        }        
    }    
    PlayerPawn = MOHAPlayerPawn(PC.Pawn);
    iAppliedUpgradeLevel = PlayerPawn.WeaponUpgradeManager.GetAppliedUpgradeLevel(SelectedWeaponType);
    // End:0x9E
    if(iAppliedUpgradeLevel <= CurrentUpgradeNumber)
    {
        OutputLinks[0].bHasImpulse = true;        
    }
    else
    {
        OutputLinks[1].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Not Applied",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Applied",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Weapon Upgrade Status"
}