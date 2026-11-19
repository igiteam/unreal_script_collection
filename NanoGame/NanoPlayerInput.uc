/**
 * NanoPlayerInput
 * Nano player input post processing
 *
 // for 1st person game we probably want to grab the UT3 PlayerInput code  as that has all of the fast acceleration and such that UT3 needed
 // also it is partially c++'d.  
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPlayerInput extends NanoPlayerInput_Base
	dependson(NanoPawn)
	transient;


var transient NanoPlayerInput_Base ForgeUIInputHandler;

var transient bool bHolsteredWeapon;
var bool bCanReleaseMoon;
var transient float StartHookTime;

/** This is how long we wait before the Nano power is activated **/
var config float NanoPowerActivateTime;

/** How long to wait after entering DBNO before we can interact with him.  (e.g. mashing X X X we don't want to start immediately harvesting once the the guy goes DBNO) **/
var config float TimeBeforeDBNOInteractable;

var config float DBNO_InteractionDistance;


function OnInputObjectCreate()
{
	Super.OnInputObjectCreate();

	// create forgeui handler
	ForgeUIInputHandler = new(Outer) class'NanoPlayerInput_ForgeUI';
	if (ForgeUIInputHandler != None)
	{
		ForgeUIInputHandler.OnInputObjectCreate();
	}
}


/** Sets the input handlers for the button handling list - set by subclasses */
event InitializeButtonHandlingHandlers()
{
	InputButtonDataList[GB_A].ButtonHandler					= HandleButtonInput_A;
	InputButtonDataList[GB_X].ButtonHandler					= HandleButtonInput_X;
	InputButtonDataList[GB_Y].ButtonHandler					= HandleButtonInput_Y;
	InputButtonDataList[GB_B].ButtonHandler					= HandleButtonInput_B;
	InputButtonDataList[GB_Start].ButtonHandler				= HandleButtonInput_Start;
	InputButtonDataList[GB_Back].ButtonHandler				= HandleButtonInput_Back;
	InputButtonDataList[GB_LeftTrigger].ButtonHandler		= HandleButtonInput_LeftTrigger;
	InputButtonDataList[GB_LeftBumper].ButtonHandler		= HandleButtonInput_LeftBumper;
	InputButtonDataList[GB_RightTrigger].ButtonHandler		= HandleButtonInput_RightTrigger;
	InputButtonDataList[GB_RightBumper].ButtonHandler		= HandleButtonInput_RightBumper;
	InputButtonDataList[GB_DPad_Up].ButtonHandler			= HandleButtonInput_DPad_Up;
	InputButtonDataList[GB_DPad_Left].ButtonHandler			= HandleButtonInput_DPad_Left;
	InputButtonDataList[GB_DPad_Down].ButtonHandler			= HandleButtonInput_DPad_Down;
	InputButtonDataList[GB_DPad_Right].ButtonHandler		= HandleButtonInput_DPad_Right;
	InputButtonDataList[GB_LeftStick_Push].ButtonHandler	= HandleButtonInput_LeftStickButton;
	InputButtonDataList[GB_RightStick_Push].ButtonHandler	= HandleButtonInput_RightStickButton;
}

function HandleButtonInput_A( bool bPressed, optional bool bDblClickMove )
{
	local NanoVehicleAgent NVA;
	local NanoPerchPole_Base Pole;
	local NanoPawn CounterTarget;
	
	//	local float AttemptJumpTime;

	if( bPressed )
	{
		NVA = NanoVehicleAgent(TargetedActor);
		Pole = MyNP.GetPerchPole();
		if( NVA != None && !MyNP.IsPlatformJumping() && NVA.ValidPlatformJumpTarget(MyNP) )
		{
			MyNP.AttemptCarPlatformJump(NVA);
			ClearTimer( nameof(self.AttemptJump), self );
		}
		else if( MyNP.CurrentTurbine != None && MyNP.ActiveSpecialMoveName == 'NSM_Turbine' )
		{
			MyNP.CurrentTurbine.ReleaseUser();
		}
		else if( MyNP.CurrentLadder != None )
		{
			MyNP.AbortLadderClimb();
		}
		else if( Pole != None )
		{
			Pole.BeginPull();
		}
		else if( CanDoDBNODrag( CounterTarget ) == TRUE )
		{
			`log( "DBNODrag DBNODrag DBNODrag" @ `showvar(CounterTarget) );

			MyNP.DoSpecialMove( 'NSM_DBNO_DragAttempt',, CounterTarget );
		}
		else
		{
			// throttle the jump rate slightly
			if( !MyNP.bDodging && (`TimeSince(MyNP.LastJumpTime) < 0.25f || `TimeSince(MyNP.LastLandingTime) < 0.25f) )
			{
				SetTimer( 0.1f, FALSE, 'AttemptJump', self );
			}
			else
			{
				AttemptJump();
			}
		}
	}
	else
	{
		MyNP.JumpHoldTime = -1.f;
		ClearTimer( nameof(self.AttemptJump), self );

		Pole = MyNP.GetPerchPole();
		if(Pole != None)
		{
			Pole.ReleasePull();	
		}
	}
}


function bool AttemptDodge()
{
	local vector StickDir;
	local NanoSkill_Jump JumpSkill;
	local Rotator CamRot;
	local Vector CamLoc;
	
	JumpSkill = MyNP.GetSkill(class'NanoSkill_Jump');
	if( JumpSkill != None )
	{
		GetActorEyesViewPoint(CamLoc,CamRot);

		if( Abs(RawJoyUp) > 0.2f )
		{
			StickDir.X = RawJoyUp;
		}
		if( Abs(RawJoyRight) > 0.2f )
		{
			StickDir.Y = RawJoyRight;
		}
		StickDir = StickDir >> CamRot;

		if( !IsZero(StickDir) && JumpSkill.AttemptDodge( MyNP, StickDir ) )
		{
			return TRUE;
		}
	}
	return FALSE;
}

function bool AttemptJump()
{
	local vector StickDir;
	local NanoSkill_Jump JumpSkill;
	local Rotator CamRot;
	local Vector CamLoc;

	ClearTimer( nameof(self.AttemptJump), self );

	if( !MyNP.bIsDashing && Physics == PHYS_Walking )
	{
		if( MyNP.HandleMantleChecks(Outer) )
		{
			return TRUE;
		}
	}
	
	JumpSkill = MyNP.GetSkill(class'NanoSkill_Jump');
	if( JumpSkill != None )
	{
		GetActorEyesViewPoint(CamLoc,CamRot);

		StickDir.X = RawJoyUp;
		StickDir.Y = RawJoyRight;
		StickDir = StickDir >> CamRot;

		if( JumpSkill.AttemptJump( MyNP,StickDir, (RawJoyUp > 0.2 || RawJoyRight > 0.2) ) )
		{
			MyNP.JumpHoldTime = WorldInfo.TimeSeconds;
			return TRUE;
		}
	}
	return FALSE;
}

function StartJumpAnim()
{
	MyNP.ToggleJumpHoldTime(TRUE);
}

function ClearSummonDelegate()
{
	MyNP.WeaponFinishedSummoning = None;
}

function DoGrabAttack()
{
	local NanoPawn CounterTarget;

	if( CanDoGrab( CounterTarget ) == TRUE )
	{
		MyNP.DoSpecialMove( 'NSM_Melee_GrabAHostageAttempt', TRUE, CounterTarget );
	}


	//Pawn.StartFire( class'NanoWeap_Melee'.const.FIREMODE_GrabAHostage );
}

function SwordAttack()
{
	local NanoWeap_Melee Weap;
	local bool bHoldingB, bHoldingX, bHoldingY, bNearWall;

	if( !MyNP.bIsDoingStabMantle && !MyNP.bIsDoingCarHop && !MyNP.bDodging && !MyNP.bPlayingHitReaction && NanoPerchPoint(MyNP.Base) == None && ( MyNP.IsDoingSpecialMove( 'NSM_Melee_DropTheHammer') == FALSE ) )
	{
		Weap = NanoWeap_Melee(MyNP.Weapon);
		bHoldingX = Weap != None && IsButtonActive(Weap.AttackButtonOne);
		bHoldingY = Weap != None && IsButtonActive(Weap.AttackButtonTwo);
		bHoldingB = Weap != None && IsButtonActive(Weap.AttackButtonThree);
		bNearWall = MyNP.IsNearWall( vector(MyNP.Rotation),,, MyNP.GetCollisionRadius() * 5.f);
		
		MyNP.ForceDashStop();

// 		if( bHoldingB && bNearWall && MyNP.PerformSwordAction() )
// 		{
// 			`loginfo('Nano_Melee', "wall hang");
// 		}
// 		else
// 		{
			if( !MyNP.IsSkydiving() )
			{
				if( bHoldingX || bNearWall )
				{
					if( CanSlideOverLedge() && MyNP.AttemptOverLedgeStab() )
					{
						`loginfo('Nano_Melee', "slide off leddge" );
					}
					else if( MyNP.MantleState == MANTLE_None )
					{
						PerformSwordAttack(0);
					}
				}
				else if( bHoldingY )
				{
					if( MyNP.MantleState == MANTLE_None )
					{
						PerformSwordAttack( 0 );
					}
				}
				else if( bHoldingB )
				{
					if( MyNP.MantleState == MANTLE_None )
					{
						PerformSwordAttack( 0 );
					}
				}
			}
//		}
	}
}

function HandleButtonInput_B( bool bPressed, optional bool bDblClickMove )
{
	local Actor HitActor;
	local NanoPawn_MetaCorp_BullRamBase Bull;
	local Vector ChargeLocation;
	local array<NanoInterface_Interact> InteractObjects;
	local NanoInterface_Interact InteractInt;
	local Vector CamLoc;
	local Rotator CamRot;
	local NanoVehicleAgent NVA;
	local bool bStabMantle;
	local int Idx;
	local NanoPerchPole_Base Pole;
	local NanoPawn CounterTarget;


	NVA = NanoVehicleAgent(MyNP.Base);
	Pole = MyNP.GetPerchPole();

	if( bPressed )
	{
		// Allow the debug cam to intercept the B button for toggling fast mode
		if( DebugCam != None )
		{
			DebugCam.ToggleFastMode();
			return;
		}

		if( MyNP.InteractionPawn != None )
		{
			if( MyNP.InteractionType == PAWNINTER_Tackle && !MyNP.FullBodySlot.bIsPlayingCustomAnim )
			{
				MyNP.ThrowTackledActor();
			}
			// Can't do any of this if being held
		}
		else if (MyNP.CurrentLadder != None)
		{
			MyNP.AbortLadderClimb();
		}
		else if (MyNP.LookForLadderToClimb())
		{
			// climbing a ladder, yay
		}
		else if (MyNP.CanTackle() && MyNP.AttemptToTackle())
		{
			// grabbed someone, don't do anything
		}
		else if( Pole != None )
		{
			Pole.Disengage();
		}
/*		
		else if (GrappleTarget != None || MyNP.ActiveSpecialMoveName == 'NSM_Grapple')
		{
			if( MyNP.ActiveSpecialMoveName == 'NSM_Grapple' )
			{
				MyNP.LocalEndSpecialMove('NSM_Grapple');
			}
			else
			{
				MyNP.DoSpecialMove('NSM_Grapple', TRUE, None, GrappleTarget);
			}
		}
*/
		else
		{
			// check for target to counter
			if( CanDoCounter( CounterTarget ) == TRUE )
			{
				`log( "Countering" );
				
				MyNP.DoSpecialMove( 'NSM_Melee_Counter', TRUE,, CounterTarget );
				CounterTarget.DoSpecialMove( 'NSM_Melee_Counter_Victim', TRUE,, MyNP );

				//PerformSwordAttack( 0 );

				// return for now?
				return;
			}


			//if( CanDoGrab( CounterTarget ) == TRUE )
			//{
			//	`log( "GRAB GRAB GRAB" @ `showvar(CounterTarget) );
			//
			//	MyNP.StartFire( class'NanoWeap_Melee'.const.FIREMODE_GrabAndBeat );
			//}


			if( CanDoInterrogate( CounterTarget ) == TRUE )
			{
				`log( "Interrogate Interrogate Interrogate" @ `showvar(CounterTarget) );

				MyNP.DoSpecialMove( 'NSM_DBNO_InterrogateAttempt', TRUE, CounterTarget );

				//MyNP.StartFire( class'NanoWeap_Melee'.const.FIREMODE_GrabAndInterrogate );
			}

		
			// Car dash/stab check - first check our current target
			bStabMantle = CheckForStabMantle(TargetedActor,, FALSE);
			if( !bStabMantle )
			{
				// Then check our recent target buffer incase the target *just* moved out of range
				for( Idx = 0; Idx < RecentTargetedActorList.Length; Idx++ )
				{
					if( CheckForStabMantle(RecentTargetedActorList[Idx].Target, 1.1f, FALSE) )
					{
						SetTargetedActor( RecentTargetedActorList[Idx].Target );
						bStabMantle = TRUE;
						break;
					}
				}
			}

			if( bStabMantle )
			{
				`loginfo('Nano_Melee', "car jump");
				MyNP.AttemptStabMantle();
			}
			else 
			{
				bHolsteredWeapon = FALSE;
				// do not holster the weapon on B button press SetTimer( 0.5f, FALSE, nameof(HolsterWeapon), self );

				// if not already absorbing something, try to start
				if(CurrentlyAbsorbingObjects.length == 0)
				{
					// start absorb interaction
					InteractObjects = MyNP.GetBestInteractObject(ENIT_AbsorbBegin, FALSE);
					foreach InteractObjects(InteractInt)
					{
						if(InteractInt != none && InteractInt.CanInteract(MyNP, ENIT_AbsorbBegin))
						{
							// holster weapon if we are going to interact with something
							if(CurrentlyAbsorbingObjects.length == 0)
							{
								MyNP.HolsterCurrentWeapon();
							}

							InteractInt.DoInteract(MyNP, ENIT_AbsorbBegin);
						}
					}
				}		
				
				// Context sensitive - interact if something here (non-absorb)..
				if( MyNP.IsAttachedToPerch() && (NanoPawn_MetaCorp_BullRamBase(MyNP.Base) != none) )
				{
					Bull = NanoPawn_MetaCorp_BullRamBase(MyNP.Base);

					if( TargetedActor == none )
					{
						GetActorEyesViewPoint(CamLoc,CamRot);
						HitActor = SelectTarget_Worker( BullRamRateTarget, 4096.f, 0.3f, CamLoc, CamRot );

						if( HitActor == none )
						{
							ChargeLocation = Bull.Location + (Normal(Vector(Bull.Rotation)) * 2048.0f);
						}
						else
						{
							`log( "HitActorHitActor" @ HitActor );
							ChargeLocation = HitActor.Location;
						}
					}
					else
					{
						`log( "TargetedActor" @ TargetedActor );
						ChargeLocation = TargetedActor.Location;
					}


					class'NanoAICmd_BullRam_Charge_Player'.static.Charge( NanoAI_BullRam(Bull.Controller), ChargeLocation, None, 5.0f, TRUE );
				}
				else if( NVA != None )
				{
					// Attempt to override the vehicle, if we're on one
					NVA.AttemptToOverride(FALSE);
					ClearTimer( nameof(HolsterWeapon), self );
				}
				else if( IsNearbyInteractable() )
				{
					TriggerInteract();
					ClearTimer( nameof(HolsterWeapon), self );  // we are interacting so don't holster later
				}
				else if( ( NanoWeap_MP7(MyNP.MyNanoWeapon) == None ) && ( GetPRI().MeleePlan != None ) )
				{
					`log( "shizzzlee" );
					// !!!! This is our "Do sword action" function call !!!!
					// so try to switch to this this MeleePlan.  And if we already are wielding it then go SwordAttack()
					MyNP.StartForge(GetPRI().MeleePlan, self.DoGrabAttack);
				}

			}
		}
	}
	else
	{
		ClearTimer( nameof(HolsterWeapon), self );

		if (MyNP.InteractionPawn == None && MyNP.CurrentLadder == None)
		{
			TriggerUnInteract();
	
			// when releasing, end absorb interaction
			if(CurrentlyAbsorbingObjects.Length > 0)
			{
				// can't do a foreach on the list we are going to remove things from so we make a copy here and iterate over that
				InteractObjects = CurrentlyAbsorbingObjects;
				foreach InteractObjects(InteractInt)
				{
					//`log( "  STOP INTERACTING!!" @ `showvar(CurrentlyAbsorbingObjects.Length) @ `showvar(InteractObjects.Length) @ `showvar(InteractInt) );
					InteractInt.DoInteract(MyNP, ENIT_AbsorbEnd);
				}
			}
			else if( NVA != None )
			{
				// Stop overriding the vehicle if we were
				NVA.StopOverride();
			}
			else if( !bHolsteredWeapon && MyNP.CurrentLadder == None )
			{
				if( MyNP.MyNanoWeapon != None )
				{
					MyNP.MyNanoWeapon.ForceReload();
				}
			}
		}
	}
}


/** If we have held the X button for a while then we want to hoslter our weapon **/
function HolsterWeapon()
{
	bHolsteredWeapon = TRUE;
	MyNP.HolsterCurrentWeapon();
}


function HandleButtonInput_X( bool bPressed, optional bool bDblClickMove )
{
	local NanoPawn CounterTarget;

	if( bPressed )
	{
		// Immediately throw tackle victim 
		if( MyNP.CurrentTurbine != None || MyNP.MantleState != MANTLE_None )
		{
			// nothing while mantling/turbining
		}
		else if( MyNP.IsAttachedToPerch() )
		{
			TryToHopToNewCar();
		}
		else if( !MyNP.CanDoMeleeAttack() )
		{
			// skip for now as we are in the wall and don't want to swing the sword
		}
		else if( CanDoHarvest( CounterTarget ) == TRUE )
		{
			`log( "Harvest Harvest Harvest" @ `showvar(CounterTarget) );

			MyNP.DoSpecialMove( 'NSM_DBNO_HarvestAttempt',, CounterTarget );
		}
		else
		{
			if( GetPRI().MeleePlan != None )
			{
				// !!!! This is our "Do sword action" function call !!!!
				// so try to switch to this this MeleePlan.  And if we already are wielding it then go SwordAttack()
				MyNP.StartForge(GetPRI().MeleePlan, self.SwordAttack);
			}
		}
	}
}


/** Util to see if there is something nearby we can interact with */
function bool IsNearbyInteractable()
{
	local array<NanoInterface_Interact> InteractObjects;
	local array<Trigger> Triggers;
	local NanoInterface_Interact InteractInt;

	// Get set of triggers
	GetTriggerUseList(256.f,100.f,0.1f,TRUE,Triggers);
	// Get interactable object
	InteractObjects = MyNP.GetBestInteractObject(ENIT_Default, TRUE);
	if( InteractObjects.Length > 0 )
	{
		InteractInt = InteractObjects[0];
	}


	// If we have either - return TRUE
	return ((Triggers.Length > 0) || (InteractInt != None));
}

/** Start performing an interaction on a nearby object */
function TriggerInteract()
{
	local array<NanoInterface_Interact> InteractObjects;
	local array<Trigger> Triggers;
	local Trigger Trigger;
	local NanoInterface_Interact InteractInt;
	
	// grab a list of triggers we can interact with
	GetTriggerUseList(256.f,100.f,0.1f,TRUE,Triggers);
	foreach Triggers(Trigger)
	{
		if (Trigger.TriggerEventClass(class'SeqEvent_Used',MyNP,0))
		{
			CurrentlyUsingTriggers.AddItem(Trigger);
			IgnoreMoveInput(TRUE);
		}
	}
	
	// NanoInterface_Interact objects
	InteractObjects = MyNP.GetBestInteractObject(ENIT_Default, TRUE);
	if( InteractObjects.Length > 0 )
	{
		InteractInt = InteractObjects[0];
	}
	
    if(InteractInt != none && InteractInt.CanInteract(MyNP, ENIT_Default))
	{
		InteractInt.DoInteract(MyNP, ENIT_Default);
	}
}

function TriggerUnInteract()
{
	local Trigger Trigger;

	if( CurrentlyUsingTriggers.Length > 0 )
	{
		// de-activate anything still on the list
		foreach CurrentlyUsingTriggers(Trigger)
		{
			Trigger.TriggerEventClass(class'SeqEvent_Used',MyNP,1);
			IgnoreMoveInput(FALSE);
		}
		CurrentlyUsingTriggers.Length = 0;
	}
}

function RicochetMoonAttack()
{
	if (bCanReleaseMoon)
	{
		// only fire once no longer holding the button
		StartFire(0);
	}
	else
	{
		SetTimer(0.1f,FALSE,nameof(RicochetMoonAttack),self);
	}
}

function FireOrbitals()
{
	// only fire once no longer holding the button	
	StartFire(0);
}


function HandleButtonInput_Y( bool bPressed, optional bool bDblClickMove )
{
	local NanoVehicleAgent NVA;
	local NanoPawn CounterTarget;


	NVA = NanoVehicleAgent(MyNP.Base);

	if( bPressed )
	{
		// if we are doing any of these things then we are going to do special handling to stop any other actions in the else if chain from occurring
		if( MyNP.CurrentTurbine != None || MyNP.MantleState != MANTLE_None || (MyNP.InteractionPawn != None && MyNP.InteractionType != PAWNINTER_Pin) )
		{
			// allow hammer drop attempts
			MyNP.AttemptHammer();

			// nothing else except hammer dropping while mantling/turbining
			// NOTE: this seems wrong.  you should be able to attack while mantling
		}
		else if( NVA != None )
		{
			// Attempt to override the car controls
			NVA.AttemptToOverride(TRUE);
		}
		else if( MyNP.AttemptHammer() == TRUE )
		{
		}
		else if( MyNP.bIsDashing == TRUE )
		{
			MyNP.ActivateSelfNanoPower( class'NanoSkill_Dense') ;
		}
		else if( CanDoPatDown( CounterTarget ) == TRUE )
		{
			`log( "PatDown PatDown PatDown" @ `showvar(CounterTarget) );

			MyNP.DoSpecialMove( 'NSM_DBNO_PatDownAttempt',, CounterTarget );
		}
		else if( GetPRI().MeleePlan != None && MyNP.CanDoMeleeAttack() )
		{
			`log( "==========================================================================================================" );
			// !!!! This is our "Do sword action" function call !!!!
			// so try to swtich to this this MeleePlan.  And if we already are wielding it then go SwordAttack()
			MyNP.StartForge(GetPRI().MeleePlan, self.SwordAttack);
		}
		else if( MyNP.bEmptyHanded )
		{
			// If nothing else, try to look at a point of interest
			TryPOILookAt();
		}
	}
	else
	{
		if( NVA != None )
		{
			// Stop overriding the car, if we were
			NVA.StopOverride();
		}

		MyNP.DeactivateSelfNanoPower( class'NanoSkill_Dense') ;

		// No longer want to look at a POI, if any
		TryPOILookAway();
	}
}

/** forge */
function HandleButtonInput_LeftBumper( bool bPressed, optional bool bDblClickMove )  
{
	if (bPressed)
	{
		// need to test to see if we have enough nanopower here
		if( GetPRI().UtilityPlan.static.CanDoForge( MyNP ) == TRUE )
		{
			GetPRI().UtilityPlan.static.PayNanoPowerCost( MyNP );
		}
		else
		{
			return;
		}


		if ( !MyNP.IsDoingSpecialMove('NSM_ForgeCycle') && (GetPRI().UtilityPlan != None) )
		{
			MyNP.StartForge(GetPRI().UtilityPlan);
		}
	}
	else
	{
		MyNP.EndForge(GetPRI().UtilityPlan);
	}
}

function HandleButtonInput_RightBumper( bool bPressed, optional bool bDblClickMove )
{
	if( bPressed )
	{
		MyNP.bWantsToDash = TRUE;
	}
	else
	{
		MyNP.bWantsToDash = FALSE;

		if( `TimeSince(InputButtonDataList[GB_RightBumper].LastRawActiveTime) < 0.25f )
		{
			AttemptDodge();
		}
	}
}

function bool HandleBumperInput( bool bPressed, class<NanoSkill_NanoPowerBase> DesiredNanoPower )
{
	if( bPressed && !bCinematicMode )
	{
		return MyNP.ActivateSelfNanoPower(DesiredNanoPower);
	}
	return FALSE;
}

function DeactivateSelfNanoPower()
{
	if (MyNP.CurrNanoState == ENS_Dust)
	{
		if (!IsButtonActive(GB_RightBumper))
		{
			MyNP.DeactivateSelfNanoPower( class'NanoSkill_Ghost' );
		}
	}
	else
	{
		if (!IsButtonActive(GB_LeftBumper))
		{
			MyNP.DeactivateSelfNanoPower( class'NanoSkill_Dense' );
		}
	}
}

function HandleButtonInput_LeftTrigger( bool bPressed, optional bool bDblClickMove )
{
	local vector CamLoc;
	local rotator CamRot;

	//local vector HitL, HitN;
	//local rotator NewRot;
	//local Actor HitA;
	
	if( bPressed )
	{
		if( MyNP.InteractionPawn != None )
		{
			// Can't use gun if grabbed
		}
		else if (GetPRI().GunPlan != None)
		{
			// bring out the gun
			MyNP.StartForge(GetPRI().GunPlan);

			MyNP.SpawnWeaponCrowdPanicRepulsor( class'NanoCrowd_PanicRepulsor_GunOut' );

			// and transition to first
//			MyNP.SetFirstPersonCamera(TRUE);
			MyNP.bIsTargeting = TRUE;
			// try to account for what the camera was pointing at
			MyNP.GetActorEyesViewPoint(CamLoc,CamRot);
			MyNP.SetRotation(CamRot);


// 			HitA = MyNP.Trace(HitL,HitN,CamLoc+vector(CamRot)*2500.f,CamLoc,FALSE,vect(1,1,1));
// 			if (HitA != None)
// 			{
// 				NewRot = rotator(HitL - Pawn.Location);
// 				SetRotation(NewRot);
// 				MyNP.SetRotation(NewRot);
// 			}
		}
	}
	else
	{
		MyNP.SetThirdPersonCamera(TRUE);
		MyNP.bIsTargeting = FALSE;

		// clear the timers as otherwise we have a race condition with all of the delayed summoning and unholstering firing off even after
		// we have released the trigger
		MyNP.ClearTimer( nameof(MyNP.WeaponUnholstered) );
		MyNP.ClearTimer( nameof(MyNP.UnholsterPendingWeapon) );
		MyNP.bSummoningInProgress = FALSE;

		MyNP.HolsterCurrentWeapon();
	}
}

function GunAttack()
{
	if( ClassIsChildOf( MyNP.Weapon.Class, class'NanoWeap_MP7' ) && IsButtonActive(GB_RightTrigger) ) 
	{
		if( bHoldSprint )
		{
			MyNP.ForceDashStop();
		}
		StartFire( 0 );
	}
}

function ForceGunReload() 
{
	if( ClassIsChildOf( MyNP.Weapon.Class, class'NanoWeap_MP7' ) )
	{
		MyNP.MyNanoWeapon.ForceReload();
	}
}

function HandleButtonInput_RightTrigger( bool bPressed, optional bool bDblClickMove )
{
	// just bail if we are not allowed to attack
	if( MyNP.TeslaShock_NoAttack_ActiveUntil > WorldInfo.TimeSeconds )
	{
		return;
	}

	if( MyNP != None )
	{
		// only shoot if we have a gun out
		if( NanoWeap_MP7(MyNP.Weapon) != None )
		{
			if( bPressed )
			{
				MyNP.bWantsToShoot = TRUE;
				MyNP.SpawnWeaponCrowdPanicRepulsor( class'NanoCrowd_PanicRepulsor_GunFired' );
			}
			else
			{
				MyNP.bWantsToShoot = FALSE;
			}
		}
	}
	else if( MyTurret != None )
	{
		bFire = bPressed ? 1 : 0;
	}
}

function HandleButtonInput_LeftStickButton( bool bPressed, optional bool bDblClickMove )
{
	local Vector StickDir;
	local Rotator CamRot;
	local Vector CamLoc;

	GetActorEyesViewPoint(CamLoc,CamRot);
	RemapControlsByRotation(Normalize(MyNP.Rotation - CamRot),StickDir.Y,StickDir.X);

//	DoPingOnePingOnly( bPressed );	
}

/**
 * This will send a nano ping out into the world. 
 **/
function DoPingOnePingOnly( bool bPressed )
{
	local NanoSkill_Ping PingSkill;

	PingSkill = MyNP.GetSkill(class'NanoSkill_Ping');

	if( ( PingSkill != none )
		&& ( ( bPressed == FALSE ) || ( MyNP.HasEnoughNanoPower( PingSkill.GetPingNanoCost(), TRUE ) == TRUE ) )
		&& ( MyNP.IsTimerActive( nameof(PingSkill.FireOffInwardPing), PingSkill ) == FALSE )
		&& ( MyNP.IsTimerActive( nameof(PingSkill.ResetTimeOutwardPingFired), PingSkill ) == FALSE )
		)
	{
		PingSkill.bOutwardWave = bPressed;
		PingSkill.ActivateSkill();
	}
}



function HandleButtonInput_RightStickButton( bool bPressed, optional bool bDblClickMove )
{
	ResetPlayerView(0.5f);
}

/** DEBUG - Switch between moon and orbitals */
function HandleButtonInput_DPad_Up( bool bPressed, optional bool bDblClickMove )
{
	if (bPressed)
	{
		//Outer.PushPlayerInput(ForgeUIInputHandler);
		//Outer.MyNanoHUD.ShowWeaponSelectUI(true);

		QuickSwitchWeaponPlan(DIR_Up);
	}
}

function HandleButtonInput_DPad_Down( bool bPressed, optional bool bDblClickMove )
{
	if (bPressed)
	{
		//Outer.PushPlayerInput(ForgeUIInputHandler);
		//Outer.MyNanoHUD.ShowForgeUI(true);

		QuickSwitchWeaponPlan(DIR_Down);
	}
}

function HandleButtonInput_DPad_Left( bool bPressed, optional bool bDblClickMove )
{
	if (bPressed)
	{
		QuickSwitchWeaponPlan(DIR_Left);
	}
}

function HandleButtonInput_DPad_Right( bool bPressed, optional bool bDblClickMove )
{
	if(bPressed)
	{
		QuickSwitchWeaponPlan(DIR_Right);
	}
}

function HandleButtonInput_Start( bool bPressed, optional bool bDblClickMove )
{
	if( bPressed )
	{
		// If back is pressed, then we want to deal with the debug camera
		if( IsButtonActive(GB_Back, TRUE) )
		{
			if( DebugCam == None )
			{
				SpawnDebugCamera();
			}
			else
			{
				EndDebugCamera();
			}

			// Clear this timer to prevent the pawn from teleporting after back is released
			ClearTimer(nameof(SetTestingTeleportBackToAnchorPoint),self);
		}
		else if( DebugCam != None )
		{
			// Allow toggling of pause button if in debug camera mode
			SetPause(!IsPaused());
		}
		else if(MyNanoHUD.GetCurrentUIPage() == None)
		{
			MyNanoHUD.ActivateMissionsMenu();
		}
		// Closing menu handled inside HUDFilterButtonInput
	}
}


/** 
 *
 **/
function HandleButtonInput_Back( bool bPressed, optional bool bDblClickMove )
{
	local NanoPawn NP;
	NP = NanoPawn(Pawn);

	if( NP != None )
	{
		if( bPressed )
		{
			if( NP.IsTimerActive( nameof(NP.ResetToAnchorIsValid) ) == TRUE ) 
			{
				NP.ResetToAnchor();
			}
			else
			{
				SetTimer(0.5f,FALSE,nameof(SetTestingTeleportBackToAnchorPoint),self);
			}
		}
		else
		{
			if (DebugCam == None && IsTimerActive(nameof(SetTestingTeleportBackToAnchorPoint),self))
			{
				if (!IsTimerActive(nameof(HaveManualAnchorPoint),self))
				{
					NP.ResetToAnchor();
				}
				else
				{
					TeleportToTestingTeleportBackToAnchorPoint();
				}
			}
			ClearTimer(nameof(SetTestingTeleportBackToAnchorPoint),self);
		}
	}
}

function SetTestingTeleportBackToAnchorPoint()
{
	local NanoPawn NP;
	NP = NanoPawn(Pawn);
	if (NP != None )
	{
		ClientMessage("Anchor point set!");
		SetTimer(500.f,FALSE,nameof(HaveManualAnchorPoint),self);
		NP.TestingTeleportBackToAnchorPoint = NP.Location;
		NP.TestingTeleportBackToAnchorPointRotation = Rotation;
	}
}

function HaveManualAnchorPoint();

function TeleportToTestingTeleportBackToAnchorPoint()
{
	local NanoPawn NP;
	NP = NanoPawn(Pawn);
	if (NP != None)
	{
		ClientMessage("Returning to Anchor point!");
		NP.SetLocation( NP.TestingTeleportBackToAnchorPoint );
		SetRotation( NP.TestingTeleportBackToAnchorPointRotation );
		NP.SetPhysics(PHYS_Falling);
	}
}


/** This will check to see if we should spawn a Nanite Tornado! **/
function PossiblyDoNaniteTornado()
{
	local Actor NaniteTornadoVictim;
	//local ParticleSystemComponent Tornado;
	local NanoPawn NP;

	if( MyNP.NaniteTornadoCount >= 4 )
	{
		foreach MyNP.NaniteTornadoTargets( NaniteTornadoVictim )
		{
			NP = NanoPawn(NaniteTornadoVictim);
			if( NP != none )
			{
				PlaySound( class'NaniteTornado'.default.NaniteTornadoSpawnSound );
			
				if( NP.NaniteTornadoFunnel != none )
				{
				    NP.NaniteTornadoFunnel.InvokeFullTornado();
				}
			}
		}

		// reset ant tornado vars as we just did one
		MyNP.ResetNaniteTornadoCount( TRUE );
	}
}


/**
 * Check if there is a foe near us in the dir of the stick direction that is attacking
 **/
function bool CanDoCounter( out NanoPawn out_CounterTarget )
{
	local NanoWeap_Melee Melee;
	local bool bPlayerInput;
	local Rotator Rot;
	//local EComboJoyDirection Dir;
	local Actor PossibleAttacker;
	local NanoPawn PossibleAttackerPawn;
	local NanoAIBase PossibleAttackerAI;
	local Rotator AttackDir;

	Melee = NanoWeap_Melee(MyNP.MyNanoWeapon);

	if( Melee != None )
	{
		PossibleAttacker = Melee.FindComboTarget();
		bPlayerInput = (Abs(RawJoyUp) > 0.2f || Abs(RawJoyRight) > 0.2f);
		AttackDir = GetDirFromLeftStick( Rot, !bPlayerInput );

		//Dir = 
		Melee.DetermineComboDirection( Outer, AttackDir, PossibleAttacker ); 

		//`log( `showvar(PossibleAttacker) @ `showvar(AttackDir) @  `showvar(Dir) );

	}
	

	PossibleAttackerPawn = NanoPawn(PossibleAttacker);

	if( PossibleAttackerPawn != None )
	{
		PossibleAttackerAI = NanoAIBase(PossibleAttackerPawn.Controller);

		if( ( PossibleAttackerAI != None )
			// ||  ( PossibleAttackerPawn.Weapon.IsFiring() == TRUE ) // ?? shooting a gun?
			&& ( PossibleAttackerAI.FindCommandOfClass( class'NanoAICmd_Trooper_Attack_Base' ) != None )
			)
		{
			out_CounterTarget = PossibleAttackerPawn;
			return TRUE;
		}
	}


	return FALSE;
}


/**
 * Check if there is a foe near us in the dir of the stick direction that is applicable for grabbing
 **/
function bool CanDoGrab( out NanoPawn out_CounterTarget )
{
	local NanoWeap_Melee Melee;
	local bool bPlayerInput;
	local Rotator Rot;
	//local EComboJoyDirection Dir;
	local Actor PossibleAttacker;
	local NanoPawn PossibleAttackerPawn;
	local NanoAIBase PossibleAttackerAI;
	local Rotator AttackDir;

	// sucks that we need to have a weapon to do anything!
	Melee = NanoWeap_Melee(MyNP.MyNanoWeapon);

	if( Melee != None )
	{
		PossibleAttacker = Melee.FindComboTarget();
		bPlayerInput = (Abs(RawJoyUp) > 0.2f || Abs(RawJoyRight) > 0.2f);
		AttackDir = GetDirFromLeftStick( Rot, !bPlayerInput );

		//Dir = 
		Melee.DetermineComboDirection( Outer, AttackDir, PossibleAttacker ); 

		`log( `showvar(PossibleAttacker) @ `showvar(AttackDir)  );

	}
	

	PossibleAttackerPawn = NanoPawn(PossibleAttacker);

	if( PossibleAttackerPawn != None )
	{
		PossibleAttackerAI = NanoAIBase(PossibleAttackerPawn.Controller);

		if( ( PossibleAttackerAI != None )
			&& ( PossibleAttackerPawn.IsInState( 'DBNO' ) == FALSE )
			// ||  ( PossibleAttackerPawn.Weapon.IsFiring() == TRUE ) // ?? shooting a gun?
			//&& ( PossibleAttackerAI.FindCommandOfClass( class'NanoAICmd_Trooper_Attack_Base' ) != None )
			)
		{
			out_CounterTarget = PossibleAttackerPawn;
			return TRUE;
		}
	}

	`log( GetFuncName() @  "CanDoGrab" @ "returning false" );
	return FALSE;
}



/**
 * Check if there is a foe near us in the dir of the stick direction that is applicable for pat down
 **/
function bool CanDoPatDown( out NanoPawn out_CounterTarget )
{
	local NanoPawn PossibleAttackerPawn;
	local NanoAIBase PossibleAttackerAI;

	//we need to find all the pawns around us and find dbno ones
	foreach WorldInfo.AllPawns( class'NanoPawn', PossibleAttackerPawn, Pawn.Location, DBNO_InteractionDistance )
	{
		if( ( PossibleAttackerPawn.IsInState( 'DBNO' ) == TRUE )
			&& ( `TimeSince(PossibleAttackerPawn.TimeOfDBNO) > TimeBeforeDBNOInteractable )
			)
		{
			break;
		}
	}

	`log( GetFuncName() @ `showvar(PossibleAttackerPawn) );

	if( PossibleAttackerPawn != None )
	{
		PossibleAttackerAI = NanoAIBase(PossibleAttackerPawn.Controller);

		if( ( PossibleAttackerAI != None )
			&& ( PossibleAttackerPawn.IsInState( 'DBNO' ) == TRUE )
			// ||  ( PossibleAttackerPawn.Weapon.IsFiring() == TRUE ) // ?? shooting a gun?
			//&& ( PossibleAttackerAI.FindCommandOfClass( class'NanoAICmd_Trooper_Attack_Base' ) != None )
			)
		{
			out_CounterTarget = PossibleAttackerPawn;
			return TRUE;
		}
	}

	`log( GetFuncName() @  "CanDoPatDown" @ "returning false" );
	return FALSE;
}



/**
 * Check if there is a foe near us in the dir of the stick direction that is applicable for interrogate
 **/
function bool CanDoInterrogate( out NanoPawn out_CounterTarget )
{
	local NanoPawn PossibleAttackerPawn;
	local NanoAIBase PossibleAttackerAI;

	//we need to find all the pawns around us and find dbno ones
	foreach WorldInfo.AllPawns( class'NanoPawn', PossibleAttackerPawn, Pawn.Location, DBNO_InteractionDistance )
	{
		if( ( PossibleAttackerPawn.IsInState( 'DBNO' ) == TRUE )
			&& ( `TimeSince(PossibleAttackerPawn.TimeOfDBNO) > TimeBeforeDBNOInteractable )
			)
		{
			break;
		}
	}


	`log( GetFuncName() @ `showvar(PossibleAttackerPawn) );

	if( PossibleAttackerPawn != None )
	{
		PossibleAttackerAI = NanoAIBase(PossibleAttackerPawn.Controller);

		if( ( PossibleAttackerAI != None )
			&& ( PossibleAttackerPawn.IsInState( 'DBNO' ) == TRUE )
			// ||  ( PossibleAttackerPawn.Weapon.IsFiring() == TRUE ) // ?? shooting a gun?
			//&& ( PossibleAttackerAI.FindCommandOfClass( class'NanoAICmd_Trooper_Attack_Base' ) != None )
			)
		{
			out_CounterTarget = PossibleAttackerPawn;
			return TRUE;
		}
	}

	`log( GetFuncName() @  "CanDoInterrogate" @ "returning false" );
	return FALSE;
}



/**
 * Check if there is a foe near us in the dir of the stick direction that is applicable for Harvest
 **/
function bool CanDoHarvest( out NanoPawn out_CounterTarget )
{
	local NanoPawn PossibleAttackerPawn;
	local NanoAIBase PossibleAttackerAI;

	//we need to find all the pawns around us and find dbno ones
	foreach WorldInfo.AllPawns( class'NanoPawn', PossibleAttackerPawn, Pawn.Location, DBNO_InteractionDistance )
	{
		if( ( PossibleAttackerPawn.IsInState( 'DBNO' ) == TRUE )
			&& ( `TimeSince(PossibleAttackerPawn.TimeOfDBNO) > TimeBeforeDBNOInteractable )
			)
		{
			break;
		}
	}


	`log( GetFuncName() @ `showvar(PossibleAttackerPawn) );

	if( PossibleAttackerPawn != None )
	{
		PossibleAttackerAI = NanoAIBase(PossibleAttackerPawn.Controller);

		if( ( PossibleAttackerAI != None )
			&& ( PossibleAttackerPawn.IsInState( 'DBNO' ) == TRUE )
			// ||  ( PossibleAttackerPawn.Weapon.IsFiring() == TRUE ) // ?? shooting a gun?
			//&& ( PossibleAttackerAI.FindCommandOfClass( class'NanoAICmd_Trooper_Attack_Base' ) != None )
			)
		{
			out_CounterTarget = PossibleAttackerPawn;
			return TRUE;
		}
	}

	`log( GetFuncName() @  "CanDoHarvest" @ "returning false" );
	return FALSE;
}



/**
 * Check if there is a foe near us in the dir of the stick direction that is applicable for DBNODrag
 **/
function bool CanDoDBNODrag( out NanoPawn out_CounterTarget )
{
	local NanoPawn PossibleAttackerPawn;
	local NanoAIBase PossibleAttackerAI;


	//we need to find all the pawns around us and find dbno ones
	foreach WorldInfo.AllPawns( class'NanoPawn', PossibleAttackerPawn, Pawn.Location, DBNO_InteractionDistance )
	{
		if( ( PossibleAttackerPawn.IsInState( 'DBNO' ) == TRUE )
			&& ( `TimeSince(PossibleAttackerPawn.TimeOfDBNO) > TimeBeforeDBNOInteractable )
			)
		{
			break;
		}
	}


	`log( GetFuncName() @ `showvar(PossibleAttackerPawn) );

	if( PossibleAttackerPawn != None )
	{
		PossibleAttackerAI = NanoAIBase(PossibleAttackerPawn.Controller);

		if( ( PossibleAttackerAI != None )
			&& ( PossibleAttackerPawn.IsInState( 'DBNO' ) == TRUE )
			// ||  ( PossibleAttackerPawn.Weapon.IsFiring() == TRUE ) // ?? shooting a gun?
			//&& ( PossibleAttackerAI.FindCommandOfClass( class'NanoAICmd_Trooper_Attack_Base' ) != None )
			)
		{
			out_CounterTarget = PossibleAttackerPawn;
			return TRUE;
		}
	}

	`log( GetFuncName() @  "CanDoDBNODrag" @ "returning false" );
	return FALSE;
}






defaultproperties
{
	bHoldSprint=TRUE
}