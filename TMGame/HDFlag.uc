//-----------------------------------------------------------
// HD???????
//-----------------------------------------------------------
class HDFlag extends SkeletalMeshActor;

var repnotify int OwnerTeam;

//Count
var int TotalProc;
var int RedNum;
var int BlueNum;
var int RedProc;
var int BlueProc;

var array<Controller> Touchers;
var HDCTFGame GameInfo;

//Effect
var MaterialInterface Mat[3];
var ParticleSystem    PST[2];
var ParticleSystemComponent CapturePS;

replication
{
     if(Role == ROLE_Authority)
		TotalProc, OwnerTeam;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	SetMaterial(2);

	if(Role == ROLE_Authority)
	{
		GameInfo = HDCTFGame(WorldInfo.Game);
	}
}

simulated event ReplicatedEvent(name VarName)
{
	if(VarName == 'OwnerTeam')
	{
     	;
     	CaptureEffect(OwnerTeam);
	}
	else
	{   ;
		Super.ReplicatedEvent(VarName);
	}
}

//??????
final function bool NeedFighting()
{
	return RedNum > BlueNum && OwnerTeam != 0 && Abs(RedProc - BlueProc) < TotalProc ||
	      BlueNum > RedNum  && OwnerTeam != 1 && Abs(RedProc - BlueProc) < TotalProc;
}

final function CheckFighting()
{
	if(NeedFighting())
	{
		if(!IsTimerActive('FightTimer'))
			SetTimer(0.5, true, 'FightTimer');
	}
	else
	{
	    RedProc = 0;
	    BlueProc = 0;
		ClearTimer('FightTimer');
	}
}

final function Hold(Controller C)
{
    local int i;

    for(i = 0; i < Touchers.Length; i++)
	{
		if(Touchers[i] == C)
		{
			return;
		}
	}

	Touchers.AddItem(C);

    //`log("#HDFlag::TeamIndex="@C.PlayerReplicationInfo.Team.TeamIndex);

	if(C.PlayerReplicationInfo.Team.TeamIndex == 0)
	{
	    ;
		RedNum++;
	}
	else
	{
		;
		BlueNum++;
	}

	;

	CheckFighting();
}

final function bool Drop(Controller C)
{
	local int i;

	;

	for(i = 0; i < Touchers.Length; i++)
	{
		if(Touchers[i] == C)
		{
			Touchers.Remove(i, 1);

			//`log("#HDFlag::TeamIndex="@C.PlayerReplicationInfo.Team.TeamIndex);

			if(C.PlayerReplicationInfo.Team.TeamIndex == 0)
			{
			    ;
				RedNum--;
			}
			else
			{
				;
				BlueNum--;
			}

			;

			if(RedNum == 0)
				RedProc = 0;

			if(BlueNum == 0)
				BlueProc = 0;

			CheckFighting();

			return true;
		}
	 }

	 return false;
}

singular event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local Pawn P;

	P = Pawn(Other);
	if(P != none && P.Controller != none)
	{
	    ;
		Hold(P.Controller);
	}
}

event UnTouch( Actor Other )
{
	local Pawn P;

	P = Pawn(Other);
	if(P != none && P.Controller != none)
	{
	 	;
	    Drop(P.Controller);
	}
}

final function SendProgressMsg()
{
	local int i;
	local int Diff;
	local int Prog;
	local PlayerController C;

	Diff = RedProc - BlueProc;
	for(i = 0; i < Touchers.Length; i++)
	{
		C =  PlayerController(Touchers[i]);
		if(C != none)
		{
			Prog = C.PlayerReplicationInfo.Team.TeamIndex == 0 ? Diff : -Diff;

			if(Prog > 0)
				GameInfo.BroadcastHandler.BroadcastLocalized(self, C, MessageClass, Prog + 100);
		}
	}
	//GameInfo.BroadcastLocalizedTeamMessage(1, MessageClass, 0);
}

simulated final function SetMaterial(int type)
{
	SkeletalMeshComponent.SetMaterial(1, Mat[type]);  //0???
}

simulated final function CaptureEffect(int team)
{
	SetMaterial(team);
	CapturePS.SetTemplate(PST[team]);
	CapturePS.SetActive(true);
}

final function Fighting()
{
	local int Diff;

	RedProc += RedNum;
	BlueProc += BlueNum;

	Diff = Abs(RedProc - BlueProc);

	//`log("#HDFlag::RedProc="@RedProc@"BlueProc="@BlueProc);
    SendProgressMsg();

	if(Diff >= TotalProc)
	{
	    OwnerTeam = RedProc > BlueProc ? 0 : 1;
	    ;

	    GameInfo.HDScoreFlag(OwnerTeam, self);
	    CaptureEffect(OwnerTeam);

	    //reset
		RedProc = 0;
		BlueProc = 0;

		ClearTimer('FightTimer');
	}
}

/*
event Tick( float DeltaTime )
{

} */

final function FightTimer()
{
 	Fighting();
}

