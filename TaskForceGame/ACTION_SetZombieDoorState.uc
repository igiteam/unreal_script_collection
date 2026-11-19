class ACTION_SetZombieDoorState extends ScriptedAction;

var(Action) name				ZombieDoorTag;
var(Action) EZombieDoorType		NewDoorType;
var(Action) name				NewDoorTag;
var(Action) string				NewDoorMessage;
var(Action) bool				bShowNewMessage;


function bool InitActionFor ( ScriptedController C )
{
	local ZombieDoor MyDoor;

	ForEach C.AllActors ( class'ZombieDoor', MyDoor, ZombieDoorTag )
		break;

	if ( MyDoor != None )
	{
		MyDoor.ZombieDoorType = NewDoorType;
		MyDoor.Tag = NewDoorTag;
		MyDoor.Message = NewDoorMessage;
		MyDoor.ShowMessage = bShowNewMessage;

		MyDoor.SetUpTrigger ( );
	}
	
	return false;	
}

