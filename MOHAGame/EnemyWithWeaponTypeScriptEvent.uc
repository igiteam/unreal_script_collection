class EnemyWithWeaponTypeScriptEvent extends AxonScriptEvent;

var class<EALAWeapon> WeaponType;
var MOHAScriptAIController Controller;
//var delegate<TargetHasWeaponCB> __TargetHasWeaponCB__Delegate;

delegate TargetHasWeaponCB()
{
    //return;    
}

function Register(MOHAScriptAIController C, delegate<TargetHasWeaponCB> callback, optional name Key = 'stack')
{
    Controller = C;
    __TargetHasWeaponCB__Delegate = callback;
    RegisterSubstate(Key);
    //return;    
}

event Tick(float DeltaTime)
{
    // End:0x7C
    if((Pawn(Controller.Focus) != none) && Pawn(Controller.Focus).Weapon != none)
    {
        // End:0x7C
        if(ClassIsChildOf(Pawn(Controller.Focus).Weapon.Class, WeaponType))
        {
            TargetHasWeaponCB();
        }
    }
    //return;    
}

defaultproperties
{
    WeaponType=Class'EALAWeapon'
}