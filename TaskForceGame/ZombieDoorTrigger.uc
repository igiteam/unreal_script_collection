class ZombieDoorTrigger extends UseTrigger
	notplaceable;

var		bool		MessageOn;
var( )	ZombieDoor	myDoor;
var		string		MessageStorage;

var bool			bOpen;
var bool			bCanSee;

function SetDoor ( ZombieDoor Door ) 
{
	if ( Door != None )
		myDoor = Door;
}

function SetTriggerState ( EDoorTriggerState State, bool ShowMessage, optional string NewMessage ) 
{
	if ( bOpen )
	{
		if ( ShowMessage ) 
		{	
			MessageStorage = NewMessage;
		} 
		else 
		{
			MessageStorage = " ";
		}
	}
	else
	{
		if ( ShowMessage ) 
		{	
			Message = NewMessage;
		} 
		else 
		{
			Message = " ";
		}
	}

	if ( State == DTS_TOUCH ) 
	{	
		// goto touch trigger state
		GotoState ( 'TouchTriggerState' );
	} 
	else if ( State == DTS_USE ) 
	{	
		// goto the use trigger state
		GotoState ( 'UseTriggerState' );
	} 
	else if ( State == DTS_LOCKED ) 
	{
		// goto the use trigger state
		GotoState ( 'UseTriggerState' );
		
	} 
	else if ( State == DTS_UNLOCKING ) 
	{
		// goto the use trigger state
		GotoState ( 'unlocking' );
		
	} 
	else if ( State == DTS_DISABLED ) 
	{	
		// goto disabled state
		GotoState ( 'DisabledTriggerState' );
	}
}

function SendNotifyMessage ( Actor Other ) 
{
	if ( !MessageOn ) 
	{	
		if ( Message != "" ) 
		{		
			BroadcastLocalizedMessage ( class'ZombieGame.ZombieWeaponMessageStay', 0, None, None, self );
			//BasicHUD ( PlayerController ( ZombiePlayerPawn( other ).Controller ).myHUD ).bDrawingSpecial=true;
			//class'ZombieGame.HUDIconMgr'.static.DrawImageHW(( SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.Canvas ), 90, (canvas.logSizex/2), 240);
			//SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisADoor=true;
			MessageOn = true;
		}
	}
}

simulated function ClearNotifyMessage ( Actor toucher ) 
{
	if ( MessageOn ) 
	{	
		if( ( Message != "" ) && ( toucher != None ) && ( ZombiePlayerPawn(toucher) != None ) ) 
		{		
			if ( PlayerController( ZombiePlayerPawn ( toucher ).Controller ) != none) 
			{			
				BasicHUD ( PlayerController ( ZombiePlayerPawn( toucher ).Controller ).myHUD ).ClearLocalMessages( class'ZombieGame.ZombieWeaponMessage' );
				//BasicHUD ( PlayerController ( ZombiePlayerPawn( toucher ).Controller ).myHUD ).bDrawingSpecial=False;
				MessageOn = false;
			}
		}
	}
}

function InternalUnBlockDoor ( ZombieBipedPawn UnBlocker )
{
	local ZombieBipedPawn CheckPawn;

	foreach TouchingActors ( class'ZombieBipedPawn', CheckPawn )
	{
		if ( CheckPawn != None && CheckPawn != UnBlocker )
		{
			if ( ZombiePlayerPawn ( CheckPawn ) == None || ( myDoor.ZombieDoorType != ZDT_LOCKEDDOOR && myDoor.ZombieDoorType != ZDT_TRIGGERDOOR ) )
			{
				if ( CheckPawn.Health > 0 || !myDoor.bCloseOnDeadBodies )
				{
					return;
				}
			}
		}
	}

	myDoor.UnBlockDoor ( );
}

function DoorOpening ( )
{
	local SFRMPlayerController PC;

	if ( !bOpen )
	{
		// clear out message
		MessageStorage = Message;
		Message = "";
		bOpen = true;

		if ( MessageOn )
		{
			foreach DynamicActors ( class'SFRMPlayerController', PC )
			{
				BasicHUD ( PC.myHUD ).ClearLocalMessages ( class'ZombieGame.ZombieWeaponMessage' );
			}
			MessageOn = false;
		}
	}
}

function DoorClosed ( )
{
	if ( bOpen )
	{
		// fill it back in
		Message = MessageStorage;
		MessageStorage = "";
		bOpen = false;
	}
}

state( ) TouchTriggerState 
{
	function Touch( Actor Other ) 
	{	
		if ( ZombieBipedPawn ( Other ) != None ) 
		{		
			// set the door as blocked
			SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisADoor=true;
			//log("bisDoor = "$SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisADoor);
			myDoor.BlockDoor ( );
			// open it
			myDoor.OpenDoor ( Other, Pawn ( Other ) );
		}
	}
	
	function UnTouch( Actor Other ) 
	{		
		if ( ZombieBipedPawn ( Other ) != None ) 
		{		
			// set the door as unblocked ( it'll close automatically when it sees it's unblocked )
			InternalUnBlockDoor ( ZombieBipedPawn ( Other ) );
		}
	}
}

state( ) UseTriggerState 
{
	function Touch( Actor Other ) 
	{ 	
		local ZombieBipedPawn OtherPawn;
		OtherPawn = ZombieBipedPawn ( Other );
	
		// make sure it's a ZombieBipedPawn
		if ( OtherPawn != None )
		{
			// set door as blocked
			myDoor.BlockDoor ( );	

			// a player?
			if ( OtherPawn.IsHumanControlled ( )  )
			{	/* no touch for Human player		
				//SendNotifyMessage ( OtherPawn );
				//BasicHUD ( PlayerController ( OtherPawn.Controller ).myHUD ).bDrawingSpecial=true;
				//log("bDrawingSpecial "$BasicHUD ( PlayerController ( OtherPawn.Controller ).myHUD ).bDrawingSpecial);
				//class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, 88, (canvas.logSizex/2), 240);

				//check to see if he is looking at the door here, if not don't show an icon
				UserVector = OtherPawn.Location - Mydoor.Location;
				UserVector = Normal (UserVector);
				GetAxes(OtherPawn.Rotation,X,Y,Z);
				X = Normal ( X );
				dotResult = X Dot UserVector;
				if( dotResult < 0)
				{
					bCanSee = true;
					log("bCanSee "@bCanSee);
					BasicHUD ( PlayerController ( OtherPawn.Controller ).myHUD ).bDrawingSpecial=true;
					SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bCanSeeDoor=true;
					log("bDrawingSpecial "$BasicHUD ( PlayerController ( OtherPawn.Controller ).myHUD ).bDrawingSpecial);
					//class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, 88, (canvas.logSizex/2), 240);

					if( myDoor.ZombieDoorType != ZDT_LOCKEDDOOR)
					{
						BasicHUD ( PlayerController ( OtherPawn.Controller ).myHUD ).bDrawingSpecial=true;
						log("bDrawingSpecial "$BasicHUD ( PlayerController ( OtherPawn.Controller ).myHUD ).bDrawingSpecial);
						SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisALockedDoor=false;
						SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisADoor=true;
						log("bisDoor = "$SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisADoor);
					}
					else
					{
						BasicHUD ( PlayerController ( OtherPawn.Controller ).myHUD ).bDrawingSpecial=true;
						log("bDrawingSpecial "$BasicHUD ( PlayerController ( OtherPawn.Controller ).myHUD ).bDrawingSpecial);
						SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisALockedDoor=true;
						SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisADoor=false;
						log("bisDoor = "$SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisADoor);
					}
				}
			*/}
			// npc?
			else if ( OtherPawn.Controller!=None && ZombieBot( OtherPawn.Controller ).bOpenDoors && myDoor.bNPCAutoUse && ( myDoor.DoorState == DS_CLOSED || myDoor.DoorState == DS_CLOSING ) && !OtherPawn.IsHumanControlled ( )) 
			{			
				// use it
				UsedBy ( OtherPawn );
			}
		}
	}

	function UnTouch( Actor Other ) 
	{	
		local ZombieBipedPawn OtherPawn;
		OtherPawn = ZombieBipedPawn ( Other );
	
		if ( OtherPawn != None ) 
		{		
			if (  OtherPawn.IsHumanControlled ( ) )
			{/*
				SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisALockedDoor=false;
				SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisADoor=false;
				BasicHUD ( PlayerController ( OtherPawn.Controller ).myHUD ).bDrawingSpecial=false;
				log("bDrawingSpecial in untouch = "$BasicHUD ( PlayerController ( OtherPawn.Controller ).myHUD ).bDrawingSpecial);
				log("bisDoor in untouch = "$SFRMPlayerController ( ZombiePlayerPawn( other ).Controller ).MySAInteraction.bisADoor);
				ClearNotifyMessage ( OtherPawn );
				*/
			}
		
			if ( myDoor.bAutoClose ) 
			{			
				// set door as unblocked
				InternalUnBlockDoor ( OtherPawn );
			}
		}
	}
	
	function UsedBy ( Pawn User ) 
	{
		local ZombieBipedPawn OtherPawn;
		local Vector UserVector;
		local float dotResult;
		local vector X,Y,Z;
		//local Bool bcanSeeDoor;
		OtherPawn = ZombieBipedPawn ( User );

		if ( OtherPawn != None ) 
		{
			//bCanSeeDoor=SFRMPlayerController ( ZombiePlayerPawn( otherPawn ).Controller ).MySAInteraction.bCanSeeDoor;
			UserVector = OtherPawn.Location - Mydoor.Location;
			UserVector = Normal (UserVector);
			GetAxes(OtherPawn.Rotation,X,Y,Z);
			X = Normal ( X );
			dotResult = X Dot UserVector;
			// locked?
			if ( myDoor.ZombieDoorType == ZDT_LOCKEDDOOR) 
			{	
				// player
				if ( OtherPawn.IsHumanControlled ( ) && SFRMPlayerController ( ZombiePlayerPawn( otherPawn ).Controller ).MySAInteraction.bCanSeeDoor)
				{
					// do the locked door stuff
					myDoor.TryDoor ( );
					
				}
				// npc and the NPC should ignore that it's locked
				else if ( myDoor.bNPCIgnoreDoorState && !OtherPawn.IsHumanControlled ( ))
				{
					// and door is closed or closing
					if ( myDoor.DoorState == DS_CLOSED || myDoor.DoorState == DS_CLOSING )
					{
						// open the door
						myDoor.OpenDoor ( OtherPawn, OtherPawn );
					}
				}
			} 
			else 
			{	
				if ( (myDoor.DoorState == DS_CLOSED || myDoor.DoorState == DS_CLOSING)  ) 
				{	
					if(OtherPawn.IsHumanControlled ( )&& SFRMPlayerController ( ZombiePlayerPawn( otherPawn ).Controller ).MySAInteraction.bCanSeeDoor)
					{
						// open the door
						//log("opening the Door; DotResult ="@dotResult);
						ClearNotifyMessage ( OtherPawn );
						myDoor.OpenDoor ( OtherPawn, OtherPawn );
					}
					else if(!OtherPawn.IsHumanControlled ( ))
					{
						ClearNotifyMessage ( OtherPawn );
						myDoor.OpenDoor ( OtherPawn, OtherPawn );
					}
				} 
				else
				{
					// unblock it and it will close automatically
					InternalUnBlockDoor ( None );
				}
			}
		}
	}
}
state  Unlocking
{
	function UsedBy ( Pawn User ) 
	{
		local ZombieBipedPawn OtherPawn;
		local ZombieDoor Door;
		local Vector UserVector;
		local float dotResult;
		local vector X,Y,Z;
		local bool bcanSeeDoor;
		OtherPawn = ZombieBipedPawn ( User );

		if ( OtherPawn != None ) 
		{
			bCanSeeDoor = SFRMPlayerController ( ZombiePlayerPawn( otherPawn ).Controller ).MySAInteraction.bCanSeeDoor;
			UserVector = OtherPawn.Location - Mydoor.Location;
			UserVector = Normal (UserVector);
			GetAxes(OtherPawn.Rotation,X,Y,Z);
			X = Normal ( X );
			dotResult = X Dot UserVector;
			// locked?
			if ( myDoor.ZombieDoorType == ZDT_LOCKEDDOOR) 
			{	
				// player
				if ( OtherPawn.IsHumanControlled ( ) && bCanSeeDoor)
				{
					// do the locked door stuff
					myDoor.TryDoor ( );
					
				}
				// npc and the NPC should ignore that it's locked
				else if ( myDoor.bNPCIgnoreDoorState && !OtherPawn.IsHumanControlled ( ))
				{
					// and door is closed or closing
					if ( myDoor.DoorState == DS_CLOSED || myDoor.DoorState == DS_CLOSING )
					{
						// open the door
						myDoor.OpenDoor ( OtherPawn, OtherPawn );
					}
				}
			} 
			else 
			{	
				if ( (myDoor.DoorState == DS_CLOSED || myDoor.DoorState == DS_CLOSING)  ) 
				{	
					if(OtherPawn.IsHumanControlled ( )&& bCanSeeDoor)
					{
						// open the door
						//log("opening the Door; DotResult ="@dotResult);
						ClearNotifyMessage ( OtherPawn );
						myDoor.OpenDoor ( OtherPawn, OtherPawn );
						bCanSeeDoor = SFRMPlayerController ( ZombiePlayerPawn( otherPawn ).Controller ).MySAInteraction.bCanSeeDoor;
						
						foreach AllActors(class 'ZombieDoor',Door,Mydoor.Tag)
						{
							//log("the door I think i am fucking with"@Mydoor);
							//log("Doors being Fuxored"@MyDoor.Tag);
							Door.ZombieDoorType = ZDT_USEDOOR;
							//log("just changed to a usedoor"@door);
						}
						SetTriggerState ( DTS_USE, false);

						SFRMPlayerController ( ZombiePlayerPawn( otherPawn ).Controller ).MySAInteraction.RemoveKeyFromInv();
					}
					else if(!OtherPawn.IsHumanControlled ( ))
					{
						ClearNotifyMessage ( OtherPawn );
						myDoor.OpenDoor ( OtherPawn, OtherPawn );
					}
				} 
				else
				{
					// unblock it and it will close automatically
					InternalUnBlockDoor ( None );
				}
			}
		}
	}
}

state( ) DisabledTriggerState 
{
	function Touch ( Actor Other ) 
	{	
		local ZombieBipedPawn OtherPawn;
		OtherPawn = ZombieBipedPawn ( Other );
		// NPC?
		if ( OtherPawn != None && !OtherPawn.IsHumanControlled ( ) )
		{
			if ( myDoor.bNPCIgnoreDoorState && myDoor.bNPCAutoUse )
			{
				// set door as blocked and open it
				myDoor.BlockDoor ( );
				myDoor.OpenDoor ( OtherPawn, OtherPawn );
			}
		}
	}
	
	function UnTouch ( Actor Other ) 
	{	
		local ZombieBipedPawn OtherPawn;
		OtherPawn = ZombieBipedPawn ( Other );
		// NPC?
		if ( OtherPawn != None && !OtherPawn.IsHumanControlled ( ) )
		{		
			if ( myDoor.bNPCIgnoreDoorState && myDoor.bNPCAutoUse && myDoor.bAutoClose ) 
			{			
				// set door as unblocked
				InternalUnBlockDoor ( ZombieBipedPawn ( Other ) );
			}
		}
	}
	
	function UsedBy ( Pawn User ) 
	{	
		return;
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    Message="Press <action=use> to open"
    Texture=Texture'Engine.S_MaterialTrigger'
    CollisionRadius=50.0000000
}