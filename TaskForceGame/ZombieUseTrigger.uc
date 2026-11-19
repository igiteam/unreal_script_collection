class ZombieUseTrigger extends UseTrigger;

var() name InventoryInteractionTag;
var() class<SFRMInventoryWeapon> ItemClass;
var() float TraceDistance; 
var() bool UseOnce;
var() bool bTriggerOnUse;
var() bool bNPCAutoUse;

var ZombiePlayerPawn TouchingPlayer;
var Pawn PawnUser;
var SFRMInventoryWeapon Item;
var InventoryInteractionActor InteractionActor;
var bool HasBeenUsed;

var ZombiePlayerPawn MessageViewer;

replication
{
	reliable if(Role < ROLE_Authority)
		SendNotifyMessage,ClearNotifyMessage;
}
simulated function PostBeginPlay()
{
	if ((InventoryInteractionTag != '') && (InventoryInteractionTag != 'None'))
	{
		foreach AllActors(class'ZombieGame.InventoryInteractionActor',InteractionActor,InventoryInteractionTag)
		{
			break;
		}
	}
}

function UsedBy( Pawn user )
{
	if ( bDisabled )
		return;
		
	if ( MessageViewer !=None || Message == "" )
	{
		PawnUser = user;

		if (UseOnce)
		{
			HasBeenUsed=true;
			ClearNotifyMessage(MessageViewer);
			gotoState('');
		}

		if ( Item != none )
		{
			Item.TriggeredUse(self);
		}
		else
		{
			//FinishUse(user);
			ItemDone();
		}
	}
	
	user.Weapon.bForceReload = False; 
}

function FinishUse(Pawn user)
{
	Super.UsedBy(user);
	//log("Trigger used");
}

function ItemDone()
{
	if (InteractionActor != none)
	{
		InteractionActor.Activate(self);

		if(bTriggerOnUse){
			FinishUse(PawnUser);			
		}
	}
	else
	{
		FinishUse(PawnUser);
	}
}

function InteractionDone()
{
	if(!bTriggerOnUse){
		FinishUse(PawnUser);
	}
}

function bool TestItem()
{
	return ((ItemClass == none) || (Item != none));
}

function SendNotifyMessage(Actor Other)
{
	if(Message != "" && Other.IsA('ZombiePlayerPawn'))
	{
		if (MessageViewer!=None)
			ClearNotifyMessage(MessageViewer);
		
		ZombiePlayerPawn(Other).ReceiveLocalizedMessage(class'ZombieGame.ZombieWeaponMessageStay', 0, None, None, self);
		MessageViewer = ZombiePlayerPawn(Other);
	}
}

function ClearNotifyMessage(Actor toucher)
{
	if (MessageViewer == None || toucher!=MessageViewer) return;
	
	if (PlayerController(MessageViewer.Controller) != none)
	{
		BasicHUD(PlayerController(MessageViewer.Controller).myHUD).ClearLocalMessages(class'ZombieGame.ZombieWeaponMessage');
		MessageViewer = None;
	}
}

function bool TestLook(ZombiePlayerPawn p)
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local vector DiffFromPlayerView, DiffFromPlayerViewH;
	local Actor hitAct;
	local float dist, lateralH, lateralV;

	// Do a trace (used to check that player can actually see the interaction actor)
	GetAxes(p.GetViewRotation(),X,Y,Z);
	StartTrace = p.Location + p.EyePosition(); 
	EndTrace = InteractionActor.Location;
	hitAct = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True, );

	// See how far the interaction actor is from where the player is actually looking
	//  -Assume that player is looking at a point dist units away (directly ahead). 
	//  -Find horizontal and vertical distance between that point and the location of 
	//   the interaction actor (lateralH and lateralV).
	//  -These are used to check the angles (by using a trig relation like the tangent).
	//   For example: lateralH / dist = tangent in horizontal plane  
	//   As long as the relation is approximately true for the angle ranges in question,
	//   this will work.
	dist = VSize(EndTrace - StartTrace);
	DiffFromPlayerView = ((StartTrace + dist * X) - EndTrace);
	DiffFromPlayerViewH = DiffFromPlayerView;
	DiffFromPlayerViewH.Z = 0;

	lateralH = VSize(DiffFromPlayerViewH);
	lateralV = abs(DiffFromPlayerView.Z);

	// Check that player can see interaction actor.
	//  -Check that we have a clear line of sight (actor returned from trace is the InteractionActor)
	//  -Check that it is not hidden
	//  -Check that it is within certain horizontal and vertical angles from the center of the player's view
	//   Note:  tan( 70 deg / 2 ) = 0.7    tan( 58 deg / 2 ) = 0.55 
	if ((hitAct == InteractionActor) && !hitAct.bHidden && (lateralH/dist < 0.7) && (lateralV/dist < 0.55) )
	{
		return true;
	}

	return false;
}

function Touch( Actor Other )
{
	if( (!bDisabled) && (Other != None) && (ZombiePlayerPawn(Other) != None) && (!UseOnce || !HasBeenUsed))
	{
		TouchingPlayer = ZombiePlayerPawn(Other);

		if (ItemClass != none)
		{
			Item = SFRMInventoryWeapon(TouchingPlayer.FindInventoryType(ItemClass));
			log("Item: " $ Item);
		}

		if (InteractionActor != none)
		{
			gotoState('LookForInteractionActor');
		}
		else
		{
			if (TestItem())
			{
				SendNotifyMessage(Other);
			}
		}
	}
	/*
	else if( bNPCAutoUse && Other.IsA('SpecForceEnemyPawn') && !bDisabled )
	{
		FinishUse( Pawn(Other) );
	}
	*/
}

function UnTouch( Actor Other )
{
	local ZombiePlayerPawn p;

	if (Other == MessageViewer)
	{
		gotoState('');
		TouchingPlayer = none;
		Item = none;
		ClearNotifyMessage(other);
		foreach TouchingActors(class'ZombiePlayerPawn',p)
		{
			if (p!=Other)
				Touch(p);
		}
	}
}

state LookForInteractionActor
{
	event Tick( float DeltaTime )
	{
		if(TestLook(TouchingPlayer) && TestItem())
		{
			SendNotifyMessage(TouchingPlayer);
		}
		else
		{
			ClearNotifyMessage(TouchingPlayer);
		}
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    TraceDistance=90.0000000
    UseOnce=true
    Message="Press <action=use> to use"
    Texture=Texture'Engine.S_MaterialTrigger'
    CollisionRadius=45.0000000
}