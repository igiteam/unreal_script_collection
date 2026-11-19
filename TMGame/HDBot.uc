//-----------------------------------------------------------
//  ???AI????
//-----------------------------------------------------------
class HDBot extends AIController;//UDKBot;

//function OnSetAIOrder(HDSeqAct_SetAIOrder OrderAction)
//{
//    if(OrderAction.Order == '')
//	{
//		OrderAction.ScriptLog("*****WARNING: No Order!");
//		return;
//	}
//
//    `logd("New Order from Kismet="@OrderAction.Order);
//    //SetBotOrders(OrderAction.Order, self, false);
//}

/* epic ===============================================
* ::Possess
*
* Handles attaching this controller to the specified
* pawn.
*
* =====================================================
*/
function Possess(Pawn aPawn, bool bVehicleTransition)
{
	if(aPawn.bDeleteMe)
	{
		;
		ScriptTrace();
		GotoState('Dead');
	}
	else
	{
		Super.Possess(aPawn, bVehicleTransition);

		//bPlannedJump = false;
		//ResetSkill();
		//ImpactVelocity = vect(0,0,0);

		Pawn.SetMovementPhysics();  //????????????
		if(Pawn.Physics == PHYS_Walking)
			Pawn.SetPhysics(PHYS_Falling);

		enable('NotifyBump');
	}
}

/* epic ===============================================
* ::NotifyTakeHit
*
* Notification from pawn that it has received damage
* via TakeDamage().
*
* =====================================================
*/
function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
    ;

    SetEnemy(InstigatedBy.Pawn, true);
    //GotoState('Defend');
}

/**
 * Adjusts weapon aiming direction.
 * Gives controller a chance to modify the aiming of the pawn. For example aim error, auto aiming, adhesion, AI help...
 * Requested by weapon prior to firing.
*
 * @param	W, weapon about to fire
 * @param	StartFireLoc, world location of weapon fire start trace, or projectile spawn loc.
 */
function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
    //`logd("AI::GetAdjustedAimFor");

    return (Pawn != None) ? Pawn.GetBaseAimRotation() : Rotation;
}

/* epic ===============================================
* ::ReceiveWarning
*
* Notification that the pawn is about to be shot by a
* trace hit weapon.
*
* =====================================================
*/
//TMPlayerController::GetAdjustedAimFor->InstantWarnTarget->ReceiveWarning
function ReceiveWarning(Pawn shooter, float projSpeed, vector FireDir)
{
    ;

    SetEnemy(shooter, true);
}


/* epic ===============================================
* ::HearNoise
*
* Counterpart to the Actor::MakeNoise() function, called
* whenever this player is within range of a given noise.
* Used as AI audio cues, instead of processing actual
* sounds.
*
* =====================================================
*/
event HearNoise( float Loudness, Actor NoiseMaker, optional Name NoiseType )
{
    local Pawn P;

    ;

    P = Pawn(NoiseMaker);
    if(P != none && LineOfSightTo(P))
    {
        SetEnemy(P);
    }
}

/* epic ===============================================
* ::SeePlayer
*
* Called whenever Seen is within of our line of sight
* if Seen.bIsPlayer==true.
*
* =====================================================
*/
event SeePlayer( Pawn Seen )
{
    //`logd("AI::SeePlayer");
    SetEnemy(Seen);
}

/* epic ===============================================
* ::SeeMonster
*
* Called whenever Seen is within of our line of sight
* if Seen.bIsPlayer==false.
*
* =====================================================
*/
event SeeMonster( Pawn Seen )
{
    ;
}
/* epic ===============================================
* ::EnemyNotVisible
*
* Called whenever Enemy is no longer within of our line
* of sight.
*
* =====================================================
*/
event EnemyNotVisible()
{
    //`logd("AI::EnemyNotVisible");

    StopFiring();
    //GotoState('Hunting');

    //Enemy = none;
    //Focus = none;
}


/**
 * Called by APawn::moveToward when the point is unreachable
 * due to obstruction or height differences.
 */
event MoveUnreachable(vector AttemptedDest, Actor AttemptedTarget)
{
    ;
}

/** called when a ReachSpec the AI wants to use is blocked by a dynamic obstruction
 * gives the AI an opportunity to do something to get rid of it instead of trying to find another path
 * @note MoveTarget is the actor the AI wants to move toward, CurrentPath the ReachSpec it wants to use
 * @param BlockedBy the object blocking the path
 * @return true if the AI did something about the obstruction and should use the path anyway, false if the path
 * is unusable and the bot must find some other way to go
 */
event bool HandlePathObstruction(Actor BlockedBy)
{
    ;

    return false;
}

/* epic ===============================================
* ::FireWeaponAt
*
* Should cause this player to fire a weapon at the given
* actor.
*
* =====================================================
*/
function bool FireWeaponAt(Actor A)
{
	if ( A == None )
		A = Enemy;

	if ( (A == None) || (Focus != A) )
		return false;

	Focus = A;
	if(Pawn.Weapon != None)
	{
		if(Pawn.Weapon.HasAnyAmmo())
			return Pawn.BotFire(false);
	}
	//else
	//	return Pawn.BotFire(false);

	return false;
}

final function SetEnemy(Pawn Who, optional bool Attack)
{
    if(Who != none && Who != Enemy)
    {
        Enemy = Who;
        Focus = Who;
    }

    if(Enemy != none)
    {
        if(Attack)
        {
           GotoState('Attack');
        }
        else
        {
         	ScriptedMoveTarget = Who;
            if (!IsInState('ScriptedMove'))
            {
            	PushState('ScriptedMove');
            }
        }
    }

}

state Attack
{
	function EndState(Name NextStateName)
	{
         ;
	}

	function BeginState(Name PreviousStateName)
	{
	    ;
	}

Begin:
   FireWeaponAt(Enemy);
}

state Defend
{
	function EndState(Name NextStateName)
	{
         ;
	}

	function BeginState(Name PreviousStateName)
	{
	    ;
	}

Begin:
}

