class TGPC extends TMPlayerController
	native(TG)
	config(TGPawn);

/** Squad this player belongs to */
var TGSquad Squad;

/** Flag indicating that player is currently targeting. */
var			bool	bIsTargeting;

/** true if level has vehicles, so player should be checking for available HUD actions related to vehicles */
var bool bCheckVehicles;

var	class<Pawn> DefaultPawnClass;

/** The state of the inputs from cinematic mode */
var bool bCinemaDisableInputButtons;

var config bool bInvisible;

/** set when camera is being controlled by Matinee, so we don't force the server's ViewTarget on the client */
var bool bInMatinee;

/** Is this player in combat?  Set by IsInCombat(), and should never be referenced directly. */
var private float LastCheckIsInCombatTime;

event bool FindAvailableTeleportSpot( Pawn TestPawn, optional NavigationPoint TeleportAnchor, optional bool bSkipRadiusSearch)
{
	local array<NavigationPoint> NavList;
	local NavigationPoint Nav;
	local vector ChkLoc, NavLoc;
	local TGAI AI;
	local TGPawn GP;
	local TGTurret GT;
	local int Idx;
	local bool bSecondPass;
	local rotator TeleportRot;

	if (TGWeap_SniperRifle(TestPawn.Weapon) != None)
	{
		;
		TGWeap_SniperRifle(TestPawn.Weapon).SetOwnerNoSee(FALSE);
	}

	GP = TGPawn(TestPawn);
	if( GP != None )
	{
		ServerReviveTeamMate(GP);
		GP.ServerEndSpecialMove();
		//if (TGPC(GP.Controller) != None)
		//{
		//	TGPC(GP.Controller).ClientBreakFromCover();
		//}
		//else
		//{
			GP.BreakFromCover();
		//}
	}

	// if we're on a troika, get off before the teleport
	GT = TGTurret(TestPawn);
	if(GT != none)
	{
		;
		GT.DriverLeave(TRUE);
	}

	AI = TGAI(TestPawn.Controller);
	// if an anchor was specified
	if (TeleportAnchor != None)
	{
		// then attempt to spawn at that anchor
		Nav = TeleportAnchor;
		NavLoc = Nav.Location;

		if ( class'SeqAct_AIFactory'.static.CanSpawnAtLocation(NavLoc,TestPawn.GetCollisionExtent(),Nav) )
		{
			if (AI != None)
			{
				if (AI.TeleportToLocation(NavLoc,Nav.Rotation))
				{
					return TRUE;
				}
			}
			else if (TestPawn.SetLocation(Nav.Location))
			{
				if (TestPawn.Controller != None)
				{
					TeleportRot = Nav.Rotation;
					TeleportRot.Roll = 0;
					TestPawn.Controller.SetRotation(TeleportRot);
					TestPawn.Controller.ClientSetLocation(TestPawn.Location, TeleportRot);
					TestPawn.Controller.ClientSetRotation(TeleportRot, TRUE);
				}
				TestPawn.SetPhysics(PHYS_Falling);
				return TRUE;
			}
		}
		// otherwise use the anchor as the check location
		ChkLoc = TeleportAnchor.Location;
	}
	else
	{
		// use current pawn location if possible
		ChkLoc = Pawn != None ? Pawn.Location : Location;
	}
	if (!bSkipRadiusSearch)
	{
		// grab nodes in a radius
		// first try to spawn behind this player - if that doesn't work try anything
		class'NavigationPoint'.static.GetAllNavInRadius(TestPawn, ChkLoc, 1024.f, NavList);
		for (Idx = 0; Idx < NavList.Length; Idx++)
		{
			Nav = NavList[Idx];
			if ( !Nav.IsA('CoverSlotMarker') && Abs(Nav.Location.Z - ChkLoc.Z) < 78.f &&
				( bSecondPass || Pawn == None ||
					( VSize(Nav.Location - Pawn.Location) > 100.0 &&
						vector(Rotation) dot Normal(Nav.Location - Pawn.Location) < 0.0 &&
						FastTrace(Nav.Location, Pawn.Location) ) ) )
			{
				NavLoc = Nav.Location;
				if ( class'SeqAct_AIFactory'.static.CanSpawnAtLocation(NavLoc, TestPawn.GetCollisionExtent(), Nav) )
				{
					if (AI != None)
					{
						if (AI.TeleportToLocation(NavLoc,Nav.Rotation))
						{
							return TRUE;
						}
					}
					else if (TestPawn.SetLocation(NavLoc))
					{
						if (TestPawn.Controller != None)
						{
							TeleportRot = Nav.Rotation;
							TeleportRot.Roll = 0;
							TestPawn.Controller.SetRotation(TeleportRot);
							TestPawn.Controller.ClientSetLocation(TestPawn.Location, TeleportRot);
							TestPawn.Controller.ClientSetRotation(TeleportRot, TRUE);
						}
						TestPawn.SetPhysics(PHYS_Falling);
						;
						return TRUE;
					}
				}
			}
			if (Idx == NavList.length - 1 && !bSecondPass)
			{
				bSecondPass = true;
				Idx = -1;
			}
		}
	}
	;
	return FALSE;
}

reliable server function ServerReviveTeamMate( TGPawn GP )
{
	//`log(self@GetFuncName()@P);

	if (GP.IsDBNO())
	{
		//TGGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Revived, Pawn, GP);
	}

	//GP.DoRevival(MyTGPawn);
}

/** returns TRUE if we are in a coop-enabled mode and more than 1 player is active */
simulated final event bool IsActuallyPlayingCoop()
{
	local TGGRI GRI;

	GRI = TGGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		return GRI.IsActuallyPlayingCoop();
	}

	return FALSE;
}

/** resets the object pool to its initial state */
reliable client final function ClientResetObjectPool()
{
	local TGGRI GRI;

	GRI = TGGRI(WorldInfo.GRI);
	if (GRI != None && GRI.GOP != None)
	{
		GRI.GOP.CleanupForPToPTransition();
	}
}

//@HACK: fix up mesh animtree and translation after a map transition because the vehicle exit code doesn't seem to
//	trigger/work correctly in some cases for some reason
reliable client function ClientMeshFixupHack(TGPawn P)
{
	if (P != None && P.Mesh != None)
	{
		if (P.Mesh.AnimTreeTemplate != P.default.Mesh.AnimTreeTemplate)
		{
			P.Mesh.SetAnimTreeTemplate(P.default.Mesh.AnimTreeTemplate);
			P.ClearAnimNodes();
			P.CacheAnimNodes();
		}
		P.Mesh.SetTranslation(P.default.Mesh.Translation);
	}

	//@HACK: workaround for weapon sometimes not showing up for client after transition
	if ( P != None && WorldInfo.NetMode == NM_Client && !P.IsLocallyControlled() &&
			P.InvManager != None && P.InvManager.Role == ROLE_Authority )
	{
		P.InvManager.Destroy();
		P.Weapon = None;
		P.MyTGWeapon = None;
		P.RefreshRemoteAttachments();
	}
}

/** Internal.  Returns true if playing a debug/development level, false otherwise. */
simulated function bool PlayingDevLevel()
{
/*
`if(`notdefined(FINAL_RELEASE))
	local string MapName;

	MapName = Locs(GetCurrMapName());

	if ( (InStr(MapName, 'poc_') == 0) || (InStr(MapName, 'dp_') == 0) )
	{
		return TRUE;
	}
`endif
*/
	//return FALSE;
	return TRUE;
}

function ProcessGameOver()
{
	//local TGPC PC;

	//// play the anya sound
	//PlayAnyaCoopDeathSound();

	//foreach WorldInfo.AllControllers(class'TGPC', PC)
	//{
	//	PC.ClientGameOver();
	//}
}

/** called by the server to synchronize cinematic transitions with the client */
reliable client function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD)
{
	Super.ClientSetCinematicMode(bInCinematicMode, bAffectsMovement, bAffectsTurning, bAffectsHUD);

	//if (myGearHUD != None)
	//{
	//	myGearHUD.ActiveAction.bActive = FALSE;  // when we are in cinematic mode we need to clear any active ActionIcons

	//	// if the cinematic mode toggles the HUD off, we have to clean up the HUD
	//	if (myGearHUD.bShowHUD)
	//	{
	//		myGearHUD.ClearHUDAfterShowToggle();
	//	}

	//	if (bCinematicMode)
	//	{
	//		// reset taccom FX as well
	//		MyGearHud.ResetTaccomOpacity();
	//		MyGearHud.CloseDiscoverableScene();
	//	}
	//}

	//// Deactivate the active tutorial if there is one
	//if (bCinematicMode && TutorialMgr != none)
	//{
	//	TutorialMgr.RebootSystem();
	//}

	//// let the UI know that cinematic mode has [potentially] changed, so it should update cached viewport sizes for any open scenes
	//UpdateUIViewportSizes();
}

/** called by the server to synchronize cinematic transitions with the client */
reliable client function ClientDisableButtons()
{
	//DisableInput(true, false, false);
}

event SetSquadName(name NewSquadName, bool bLeader = true)
{
	local TGPRI PRI;
	local TGTeamInfo Team;

	PRI = TGPRI(PlayerReplicationInfo);
	if (PRI != None)
	{
		if( Squad != None )
		{
			Squad.UnregisterSquadMember( self );
		}

		PRI.SquadName = NewSquadName;
		Team = TGTeamInfo(Pawn.GetTeam());
		if (Team != None)
		{
			// players are always squad leaders
			Team.JoinSquad(PRI.SquadName,self,bLeader);
		}
	}
}

function OnChangeSquad( SeqAct_ChangeSquad Action )
{
	SetSquadName( Action.SquadName, Action.bSquadLeader );
}

/** Returns whether or not we think the player is in combat */
event bool IsInCombat(optional bool bForceCheck)
{
	local Controller C;
//	local bool bWasInCombat;
	local HDBasePawn p;
	p = HDBasePawn(Pawn);

	// if we don't have a TG pawn we can't be in combast
	if (p == none)
		return false;

	// server replicates combat state to client
	if (Role < ROLE_Authority)
	{
		// so just return the cached version
		return p.bIsInCombat;
	}
	// always return false in MP - kind of backwards but it was this way unintentionally for a long time
	// and we decided to keep it
	if (TGGameMP_Base(WorldInfo.Game) != None)
	{
		p.bIsInCombat = false;
		return false;
	}
	// only update the cached value if it's been a while
	if (WorldInfo.TimeSeconds - LastCheckIsInCombatTime > 1.0f)
	{
//		bWasInCombat = p.bIsInCombat;
		LastCheckIsInCombatTime = WorldInfo.TimeSeconds;

		p.bIsInCombat = FALSE;
		foreach WorldInfo.AllControllers( class'Controller', C )
		{
			// If there is a controller that has an enemy on the other team
			if (C != self &&
				C.Pawn	!= None &&
				C.Enemy != None &&
				(TGPawn(C.Pawn) == None || !TGPawn(C.Pawn).IsAHostage()) &&
				!C.Enemy.IsSameTeam( C.Pawn ) )
			{
				// Consider them in combat
				p.bIsInCombat = TRUE;
				break;
			}
		}

		// if not in combat
		//if( !PlayingDevLevel() && !p.bIsInCombat && bWasInCombat )
		//{
		//	SetTimer( RandRange(5.f,15.f),FALSE,nameof(ReviveTeammates) );
		//	SetTimer( RandRange(5.f,10.f),FALSE,nameof(ExecuteMeatshields) );
		//}

	}
	return p.bIsInCombat;
}

