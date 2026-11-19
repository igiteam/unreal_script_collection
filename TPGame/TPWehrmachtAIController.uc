class TPWehrmachtAIController extends TPSoldierAIController
	native
	dependson(BluffInteraction)
	dependson(GrappleInteraction);

//***********************************************************************
// Macros
//***********************************************************************


//How much time a challenge lasts before enemy is considered hostile


//How much time an enemy is ignored after a successful challenge





//`define HOSTILE_TIMER 3

















 







































#linenumber 26

//`define ailog(t) log(self, t)


//***********************************************************************
// enum Declarations
//***********************************************************************
	

enum eWehrmachtStartStates
{
	//These must be the exact names of the states
	Guard,
	Grappleable,
	TPPatrol,
	Idle,
};



//Note these correspond to the order of outputs on the Bluff Sequence Action.
//enum eBluffResponse
//{
//	BluffResponse_Correct,
//	BluffResponse_Neutral,
//	BluffResponse_Incorrect,
//	BluffResponse_Surprise,
//	BluffResponse_Aborted
//};


//***********************************************************************
// struct Declarations
//***********************************************************************



//***********************************************************************
// Variable Declarations
//***********************************************************************



var Name PlayerAnimSeq;
var Name GuardAnimSeq;
var int SurpriseCount;


var GrappleInteraction GrapInt;
var GrapplePerformance CurrentGrapplePerformance;
var bool bInfiniteGrapple;

var BluffInteraction BluffInt;
var BluffPerformance CurrentBluffPerformance;
var int lastBluffResult;
//var TPPlayerController ChallengePlayer; //get rid of this 

var float m_challengeRange;
var bool m_bIssuedVocalChallenge;

//***********************************************************************
// CPP Text
//***********************************************************************


//***********************************************************************
// Function Declarations
//***********************************************************************

	
	
//***********************************************************************
// Functions/States
//***********************************************************************

event Tick(float DeltaTime)
{
	if (anode_WeaponBlend != none)
	{
		if (Pawn != None && Pawn.Weapon == none)
			anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
		else
			anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
	}

	//override Tick to prevent skel controller updates
	UpdateHeadTracking();
	UpdateAimInTheOpen(FALSE);;

	// For Vaulting and Mantling
	if (bHittingWall)
		TestObstacle();
	bHittingWall = false;
}



//************************ - BEGIN SECTION - ****************************
// EVALUATION FUNCTIONS
//***********************************************************************


function bool ShouldIChallengeEnemy(optional int enemyIdx=-1)
{
	local TPPlayerController pc;
	local eUniformResponse response;
	local Pawn theEnemy;

	theEnemy = None;
	if( enemyIdx != -1 )
	{
		theEnemy = m_playerList[enemyIdx].Player.Pawn;
	}
	else if( Enemy != None )
	{
		theEnemy = Enemy;
	}
	if( theEnemy==None )
		return false;

	
	//Check their last successful bluff time.
	if( IsInPlayerList(Enemy.Controller, enemyIdx) )
	{
		if( WorldInfo.TimeSeconds - m_playerList[enemyIdx].LastSuccessfulBluffTime < 8 )
		{
			;
			return false;
		}
	}
	

	if( theEnemy.IsA('PlayerPawn') )
	{
		pc = TPPlayerController( PlayerPawn(theEnemy).Controller );
		if( pc != None )
		{
//			//Check if they are bluffing
//			if( pc.IsBluffing() )
//			{
//				return false;
//			}
		
			//Check if they are in a restricted area, etc.
			if( pc.m_RestrictedAreaVolume != None )
			{
				response = pc.m_RestrictedAreaVolume.GetResponseForEnemy( theEnemy.Controller );
				if( response == UniformResponse_Challenge )
				{
					return true;
				}
				
			}
		}
	}

	return false;
}



function MarkFriendlyChallenger(Controller challenger)
{
	local int idx;
	
	if( IsInPlayerList(challenger, idx) )
	{
		//record the time that this challenger succeeded a bluff - this will be used to prevent challenges for a while
		m_playerList[ idx ].LastSuccessfulBluffTime = WorldInfo.TimeSeconds;
	}
		
}


function NotifySquadAIEvent(TPAIController notifier, Controller eventTarget, Name squadEvent)
{
	if( squadEvent=='ChallengerIsFriendly')
	{
		MarkFriendlyChallenger(eventTarget);
	}
}


//***********************************************************************
// EVALUATION FUNCTIONS
//************************ - END SECTION - ******************************


//************************ - BEGIN SECTION - ****************************
// GRAPPLE INTERACTION
//***********************************************************************

function bool IsGrappleable()
{
    return !WehrmachtPawn(Pawn).bCannotGrapple && !IsInState('JumpDown') &&
        !IsInState('VaultMedium') && !IsInState('VaultHigh') && !IsInState('Vaulting') &&
        !IsInState('MantlingLow') && !IsInState('MantlingMedium') &&
        !IsInState('VaultMantling') && !IsInState('VaultLanding') && !Pawn.bIsCrouched &&
		!GrappleKilled();
}

event EnterGrapple(GrappleInteraction GI)
{
	GrapInt = GI;
	PushState('Grapple');
}
event ExitGrapple()
{
	PopState();
}

function OnGrappleSuccess(Controller thePlayer)
{
}


function OnGrappleFailure(Controller thePlayer)
{
}

event StartGrapplePerformance(GrapplePerformance perf)
{
}


//temp stub state to represent a grappleable guy
state Grappleable /*extends TPPatrol*/
{
	simulated event BeginState(name PreviousStateName)
	{
		local SkelControlLookAt htrack;

		//Pawn.Weapon.PutDownWeapon();

       	htrack = SkelControlLookAt(Pawn.Mesh.FindSkelControl('HeadTrack'));
       	if( htrack != None )
       	{
           	htrack.ControlStrength = 0;

       		htrack.SetSkelControlActive(false);

       	}

        Pawn.AimOffset.X = 0;
        Pawn.AimOffset.Y = 0;

	}


	function Tick(float DeltaTime)
	{
		//override Tick to prevent skel controller updates
		UpdateHeadTracking();
		UpdateAimInTheOpen(FALSE);;
	}

}


state Grapple
{
// 	function EvaluateSituation()
// 	{
// 		//override so we don't decide to break out of grapple
// 		//`log(" ChadAI - TPWehrmachtAIController::Grapple::function EvaluateSituation() override so we don't decide to break out of grapple -----------------------------------------------------------------------------------");
// 	}
// 	

	simulated event BeginState(name PreviousStateName)
	{
		local SkelControlLookAt htrack;

		//Pawn.Weapon.PutDownWeapon();

       	htrack = SkelControlLookAt(Pawn.Mesh.FindSkelControl('HeadTrack'));
       	if( htrack != None )
       	{
           	htrack.ControlStrength = 0;

       		htrack.SetSkelControlActive(false);
       	}

        Pawn.AimOffset.X = 0;
        Pawn.AimOffset.Y = 0;
        
        AbortMove(false);
		ClearLatentAction(class'SeqAct_AIMoveToActor',true);
        
        //ResetMovement();
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);

		Pawn.Velocity = vect(0,0,0);
		Pawn.Acceleration = vect(0,0,0);
        
        Pawn.DesiredRotation = Pawn.Rotation;
        StopFiring();

	}

    function OnGrappleFailure (Controller thePlayer)
    {
        //Go to hostile state here!
	    NotifyEnemy(self, thePlayer);
	    EvaluateSituation();
    }

	event PushedState()
	{
		BeginState('None');
	}

	function EndState(Name NextStateName)
	{
		local SkelControlLookAt htrack;

        if (Pawn == None)
            return;

        TPPawn(Pawn).FinishSceneAnimation();

		Pawn.InvManager.SwitchToBestWeapon();

       	htrack = SkelControlLookAt(Pawn.Mesh.FindSkelControl('HeadTrack'));
       	if( htrack != None )
       	{
       		htrack.SetSkelControlActive(true);
       	}

	}

	event PoppedState()
	{
		EndState('None');
	}

	function Tick(float DeltaTime)
	{
		//override Tick to prevent skel controller updates

	}

	event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
//		local weapon weap;


		//log(self @ "anim end" @ SeqNode.AnimSeqName);

		GrapInt.NotifyPerformanceFinished(CurrentGrapplePerformance);


        if (CurrentGrapplePerformance == GP_GrappleEnemyEnd)
        {
            ExitGrapple();
        }

		if( SeqNode.AnimSeqName == 'be0000i_ground_static_stand_attack_guardgrapple01disadv' ||
			SeqNode.AnimSeqName == 'be0000j_ground_static_stand_attack_guardgrapple01adv' )
		{
			GrapInt.NotifyAdvantageFinished();
		}

		if( SeqNode.AnimSeqName == 'be0000c_ground_static_stand_attack_guarddisarmed01succeed' ||
			SeqNode.AnimSeqName == 'be0000d_ground_static_stand_attack_guarddisarmed01fail' )
		{
			//Pawn.Weapon.PutDownWeapon();
            Pawn.Weapon.SetHidden(true);

//			Pawn.Weapon.SetPhysics(PHYS_Falling);
//			Pawn.Weapon.DetachWeapon();
//
//			//Pawn.TossWeapon(vect(0,0,-1));
//			//Pawn.Weapon.DropFrom( Pawn.Weapon.Location, vect(0,0,-1) );
//			weap = Pawn.Weapon;
//			Pawn.Weapon.DetachWeapon();
//			//Pawn.Weapon.DropFrom( Pawn.Mesh.GetBoneLocation('JO_Gun'), vect(0,0,-1) );
//			weap.SetRotation( QuatToRotator(Pawn.Mesh.GetBoneQuaternion('JO_Gun')) );
//			//weap.SetPhysics(PHYS_Falling);


			GrapInt.NotifyDisarmFinished();
		}
		if( SeqNode.AnimSeqName == 'be0001b_ground_static_stand_attack_adisarmfail' ||
			SeqNode.AnimSeqName == 'be0002b_ground_static_stand_attack_aenemydisarmedfail' )
		{
			GrapInt.NotifySurpriseFinished();
		}
	}


	event StartGrapplePerformance(GrapplePerformance perf)
	{
		CurrentGrapplePerformance=perf;

		switch(perf)
		{
			case GP_DisarmSuccess:
				TPPawn(Pawn).PlaySceneAnimation('be0000c_ground_static_stand_attack_guarddisarmed01succeed', 1, 0.25);
				break;

			case GP_DisarmFail:
				TPPawn(Pawn).PlaySceneAnimation('be0000d_ground_static_stand_attack_guarddisarmed01fail', 1, 0.25);
				break;

            case GP_GrappleEnemyEnd:
                TPPawn(Pawn).PlaySceneAnimation ('be0009a_ground_static_stand_alert_weaponpickup', 1, 0);
                break;

			case GP_PlayerAdvantage:
				TPPawn(Pawn).PlaySceneAnimation('be0000i_ground_static_stand_attack_guardgrapple01disadv', 1, 0.25);
				break;

			case GP_EnemyAdvantage:
				TPPawn(Pawn).PlaySceneAnimation('be0000j_ground_static_stand_attack_guardgrapple01adv', 1, 0.25);
				break;



			case GP_Idle:
				TPPawn(Pawn).PlaySceneAnimation('be0000f_ground_static_stand_alert_guardgrappleidle01', 0, 0.25);
				break;




			case GP_Surprise_EnemyDisadvantage:
                // This scene requires extracting root rotation
                Pawn.Mesh.RootMotionMode=RMM_Translate;
                Pawn.Mesh.RootMotionRotationMode=RMRM_RotateActor;
                Pawn.SetPhysics (PHYS_None);
                TPPawn(Pawn).PlaySceneAnimation('be0002c_ground_static_stand_alert_disarmbehind', 1, 0.25);
				break;
			case GP_Surprise_EnemyAdvantage:
				TPPawn(Pawn).PlaySceneAnimation('be0002b_ground_static_stand_attack_aenemydisarmedfail', 1, 0.25);
				break;



			case GP_Struggle_EnemyLoop:
				TPPawn(Pawn).PlaySceneAnimation('be0004b_ground_static_stand_attack_astruggleloop', 0, 0.25);
				break;

			case GP_Struggle_EnemyTakesHitA:
				TPPawn(Pawn).PlaySceneAnimation('be0004c_ground_static_stand_alert_astruggleadv', 1, 0.25);
				break;
			case GP_Struggle_EnemyTakesHitB:
				TPPawn(Pawn).PlaySceneAnimation('be0004h_ground_static_stand_attack_struggleadvkneeattk', 1, 0.25);                
				break;
			case GP_Struggle_EnemyHitsPlayer:
				TPPawn(Pawn).PlaySceneAnimation('be0004g_ground_static_stand_attack_astruggleenemyadv', 1, 0.25);
				break;

			case GP_Struggle_EnemySuperhit:
				TPPawn(Pawn).PlaySceneAnimation('be0004e_ground_static_stand_attack_asuperhit', 1, 0.25);
				break;

			case GP_Struggle_EnemyBreakToNeutral:
				TPPawn(Pawn).PlaySceneAnimation('be0004d_ground_static_stand_state_abreakoff', 1, 0.25);
				break;

			case GP_Struggle_EnemyGetsDisarmed:
				TPPawn(Pawn).PlaySceneAnimation('be0004a_ground_static_stand_hit_agetsdisarmed', 1, 0.25);
				break;

			case GP_Struggle_EnemyTransTo:
				TPPawn(Pawn).PlaySceneAnimation('be0004f_ground_static_stand_state_atransto', 1, 0.25);
				break;




//			case GP_Combo_EnemyTakesHit:
//				TPPawn(Pawn).PlaySceneAnimation('be0006a_ground_static_stand_attack_amultifulfacepunch', 1, `AISCENE_BLENDTIME);
//				break;

			case GP_Combo_EnemyLoopA:
				TPPawn(Pawn).PlaySceneAnimation('be0006a_ground_static_stand_attack_amultifulfacepunch', 1, 0.25);
				break;
			case GP_Combo_EnemyLoopB:
				TPPawn(Pawn).PlaySceneAnimation('be0006h_ground_static_stand_attack_playeradvkicksmash', 1, 0.25);
				break;
			case GP_Combo_EnemyLoopC:
				TPPawn(Pawn).PlaySceneAnimation('be0012b_ground_static_stand_attack_nazicombograpple', 1, 0.25);
				break;
			case GP_Combo_EnemyLoopD:
				TPPawn(Pawn).PlaySceneAnimation('be0013b_ground_mixed_stand_attack_punchingcombo', 1, 0.25);
				break;
			case GP_Combo_EnemyLoopE:
				TPPawn(Pawn).PlaySceneAnimation('be0014f_ground_static_stand_attack_gotpunches', 1, 0.25);
				break;
			case GP_Combo_EnemyLoopF:
				TPPawn(Pawn).PlaySceneAnimation('be0015b_ground_static_stand_attack_grapplehitpunchvictim', 1, 0.25);
				break;

			case GP_Combo_EnemyAdvantage:
				TPPawn(Pawn).PlaySceneAnimation('be0006c_ground_static_stand_attack_ahitsplayer', 1, 0.25);
				break;
			case GP_Combo_EnemyDisadvantage:
				TPPawn(Pawn).PlaySceneAnimation('be0006b_ground_static_stand_attack_aenemydeath', 1, 0.25);
				break;


            case GP_Combo_EnemyComboFail:
			    TPPawn(Pawn).PlaySceneAnimation('be0011a_ground_static_stand_alert_transblockplayer', 1, 0.25);
				break;


			case GP_Defense_EnemyTransition:
				TPPawn(Pawn).PlaySceneAnimation('be0008a_ground_static_stand_attack_atranstooffensive', 1, 0.25);
				break;

			case GP_Defense_EnemyLoop:
				TPPawn(Pawn).PlaySceneAnimation('be0008b_ground_static_stand_attack_aoffensiveloop', 0, 0.25);
				break;

			case GP_Defense_EnemyTakesHit:
				TPPawn(Pawn).PlaySceneAnimation('be0008c_ground_static_stand_attack_abreaktoneutral', 0, 0.25);
				break;
		}
	}



//	event ExitGrapple()
//	{
//		//go back to wait state
//		GotoState('WaitForGrapple');
//	}

Begin:

}

//************************ - END SECTION - ******************************
// GRAPPLE INTERACTION
//***********************************************************************



//************************ - BEGIN SECTION - ****************************
// BLUFF INTERACTION
//***********************************************************************

//Called by Bluff Interaction to end the bluff
function ExitBluff()
{
	PopState();
}

//Called by Bluff Interaction when player has completed a successful bluff
function OnBluffSuccess(Controller thePlayer)
{
}

//Called by Bluff Interaction when player has completed a failed bluff
function OnBluffFailure(Controller thePlayer)
{
}

//Called by Bluff Interaction to play a scene animation
function StartBluffPerformance(BluffPerformance perf)
{
}

//Called by Bluff Interaction when bluff prompt is enabled
function OnBluffPrompt(BluffInteraction BI, Controller thePlayer)
{
}

//Called by Bluff Interaction when bluff starts
function EnterBluff(BluffInteraction BI)
{
}


//Called by Bluff Interaction when prompt is cancelled
function OnBluffCancelled()
{
}

//function bool IsInBluff()
//{
//	if( IsInState('Guard') )
//		return true;
//
//	if( ChallengePlayer != None )
//	{
//		//log(self @ "IsInBluff.. true" @ GetStateName() @ ChallengePlayer);
//		return true;
//	}
//
//	//log(self @ "IsInBluff.. false" @ GetStateName() @ ChallengePlayer);
//	return false;
//}



//Stand guard and respond to challengers
state Guard
{
	event PoppedState()
	{
		TPPawn(Pawn).FinishSceneAnimation();
		Pawn.SetPhysics(PHYS_Walking);
	}
	event EndState(Name NextStateName)
	{
		TPPawn(Pawn).FinishSceneAnimation();
		Pawn.SetPhysics(PHYS_Walking);
	}	

	function OnBluffPrompt(BluffInteraction BI, Controller thePlayer)
	{
		Enemy = thePlayer.Pawn;
		BluffInt = BI;
		PlayHaltAnim();
	}

	function OnBluffCancelled()
	{
		PlayGuardIdle();
	}

	function EnterBluff(BluffInteraction BI)
	{
		BluffInt = BI;
		PushState('Bluff');
	}



	function PlayGuardIdle()
	{
		TPPawn(Pawn).PlaySceneAnimation('bd0000r_ground_static_stand_alert_checkpointcaptbreatheidle', 0, 0.25);
	}


	function PlayHaltAnim()
	{
		TPPawn(Pawn).PlaySceneAnimation('bd0000s_ground_static_stand_alert_checkpointcapthalt', 1, 0.25);
	}

	function PlayHaltLoopAnim()
	{
		TPPawn(Pawn).PlaySceneAnimation('bd0000t_ground_static_stand_alert_checkpointcapthaltidle', 0, 0.25);
	}

	function PlayHaltEndAnim()
	{
		TPPawn(Pawn).PlaySceneAnimation('bd0000u_ground_static_stand_alert_checkpointcaptallow', 1, 0.25);
	}


	event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		//Transition from halt to looping halt
		if( SeqNode.AnimSeqName == 'bd0000s_ground_static_stand_alert_checkpointcapthalt')
		{
			PlayHaltLoopAnim();
		}
	}

	function Tick(float DeltaTime)
	{
		//override Tick to prevent skel controller updates
		UpdateHeadTracking();
		UpdateAimInTheOpen(FALSE);;
	}


Begin:

    //log("------------------I am starting the bluff---------------");
	//Pawn.Weapon.PutDownWeapon();

	PlayGuardIdle();


//	while(true)
//	{
//		ChallengePlayer = SearchForChallenger();
//		if( ChallengePlayer != None )
//		{
//BluffPlayer = ChallengePlayer;		
//			PushState('BluffChallenge'); //may want goto state here?
//		}
//		Sleep(0.2f);
//	}

	while( true )
	{
		// turn towards our target
		//Focus = Target;
		Focus = Enemy;

		// wait til the turn is finished
		FinishRotation();

		// preserve the new orientation and stop turning
		PreserveRotation();
		Focus = None;


	
		sleep(0.1);
	}	

}


simulated function Destroyed()
{
	//Clean up before being destroyed...

//	if(ChallengePlayer != None)
//	{
//		ChallengePlayer.CancelBluff();
//		ChallengePlayer = None;
//	}

	super.Destroyed();
}


//************************ - BEGIN SECTION - ****************************
// PUSHABLE STATES - States that are used to stack on top of current state
//***********************************************************************



//***********************************************************************
// PUSHABLE STATES
//************************ - END SECTION - ******************************
 
//-----------------------------------------------------------------------
// Function:
// Description: Set Grapple Settings
//-----------------------------------------------------------------------

function OnGrappleSettings(SeqAct_GrappleSettings action)
{    
    if(action.bInfiniteGrapple)
        bInfiniteGrapple=action.bInfiniteGrapple;
    
    if(action.bForceGrapple)
    {
        action.thePlayer.GrappleOpponent = TPPawn(Pawn);
        action.thePlayer.GrapInt.ForceGrapple(self, action.thePlayer, action.bEnemyAttackFirst);
    }
}            

