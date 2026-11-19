//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDPlayerControllerMP extends HDPlayerController;

var     float           FocusOnBodyTime;
var     float           FocusOnKillerTime;
var     bool            bFreeFocus;


reliable client function ClientStartRespawnCountdown();


function CheckRespawn()
{
	ClearTimer( 'CheckRespawn' );
}


state Dead
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		bFrozen = false;

		if( Role == ROLE_Authority )
		{
			SetTimer(
				FocusOnBodyTime,
				false, 'FocusOnKiller' );
		}
	}

	function EndState(name NextStateName)
	{
		Super.EndState( NextStateName );

		bFrozen = true;
		ClearTimer( 'CheckRespawn' );
	}

	function FocusOnKiller()
	{
		local TMPlayerReplicationInfo PRI;

		if( Role == ROLE_Authority )
		{
			PRI = TMPlayerReplicationInfo( PlayerReplicationInfo );
			if( PRI.LastKillerPRI != none )
			{
				SetViewTargetWithBlend(
					PRI.LastKillerPRI,
					3.0f,
					VTBlend_EaseInOut,
					2.f,
					false );

				SetTimer( FocusOnKillerTime, false, 'FocusOnTeam' );
			}
			else
			{
				FocusOnTeam();
			}
		}
	}

	function FocusOnTeam()
	{
		if( Role == ROLE_Authority )
		{
			ServerViewNextPlayer();

			if( !PlayerReplicationInfo.bOutOfLives )
			{
				if( TMGame(WorldInfo.Game) != None
				&& TMGame(WorldInfo.Game).ForceRespawn() )
				{
					if( WorldInfo.GRI.RespawnTime > 0.0 )
					{
						ClientStartRespawnCountdown();
						SetTimer( WorldInfo.GRI.RespawnTime, false, 'DoForcedRespawn' );
					}
					else if( WorldInfo.GRI.RespawnTime == 0.0 )
					{
						DoForcedRespawn();
					}
				}
			}
		}
	}

	function CheckRespawn()
	{
		ServerRestartPlayer();
	}

	function DoForcedRespawn()
	{
		if( !PlayerReplicationInfo.bOnlySpectator )
		{
			ServerRestartPlayer();
			SetTimer( 1.0, true, 'CheckRespawn' );
		}

		ClearTimer('DoForcedRespawn');
	}

	simulated exec function ChangeZoomFunction( byte Value )
	{
		if( Value != 0 )
		{
			ServerViewPrevPlayer();
		}
		else
		{
			ServerViewNextPlayer();
		}
	}

	simulated exec function StartFire( optional byte FireModeNum )
	{
		//BehindView();
	}

	reliable client function ClientStartRespawnCountdown()
	{
		bFreeFocus = true;
		RespawnTime = WorldInfo.TimeSeconds;
	}
}

state Spectating
{
	simulated exec function ChangeZoomFunction( byte Value )
	{
		if( Value != 0 )
		{
			ServerViewPrevPlayer();
		}
		else
		{
			ServerViewNextPlayer();
		}
	}

	simulated exec function StartFire( optional byte FireModeNum )
	{
		bFreeCamera = !bFreeCamera;
		if( bFreeCamera )
		{
			SetViewTargetWithBlend( none,
				3.0f,
				VTBlend_EaseInOut,
				2.f,
				false );
		}
		else
		{
			ServerViewNextPlayer();
		}
	}

	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );
		if( Role == ROLE_Authority )
		{
			ServerViewNextPlayer();
		}
	}
}


