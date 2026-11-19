class SkyAIFloatingMine extends Controller
    native;

function bool FireWeaponAt(Actor TargetActor)
{
    return false;
    //return ReturnValue;    
}

auto state Start_State
{Begin:

    // End:0x19
    if(Pawn != none)
    {
        GotoState('Idle');
    }
    Sleep(1.0000000 + FRand());
    goto 'Begin';
    stop;                    
}

state Idle
{    stop;    
}
