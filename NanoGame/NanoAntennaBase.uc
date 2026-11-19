/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAntennaBase extends Actor
	abstract
	placeable;

var() vector LaunchVelocity;
var() NanoSplineActor LaunchSpline;
var transient NanoPawn CurrentUser;
var SkeletalMeshComponent Mesh;
var AnimNodeSequence SeqNode;

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local NanoPawn NP;
	
	NP = NanoPawn(Other);
	if( ( NP != None ) && ( NP.Role == ROLE_Authority ) )
	{
		if( CurrentUser == None && NP != None && VSize2D(NP.Velocity) > 100 && (NP.MantleState == MANTLE_None || NP.MantleState == MANTLE_FlipJump) )
		{
			NP.ServerDictateSpecialMove( 'NSM_Mantle_AntennaRun', TRUE, None, self, LaunchSpline != None ? 1 : 0 );
		}
	}
}

simulated function BeginAntennaMantle(name AnimToPlay, rotator AttackDir)
{
	SetRotation(AttackDir);

	if (SeqNode == None)
	{
		SeqNode = AnimNodeSequence(Mesh.FindAnimNode('AnimSeq'));
	}
	if (SeqNode != None)
	{
		SeqNode.SetAnim(AnimToPlay);
		SeqNode.PlayAnim(FALSE,1.f,0.f);

		if( CurrentUser.Role == ROLE_Authority )
		{
			SetTimer(SeqNode.GetTimeLeft(),FALSE,nameof(FinishMove));
		}
	}
}

simulated function FinishMove()
{
	CurrentUser.ServerEndSpecialMove( 'NSM_Mantle_AntennaRun' );
}

defaultproperties
{
	bNoDelete=TRUE
	
	Begin Object Class=SkeletalMeshComponent Name=AntennaMesh_0
		CollideActors=FALSE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
	End Object
	Components.Add(AntennaMesh_0)
	Mesh=AntennaMesh_0
	CollisionComponent=AntennaMesh_0

	Begin Object Class=CylinderComponent Name=AntennaCyl_0
		CollisionHeight=384.f
		CollisionRadius=70.f
		Translation=(Z=384)
		CollideActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
	End Object
	Components.Add(AntennaCyl_0)

	bCollideActors=TRUE

	LaunchVelocity=(X=1200,Z=384)
}
