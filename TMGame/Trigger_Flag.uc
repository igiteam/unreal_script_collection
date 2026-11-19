class Trigger_Flag extends Trigger
	dependson( TMPawn, TMPlayerController )
	placeable;

var 	array< TMPawn >		TouchListTeam0;
var 	array< TMPawn >		TouchListTeam1;
var     int					ScoreList[2];
var	repnotify int			CaptureTeam;

/** This is the actual Material Instance that is used to affect the colors */
var protected array<MaterialInstanceConstant> MaterialInstances;


var(Flag)	Texture						TeamTexture0<DisplayName=Texture of Red Team>;
var(Flag)	Texture						TeamTexture1<DisplayName=Texture of Blue Team>;
var(Flag)	Texture						NeutralTexture<DisplayName=Texture of Neutral>;
var(Flag)	SkeletalMeshComponent		FlagMesh;

var(Flag) const editconst LightEnvironmentComponent LightEnvironment;


event Touch(
	Actor Other,
	PrimitiveComponent OtherComp,
	vector HitLocation,
	vector HitNormal )
{
	local TMPawn				TMP;
	local TMPlayerController    TMPC;
	local int					TeamIndex;

	Super.Touch( Other, OtherComp, HitLocation, HitNormal );

	TMP = TMPawn( Other );
	if( TMP == none )
	{
		return;
	}

	TMPC = TMPlayerController( TMP.Controller );
	if( TMPC == none )
	{
		return;
	}

	if( TMPC.PlayerReplicationInfo == none ||
		TMPC.PlayerReplicationInfo.Team == none )
	{
		return;
	}

	TeamIndex = TMPC.PlayerReplicationInfo.Team.TeamIndex;
	if( TeamIndex == 0 )
	{
		if( TouchListTeam0.Find( TMP ) >= 0 )
		{
			return;
		}

		TouchListTeam0.AddItem( TMP );
	}
	else if( TeamIndex == 1 )
	{
		if( TouchListTeam1.Find( TMP ) >= 0 )
		{
			return;
		}

		TouchListTeam1.AddItem( TMP );
	}

	CheckScoreStatus();
}

event Untouch( Actor Other )
{
	local TMPawn				TMP;

	Super.UnTouch( Other );

	TMP = TMPawn( Other );
	if( TMP == none )
	{
		return;
	}

	TouchListTeam0.RemoveItem( TMP );
	TouchListTeam1.RemoveItem( TMP );
	CheckScoreStatus();
}

event Timer()
{
	CheckScoreStatus();

	if( CaptureTeam == -1 )		// No team capture this flag now.
	{
		return;
	}

	// Add score to the capture team.
	ScoreList[ CaptureTeam ] ++;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetupMaterial();
    ChangeTeamTexture( CaptureTeam );

	if( Role == ROLE_Authority )
	{
		SetTimer( 1.0, true );
	}
}

simulated function SetupMaterial()
{
	local int i;

	MaterialInstances.Length = FlagMesh.GetNumElements();
	for( i = 0; i < MaterialInstances.Length; ++ i )
	{
		MaterialInstances[ i ] = FlagMesh.CreateAndSetMaterialInstanceConstant( i );
	}
}

function CheckScoreStatus()
{
	local int i;
	local int PreTeam;

	PreTeam = CaptureTeam;
	CaptureTeam = -1;

	for( i = 0; i < TouchListTeam0.Length; ++ i )
	{
		if( TouchListTeam0[ i ].Health > 0 )
		{
			CaptureTeam = 0;
			break;
		}
	}

	for( i = 0; i < TouchListTeam1.Length; ++ i )
	{
		if( TouchListTeam1[ i ].Health > 0 )
		{
			if( CaptureTeam == -1 )
			{
				CaptureTeam = 1;
			}
			else
			{
				CaptureTeam = -1;
			}
			break;
		}
	}

	if( PreTeam != CaptureTeam )
	{
		bNetDirty = true;
		ChangeTeamTexture( CaptureTeam );
    }
}

simulated function ChangeTeamTexture( int InTeam )
{
	local int i;

	;

	switch( InTeam )
	{
	case 0:
		for( i = 0; i < MaterialInstances.Length; ++ i )
		{
			MaterialInstances[ i ].SetTextureParameterValue( 'TeamTexture', TeamTexture0 );
		}
		break;

	case 1:
		for( i = 0; i < MaterialInstances.Length; ++ i )
		{
			MaterialInstances[ i ].SetTextureParameterValue( 'TeamTexture', TeamTexture1 );
		}
		break;

	case -1:
		for( i = 0; i < MaterialInstances.Length; ++ i )
		{
			MaterialInstances[ i ].SetTextureParameterValue( 'TeamTexture', NeutralTexture );
		}
		break;
	}
}

/* epic ===============================================
* ::ReplicatedEvent
*
* Called when a variable with the property flag "RepNotify" is replicated
*
* =====================================================
*/
simulated event ReplicatedEvent(name VarName)
{
	if( VarName == 'CaptureTeam' )
	{
		ChangeTeamTexture( CaptureTeam );
	}
}

replication
{
	if( bNetDirty || bNetInitial )
		CaptureTeam;
}

