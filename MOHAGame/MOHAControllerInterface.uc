interface MOHAControllerInterface extends Interface
    abstract;

function StimulusComponent GetStimulusComponent()
{
    //return ReturnValue;    
}

function NotifyWeaponFired(Weapon iWeap, byte FireMode)
{
    //return;    
}

function NotifyWeaponFinishedFiring(Weapon iWeap, byte FireMode)
{
    //return;    
}

function int GetTeamIndex()
{
    //return ReturnValue;    
}

function bool IsSniperController()
{
    //return ReturnValue;    
}
