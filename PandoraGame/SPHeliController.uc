class SPHeliController extends SPVehicleController
    native;

function OnAIMoveToActor(SeqAct_AIMoveToActor inAction)
{
    super.OnAIMoveToActor(inAction);
    //return;    
}

function OnAIStartForceFireAtTarget(SeqAct_AIStartForceFireAtTarget Action)
{
    local MiniGunPersistent G;

    ClearLatentAction(Class'SeqAct_AIStartForceFireAtTarget', true);
    // End:0x80
    foreach AllActors(Class'MiniGunPersistent', G)
    {
        // End:0x7F
        if(G.Base != none)
        {
            // End:0x7F
            if(G.Base == self.Pawn)
            {
                G.Target = Target;
                G.OnAIStartForceFireAtTarget(Action);
            }
        }        
    }    
    //return;    
}

function OnAIStopForceFireAtTarget(SeqAct_AIStopForceFireAtTarget Action)
{
    local MiniGunPersistent G;

    ClearLatentAction(Class'SeqAct_AIStartForceFireAtTarget', true);
    // End:0x6B
    foreach AllActors(Class'MiniGunPersistent', G)
    {
        // End:0x6A
        if(G.Base != none)
        {
            // End:0x6A
            if(G.Base == self.Pawn)
            {
                G.OnAIStopForceFireAtTarget(Action);
            }
        }        
    }    
    //return;    
}

function OnAIStartForceAimAtTarget(SeqAct_AIStartForceAimAtTarget Action)
{
    local MiniGunPersistent G;

    ClearLatentAction(Class'SeqAct_AIStartForceAimAtTarget', true);
    // End:0x80
    foreach AllActors(Class'MiniGunPersistent', G)
    {
        // End:0x7F
        if(G.Base != none)
        {
            // End:0x7F
            if(G.Base == self.Pawn)
            {
                G.Target = Target;
                G.OnAIStartForceAimAtTarget(Action);
            }
        }        
    }    
    //return;    
}

function OnAIStopForceAimAtTarget(SeqAct_AIStopForceAimAtTarget Action)
{
    local MiniGunPersistent G;

    ClearLatentAction(Class'SeqAct_AIStartForceAimAtTarget', true);
    // End:0x6B
    foreach AllActors(Class'MiniGunPersistent', G)
    {
        // End:0x6A
        if(G.Base != none)
        {
            // End:0x6A
            if(G.Base == self.Pawn)
            {
                G.OnAIStopForceAimAtTarget(Action);
            }
        }        
    }    
    //return;    
}

state Idle
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        Focus = none;
        // End:0x23
        if(Target == none)
        {
            PreserveRotation();
        }
        // End:0x68
        if(Pawn != none)
        {
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
        //return;        
    }
    stop;    
}
