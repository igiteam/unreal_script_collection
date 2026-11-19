class EnemyWithinRadiusAxonScriptEvent extends AxonScriptEvent;

var KynapseAIController Controller;
var float fTimeSinceLastCheck;
var float fTimeBetweenRadiusChecks;
var() float fRadius;
var() bool bDebugDraw;
var() Color WithinRadiusColor;
var() Color NotWithinRadiusColor;
//var delegate<OnWithinRadius> __OnWithinRadius__Delegate;
//var delegate<OnNotWithinRadius> __OnNotWithinRadius__Delegate;

delegate OnWithinRadius()
{
    //return;    
}

delegate OnNotWithinRadius()
{
    //return;    
}

function RegisterCheckWithinRadius(KynapseAIController C, float Radius, delegate<OnWithinRadius> cb, optional name Key = 'stack')
{
    Controller = C;
    __OnWithinRadius__Delegate = cb;
    fRadius = Radius;
    fTimeSinceLastCheck = fTimeBetweenRadiusChecks;
    GotoState('CheckWithinRadius');
    RegisterSubstate(Key);
    //return;    
}

function RegisterCheckNotWithinRadius(KynapseAIController C, float Radius, delegate<OnNotWithinRadius> cb, optional name Key = 'stack')
{
    Controller = C;
    __OnNotWithinRadius__Delegate = cb;
    fRadius = Radius;
    fTimeSinceLastCheck = fTimeBetweenRadiusChecks;
    GotoState('CheckNotWithinRadius');
    RegisterSubstate(Key);
    //return;    
}

event Withdraw()
{
    __OnWithinRadius__Delegate = None;
    __OnNotWithinRadius__Delegate = None;
    fTimeSinceLastCheck = 0.0000000;
    GotoState('None');
    //return;    
}

function bool IsEnemyWithinRadius(float Radius)
{
    local Pawn EnemyPawn;
    local Vector dirToTarget;
    local float distToTarget;

    // End:0x8B
    if(Controller != none)
    {
        EnemyPawn = Controller.CurrentEnemy;
        // End:0x8B
        if((EnemyPawn != none) && EnemyPawn.Health > 0)
        {
            dirToTarget = EnemyPawn.Location - Controller.Pawn.Location;
            distToTarget = VSize(dirToTarget);
            // End:0x8B
            if(distToTarget <= Radius)
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function DoDebugDraw()
{
    local Color circleColor;

    // End:0xC6
    if((Controller.CurrentEnemy != none) && Controller.CurrentEnemy.Health > 0)
    {
        // End:0x53
        if(IsEnemyWithinRadius(fRadius))
        {
            circleColor = WithinRadiusColor;            
        }
        else
        {
            circleColor = NotWithinRadiusColor;
        }
        Controller.DrawDebugCircle(Controller.Pawn.Location, vect(0.0000000, 0.0000000, 1.0000000), fRadius, 16, circleColor.R, circleColor.G, circleColor.B);
    }
    //return;    
}

state CheckWithinRadius
{
    event Tick(float DeltaTime)
    {
        // End:0x13
        if(bDebugDraw)
        {
            DoDebugDraw();
        }
        fTimeSinceLastCheck += DeltaTime;
        // End:0x5A
        if(fTimeSinceLastCheck > fTimeBetweenRadiusChecks)
        {
            fTimeSinceLastCheck = 0.0000000;
            // End:0x5A
            if(IsEnemyWithinRadius(fRadius))
            {
                OnWithinRadius();
            }
        }
        //return;        
    }
    stop;    
}

state CheckNotWithinRadius
{
    event Tick(float DeltaTime)
    {
        // End:0x13
        if(bDebugDraw)
        {
            DoDebugDraw();
        }
        fTimeSinceLastCheck += DeltaTime;
        // End:0x5C
        if(fTimeSinceLastCheck > fTimeBetweenRadiusChecks)
        {
            fTimeSinceLastCheck = 0.0000000;
            // End:0x5C
            if(!IsEnemyWithinRadius(fRadius))
            {
                OnNotWithinRadius();
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    fTimeBetweenRadiusChecks=0.1000000
    WithinRadiusColor=(R=255,G=0,B=0,A=0)
    NotWithinRadiusColor=(R=0,G=255,B=0,A=0)
}