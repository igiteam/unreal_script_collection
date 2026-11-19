class GTVipPlayerController extends SFRMPlayerController
native;

replication
{
    //send this to clients
    reliable if( Role==ROLE_Authority )
		VIPRoundEnded,VIPRoundStarting;
}

function bool shouldFade()
{
	return false;
}

event bool IsVIP()
{
	return PlayerReplicationInfo.ClassIdx==6 || GameReplicationInfo.VIPController == self;
}

//both called on Client
native event VIPRoundStarting();
native event VIPRoundEnded();

//following functions run on server
event ServerViewSelf()
{
	ServerViewNextPlayer(); // can't view yourself in VIP
}
function AskForPawn()
{
	Super.AskForPawn();
	
	if( GTVIP(Level.Game).bRoundEnded )
	{
		//sends this back down to the client
		VIPRoundEnded();
	}
}


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
