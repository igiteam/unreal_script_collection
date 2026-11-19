
class InventoryTrigger extends Trigger
abstract; 

var(InventoryTrigger)	class<StaticMeshActor>	TriggerActor; 


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






// Decompiled with UE Explorer.
defaultproperties
{
    Texture=Texture'Engine.S_MaterialTrigger'
    CollisionRadius=100.0000000
    CollisionHeight=100.0000000
}