class MOHAITPController extends AIController
    native
    hidecategories(Navigation);

var bool bIsParachuting;
var bool InAirdrop;

event MarkForDeletion()
{
    InAirdrop = false;
    Destroy();
    //return;    
}

function StopCinematic()
{
    //return;    
}

function StartCinematic()
{
    //return;    
}

function PlayerExitsPlane()
{
    //return;    
}

state Airdrop
{
    function BeginState(name PreviousStateName)
    {
        bIsParachuting = true;
        self.bForceDesiredRotation = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        bIsParachuting = false;
        //return;        
    }

    event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
    {
        InAirdrop = false;
        GotoState('CombatTransition');
        MOHAParatrooperPawnNative(Pawn).Landed(HitNormal, FloorActor);
        return true;
        //return ReturnValue;        
    }
Begin:

    InAirdrop = true;
    stop;                
}

state CombatTransition
{Begin:

    stop;                
}

defaultproperties
{
    // Reference: SpriteComponent'Default__MOHAITPController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    ActorType=5
}