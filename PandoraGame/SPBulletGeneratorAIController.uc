class SPBulletGeneratorAIController extends SPAIController
    native;

var SPBulletGeneratorPawnPersistent m_BulletGeneratorPawn;
var bool m_bIsFiring;
var bool m_bFiringDisabled;
var bool m_bSetSemiAutoEnabled;
var bool m_bSetAutoEnabled;

function EvaluateSituation()
{
    // End:0x37
    if(m_BulletGeneratorPawn.m_bActive && m_bIsFiring)
    {
        GotoState('Firing', 'Begin', true, false);        
    }
    else
    {
        GotoState('Idle', 'Begin', true, false);
    }
    //return;    
}

auto state WaitingForPawn
{
    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        // End:0x1B
        if(m_BulletGeneratorPawn == none)
        {
            m_BulletGeneratorPawn = SPBulletGeneratorPawnPersistent(NewPawn);
        }
        super.Possess(NewPawn, bVehicleTransition);
        SetPawnRotationRate(0, 0, 0);
        //return;        
    }
    stop;    
}

state Idle
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        //return;        
    }

    function StartFiring()
    {
        m_bIsFiring = true;
        EvaluateSituation();
        //return;        
    }

    function CheckFiringDisabled()
    {
        // End:0x15
        if(!m_bFiringDisabled)
        {
            StartFiring();
        }
        //return;        
    }
Begin:

    // End:0x5E
    if(!m_bFiringDisabled)
    {
        // End:0x3E
        if(m_BulletGeneratorPawn.m_bIsSemiAuto)
        {
            SetTimer(m_BulletGeneratorPawn.IntervalBetweenSingleFireSegments, false, 'StartFiring');            
        }
        else
        {
            SetTimer(m_BulletGeneratorPawn.IntervalBetweenAutoFireSegments, false, 'StartFiring');
        }        
    }
    else
    {
        SetTimer(1.0000000, true, 'CheckFiringDisabled');
    }
    stop;            
}

state Firing
{
    function BeginState(name PreviousStateName)
    {
        super(Object).BeginState(PreviousStateName);
        m_bSetSemiAutoEnabled = false;
        m_bSetAutoEnabled = false;
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimers();
        //return;        
    }

    function ClearTimers()
    {
        ClearTimer('StartBulletGeneratorSemiAutoFiring');
        ClearTimer('DelayBulletGeneratorFiring');
        ClearTimer('DisableAutoFire');
        //return;        
    }

    function DisableAutoFire()
    {
        m_bSetAutoEnabled = false;
        //return;        
    }

    function StartBulletGeneratorFiring()
    {
        StartFiring();
        //return;        
    }

    function StartBulletGeneratorSemiAutoFiring()
    {
        SetTimer(RandRange(m_BulletGeneratorPawn.IntervalBetweenSingleFireSegments - m_BulletGeneratorPawn.IntervalBetweenSingleFireRange, m_BulletGeneratorPawn.IntervalBetweenSingleFireSegments + m_BulletGeneratorPawn.IntervalBetweenSingleFireRange), false, 'StartBulletGeneratorSemiAutoFiring');
        StartFiring();
        //return;        
    }

    function DelayBulletGeneratorFiring()
    {
        StopFiring();
        SetTimer(RandRange(m_BulletGeneratorPawn.IntervalBetweenAutoFireSegments - m_BulletGeneratorPawn.IntervalBetweenAutoFireRange, m_BulletGeneratorPawn.IntervalBetweenAutoFireSegments + m_BulletGeneratorPawn.IntervalBetweenAutoFireRange), false, 'DisableAutoFire');
        //return;        
    }

    function StopBulletGeneratorFiring()
    {
        StopFiring();
        GotoState('Idle', 'Begin', true, false);
        //return;        
    }
    J0x00:
    // End:0x104 [Loop If]
    if(!m_bFiringDisabled)
    {
        // End:0x88
        if(m_BulletGeneratorPawn.m_bIsSemiAuto)
        {
            // End:0x85
            if(!m_bSetSemiAutoEnabled)
            {
                m_bSetSemiAutoEnabled = true;
                SetTimer(RandRange(m_BulletGeneratorPawn.IntervalBetweenSingleFireSegments - m_BulletGeneratorPawn.IntervalBetweenSingleFireRange, m_BulletGeneratorPawn.IntervalBetweenSingleFireSegments + m_BulletGeneratorPawn.IntervalBetweenSingleFireRange), false, 'StartBulletGeneratorSemiAutoFiring');
            }            
        }
        else
        {
            // End:0xF9
            if(!m_bSetAutoEnabled)
            {
                m_bSetAutoEnabled = true;
                StartBulletGeneratorFiring();
                SetTimer(RandRange(m_BulletGeneratorPawn.IntervalOfAutoFire - m_BulletGeneratorPawn.IntervalOfAutoFireRange, m_BulletGeneratorPawn.IntervalOfAutoFire + m_BulletGeneratorPawn.IntervalOfAutoFireRange), false, 'DelayBulletGeneratorFiring');
            }
        }
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    StopBulletGeneratorFiring();
    stop;        
}

state ControllerDying
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function NotifyDied()
    {
        PopState();
        GotoState('WaitingForTheInevitable');
        //return;        
    }
Begin:

    stop;                
}

state WaitingForTheInevitable
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }
    stop;    
}
