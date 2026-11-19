class GTVipEscapePoint extends Triggers;

var bool Enabled;
var int gtFlags;
//var StaticMesh ringMesh;

replication
{
	//send this func to the server
	reliable if (Role<ROLE_Authority)
		SFWin;
}

//server func
function SFWin()
{
	//SF Win!
	log("SF win through escape");
	Level.Game.EndGame(Level.Game.GameReplicationInfo.VIPController.PlayerReplicationInfo, GTVIP(Level.Game).VIPEscapedText);
}

function bool RelevantTouch(Actor Other)
{
	local GTVipPawn vip;
	vip = GTVipPawn(Other);

	// game is suspended
	if( Level.Game != none && Level.Game.bWaitingToStartMatch )
		return false;

	// kkm--dead VIP's can't escape
	return vip != none && vip.IsVip() && vip.Health > 0;
}

event PostBeginPlay()
{
	local int gtInt;
//	local AmbientActor sma;
//	local vector ringPos;
//	local vector ringScale;
//	local float dim;
	
	Enabled = false;
	
	if (Level.Game != none)
	{
		gtInt = Level.Game.GameTypeID;
		
		if( (gtFlags & (1<<gtInt)) != 0 )
		{
			Enabled = true;
			Level.Game.GameReplicationInfo.SetFlagPos(location);
			
//			ringPos.x = Location.x;
//			ringPos.y = Location.y;
//			ringPos.z = Location.z-CollisionHeight;
//			
//			dim = CollisionRadius;
//			
//			dim /= 100;
//			
//			ringScale.x = dim;
//			ringScale.y = dim;
//			ringScale.z = 1;
//			
//			sma = Spawn(class'AmbientActor');
//			sma.SetStaticMesh(ringMesh);
//			sma.SetDrawType(DT_StaticMesh);
//			sma.SetCollision(false, false, false);
//			sma.SetDrawScale3D(ringScale);
//			sma.SetLocation(ringPos);
		}
	}
}

event Touch( Actor Other )
{
	if( Enabled && RelevantTouch(Other) )
	{
		SFWin();
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    gtFlags=128
}