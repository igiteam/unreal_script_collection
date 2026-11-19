
class SOFLAMTrigger extends InventoryTrigger placeable; 
 

function PostBeginPlay()
{ 
//	Log(Self$"::PostBeginPlay()"); 
	Super.PostBeginPlay();
}


function Touch( actor Other )
{
	Super.Touch(Other); 

	If(ZombiePlayerPawn(Other) != None )
		ZombieWeapon(ZombiePlayerPawn(Other).Weapon).InventoryTriggerTouch(self);
	
//	Log(Self$"::Touch()");

}

function UnTouch( actor Other )
{
//	Log(Self$"::UnTouch()");
	
	If(ZombiePlayerPawn(Other) != None )
		ZombieWeapon(ZombiePlayerPawn(Other).Weapon).InventoryTriggerUnTouch(self);

	Super.UnTouch(Other); 
}

