/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCheatManager extends CheatManager within NanoPC
	config(Game);

/** For spawning on demand */
struct native SpawnPawnInfo
{
	var	String				PawnName;
	var String				ClassName;
	var String	            AIClassName;
	var byte TeamNum;

	structdefaultproperties
	{
		TeamNum=255
	}
};
var	config Array<SpawnPawnInfo>	SpawnPawnList;

var transient NanoFormation_Wall Wall;
var transient array<NanoFormation_Wall> SplitWalls;

struct TestSortStruct
{
	var string Label;
	var float Value;
};

var array< class<PlayerInput> > InputCycleList;



exec function DebugAI(optional coerce name Category)
{
	bDebugAI = !bDebugAI;
	DebugAIController = None;
	ClientMessage( "DebugAI"@bDebugAI );

	// and hook/unhook our debug draw
	NanoHUD_Base(myHUD).SetDebugDraw(DebugDraw_AI,bDebugAI);
}

exec function DebugRoad()
{
	bDebugRoad = !bDebugRoad;
	ClientMessage( "DebugRoad"@bDebugRoad );

	NanoHUD_Base(myHUD).SetDebugDraw(DebugDraw_Road, bDebugRoad);
}

exec function DebugAICycle()
{
	local NanoAI AI;
	local vector CamLoc;
	local rotator CamRot;

	if( !bDebugAI )
	{
		DebugAI();
	}

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( AI == None || !AI.bAIDrawDebug || AI.Pawn == None )
		{
			continue;
		}

		GetPlayerViewPoint(CamLoc,CamRot);
		if( (AI.Pawn.Location - CamLoc) dot vector(CamRot) < 0.f )
		{
			continue;
		}

		if( DebugAIController == None )
		{
			DebugAIController = AI;
			return;
		}
		else if( DebugAIController == AI )
		{
			DebugAIController = None;
		}
	}
	DebugAIController = None;
}


exec function Slomo( float T )
{
	local NanoGRI GRI;

	GRI = NanoGRI(WorldInfo.GRI);
	if( GRI != None )
	{
		GRI.GameSlomo( T );
	}
	else
	{
		Super.Slomo( T );
	}
}


exec function Invis()
{
	MyNP.bDebugInvisToAI = !MyNP.bDebugInvisToAI;
}

/** Cheat that gives you infinite nano power */
exec function NanoGod()
{
	bInfiniteNanoPower = !bInfiniteNanoPower;
}

/** Cheat that jumps you straight to full combo power */
exec function FullCombo()
{
	bInfiniteComboPoints = !bInfiniteComboPoints;
}

exec function TestHealth()
{
	MyNP.TakeDamage(RandRange(10,50),Outer,MyNP.Location,vect(0,0,0),class'NDT_Tackled');
}

exec function ComboPoints()
{
	MyNP.ComboPoints += 25;
}


//// cheats to give resources

exec function AddCurrency( int InAmount )
{
	GetPRI().AwardCurrency( InAmount, "CheatAmount:" );
}

exec function AddNanoPower( int InAmountOfBuckets )
{
	MyNP.AddNanoBuckets( InAmountOfBuckets );
}

exec function AddNanoForgeCores( int InAmountOfBuckets )
{
	MyNP.AddNanoForgeCoreBuckets( InAmountOfBuckets );
}

exec function AddRebelMindShare( int InAmount )
{
	NanoGRI(WorldInfo.GRI).GetCurrentRebelMindShareManager().AddRebelMindShareLevel( InAmount );
}

exec function AddXP( int InAmount )
{
	GetPRI().AwardXP( InAmount, "CheatAmount:" );
}

exec function ResetAllRewards()
{
	GetPRI().ResetAllRewards();
	NanoGRI(WorldInfo.GRI).GetCurrentRebelMindShareManager().ResetMindShare();
}




exec function MaxSkills()
{
	local int Idx;
	for( Idx = 0; Idx < MyNP.SkillList.Length; Idx++ )
	{
		MyNP.SkillList[Idx].Skill.SetSkillLevel(TRUE,99);
	}
}

exec function ToggleCamera()
{
	NanoPlayerCamera(PlayerCamera).Cam_3p.bThirdPersonTraversal = !NanoPlayerCamera(PlayerCamera).Cam_3p.bThirdPersonTraversal;
}

exec function Trail()
{
	NanoHUD_Base(MyHUD).bEnablePlayerTrail = !NanoHUD_Base(MyHUD).bEnablePlayerTrail;
}

exec function FreezeTrail()
{
	NanoHUD_Base(MyHUD).bFreezePlayerTrail = !NanoHUD_Base(MyHUD).bFreezePlayerTrail;
}

exec function SetSkillLevels( int Lvl )
{
/*
// 	local NanoSkill_Jump JumpSkill;
// 	JumpSkill = NanoSkill_Jump(MyNP.GetSkill(class'NanoSkill_Jump'));
// 	JumpSkill.SkillLevel = Lvl;
*/

	local NanoSkill_Dash DashSkill;
	DashSkill = MyNP.GetSkill(class'NanoSkill_Dash');
	DashSkill.SkillLevel = Lvl;
}

function SpawnTargetDummy( float SpawnRange, bool bSetGodMode, bool bCaptain )
{
	local NanoPawn Dummy;
	local NanoAI AI;
	local class<NanoPawn> DummyTargetClass;

	if( bCaptain )
	{
		DummyTargetClass = class<NanoPawn>(DynamicLoadObject("NanoGameContent.NanoPawn_MetaCorp_RiotCop_Agent",class'class'));
	}
	else
	{
		DummyTargetClass = class<NanoPawn>(DynamicLoadObject("NanoGameContent.NanoPawn_MetaCorp_RiotCop",class'class'));
	}

	Dummy = Spawn(DummyTargetClass,,,Pawn.Location+vector(Pawn.Rotation)*SpawnRange+vect(0,0,128.f));
	if (Dummy != None)
	{
		AI = Spawn(class'NanoAI_Trooper',,,, Dummy.Rotation );
		AI.Possess(Dummy,FALSE);
		AI.SetTeam( 1 );
		AI.bIsScripted = TRUE;
		AI.bTargetDummy = TRUE;
		AI.SetFocalPoint( Pawn.Location );
		Dummy.SpawnNanoBaton();
		//Dummy.CreateShield();
		if (bSetGodMode)
		{
			//AI.bGodMode = TRUE;
			// just give a huge amount of health "emulate" god mode so we still get the correct hit reactions
			Dummy.DefaultHealth *= 100;
			Dummy.Health *= 100;
			//`log( `showvar(Dummy.DefaultHealth) @ `showvar(Dummy.Health) );
		}
	}
}

exec function TargetCircle( optional int EnemyCnt = 1, optional bool bSetGodMode, optional bool bCaptain )
{
	local int i;
	local Rotator OldRot, RotInc;

	EnemyCnt = Max( 1, EnemyCnt );

	OldRot = Pawn.Rotation;
	RotInc.Yaw = 65536 / EnemyCnt;

	for( i = 0; i < EnemyCnt; i++ )
	{
		SpawnTargetDummy( 256.f, bSetGodMode, bCaptain );
		Pawn.SetRotation( Pawn.Rotation + RotInc );
	}

	Pawn.SetRotation( OldRot );
}




exec function ActivateAI()
{
	local NanoPawn P;
	local NanoAI AI;

	foreach WorldInfo.AllPawns( class'NanoPawn', P )
	{
		AI = NanoAI(P.Controller);
		if( AI != None )
		{
			AI.bIsScripted = FALSE;
			AI.bTargetDummy = FALSE;
		}
	}

}

/** Cheat that gives you all plans */
exec function AllPlans()
{
	MyNP.GetPRI().GiveNanoPlan(class'NanoPlan_RicochetMoon', false);
	//MyNP.GetPRI().GiveNanoPlan(class'NanoPlan_Orbitals', false);
}

exec function WallTest(optional int NumToSpawn, optional int RowSize)
{
	local NanoPawnBase Dummy;
	local NanoAI_Trooper AI;
	local class<NanoPawn> DummyTargetClass;
    local rotator PawnRotation;
    local int SpawnCount;
    if (NumToSpawn == 0)
    {
	NumToSpawn = 5;
    }
	if (RowSize == 0)
	{
		RowSize = 3;
	}
	if (Wall == None)
	{
		Wall = Spawn(class'NanoFormation_Wall',,,,Pawn.Rotation);
	}
	Wall.DesiredRowSize = RowSize;
    PawnRotation = Pawn.Rotation;
    SpawnCount = 0;

	DummyTargetClass = class<NanoPawn>(DynamicLoadObject("NanoGameContent.NanoPawn_MetaCorp_RiotCop",class'class'));
    while (SpawnCount++ < NumToSpawn)
    {
    	Dummy = Spawn(DummyTargetClass,,,Pawn.Location+vector(Pawn.Rotation)*1024.f+vector(PawnRotation)*512.f);
    	if (Dummy != None)
    	{
    		AI = Spawn(class'NanoAI_Trooper');
    		AI.Possess(Dummy,FALSE);
	    AI.bIsScripted = TRUE;
	    Wall.AddMember(AI);
    	}
	PawnRotation.Yaw += 65535/NumToSpawn;
    }
	Wall.CalculateLocation();
	ConsoleCommand("PlayersOnly");
	/*
	ConsoleCommand("Ghost");
	Pawn.SetLocation(Wall.Location + vect(0,0,2048));
	SetRotation(rotator(Wall.Location - Pawn.Location));
	*/
}

exec function ResizeWall(int RowSize)
{
    RowSize = Max(1,RowSize);
    if (Wall != None)
    {
		Wall.SetRowSize(RowSize);
    }
}

exec function SplitWall()
{
	local NanoFormation_Wall NewWall;
	local int NumToSplit, ListOffset;
	local array<NanoAI_Trooper> MembersToSplit;
	local NanoAI_Trooper Member;
	if (Wall != None)
	{
		NewWall = Spawn(class'NanoFormation_Wall');
		NumToSplit = Wall.RowCount/2 * Wall.RowSize;
		`log(`location@`showvar(NumToSplit));
		ListOffset = 0;
		// pull off the back rows
		while (NumToSplit-- > 0)
		{
			MembersToSplit.AddItem(NanoAI_Trooper(Wall.Members[Wall.Positions[Wall.Positions.Length-(++ListOffset)].MemberIdx]));
		}
		foreach MembersToSplit(Member)
		{
			Wall.RemoveMember(Member);
			NewWall.AddMember(Member);
		}
		SplitWalls.AddItem(NewWall);
	}
}

exec function CombineWalls()
{
	local NanoFormation_Wall OtherWall;
	local NanoAI Member;
	foreach SplitWalls(OtherWall)
	{
		foreach OtherWall.Members(Member)
		{
			Wall.AddMember(Member);
		}
		OtherWall.Destroy();
	}
	SplitWalls.Length = 0;
}

exec function TestHit()
{
	MyNP.AddRecentHit(None,MyNP.Location + vector(MyNP.Rotation) * 256.f,WorldInfo.TimeSeconds);
}

exec function TeslaCoil()
{
	Spawn(class'TeslaCoil',,,Pawn.Location + vector(Pawn.Rotation) * 128.f + vect(0,0,1) * -Pawn.GetCollisionHeight());
}

exec function Step( optional bool bPause )
{
	if( bPause )
	{
		ConsoleCommand("Pause");
		SetTimer(0.00001f,FALSE,nameof(NextPause),self);
	}
	else
	{
		ConsoleCommand("PlayersOnly");
		SetTimer(0.00001f,FALSE,nameof(NextPlayersOnly),self);
	}

}

function NextPause()
{
	ConsoleCommand("Pause");
}
function NextPlayersOnly()
{
	ConsoleCommand("PlayersOnly");
}

exec function Trooper(optional int NumToSpawn)
{
	local NanoPawn Dummy;
	local NanoAI AI;
    local rotator PawnRotation;
	local class<NanoPawn> TrooperClass;
    local int SpawnCount;
	NumToSpawn = Max(1,NumToSpawn);
    PawnRotation = Pawn.Rotation;
    SpawnCount = 0;
	TrooperClass = class<NanoPawn>(DynamicLoadObject("NanoGameContent.NanoPawn_MetaCorp_RiotCop",class'class'));

	if( TrooperClass == None )
	{
		`log("Can't DLO Trooper Class!");
	}

    while (SpawnCount++ < NumToSpawn)
    {
		Dummy = Spawn(TrooperClass,,,Pawn.Location+vector(Pawn.Rotation)*1024.f+vector(PawnRotation)*256.f,PawnRotation);
		if (Dummy != None)
		{
			AI = Spawn(class'NanoAI_Trooper');
			AI.Possess(Dummy,FALSE);
		}
	PawnRotation.Yaw += 65535/NumToSpawn;
   }
}

exec function DockBots()
{
	local NanoAI_SentryBot Bot;
	foreach WorldInfo.AllControllers(class'NanoAI_SentryBot',Bot)
	{
		Bot.ReturnToDock();
	}
}

exec function MakeChaos(optional int Amount)
{
	local NanoCausingChaosValueDatum Chaos;

	if (Amount == 0)
	{
		Amount = 50;
	}

	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;

	Chaos.ChaosDesc = "MakeChaos Exec";

	NanoGRI(WorldInfo.GRI).GetCurrentChaosManager().ModifyChaosLevel( Pawn, Chaos );
}

exec function Baton()
{

	NanoPawn(Pawn).SpawnNanoBaton();
}

exec function AudioTest()
{
	NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_StopPlayer,Pawn);
}

delegate int IntSort(int A, int B)
{
	return B - A;
}

delegate int StructSort(TestSortStruct A, TestSortStruct B)
{
	return A.Value < B.Value ? -1 : 0;
}

delegate int StringSort(String A, String B)
{
	return Len(B) - Len(A);
}

exec function SortTest()
{
	local array<int> DummyIntArray;
	local int DummyInt;
	local array<TestSortStruct> DummyStructArray;
	local TestSortStruct DummyStruct;
	local array<string> DummyStringArray;
	local string DummyString;
	`log("!!!!!!!!!!!!!!");
	DummyIntArray.AddItem(3);
	DummyIntArray.AddItem(2);
	DummyIntArray.AddItem(1);
	`log("orig int list:");
	foreach DummyIntArray(DummyInt)
	{
		`log(DummyInt);
	}
	DummyIntArray.Sort(IntSort);
	`log("sorted int list");
	foreach DummyIntArray(DummyInt)
	{
		`log(DummyInt);
	}
	DummyStruct.Label = "A";
	DummyStruct.Value = 2.3f;
	DummyStructArray.AddItem(DummyStruct);
	DummyStruct.Label = "B";
	DummyStruct.Value = 1.62f;
	DummyStructArray.AddItem(DummyStruct);
	DummyStruct.Label = "C";
	DummyStruct.Value = 1.63f;
	DummyStructArray.AddItem(DummyStruct);
	`log("orig struct list:");
	foreach DummyStructArray(DummyStruct)
	{
		`log(DummyStruct.Label@DummyStruct.Value);
	}
	DummyStructArray.Sort(StructSort);
	`log("sorted struct list:");
	foreach DummyStructArray(DummyStruct)
	{
		`log(DummyStruct.Label@DummyStruct.Value);
	}
	DummyStringArray.AddItem("abcd");
	DummyStringArray.AddItem("abc");
	DummyStringArray.AddItem("ab");
	DummyStringArray.AddItem("abcde");
	DummyStringArray.AddItem("abcdef");
	DummyStringArray.AddItem("a");
	`log("orig string list:");
	foreach DummyStringArray(DummyString)
	{
		`log(DummyString);
	}
	DummyStringArray.Sort(StringSort);
	`log("sorted by length string list:");
	foreach DummyStringArray(DummyString)
	{
		`log(DummyString);
	}
	`log("!!!!!!!!!!!!!!");
}


exec function AddAIFilter( coerce string Filter )
{
	local NanoAI AI;
	local int Idx;
	local Name N;

	N = Name(Filter);
	foreach WorldInfo.AllControllers(class'NanoAI',AI)
	{
		Idx = AI.AILogFilter.Find( N );
		if( Idx < 0 )
		{
			AI.AILogFilter[AI.AILogFilter.Length] = N;
		}
	}
}
exec function RemoveAIFilter( coerce string Filter )
{
	local NanoAI AI;
	local int Idx;
	local Name N;

	N = Name(Filter);
	foreach WorldInfo.AllControllers(class'NanoAI',AI)
	{
		Idx = AI.AILogFilter.Find( N );
		if( Idx >= 0 )
		{
			Pawn.MessagePlayer( "Removed Filter"@Filter );
			AI.AILogFilter.Remove( Idx, 1 );
		}
	}
}


/** Will turn on/off the showing of the current attack name above the attacker's head **/
exec function ShowAttackNames( bool bShowAttackNames, bool bOnNonPlayer )
{
	local array<NanoMeleeWeaponSheet> Sheets;
	local NanoWeap_Melee Weap;
	local int Idx;

	// Get a list of all weapon sheets currently active in the game
	foreach AllActors( class'NanoWeap_Melee', Weap )
	{
		Idx = Sheets.Find( Weap.WeaponSheet );
		if( Idx < 0 )
		{
			Idx = Sheets.Length;
			Sheets[Idx] = Weap.WeaponSheet;
		}
	}

	for( Idx = 0; Idx < Sheets.Length; Idx++ )
	{
		Sheets[Idx].bDebugDrawAttackName = bShowAttackNames;
		Sheets[Idx].bDebugDrawAttackNameNonPlayer = bOnNonPlayer;
	}
}


exec function LogMeleeCombos( optional bool bShowAnimNames )
{
	local array<NanoMeleeWeaponSheet> Sheets;
	local NanoWeap_Melee Weap;
	local int Idx;
	local int MaxComboCount;
	local String ComboList;

	// Get a list of all weapon sheets currently active in the game
	foreach AllActors( class'NanoWeap_Melee', Weap )
	{
		Idx = Sheets.Find( Weap.WeaponSheet );
		if( Idx < 0 )
		{
			Idx = Sheets.Length;
			Sheets[Idx] = Weap.WeaponSheet;
		}
	}
	MaxComboCount = 25;

	`log( "LIST WEAPON SHEETS...");
	for( Idx = 0; Idx < Sheets.Length; Idx++ )
	{
		`log( ">>"@Sheets[Idx]@Sheets[Idx].MeleeAttacks.Length );
		ComboList = "";
		LogComboString( Sheets[Idx], 0, 0, MaxComboCount, ComboList, bShowAnimNames );
	}
}

function LogComboString( NanoMeleeWeaponSheet Sheet, int CurAttackIdx, int ComboCount, int MaxCount, String ComboList, bool bShowAnimNames )
{
	local int ComboIdx;

	if( CurAttackIdx > 0 )
	{
		ComboList = ComboList @ Sheet.MeleeAttacks[CurAttackIdx].AttackName;
		if( bShowAnimNames  )
		{
			ComboList = ComboList $ "(" $ Sheet.MeleeAttacks[CurAttackIdx].AttackAnimName $ ")";
		}
	}
	ComboCount++;
	if( ComboCount > MaxCount || Sheet.MeleeAttacks[CurAttackIdx].ComboAttacks.Length == 0 )
	{
		`log( ">>>>"@ComboList );
		`log( "WARNING: Hit max combo count... INF RECURSION COMBO?!", (ComboCount>MaxCount) );
		return;
	}

	for( ComboIdx = 0; ComboIdx < Sheet.MeleeAttacks[CurAttackIdx].ComboAttacks.Length; ComboIdx++ )
	{
		if( Sheet.MeleeAttacks[CurAttackIdx].ComboAttacks[ComboIdx].ComboAttackIdx < 0 )
			continue;

		LogComboString( Sheet, Sheet.MeleeAttacks[CurAttackIdx].ComboAttacks[ComboIdx].ComboAttackIdx, ComboCount, MaxCount, ComboList, bShowAnimNames );
	}
}

exec function TestDropPod()
{
	local int Idx;
	local Vector Dir, DropLoc;
	local Vector HitLocation, HitNormal;
	local Actor HitActor;
	local Rotator Rot;
	local NanoProj_DropPod Pod;

	Rot = rot(0,16384,0) * Rand(3);
	for( Idx = 0; Idx < 4; Idx++ )
	{
		Dir = Vector((Rot + rot(0,16384,0)) * Idx);
		DropLoc = Pawn.Location + Dir * 512.f;

		HitActor = Trace( HitLocation, HitNormal, DropLoc + vect(0,0,4096), DropLoc );
		if( HitActor == None )
		{
			Pod = Spawn( class'NanoProj_DropPod',,, DropLoc + vect(0,0,4096), Rotator(vect(0,0,-1)) );
			if( Pod != None )
			{
				Pod.SetPhysics( PHYS_Falling );
				Pod.SpawnDecalActor( DropLoc );
				break;
			}
		}
	}
}


exec function NPESOn()
{
    NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NPES.bActive = TRUE;
}

exec function NPESOff()
{
    NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NPES.bActive = FALSE;
}

exec function ShowVelocityHistory()
{
	NanoHUD_Base(myHUD).bDrawVelocityHistory = !NanoHUD_Base(myHUD).bDrawVelocityHistory;
}

exec function ShowResponseSystem()
{
	NanoHUD_Base(myHUD).bShowResponseSystem = !NanoHUD_Base(myHUD).bShowResponseSystem;
}


exec function TestMP7Summon()
{
	MyNP.TestSummonEffects( class'NanoWeap_MP7' );
}

exec function TestSwordSummon()
{
	MyNP.TestSummonEffects( class'NanoWeap_Sword' );
}




/** This is used to play the GoreTest anim on the pawn we are facing.  So the animators can test out the gore skeleton **/
exec function GoreTest()
{
	local NanoPawn GP;
	local int i;

	// look at all pawns and see if we should try to play a GoreTest anim on them
	foreach WorldInfo.AllPawns( class'NanoPawn', GP )
	{
		if( !GP.IsHumanControlled()
			&& IsAimingAt( GP, 0.1f ) // if we are semi looking in the direction of the pawn
			)
		{
			//GP.bUsingNewSoftWeightedGoreWhichHasStretchiesFixed = TRUE;
			GP.CreateGoreSkeleton( GP.GoreSkeletalMesh, GP.GorePhysicsAsset );

			for( i = 0; i < GP.GoreBreakableJoints.Length; ++i )
			{
				`log("  Breaking Joint:" @ GP.GoreBreakableJoints[i].ConstraintName );
				GP.BreakConstraint( vect(0,0,0), vect(0,0,0), GP.GoreBreakableJoints[i].ConstraintName );
			}

			`log( "Attempting to play GoreTest on: " $ GP );
			GP.FullBodySlot.PlayCustomAnim( 'GoreTest', 1.0f, 0.2f/1.0f, 0.2f/1.0f, FALSE, TRUE );
		}
	}
}


/**
 *
 * Usage:  GoreTestJointList (foo,bar,baz)
 **/
exec function GoreTestJointList( array<name> JointList )
{
	local NanoPawn GP;
	local int i;

	// look at all pawns and see if we should try to play a GoreTest anim on them
	foreach WorldInfo.AllPawns( class'NanoPawn', GP )
	{
		if( !GP.IsHumanControlled()
			&& IsAimingAt( GP, 0.1f ) // if we are semi looking in the direction of the pawn
			)
		{
			//GP.bUsingNewSoftWeightedGoreWhichHasStretchiesFixed = TRUE;
			GP.CreateGoreSkeleton( GP.GoreSkeletalMesh, GP.GorePhysicsAsset );

			for( i = 0; i < JointList.Length; ++i )
			{
				`log("  Breaking Joint:" @ JointList[i] );
				GP.BreakConstraint( vect(0,0,0), vect(0,0,0), JointList[i] );
			}

			`log( "Attempting to play GoreTestJointList on: " $ GP );
			GP.FullBodySlot.PlayCustomAnim( 'GoreTest', 1.0f, 0.2f/1.0f, 0.2f/1.0f, FALSE, TRUE );
		}
	}
}


/**
 *
 * Usage:  GoreTestRagdoll (foo,bar,baz) / GoreTestRagdoll ()
 **/
exec function GoreTestRagdoll( array<name> JointList )
{
	local NanoPawn GP;
	local name JointName;
	local GoreBreakableJoint NewJoint;

	// look at all pawns and see if we should try to play a GoreTest anim on them
	foreach WorldInfo.AllPawns( class'NanoPawn', GP )
	{
		if( !GP.IsHumanControlled()
			&& IsAimingAt( GP, 0.1f ) // if we are semi looking in the direction of the pawn
			)
		{
			//GP.bUsingNewSoftWeightedGoreWhichHasStretchiesFixed = TRUE;

			if( JointList.Length > 0 )
			{
				GP.GoreBreakableJoints.Length = 0;

				foreach JointList( JointName )
				{
					NewJoint.ConstraintName = JointName;
					GP.GoreBreakableJoints.AddItem( NewJoint );
					//	GP.GoreBreakableJointsTest.ConstraintName = JointName;
					//	GP.GoreBreakableJoints.ConstraintName = JointName;
				}
			}

			GP.CreateGoreSkeleton( GP.GoreSkeletalMesh, GP.GorePhysicsAsset );
			GP.TakeDamage( 10000.0f, Outer, GP.Location, vect(0,0,0), class'NDT_Explosive' );
		}
	}
}



exec function GunSmoke()
{
	local vector Loc;

	Loc = NanoGRI(WorldInfo.GRI).FindLocationToSpawnPostBattleGunSmoke( Pawn.Location, 2048.0f );

	// if we didn't find any dead bodies to center the box on
	if( VSize(Loc) == 0 )
	{
		Loc = Pawn.Location;
	}

	Spawn( class'Emit_GunSmoke',,,Loc );

}


/**
 * Additional console commands for killing various players, strictly for
 * testing purposes.
 */
exec function Kill(optional string type)
{
	local NanoPawn NanoPawn;
	local Vehicle V;
	local AIController ai;

	if (type ~= "ai" || type ~= "bots" || type ~= "all")
	{
		foreach DynamicActors(class'AIController',ai)
		{
			V = Vehicle(ai.Pawn);
			if( V != None )
			{
				V.DriverLeave( TRUE );
			}

			NanoPawn = NanoPawn(ai.Pawn);
			if (NanoPawn != None)
			{
				NanoPawn.ScriptedDeath();
			}
			ai.Destroy();
		}
	}
}

/** Will spawn some blood on camera and then FOV in and out **/
exec function TestBloodFOV()
{
	local NanoGRI NGRI;

	ClientSpawnCameraLensEffect( class'Emit_Camera_UpCloseGoreMega' );

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	NGRI.SetOverrideFOV(35.0f);
	NGRI.SetTimer( 2.0f, FALSE, nameof(NGRI.ResetFOV) );
}


/** Test function to fix up PostPhysicsSkelControl modifying bodies that have been cut off **/
exec function Armless()
{
	local NanoAI AI;
	local Name OverrideDeathAnimName;
	local vector foo;

	TargetCircle( 1 );

	ActivateAI();

	foo = vect(0,0,0);

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		NanoGRI(WorldInfo.GRI).NGM.ShouldPlayNanoGoreEffect( TRUE, 'SliceLeftArmOff', NanoPawn(AI.Pawn), foo, foo, TRUE, OverrideDeathAnimName );
		NanoPawn(AI.Pawn).bDismemberedAndDying = TRUE;
	}
}


/** Can spawn friendlies or enemies. */
exec function AIController SpawnPawn(optional string Type, optional bool bDummy)
{
	//local NavigationPoint Nav;
	local Pawn NewPawn;
	local NanoAIBase NewAI;
	local class<Pawn> PawnClass;
	local class<NanoAIBase> AIClass;
	local INT	i;
	local byte TeamNum;

//	if (Pawn != None)
//	{
//		Nav = class'NavigationPoint'.static.GetNearestNavToActor(Pawn,,,128.f);
//	}
//
//	if (Nav == None)
//	{
//		Nav = class'NavigationPoint'.static.GetNearestNavToPoint((Pawn != None) ? Pawn : Outer, (Pawn != None) ? Pawn.Location : Location);
//	}
	
// 	if (Nav == None)
// 	{
// 		if (Pawn != None)
// 		{
// 			Nav = Pawn.Anchor;
// 		}
// 	}




	if (Pawn != None)
	{
		// See if we can find a matching creature type.
		for(i=0; i<SpawnPawnList.Length; i++)
		{
			if( SpawnPawnList[i].PawnName ~= Type )
			{
				PawnClass = class<Pawn>(DynamicLoadObject(SpawnPawnList[i].ClassName,class'class'));
				AIClass = class<NanoAI>(DynamicLoadObject(SpawnPawnList[i].AIClassName,class'class'));
				TeamNum = SpawnPawnList[i].TeamNum;
				break;
			}
		}

		if( PawnClass == None )
		{
// 			if(!FindSpawnInfoFromAIFactory(Type, PawnClass, AIClass, TeamNum))
// 			{
				PawnClass = class<Pawn>(DynamicLoadObject("NanoGameContent.NanoPawn_MetaCorp_RiotCop",class'class'));
				AIClass = class'NanoAI_Trooper';
				TeamNum = 1;
//			}
		}

		if (PawnClass != None && AIClass != None)
		{
			`DLog("Spawning type:" @ Type @ "PawnClass:" @ PawnClass @ "AIClass:" @ AIClass @ "at" @ Pawn );

			NewPawn = Spawn( PawnClass,,, Pawn.Location + 512*vector(Pawn.Rotation), rotator(Pawn.Location - Pawn.Location) );
			if (NewPawn != None)
			{
				NewAI = Spawn(AIClass);
				if (NewAI != None)
				{
					if (bDummy)
					{
						NewAI.bTargetDummy = true;
						NewAI.bIsScripted = true;
					}

					`log( "setting Team to:" @ `showvar(TeamNum) );

					if (TeamNum != 255)
					{
						NewAI.SetTeam(TeamNum);
					}
					else
// 					else if (GearAI_COGGear(NewAI) != None)
// 					{
// 						NewAI.SetTeam(0);
// 					}
// 					else
					{
						NewAI.SetTeam(1);
					}

					NewAI.Possess(NewPawn,FALSE);
					NewPawn.AddDefaultInventory();

// 					if ( bDummy && (GearAI(NewAI) != None) )
// 					{
// 						GearAI(NewAI).bAllowCombatTransitions = FALSE;
// 					}

					return NewAI;
				}
				else
				{
					NewPawn.Destroy();
				}
			}
		}
	}

	return None;
}

exec function FlushPeds()
{
	GameCrowdPopulationManager(WorldInfo.PopulationManager).FlushAgents();
}

exec function GiveMeAGun()
{
	local NanoPC PC;
	local NanoPRI NPRI;

	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
		break;
	}


	NPRI = NanoPRI(PC.PlayerReplicationInfo);

	NPRI.GiveNanoPlan(class'NanoPlan_MP7', TRUE);
	NPRI.EquipNanoPlan(class'NanoPlan_MP7');
	NPRI.GiveNanoPlan(class'NanoPlan_Pistol', TRUE);
}


/** Will kill off AI with NDT_KilledByProceduralSpawner**/
exec function ForceKillAllAI( float DistanceFromYou )
{
	local vector PlayerLocation;
	local NanoAI AI;


	PlayerLocation = NanoGRI(WorldInfo.GRI).NPES.GetPlayerLocation();

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( AI.Pawn != None )
		{
			if( ( VSize(AI.Pawn.Location - PlayerLocation ) > DistanceFromYou )
				)
			{
				`log( "DoEnemyCleanUp kill off" @ AI @ VSize(AI.Pawn.Location - PlayerLocation) );
				AI.Pawn.Died( None, class'NDT_KilledByProceduralSpawner', AI.Pawn.Location );
			}
		}
	}
}

exec function CycleForgePose( optional int Idx )
{
	local NSM_ForgePose SM;

	MyNP.DoSpecialMove( 'NSM_ForgePose', TRUE );
	SM = NSM_ForgePose(MyNP.ActiveSpecialMove);
	if( Idx == 0 )
	{
		SM.DesiredIdx++;
	}
	else
	{
		SM.DesiredIdx = Idx - 1;
	}
}

exec function CycleInputType()
{
	local int Idx;
	local class<PlayerInput> PIC;

	PIC = PlayerInput.Class;
	Idx = Interactions.Find(PlayerInput);
	if( Idx >= 0 )
	{
		Interactions.Remove(Idx,1);
	}
	PlayerInput = None;

	Idx = InputCycleList.Find(PIC);
	Idx = ((Idx+1)%InputCycleList.Length);
	InputClass = InputCycleList[Idx];

	InitInputSystem();

	ClientMessage( "Input:"@PlayerInput );
}

exec function TestResponseSystemEvent()
{
	NanoGRI(WorldInfo.GRI).NRSAM.PlayEvent( ENRS_Player_ShouldFleeTheScene, None );
}



exec function DoPhalanx()
{
	NanoGRI(WorldInfo.GRI).AIBlackboard.bDoPhalanx = TRUE;
}


exec function ShowCrowdMembers()
{
	local GameCrowdPopulationManager PopMgr;
	local GameCrowdAgent Agent;
	local int i;


	ForEach DynamicActors(class'GameCrowdPopulationManager', PopMgr)
	{
		break;
	}


	for( i = 0; i < PopMgr.AgentArchetypes.length; i++ )
	{
		`log( `showvar(PopMgr.AgentArchetypes[i].AgentArchetype) @ `showvar(PopMgr.AgentArchetypes[i].CurrSpawned) @ `showvar(PopMgr.AgentArchetypes[i].MaxAllowed) );
	}

	ForEach PopMgr.AgentPool( Agent )
	{
		`log( `showvar(Agent) );
	}


	foreach DynamicActors( class'GameCrowdAgent', Agent )
	{
		`log( `showvar(Agent.MyArchetype) );
	}
}


/** shortcut for the lazy :-) **/
exec function UA()
{
	UnlimitedAmmo();
}

/** Gives all carried weapons unlimited ammo */
exec function UnlimitedAmmo()
{
	local NanoWeapon	Weap;

	if( (WorldInfo.NetMode!=NM_Standalone) || (Pawn == None) )
		return;

	ClientMessage("Unlimited ammo!");
	//if( NanoPawn(Pawn) != None )
	//{
	//	GearPawn(Pawn).bUnlimitedAmmo = true;
	//}

	ForEach Pawn.InvManager.InventoryActors(class'NanoWeapon', Weap)
	{
		Weap.SetInfiniteMagazineSize();	// disable reloads
		Weap.SetInfiniteSpareAmmo();	// unlimited spare ammo
	}
}

/** shortcut for the lazy :) */
exec function UC()
{
	UnlimitedClips();
}

/** gives unlimited clips */
exec function UnlimitedClips()
{
	if( (WorldInfo.NetMode!=NM_Standalone) || (Pawn == None) )
		return;

	ClientMessage("Unlimited clips!");
	if( NanoPawn(Pawn) != None )
	{
		NanoPawn(Pawn).SetUnlimitedClips( TRUE );
	}
}





exec function SetWeaponScale( optional float F )
{
	if( F <= 0.f )
	{
		F = 1.f;
	}
	Pawn.Weapon.Mesh.SetScale( F );
}

exec function GiveMeAllWeapons()
{
	local NanoPC PC;
	local NanoPRI NPRI;

	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
		break;
	}

	NPRI = NanoPRI(PC.PlayerReplicationInfo);

	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_Knife", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_Sword", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_Staff", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_MP7", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_Pistol", class'Class')), TRUE );


	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_AssaultRifle", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_GrenadeLauncher", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_ShotgunSemiAuto", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Suitcase", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_RPG", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_SMG", class'Class')), TRUE );


	// new pistols
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_BensGun", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_BurstStorm", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HandCannon", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HeavyAutomatic", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HeavyRevolver", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HoldOutPistol", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_LookerGun", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_SemiAutoPistol", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_ShotGunRevolver", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_SniperPistol", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_SnubNoseRevolver", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_StunGun", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_TazerAdvanced", class'Class')), TRUE );


	//NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Orbitals", class'Class')), TRUE );

	NPRI.GiveMaxAmmoForUnlockedWeapons( NanoPawn(Pawn) );
}


exec function GiveMeAllWeaponMods()
{
	local NanoPC PC;
	local NanoPRI NPRI;

	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
		break;
	}

	NPRI = NanoPRI(PC.PlayerReplicationInfo);


	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_ButterflyBullets", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_DenseBullets", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_ExplosiveBullets", class'Class')), TRUE );

	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_QuickReload", class'Class')), TRUE );

}

/**
 * Little bit of a misnomer, but this is for the items that go in the utility slot.
 **/
exec function GiveMeAllForgeables()
{
	local NanoPC PC;
	local NanoPRI NPRI;

	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
		break;
	}

	NPRI = NanoPRI(PC.PlayerReplicationInfo);


	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_SentryTurret", class'Class')), TRUE );


	// these should be moved to NanoGameContent
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_RebelSuperBomb", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_RebelAntenna", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HealthTotem", class'Class')), TRUE );

	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_BulletMagnet", class'Class')), TRUE );

	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Thruster", class'Class')), TRUE );


	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_Boulder", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_ForgeRockets", class'Class')), TRUE );	
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_ForgeRockets_Homing", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_RebelHandPrint", class'Class')), TRUE );

	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Thruster", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Orbitals", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Mine", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Attractor", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_ShieldWall", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HealthTotem", class'Class')), TRUE );
	NPRI.GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Cannon", class'Class')), TRUE );
	

}


exec function GiveMeAllPlans()
{
	GiveMeAllWeapons();
	GiveMeAllWeaponMods();
	GiveMeAllForgeables();
}


exec function DoTrip()
{
	NanoPawn(Pawn).DoSpecialMove( 'NSM_Tripped', TRUE );
}

exec function DoStunnedAndDazed ()
{
	NanoPawn(Pawn).DoSpecialMove( 'NSM_StunnedAndDazed', TRUE );
}





//// Manual AI  ( MAI_ ) Section

exec function MAI_NearestGuyAttack()
{
	local NanoPC PC;
	local vector PlayerLocation;
	local NanoAI AI;
	local float DistToPlayer;
	local float ClosestDistance;
	local NanoAI ClosestAI;

	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
		PlayerLocation = PC.Pawn.Location;
		break;
	}


	ClosestDistance = 9999999999;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( AI.Pawn != None )
		{
			DistToPlayer = VSize(AI.Pawn.Location - PlayerLocation);
			if( DistToPlayer < ClosestDistance )
			{
				ClosestDistance = DistToPlayer;
				ClosestAI = AI;
			}
		}
	}

	if( ClosestAI != None )
	{
		ClosestAI.bMAI_ClosestPawn = TRUE;
		ClosestAI.bMAI_OverrideAttackPacing = TRUE;
		`log( "MAI_NearestGuyAttack" @ `showvar(ClosestAI) );
	}
}

exec function MAI_EveryOneAttack()
{
	local NanoAI AI;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( AI.Pawn != None )
		{
			AI.bMAI_ClosestPawn = TRUE;
			AI.bMAI_OverrideAttackPacing = TRUE;
			`log( "MAI_EveryOneAttack" @ `showvar(AI) );
		}
	}
}

exec function MAI_DogPile()
{
}

exec function MAI_BackUpAwayFromPlayer( float DurationToKeepBackedUp )
{
	// i guess we just set the melee rings to only have stand by
	// and then restore to real values after a N seconds

	// ??? blah
}


exec function MAI_PursueAndEngage()
{
}

exec function MAI_FormAFormation()
{
}

exec function MAI_SingleGrabAttempt()
{
	NanoGRI(WorldInfo.GRI).AIBlackboard.bMAI_DoAGrabAttack = TRUE;
}

exec function MAI_SingleGrabAndBeatAttempt()
{
	NanoGRI(WorldInfo.GRI).AIBlackboard.bMAI_DoAGrabAndBeatAttack = TRUE;
}

exec function MAI_SingleRangeShooting()
{
	local NanoAI AI;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		// just choose the first AI
		if( AI.Pawn != None )
		{
			AI.bMAI_RangeAttackPlayer = TRUE;
			AI.bMAI_OverrideAttackPacing = TRUE;
			`log( "MAI_SingleRangeShooting" @ `showvar(AI) );
			break;
		}
	}
}

exec function MAI_1()
{
}

exec function MAI_2()
{
}

exec function MAI_3()
{
}

exec function MAI_4()
{
}

exec function MAI_5()
{
}

exec function MAI_6()
{
}

exec function MAI_7()
{
}





defaultproperties
{
	InputCycleList.Add(class'NanoPlayerInput')
}
