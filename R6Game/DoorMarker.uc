class DoorMarker extends NavigationPoint
    native
    placeable
    hidecategories(lighting,lighting,LightColor,Force);

enum EDoorType
{
    DOOR_Shoot,                     // 0
    DOOR_Touch,                     // 1
    DOOR_MAX                        // 2
};

var() edfindable InterpActor MyDoor;
var() DoorMarker.EDoorType DoorType;
var() edfindable Actor DoorTrigger;
var() bool bWaitUntilCompletelyOpened;
var() bool bInitiallyClosed;
var() bool bBlockedWhenClosed;
var bool bDoorOpen;
var const transient bool bTempDisabledCollision;

function PostBeginPlay()
{
    bBlocked = bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = !bInitiallyClosed;
    PostBeginPlay();
    return;
}

function MoverOpened()
{
    bBlocked = !bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = bInitiallyClosed;
    return;
}

function MoverClosed()
{
    bBlocked = bInitiallyClosed && bBlockedWhenClosed;
    bDoorOpen = !bInitiallyClosed;
    return;
}

event Actor SpecialHandling(Pawn other)
{
    local Actor TouchActor;

    // End:0x4E
    if((bDoorOpen || MyDoor == none) || bInitiallyClosed == (bDoorOpen || VSizeSq(MyDoor.Velocity) > 1.0000000))
    {
        return self;        
    }
    else
    {
        // End:0xAC
        if(int(DoorType) == int(1))
        {
            // End:0x72
            if(DoorTrigger == none)
            {
                return MyDoor;                
            }
            else
            {
                TouchActor = DoorTrigger.SpecialHandling(other);
                // End:0xA3
                if(TouchActor == none)
                {
                    TouchActor = DoorTrigger;
                }
                return TouchActor;
            }            
        }
        else
        {
            return self;
        }
    }
    return;
}

function bool ProceedWithMove(Pawn other)
{
    // End:0x4C
    if((int(DoorType) == int(0)) && other.Controller.Focus == MyDoor)
    {
        other.Controller.StopFiring();
    }
    // End:0x69
    if(bDoorOpen || int(DoorType) != int(0))
    {
        return true;
    }
    other.Controller.Focus = ((DoorTrigger != none) ? DoorTrigger : MyDoor);
    // End:0xED
    if(!other.Controller.FireWeaponAt(other.Controller.Focus))
    {
        other.Controller.MoveTimer = 0.2500000;        
    }
    else
    {
        // End:0x114
        if(bWaitUntilCompletelyOpened)
        {
            other.Controller.WaitForMover(MyDoor);
        }
    }
    return false;
    return;
}

event bool SuggestMovePreparation(Pawn other)
{
    // End:0x1B
    if(bDoorOpen || MyDoor == none)
    {
        return false;        
    }
    else
    {
        // End:0x5C
        if(VSizeSq(MyDoor.Velocity) > 1.0000000)
        {
            other.Controller.WaitForMover(MyDoor);
            return true;            
        }
        else
        {
            // End:0x157
            if(int(DoorType) == int(0))
            {
                other.Controller.Focus = ((DoorTrigger != none) ? DoorTrigger : MyDoor);
                // End:0x10C
                if(!other.Controller.FireWeaponAt(other.Controller.Focus))
                {
                    other.Controller.MoveTimer = 0.2500000;
                    other.Controller.bPreparingMove = true;
                    return true;                    
                }
                else
                {
                    // End:0x152
                    if(bWaitUntilCompletelyOpened)
                    {
                        other.Controller.WaitForMover(MyDoor);
                        other.Controller.bPreparingMove = true;
                        return true;                        
                    }
                    else
                    {
                        return false;
                    }
                }                
            }
            else
            {
                // End:0x237
                if(((int(DoorType) == int(1)) && DoorTrigger != none) && other.Controller.ActorReachable(DoorTrigger))
                {
                    // End:0x1E3
                    if(other.Controller.Focus == other.Controller.MoveTarget)
                    {
                        other.Controller.Focus = DoorTrigger;
                    }
                    other.Controller.MoveTarget = DoorTrigger;
                    other.Controller.CurrentPath = none;
                    other.Controller.NextRoutePath = none;
                    return false;                    
                }
                else
                {
                    return false;
                }
            }
        }
    }
    return;
}

defaultproperties
{
    bInitiallyClosed=true
    bSpecialMove=true
    ExtraCost=100
}