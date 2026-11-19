class SOFLAMInteractionActor extends InventoryInteractionActor placeable;

var(SOFLAMInteractionActor)	Material ActiveMaterial; 
var(SOFLAMInteractionActor) Material DeactivatedMaterial; 

var(SOFLAMInteractionActor) bool InitiallyVisible;
var(SOFLAMInteractionActor) bool DetonateOnSecondTrigger;


function PreBeginPlay()
{
	SetStaticMesh(StaticMesh(DynamicLoadObject("DefaultMeshes.Box64", class'StaticMesh')));
	ActiveMaterial = Material(DynamicLoadObject("Engine.DefaultTexture", class'Material'));
	DeactivatedMaterial = Material(DynamicLoadObject("Engine.DefaultTexture", class'Material'));
}


simulated function PostBeginPlay()
{
	Super.PostBeginPlay(); 
	Skins[0]=DeactivatedMaterial;
	
	if (!InitiallyVisible)
	{
		bHidden = true;
	}
}

event Trigger( Actor Other, Pawn EventInstigator )
{
	if (!InitiallyVisible)
	{
		bHidden = false;
	}
}

state Armed
{
	function BeginState()
	{
		// If not set to detonate on a second trigger, then set timer
		if( !DetonateOnSecondTrigger )
			Super.BeginState(); 
		
		Skins[0]=ActiveMaterial;
	}

	event Trigger( Actor Other, Pawn EventInstigator )
	{
		// If this is set to detonate via trigger (not via timer), then fire 
		// the Event (which will lead to detonation)
		if( DetonateOnSecondTrigger )
			TriggerEvent( Event, Self, None); 
	}

	function TimesUp()
	{
//		log("Sending trigger event");
		TriggerEvent( Event, Self, None); 	
	}

}


// Decompiled with UE Explorer.
defaultproperties
{
    InitiallyVisible=true
}