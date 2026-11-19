Class SearchableActorInteraction	extends	interaction;

var ZombiePlayerPawn MyPawn;					//the player
var	SearchableActor MySearchableActor;			// a searchable actor
var ZombieBipedPawn DeadGuy;					// a dead pawn that can be searched for ammo
var class<ammunition> tempAmmoClass;
var	float startTime;
var	float currTime;
var	float oldTime;
var	float holdTime;
var() float	totalTime;
//var float DeadGuyTime;
var	int	numdrawn; 
var int numslices; //circular progbar
var int ProgBarwidth;
var int AmmoAmount;
//var int openIndex;
var	bool keyHeld;
var bool bisADoor;
var bool bisALockedDoor;
var bool bisAUnlockingDoor;
var bool bCanSeeDoor;
var bool bisaDeadEnemy; //might want to make a new interaction
var bool bReceivedAmmo;
var	Texture	WhiteSquareMat;
var() localized string Message;
var() localized string NoAmmoFoundMsg;
//circle stuff
var	canvas.TexVert2D v1;	 //origin should never change
var	canvas.TexVert2D v2[38]; //38 will become numslices
var	canvas.TexVert2D v3[38];
var Sound bodSearchSnd;
var Sound ammoReceivedSnd;
var  float pctTimePassed;
//const ICSTARTIDX;
var Enums.EIcon  PickupIcons[2];

function Initialized()
{
	//log(self@"I'm alive");
	PickupIcons[0]=IC_None;
	PickupIcons[1]=IC_None;
}

function NotifyLevelChange()
{	
	//log("level Changed");
	PickupIcons[0]=IC_None;
	PickupIcons[1]=IC_None;
	Master.RemoveInteraction(self);
}

Function PostRender(canvas Canvas)
{

	local int i;
	numslices=37;
	pctTimepassed=holdtime/totaltime;
	ProgBarwidth=48*pcttimepassed;
	
	//log("in postrender");
	//handle searchableActors
	if(MySearchableActor !=	none )
	{
		totaltime=MySearchableActor.totaltime;
		canvas.font=canvas.smallfont;
		if(!ViewportOwner.actor.myhud.bhideHUD)
		{
			DrawBackground(Canvas);
		}
		if(MySearchableActor.bDrawProgBar && !ViewportOwner.actor.myhud.bhideHUD)
		{
			DrawProgressBar(Canvas,200,300,50,7,2);
		}
		canvas.font=canvas.tinyfont; 
		canvas.setdrawcolor(255,255,255,0);
		if(!ViewportOwner.actor.myhud.bhideHUD)
		{
			//log("Going to blow my array right here?");
			class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, 87 + MysearchableActor.Icon, (canvas.logSizex/2), (canvas.LogSizeY/2),40,40);
		}
		//MySearchableActor.SendNotifyMessage(MyPawn);

		if(holdtime>=Totaltime)
		{
			if(MySearchableActor.bisAPickup && PickupIcons[0]==IC_NONE)
			{
				//log("Added a pickup to 0");
				PickupIcons[0]=MySearchableActor.PickupIcon;
			}
			else if(MySearchableActor.bisAPickup)
			{
				//log("Added a pickup to 1");
				PickupIcons[1]=MySearchableActor.PickupIcon;
			}
			MySearchableActor.Finished(MyPawn);	
            Numdrawn=0;
		}
		//log("Triggerevent failed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		//log	("Holdtime ="@holdtime);
	}
	//handle searching dead enemies
	if(bisaDeadEnemy && (ViewPortOwner.Actor.Level.TimeSeconds - Deadguy.TimeKilled) > 1 )
	{
		Totaltime = default.Totaltime;
		//DeadGuy.AmbientSound=none;
		if(!ViewportOwner.actor.myhud.bhideHUD)
		{
			DrawBackground(Canvas);
			DrawProgressBar(Canvas,200,300,50,7,2);
		}

		//Draw someText
		canvas.font=canvas.tinyfont;
		canvas.setdrawcolor(255,255,255,0);
		if(!ViewportOwner.actor.myhud.bhideHUD)
		{
			class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, 89, (canvas.logSizex/2), (canvas.LogSizeY/2),40,40);
		}
		//SendNotifyMessage(MyPawn);

		if(holdtime>=Totaltime)
		{
			AmmoAmount = (Frand()*10) + 10;
			//log("AmmoAmount after rand call"@Ammoamount);
			tempAmmoClass = SingleplayerMI(MyPawn.level.defaultmapinfo).GetAmmoClassForSearchableObject();
			breceivedAmmo = Mypawn.RechargeExistingAmmo(tempAmmoClass ,AmmoAmount);
			DeadGuy.beensearched=true;  //search him only once
			bisadeadenemy=false; //clean up
			if(breceivedAmmo)
			{
				MyPawn.PlaySound(ammoReceivedSnd,SLOT_Interact);
				SendNotifyMessage(MyPawn);
			}
			else
			{
				MyPawn.ReceiveLocalizedMessage(class'ZombieGame.ZombiePickupMessage', 1, None, None, self);
			}
			//ClearNotifyMessage(MyPawn);
		}
	}
	else
	{
		DeadGuy = none;
	}

	if(bisADoor && bCanSeeDoor && !BisaDeadEnemy && (MySearchableActor ==	none))
	{
		if(!ViewportOwner.actor.myhud.bhideHUD)
		{
			DrawBackground(Canvas);
		}
		//log("Going to try to do the background");
		canvas.setdrawcolor(255,255,255,0);
		if(!ViewportOwner.actor.myhud.bhideHUD)
		{
			class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, 88, (canvas.logSizex/2), (canvas.LogSizeY/2),40,40);
		}
	}
	if(bisAUnlockingDoor && bCanSeeDoor && !BisaDeadEnemy && (MySearchableActor == none))
	{
		bisADoor=false;
		if(!ViewportOwner.actor.myhud.bhideHUD)
		{
			DrawBackground(Canvas);
		}
		//log("just tried to do the background in locked door");
		canvas.setdrawcolor(255,255,255,0);
		if(!ViewportOwner.actor.myhud.bhideHUD)
		{
			class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, 93 , (canvas.logSizex/2), (canvas.LogSizeY/2),40,40);
		}
	}
	if(bisALockedDoor && bCanSeeDoor && !BisaDeadEnemy && (MySearchableActor == none))
	{
		if(!ViewportOwner.actor.myhud.bhideHUD)
		{
			DrawBackground(Canvas);
		}
		//log("just tried to do the background in locked door");
		canvas.setdrawcolor(255,255,255,0);
		if(!ViewportOwner.actor.myhud.bhideHUD)
		{
			class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, 91, (canvas.logSizex/2), (canvas.LogSizeY/2),40,40);
		}
	}
	//draw inventory icons
	if(!ViewportOwner.actor.myhud.bhideHUD)
	{
		for(i=0;i<2;i++)
		{
			if(PickupIcons[i] != IC_None)
			{
				Canvas.SetDrawColor(0,91,143);
				//log("DrawingInventory");
				//log("PickupIcon ="@PickupIcons[i]);
				class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, 87 + PickupIcons[i], Canvas.SafeFrame.Left+20,Canvas.SafeFrame.Bottom - (40+40*i),40,40);
				//class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, 87 + PickupIcons[1], Canvas.SafeFrame.Left,Canvas.SafeFrame.Bottom - 80,40,40);
			}
		}
	}
}
function bool KeyEvent(	out	EInputKey Key, out EInputAction	Action,	FLOAT Delta	)
{
	return false;  
}

function bool HandlePCKeyEvent( out EInputKey Key, out EInputAction Action, FLOAT Delta )
{
	if ( MysearchableActor == none && !bisaDeadEnemy )
	{
		KeyHeld=false;
		holdtime=0.0;
		Starttime=0.0;
		//log("setting everthing to zero");
		return false;		
	}
	if( Action!=IST_Press ) 
	{
		if(Action!=IST_Press &&	Key==IK_Enter)
			{	
				KeyHeld=false;
				holdtime=0.0;
			}
		return false;
	}   
	else	if(	Key==IK_Enter )
	{
	//only get this	the	first time
		if(startTime==0.0)
		{
		//	Log("########### //only get this the first time:   MySearchableActor:"$ MySearchableActor $"  MySearchableActor.Level:"$ MySearchableActor.Level );
			startTime=ViewportOwner.Actor.level.timeSeconds;
			oldTime=startTime;
		}
		
		//get time and make	sure user has held key down	
		currTime=ViewportOwner.Actor.level.timeSeconds;
		holdtime=currTime-startTime;
		if((currTime-oldTime)<=	0.2)
		{
			oldTime=currTime;
			keyHeld=true;
		}
		else
		{
			startTime=0.0;
			//log	("Button Released");
			holdtime=0.0;
			keyheld=false;
		}
			
		//log	("Starttime	="@starttime);
		//log	("currtime ="@currtime);
		//log	("Holdtime ="@holdtime);
		//log	("KeyHeld ="@Keyheld);
		return true;
	}
	//keyheld=false;
	//holdtime=0.0;
	//return	false;
}


function DrawProgressBar(Canvas	c, float x,	float y, float w, float	h,optional float lineThickness)
{
	//local  float progBarWidth;
	local int i;
	local int ProgBarx,ProgBary;	

	//Draw the Border
	c.setdrawcolor(255,255,255,128);
	ProgBarx=(c.logSizex/2)-(w/2);
	ProgBary=(c.logSizey/2)+28;
	BasicHUD ( ViewPortOwner.Actor.myHUD ).DrawOpenBox(c,ProgBarx,ProgBary,w,h,lineThickness);

	//MyPawn.MyHud.DrawOpenBox(c,x,y,w,h,lineThickness);
	//draw the progress	bar
	if(holdtime!= 0.0 && keyheld && holdtime <= totaltime)  
	{

		c.setdrawcolor(255,255,255,255);

		//Draw Circ	Progbar////////////////////////////////////////////////////////////////



		if(ProgBarwidth<49)
		{	
			c.SetPos( (ProgBarx+lineThickness)*c.Scale, (ProgBary+lineThickness)*c.Scale );

			If(Numdrawn==0) //special case
			{
				//log("Progbarwidth = "@progbarwidth);
				//log("pcttimepassed = "@pcttimepassed);
				c.DrawRect(c.WhiteSquare,ProgBarwidth*c.Scale,(h-2*lineThickness)*c.Scale);
				//Handle Search sounds
				if(MySearchAbleActor != none)
				{
					MySearchableActor.PlayStartSound();
				}
				else if(DeadGuy != none)
				{
					//log("playings bodsearch");
					DeadGuy.AmbientSound=bodSearchSnd;
				}
				Numdrawn++;
			}


			//the other	two verts after the first time
			Else
			{
				//log("Progbarwidth = "@progbarwidth);
				//log("pcttimepassed = "@pcttimepassed);
				c.DrawRect(c.WhiteSquare,ProgBarwidth*c.Scale,(h-2*lineThickness)*c.Scale);


			}	
			//numdrawn++;

		}
		//draw them all
		//if(numdrawn <= numslices)
		//{
		//for(i=0;i<=numdrawn;i++)
		//{

		//}
		//}	
		//numdrawn++;
	}
	//dont draw if player has let up the key
	else
	{
		progbarwidth=0.0;
		numdrawn=0;

		if(DeadGuy != none)
		{
			DeadGuy.AmbientSound=none;
		}

		i=0;

	}
}
function DrawBackground(canvas c)
{
	c.SetDrawColor(255,255,255,128);
	BasicHUD( ViewportOwner.Actor.myHUD ).DrawOpenBox( c, c.logSizex/2 - 25, c.logSizey/2 - 25, 50, 50, 2 );

	c.SetDrawColor(0,91,143,64);
	BasicHUD( ViewportOwner.Actor.myHUD ).DrawBox( c, c.logSizex/2 - 23, c.logSizey/2 - 23, 46, 46 );
}
function RemoveKeyFromInv()
{
	local int i;
	for(i=0;i<2;i++)
	{
		if(PickupIcons[i] == IC_KEY)
		{
			PickupIcons[i] = IC_NONE;
		}
	}

}
function RemoveItemFromInv(Enums.EIcon Icon)
{
	local int i;
	for(i=0;i<2;i++)
	{
		if(PickupIcons[i] == Icon)
		{
			PickupIcons[i] = IC_NONE;
		}
	}

}
function SendNotifyMessage(Actor Other)
{
	
	local array<string> args;
	
	if(Other.IsA('ZombiePlayerPawn'))
	{
		//log("1");
		if (MyPawn!=None)
		{
			//log("2");
			//ClearNotifyMessage(MyPawn);
			//tempAmmoClass = SingleplayerMI(MyPawn.level.defaultmapinfo).GetAmmoClassForSearchableObject();
			//log("tempAmmoClass"@tempAmmoClass);
			//log("tempAmmoClass.itemName"@tempAmmoClass.default.itemname);
			args[1]=tempAmmoClass.default.itemname;
			//log("AmmoAmount in SNMessagge"@AmmoAmount);
			args[0]= string (AmmoAmount);
			message=Format( class'Strings'.default.AmmoPickupMsg, args );
			ZombiePlayerPawn(Other).ReceiveLocalizedMessage(class'ZombieGame.ZombiePickupMessage', 0, None, None, self);
			tempAmmoClass=none;
			MyPawn = ZombiePlayerPawn(Other);
		}
	}
}


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
    TotalTime=3.0000000
    WhiteSquareMat=Texture'Engine.WhiteSquareTexture'
    NoAmmoFoundMsg="Nothing Found"
    bodSearchSnd=Sound'CBW_DYN_Foley.locks.body_search'
    ammoReceivedSnd=Sound'CBW_DYN_interface.HUD.pickup_ammo'
    bVisible=true
}