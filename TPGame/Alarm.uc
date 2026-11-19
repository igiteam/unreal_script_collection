class Alarm extends Actor;
    
var() bool bUsableAlarm;
var() bool bOneWayAlarm;
var bool bAlarmOn;
var StaticMeshComponent StaticMeshComponent;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

auto state AlarmWait
{
	event Touch( Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal )
	{
		local Pawn P;

		P = Pawn(Other);

		if( P != none )
		{
            PlayerPawn(P).PendingAlarm = self;
            TPPlayerController(P.Controller).ActivateInteractButton(true);
		}
	}
    
    event UnTouch( Actor Other )
	{
		local Pawn P;

		P = Pawn(Other);

		if( P != none )
		{
            PlayerPawn(P).PendingAlarm = none;
            TPPlayerController(P.Controller).ActivateInteractButton(false);
		}
	}  
}

//-----------------------------------------------------------------------
// Function:
// Description:	KISMET action to Activate all Alarms in level
//-----------------------------------------------------------------------
function OnToggle(SeqAct_Toggle Action)
{
    local Alarm A;
    
    if (Action.InputLinks[0].bHasImpulse)
	{
        foreach AllActors(class'Alarm', A)
        {
            A.bAlarmOn = true;
        }    
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
        foreach AllActors(class'Alarm', A)
        {
            A.bAlarmOn = false;
        } 
	}
    else
    {
        foreach AllActors(class'Alarm', A)
        {
            A.bAlarmOn = !A.bAlarmOn;
        }
    }
    
    if(bAlarmOn)
    {
        TriggerEventClass(class'SeqEvent_UseAlarm', self, 0);
    }
    else
    {
        TriggerEventClass(class'SeqEvent_UseAlarm', self, 1);
    } 
}

