class SOFLAMAttachmentPoint extends Actor placeable
native;

var DynamicSOFLAMAttachment soflam;

var(SOFLAMAttachmentPoint) bool InitiallyVisible;
var(SOFLAMAttachmentPoint) bool DetonateOnVisibleTrigger;
var(SOFLAMAttachmentPoint) bool StartArmed;
var(SOFLAMAttachmentPoint) bool Disarmable;
var(SOFLAMAttachmentPoint) bool DestroyAfterDisarm;
var(SOFLAMAttachmentPoint) localized String ArmMessage;
var(SOFLAMAttachmentPoint) localized String DisarmMessage;
var(SOFLAMAttachmentPoint) StaticMesh ChargeMesh;
var(SOFLAMAttachmentPoint) Material ChargeMaterialOverride;
var(Events)	name	EventOnArmed;
var(Events)	name	EventOnStartArming;
var(Events)	name	EventOnAbortArming;
var(Events)	name	EventOnDisarmed;
var(Events)	name	EventOnStartDisarming;
var(Events)	name	EventOnAbortDisarming;


event SetVisible(bool b)
{
	if (b && soflam==None)
	{
		soflam = Spawn(class'DynamicSOFLAMAttachment',self); 
		soflam.SetOffsetToOrigin();
		soflam.SetAlwaysVisible(true);
		soflam.SetStartPlacingOnTouch(true);
		soflam.Event = Event;
		if (DetonateOnVisibleTrigger)
			soflam.SetDetonateMode(true);
		soflam.SetDestroyOwnerOnExplode(true);
		soflam.bDestroyAfterDisarm=DestroyAfterDisarm;
		
		soflam.EventOnArmed=EventOnArmed;
		soflam.EventOnDisarmed=EventOnDisarmed;
		soflam.EventOnStartArming=EventOnStartArming;
		soflam.EventOnAbortArming=EventOnAbortArming;
		soflam.EventOnStartDisarming=EventOnStartDisarming;
		soflam.EventOnAbortDisarming=EventOnAbortDisarming;
		soflam.SetMessages(ArmMessage,DisarmMessage);
		
		soflam.bCanDisarm=Disarmable;
		
		soflam.ActiveMaterial = ChargeMaterialOverride;
		if(ChargeMesh!=None)
		{
			soflam.SetChargeMesh(ChargeMesh);
		}
		if (StartArmed)
			soflam.StartArmed();
			
	}
	if (soflam != None)
		soflam.bHidden=!b;
	
}

event Trigger( Actor Other, Pawn EventInstigator )
{
	// If this is set to detonate via trigger (not via timer), then fire 
	// the Event (which will lead to detonation)
	if (soflam==None || soflam.bHidden==true)
	{
		SetVisible(true);
	}
	else if( DetonateOnVisibleTrigger)
	{
		soflam.Detonate();
	}

}

event Destroyed()
{
	if (soflam!=None)
		soflam.Destroy();
	soflam=None;
}


event PostBeginPlay()
{
	SetVisible(InitiallyVisible);
}
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    InitiallyVisible=true
    armMessage="Press and hold <action=use> to place SLAM charge"
    disarmMessage="Press and hold <action=use> to disarm SLAM charge"
    DrawType=8
    StaticMesh=StaticMesh'DefaultMeshes.Generic.box64'
    bHidden=true
}