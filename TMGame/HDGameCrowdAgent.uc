//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDGameCrowdAgent extends GameCrowdAgentSkeletal
native(HDGame);

var() int TeamIndex;

//Weapon
var() class<TGWeapon> WeaponType;
var   TGWeapon        Weapon;
var() float			  NewRateOfFire;

//Fire
var   Actor    FireTarget;
var() int      ShotsToFire;
var   int      ShotsFired;
var   float    RemainingFireTime;
var() vector2d ShotsInternal;
var   bool     Firing;
var() float    InaccuracyDegrees;

var() bool     bOnlyKilledByPawn;

var() array<name> FireAnimNames;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


final function bool IsDead()
{
    return bDeleteMe || Health <= 0;
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if( IsDead() )
		return;

    //create weapon
    if(WeaponType != none)
    {
        Weapon = Spawn(WeaponType, self);
        if(Weapon != none)
        {
            if(Weapon.Mesh != none)
                Weapon.AttachComponent(Weapon.Mesh);

            Weapon.AttachWeaponTo(SkeletalMeshComponent, 'RightHand');

            //infinite ammo
            Weapon.SetInfiniteSpareAmmo();
            Weapon.SetInfiniteMagazineSize();
        }
    }
}

event SetCurrentDestination(GameCrowdDestination NewDest)
{
	if ( NewDest != CurrentDestination )
	{
		if ( CurrentBehavior != None )
		{
			CurrentBehavior.ChangingDestination(NewDest);
		}
		CurrentDestination = NewDest;
		CurrentDestination.IncrementCustomerCount(self);

        //make more random
		ReachThreshold = CurrentDestination.bSoftPerimeter ? 0.1 + 0.9*FRand() : 1.0;
	}
	if ( CurrentDestination.bFleeDestination && !IsPanicked() )
	{
		SetPanic(None, TRUE);
	}
}

final function StartFire(bool bFireImmediate = true)
{
    local float f;

    f = ShotsInternal.X + (ShotsInternal.Y - ShotsInternal.X) * FRand();
    SetTimer(f, false, 'FireTimer');

    if(bFireImmediate)
        FireTimer();
}

final function StopFire()
{
    Firing = false;
    Weapon.WeaponStoppedFiring(0);
    ClearTimer('FireTimer');
}

event Tick(float DeltaTime)
{
    //local float VSq;

    if( !bSimulateThisTick || IsDead() )
		return;

    UpdateFire(DeltaTime);

//    VSq = VSizeSq2D(Velocity);
//    if( !FullBodySlot.bIsPlayingCustomAnim && !bIsPlayingIdleAnimation && VSq < 25 )
//    {
//       PlayIdleAnimation();
//    }
//    else if(bIsPlayingIdleAnimation && VSq >= 25)
//    {
//       StopIdleAnimation();
//    }
}

final function vector GetFireTargetLocation()
{
    local Pawn P;

    P = Pawn(FireTarget);
    return (P != none) ? P.GetPawnViewLocation() : FireTarget.Location;
}

final function bool AnimCanFire()
{
    local name AnimName;

    if(FullBodySlot.bIsPlayingCustomAnim)
    {
        AnimName = FullBodySlot.GetPlayedAnimation();
    }
    else
    {
        AnimName = (SpeedBlendNode.Children[0].Weight > SpeedBlendNode.Children[1].Weight) ? WalkSeqNode.AnimSeqName : RunSeqNode.AnimSeqName;
    }

    return FireAnimNames.Find(AnimName) != INDEX_NONE;
}

final function UpdateFire(float DeltaTime)
{
    local vector Dir, MyDir, TargetLoc;

    if(Firing && Weapon != none && FireTarget != none && AnimCanFire())
    {
        RemainingFireTime -= DeltaTime;
        if(RemainingFireTime <= 0.f)
        {
        	if(ShotsFired >= ShotsToFire)
        	{
        		Weapon.WeaponStoppedFiring(0);
        		Firing = false;

    		    StartFire(false);
        	}
        	else
        	{
        		RemainingFireTime = 60.f / (NewRateOfFire > 0 ? NewRateOfFire : Weapon.WeaponRateOfFire);
        		ShotsFired++;

                TargetLoc = GetFireTargetLocation();

                Dir = Normal(TargetLoc - Location);
                MyDir = vector(Rotation);
                if(Dir dot MyDir >= 0.766 && FastTrace(TargetLoc, ,, true)) //<=40 degree
                {
               	    Weapon.DummyFire(0, TargetLoc, self, InaccuracyDegrees);
                }
               // else
//                {
//               	    Weapon.WeaponStoppedFiring(0);   //not anymore
//                }
        	}
        }
    }
}

final function FireTimer()
{
    ShotsFired = 0;
    Firing = true;
    RemainingFireTime = 0;
}

simulated function Destroyed()
{
   if(Weapon != none)
   {
        StopFire();

        //Weapon.DetachWeapon();
        if(Weapon.Mesh != none)
            SkeletalMeshComponent.DetachComponent(Weapon.Mesh);

        Weapon.Destroy();
        Weapon = none;
   }

	super.Destroyed();
}

final function StayDeathAnim(AnimNodeSequence Seq, name DeathName, float Position)
{
	Seq.bPlaying = false;
	Seq.bLooping = false;
	//Seq.bZeroRootTranslation = false;
	//Seq.bZeroRootRotation = false;

	Seq.SetAnim(DeathName);
	Seq.SetPosition(Position, false);
}

final function DeathAnimDone()
{
    local float AnimTime;
    local name AnimName;

    AnimName = FullBodySlot.GetPlayedAnimation();
    AnimTime = FullBodySlot.GetCustomAnimNodeSeq().GetAnimPlaybackLength();

    //stay the final frame
	StayDeathAnim(WalkSeqNode, AnimName, AnimTime);
	StayDeathAnim(RunSeqNode, AnimName, AnimTime);
}

/** Stop agent moving and pay death anim */
function PlayDeath(vector KillMomentum)
{
    local int AnimIndex;
    local float DeadBodyTime, AnimTime;

   	Super(GameCrowdAgent).PlayDeath(KillMomentum);

    StopFire();

	if(WorldInfo.TimeSeconds - LastRenderTime > 1)
	{
		DeadBodyTime = 0.01;
	}
	else
	{
        if(DeathAnimNames.Length > 0 && FullBodySlot != none)  //use anim
        {
            FullBodySlot.StopCustomAnim(0.0);
        	AnimIndex = Rand(DeathAnimNames.Length);
        	FullBodySlot.PlayCustomAnim(DeathAnimNames[AnimIndex], 1.0, 0.2);

        	AnimTime = FullBodySlot.GetCustomAnimNodeSeq().GetAnimPlaybackLength();
        	DeadBodyTime = AnimTime + DeadBodyDuration;

        	SetTimer(AnimTime - 1.f, false, nameof(DeathAnimDone));
        }
        else  //use phys
        {
            SkeletalMeshComponent.SetHasPhysicsAssetInstance(true);
            // If we had stopped updating kinematic bodies on this character due to distance from camera, force an update of bones now.
            SkeletalMeshComponent.MinDistFactorForKinematicUpdate = 0.f;
            SkeletalMeshComponent.ForceSkelUpdate();
            SkeletalMeshComponent.UpdateRBBonesFromSpaceBases(TRUE, TRUE);

            CollisionComponent = SkeletalMeshComponent;
            SetTickGroup(TG_PostAsyncWork);
            SkeletalMeshComponent.SetTickGroup(TG_PostAsyncWork);
            SkeletalMeshComponent.PhysicsWeight = 1.0;
            SetPhysics(PHYS_RigidBody);
            SkeletalMeshComponent.SetBlockRigidBody(true);
            SkeletalMeshComponent.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);
            SkeletalMeshComponent.SetRBChannel(RBCC_Pawn);
            SkeletalMeshComponent.SetRBCollidesWithChannel(RBCC_Default,TRUE);
            SkeletalMeshComponent.SetRBCollidesWithChannel(RBCC_Pawn,FALSE);
            SkeletalMeshComponent.SetRBCollidesWithChannel(RBCC_Vehicle,FALSE);
            SkeletalMeshComponent.SetRBCollidesWithChannel(RBCC_Untitled3,FALSE);
            SkeletalMeshComponent.SetRBCollidesWithChannel(RBCC_BlockingVolume,TRUE);
            SkeletalMeshComponent.SetTraceBlocking(false,true);

            if( KillMomentum != vect(0,0,0) )
            {
            	SkeletalMeshComponent.AddImpulse(0.5*KillMomentum, Location, '', false);
            }

            DeadBodyTime = DeadBodyDuration;
        }
	}

	LifeSpan = DeadBodyTime;
}

function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local HDGameCrowdAgent Agent;

    //check friendly kill
    if(EventInstigator != none && PlayerController(EventInstigator) == none && EventInstigator.GetTeamNum() == TeamIndex)
    {
        return;
    }
    else if(EventInstigator == none && DamageCauser != none)
    {
        Agent = HDGameCrowdAgent(DamageCauser.Owner);
        if(Agent != none && Agent.TeamIndex == TeamIndex)
        {
            return;
        }
    }

    Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

function OnCrowdMove(HDSeqAct_CrowdMove Action)
{
    local GameCrowdDestination Dest;

    if( IsDead() )
        return;

    Dest = GameCrowdDestination(Action.MoveTarget);
    if(Dest != none && Dest != CurrentDestination)
    {
        if(FullBodySlot.bIsPlayingCustomAnim)
        {
           	FullBodySlot.StopCustomAnim(0.2);
        }

        if(IsIdle())
            StopBehavior();

        PreviousDestination = CurrentDestination;
        if(CurrentDestination != none)
            CurrentDestination.DecrementCustomerCount(self);

        SetCurrentDestination(Dest);
        UpdateIntermediatePoint();
    }
}

final function Actor GetFinalActor(Actor TheActor)
{
    local Controller C;
    local Turret T;

	C = Controller(TheActor);
	if(C != none && C.Pawn != none)
	{
	    T =  Turret(C.Pawn);
	    if(T != none)
            return T.Driver;

		return C.Pawn;
	}

	return TheActor;
}

function OnCrowdSetTarget(HDSeqAct_CrowdSetTarget Action)
{
    if( IsDead() || Weapon == none)
        return;

    InaccuracyDegrees = Action.InaccuracyDegrees;
    ShotsInternal = Action.ShotsInternal;
    ShotsToFire = Action.ShotsToFire;
    if(Action.NewDamage > 0.f)
	{
		Weapon.DummyWeaponDamage = Action.NewDamage;
	}

    FireTarget = GetFinalActor(Action.FireTarget);
    if(FireTarget == none)
    {
        StopFire();
    }
    else
    {
        StartFire();
    }
}

/**
  *  Animation request from kismet
  */
simulated function OnPlayAgentAnimationEx(HDSeqAct_PlayAgentAnimationEx Action)
{
	OnPlayAgentAnimation(Action);
}

event ClearLatentAnimation()
{
    Super.ClearLatentAnimation();

	ClearLatentAction(class'HDSeqAct_PlayAgentAnimationEx', false);
}

final function OnPlayAgentAnimationExEnd()
{
    local HDGameCrowdBehavior_PlayAnimation  Behavior;

    Behavior = HDGameCrowdBehavior_PlayAnimation(CurrentBehavior);
	if(Behavior != None)
	{
		Behavior.AnimEnd();
	}
}

