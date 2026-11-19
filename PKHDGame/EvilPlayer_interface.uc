interface EvilPlayer_interface extends Interface
    abstract;

delegate OnArmAnimEnd(bool RightHand, optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
    //return;    
}

function SetOnArmAnimEndDelegate(delegate<OnArmAnimEnd> InDelegate, bool bLeftArm)
{
    //return;    
}

function ResetOnArmAnimEndDelegate(bool bLeftHand)
{
    //return;    
}

function EvilPawn GetPlayerPawn()
{
    //return ReturnValue;    
}

function EvilPlayerController GetPC()
{
    //return ReturnValue;    
}

function Weapon GetWeaponLeft()
{
    //return ReturnValue;    
}

function Weapon GetWeapon()
{
    //return ReturnValue;    
}
