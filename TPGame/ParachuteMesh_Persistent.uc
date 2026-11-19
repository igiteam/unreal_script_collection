class ParachuteMesh_Persistent extends KAsset
    native
    notplaceable;

var vector DecentVelocity;
var Actor LandingTarget;
var Pawn Paratrooper;
var array<name> FixedBones;
var bool ParatrooperHanging;
var float SwingRate, SwingVelocity;
var int InitialRoll, MaxRoll;
var vector PawnOffset;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

simulated function PostBeginPlay()
{
    local TPPawn TPParatrooper;

	super.PostBeginPlay();
	InitialRoll = Rotation.Roll;

    TPParatrooper = TPPawn(Paratrooper);
    if (TPParatrooper != None)
    {
        ParatrooperHanging=true;
        TPParatrooper.FreezeTime = 0;
    }

    AnimNodeSequence(SkeletalMeshComponent.Animations).PlayAnim(true);
}

function OnAttachParatrooper(SeqAct_AttachParatrooper Action)
{
	Paratrooper = Action.Paratrooper;
	DecentVelocity = Action.DecentVelocity;

	TPPawn(Paratrooper).MyParachute = self;
    TPPawn(Paratrooper).FreezeTime  = 0;
    ParatrooperHanging=true;

    Paratrooper.SetLocation(Location);
	Paratrooper.SetHardAttach(true);
	Paratrooper.SetBase(self,,SkeletalMeshComponent,'JO_positionTracker');
}

event Collapse()
{
    local TPPawn TPParatrooper;

    DecentVelocity = vect(0,0,0);
    //ParachuteState.SetBlendTarget(1.0,0.0);

    AnimNodeSequence(SkeletalMeshComponent.Animations).SetAnim('bo0000b_air_static_transition_na_parachutelanding');
    AnimNodeSequence(SkeletalMeshComponent.Animations).bCauseActorAnimEnd = true;
    AnimNodeSequence(SkeletalMeshComponent.Animations).PlayAnim();

    TPParatrooper = TPPawn(Paratrooper);
    if (TPParatrooper != none)
    {
        TPParatrooper.FreezeTime = class'TPPawn'.default.FreezeTime;
    }
}


event Destroyed()
{
    local TPPawn TPParatrooper;

    TPParatrooper = TPPawn(Paratrooper);
    if (TPParatrooper != none)
    {
        TPParatrooper.FreezeTime = class'TPPawn'.default.FreezeTime;
    }

    Super.Destroyed();
}


event DestroyParachute()
{
    AnimNodeSequence(SkeletalMeshComponent.Animations).StopAnim();
    Destroy();
}   

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (SeqNode.AnimSeqName == 'bo0000b_air_static_transition_na_parachutelanding')
    {
        Destroy();
    }
}

//simulated function Tick(float dt)
//{
//	local rotator NewRot;
//	local int Roll;
//	
//	NewRot = Rotation;
//	Roll = NewRot.Roll;
//
//	if (Paratrooper != none)
//	{
//		if (TPAIController(Paratrooper.Controller) != none)
//		{
//			//if(TPAIController(Paratrooper.Controller).Enemy != none)
//			//	NewRot = RLerp(rotator(TPAIController(Paratrooper.Controller).Enemy.Location-Location), NewRot, dt * 4, true);
//		}
//	}
//    else
//    {
//        Destroy();
//    }
//
//	SwingVelocity += SwingRate * dt;
//	NewRot.Roll = Roll;
//	NewRot.Roll += SwingVelocity;
//	
//	if ((NewRot.Roll - InitialRoll < -MaxRoll && SwingRate < 0) || (NewRot.Roll - InitialRoll > MaxRoll && SwingRate > 0 ))
//		SwingRate *= -1;
//
//	super.Tick(dt);
//	
//	SetLocation(Location+(DecentVelocity*dt));
//	
//	SetRotation(NewRot);
//	
//	if (Paratrooper != none && Paratrooper.Health <= 0/* && !ParatrooperHanging*/)
//	{
//		ParatrooperHanging=true;
//		Paratrooper.SetHardAttach(true);
//		Paratrooper.SetBase(self,,SkeletalMeshComponent,'JO_positionTracker');
//		Paratrooper.SetPhysics(PHYS_None);
//		Paratrooper.Mesh.PhysicsAssetInstance.SetNamedBodiesFixed(true,FixedBones,Paratrooper.Mesh,true);
//		Paratrooper.Mesh.SetPhysicsWeight(1.0f);
//	}
//}

