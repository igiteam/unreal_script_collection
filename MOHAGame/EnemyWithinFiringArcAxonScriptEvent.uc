class EnemyWithinFiringArcAxonScriptEvent extends AxonScriptEvent
    native;

var() float fFiringAngleDotMin;
var float fTimeSinceLastCheck;
var float fTimeBetweenEncroachmentChecks;
var float fEncroachmentHysteresis;
var float fCachedGotoDistance;
var KynapseAIController Controller;
var KynapseCoverNode newCoverNode;
var() bool bDebugDraw;
var() Color NotEncroachedColor;
var() Color EncroachedColor;
var() float fEncroachedDistanceScalarLateral;
var() float fEncroachedDistanceScalarFrontal;
var() float fEncroachedDistanceScalarRear;
var() float fEncroachedDistanceMax;
//var delegate<OnEncroachedUpon> __OnEncroachedUpon__Delegate;
//var delegate<OnUnEncroachedUpon> __OnUnEncroachedUpon__Delegate;
//var delegate<OnOutsideFiringArc> __OnOutsideFiringArc__Delegate;
//var delegate<OnInsideFiringArc> __OnInsideFiringArc__Delegate;

// Export UEnemyWithinFiringArcAxonScriptEvent::execEncroachedUpon(FFrame&, void* const)
native function bool EncroachedUpon();

// Export UEnemyWithinFiringArcAxonScriptEvent::execGetMaxEncroachmentDistance(FFrame&, void* const)
native function float GetMaxEncroachmentDistance();

delegate OnEncroachedUpon()
{
    //return;    
}

delegate OnUnEncroachedUpon()
{
    //return;    
}

delegate OnOutsideFiringArc()
{
    //return;    
}

delegate OnInsideFiringArc()
{
    //return;    
}

function bool QuickCheckEncroachment(KynapseAIController C, KynapseCoverNode Node, float lastGotoDistance)
{
    Controller = C;
    newCoverNode = Node;
    fCachedGotoDistance = lastGotoDistance;
    fEncroachmentHysteresis = 1.0000000;
    fCachedGotoDistance = -1.0000000;
    return EncroachedUpon();
    //return ReturnValue;    
}

function RegisterCheckEncroachment(KynapseAIController C, KynapseCoverNode Node, delegate<OnEncroachedUpon> cb, optional name Key = 'stack')
{
    Controller = C;
    newCoverNode = Node;
    __OnEncroachedUpon__Delegate = cb;
    fTimeSinceLastCheck = fTimeBetweenEncroachmentChecks;
    fEncroachmentHysteresis = 1.0000000;
    fCachedGotoDistance = -1.0000000;
    GotoState('CheckEncroachment');
    RegisterSubstate(Key);
    //return;    
}

function RegisterCheckUnEncroached(KynapseAIController C, KynapseCoverNode Node, delegate<OnUnEncroachedUpon> cb, float lastGotoDistance, optional name Key = 'stack')
{
    Controller = C;
    newCoverNode = Node;
    __OnUnEncroachedUpon__Delegate = cb;
    fTimeSinceLastCheck = fTimeBetweenEncroachmentChecks;
    fEncroachmentHysteresis = 1.2000000;
    fCachedGotoDistance = lastGotoDistance;
    GotoState('CheckUnEncroached');
    RegisterSubstate(Key);
    //return;    
}

function RegisterCheckOutsideFiringArc(KynapseAIController C, delegate<OnOutsideFiringArc> cb, optional name Key = 'stack')
{
    Controller = C;
    __OnOutsideFiringArc__Delegate = cb;
    GotoState('CheckOutsideFiringArc');
    RegisterSubstate(Key);
    //return;    
}

function RegisterCheckInsideFiringArc(KynapseAIController C, delegate<OnInsideFiringArc> cb, optional name Key = 'stack')
{
    Controller = C;
    __OnInsideFiringArc__Delegate = cb;
    GotoState('CheckInsideFiringArc');
    RegisterSubstate(Key);
    //return;    
}

event Withdraw()
{
    __OnEncroachedUpon__Delegate = None;
    __OnOutsideFiringArc__Delegate = None;
    __OnInsideFiringArc__Delegate = None;
    __OnUnEncroachedUpon__Delegate = None;
    fTimeSinceLastCheck = 0.0000000;
    GotoState('None');
    //return;    
}

function bool IsWithinFiringArc()
{
    local Pawn EnemyPawn;
    local Vector dirToTarget;

    EnemyPawn = Pawn(Controller.Focus);
    // End:0x77
    if((EnemyPawn != none) && EnemyPawn.Health > 0)
    {
        dirToTarget = EnemyPawn.Location - Controller.Pawn.Location;
        dirToTarget = Normal(dirToTarget);        
    }
    else
    {
        // End:0xDB
        if((EnemyPawn == none) && VSizeSq(Controller.FocalPoint) > (0.0500000 * 0.0500000))
        {
            dirToTarget = Normal(Controller.FocalPoint - Controller.Pawn.Location);            
        }
        else
        {
            return false;
        }
    }
    // End:0x109
    if((dirToTarget Dot Vector(Controller.Pawn.Rotation)) < fFiringAngleDotMin)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

state CheckEncroachment
{
    event Tick(float DeltaTime)
    {
        local Color circleColor;

        // End:0xD4
        if(bDebugDraw)
        {
            // End:0xD4
            if((Controller.Focus != none) && Pawn(Controller.Focus).Health > 0)
            {
                // End:0x5C
                if(EncroachedUpon())
                {
                    circleColor = EncroachedColor;                    
                }
                else
                {
                    circleColor = NotEncroachedColor;
                }
                Controller.DrawDebugCircle(Controller.Pawn.Location, vect(0.0000000, 0.0000000, 1.0000000), GetMaxEncroachmentDistance(), 16, circleColor.R, circleColor.G, circleColor.B);
            }
        }
        fTimeSinceLastCheck += DeltaTime;
        // End:0x116
        if(fTimeSinceLastCheck > fTimeBetweenEncroachmentChecks)
        {
            fTimeSinceLastCheck = 0.0000000;
            // End:0x116
            if(EncroachedUpon())
            {
                OnEncroachedUpon();
            }
        }
        //return;        
    }
    stop;    
}

state CheckUnEncroached
{
    event Tick(float DeltaTime)
    {
        local Color circleColor;

        // End:0xD4
        if(bDebugDraw)
        {
            // End:0xD4
            if((Controller.Focus != none) && Pawn(Controller.Focus).Health > 0)
            {
                // End:0x5C
                if(EncroachedUpon())
                {
                    circleColor = EncroachedColor;                    
                }
                else
                {
                    circleColor = NotEncroachedColor;
                }
                Controller.DrawDebugCircle(Controller.Pawn.Location, vect(0.0000000, 0.0000000, 1.0000000), GetMaxEncroachmentDistance(), 16, circleColor.R, circleColor.G, circleColor.B);
            }
        }
        fTimeSinceLastCheck += DeltaTime;
        // End:0x118
        if(fTimeSinceLastCheck > fTimeBetweenEncroachmentChecks)
        {
            fTimeSinceLastCheck = 0.0000000;
            // End:0x118
            if(!EncroachedUpon())
            {
                OnUnEncroachedUpon();
            }
        }
        //return;        
    }
    stop;    
}

state CheckOutsideFiringArc
{
    event Tick(float DeltaTime)
    {
        // End:0x1E
        if(!IsWithinFiringArc())
        {
            OnOutsideFiringArc();
        }
        //return;        
    }
    stop;    
}

state CheckInsideFiringArc
{
    event Tick(float DeltaTime)
    {
        // End:0x1C
        if(IsWithinFiringArc())
        {
            OnInsideFiringArc();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    fTimeBetweenEncroachmentChecks=0.1500000
    fEncroachmentHysteresis=1.0000000
    NotEncroachedColor=(R=0,G=255,B=0,A=0)
    EncroachedColor=(R=255,G=0,B=0,A=0)
    fEncroachedDistanceScalarLateral=2.0000000
    fEncroachedDistanceScalarFrontal=2.5000000
    fEncroachedDistanceScalarRear=2.5000000
    fEncroachedDistanceMax=-1.0000000
}