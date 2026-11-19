Class SearchableActor extends Actor
	placeable;

var() float MaxDist;
var() float	totalTime;
var() int AmmoAmount;
var() bool bdisappear;
var() bool bAbleToSearch;
var   bool bFinishedSearch;
var() bool bFatalFail;  //if user does not complete the interaction trigger a fail event
var() bool bDisappearOnFail;
var() bool bDrawProgBar;
var() bool bIsAPickup;
var() name FailEvent;
var ZombiePlayerPawn MyPawn;
var() class<Ammunition> MYAmmo;
var() localized string Message;
var() localized string FinishMessage;
var() StaticMesh MyMorphedMesh;
var() Sound  startSound;
var() Sound  workingSound;
var() Sound  failSound;
var() Sound  endSound;
var	  Sound  origAmbientSound;

var() Enums.EIcon  Icon,PickupIcon;  //defined in core/classes/enums.uc


function PlayStartSound()
{
	if(StartSound!=none)
	{
		PlaySound(StartSound,SLOT_Interact);
	}
	//if(workingSound != none)
	//{
	//	origAmbientSound = AmbientSound;
	//	AmbientSound=workingSound;
	//}

}

function Finished(Actor Other)
{
	triggerevent(event,None,None);
	GiveAmmo();
	MorphMesh();
	bableToSearch=false;
	bfinishedSearch=true;
	AmbientSound = origAmbientSound;
	SendFinishMessage(Other);
}
function GiveAmmo()
{
	if(MyAmmo != none)
	{
		Mypawn.RechargeExistingAmmo(MyAmmo,AmmoAmount);
	}
	//log("Made it to play sound");
	playsound(EndSound,SLOT_Interact);
	//log("Shoulda  played sound*****************************************************");
}

function Trigger(actor Other, pawn EventInstigator)
{
	if(!bAbleToSearch)
	{
		bAbleToSearch=true;
	}
}
function TriggerFailed()
{
	triggerevent(FailEvent,none,none);
	AmbientSound = origAmbientSound;
	if(FailSound != none)
	{
		PlaySound( FailSound, SLOT_Interact);
	}
	if(bDisappearOnFail)
	{
		setStaticMesh(none);
	}
}

function MorphMesh()
{
	if(MyMorphedMesh != none)
	{
		setStaticMesh(MyMorphedMesh);
	}
	if(bdisappear)
	{
		setStaticMesh(none);
	}
}	
function SendNotifyMessage(Actor Other)
{
	if(Message != "" && Other.IsA('ZombiePlayerPawn'))
	{
		if (MyPawn!=None)
			//ClearNotifyMessage(MyPawn);
		
		ZombiePlayerPawn(Other).ReceiveLocalizedMessage(class'ZombieGame.ZombiePickupMessage', 0, None, None, self);
		MyPawn = ZombiePlayerPawn(Other);
	}
}
function SendFinishMessage(Actor Other)
{
	//bFinishedSearch=true;

	if(Message != "" && Other.IsA('ZombiePlayerPawn'))
	{
		if (MyPawn!=None)
			//ClearNotifyMessage(MyPawn);
		//log("made it to finish message***************************************");
		ZombiePlayerPawn(Other).ReceiveLocalizedMessage(class'ZombieGame.ZombiePickupMessage', 1, None, None, self);
		MyPawn = ZombiePlayerPawn(Other);
		
		
	}
}
/*state DisplayingMsg
{
	Begin:
	log("in displayingmsg");
		Sleep(3.0);
		ClearNotifyMessage(MyPawn);
}*/
function ClearNotifyMessage(Actor toucher)
{
	if (MyPawn == None || toucher!=MyPawn) return;
	
	if (PlayerController(MyPawn.Controller) != none)
	{
		BasicHUD(PlayerController(MyPawn.Controller).myHUD).ClearLocalMessages(class'ZombieGame.ZombiePickupMessage');
		MyPawn = None;
	}
}

// Decompiled with UE Explorer.
defaultproperties
{
    MaxDist=200.0000000
    TotalTime=5.0000000
    AmmoAmount=20
    bAbleToSearch=true
    bDrawProgBar=true
    Message="press <action=use> to search"
    Icon=3
    DrawType=8
    StaticMesh=StaticMesh'DefaultMeshes.Generic.box64'
    bWorldGeometry=true
    bAcceptsProjectors=false
    bShowBulletHoles=true
    bShadowCast=true
    bStaticLighting=true
    CollisionRadius=20.0000000
    CollisionHeight=20.0000000
    bCollideActors=true
    bBlockActors=true
    bBlockPlayers=true
    bBlockKarma=true
    bEdShouldSnap=true
}