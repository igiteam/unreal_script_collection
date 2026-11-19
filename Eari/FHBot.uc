/*
// FHBot class
// David Lewis
// 9/11/2011
// This is for testing monster pathing.

class FHBot extends UTPawn
	placeable
	ClassGroup(ForeverHunted);


var AnimTree         defaultAnimTree;
var array<AnimSet>   defaultAnimSet;
var AnimNodeSequence defaultAnimSeq;

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// System Overrides
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

            simulated function PostBeginPlay()
            {
				Super.PostBeginPlay();
            }


            //override to do nothing
            simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
            {
            }


DefaultProperties
    {
///////////////////////////////////////////////////////////////
// Do not Modify the following variables

	Begin Object class=SkeletalMeshComponent Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'Monster_Temp.Monster_temp_01'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		Materials(1) = Material'rap.rap_M'
		bHasPhysicsAssetInstance = true
		bEnableSoftBodySimulation = true
		bSoftBodyAwakeOnStartup = true
		bAcceptsDynamicDecals = true
		AnimSets(0) = AnimSet'Monster_Temp.Monster_temp_01_Anims'
		AnimTreeTemplate = AnimTree'Monster_Temp.Monster_Temp_Animtree'
	End Object
	Mesh=SkeletalMeshComponent0
	Components.Add(SkeletalMeshComponent0)

	Begin Object Name=CollisionCylinder
		CollisionRadius=+0010.000000
		CollisionHeight=+0064.000000
		BlockZeroExtent=false
	End Object
	CylinderComponent=CollisionCylinder
	CollisionComponent=CollisionCylinder

	bCollideActors=true
	bPushesRigidBodies=true
	bStatic=False
	bMovable=True

	bAvoidLedges=true
	bStopAtLedges=true

	MaxStepHeight = 0
	MaxJumpHeight = 5
	bJumpCapable = false;
	//bCanJump = false

	GroundSpeed = 500

	LedgeCheckThreshold=10

	ControllerClass=class'FHAIController'
    }
*/


class FHBot extends UDKPawn
    placeable;


// Decompiled with UE Explorer.
defaultproperties
{
    bJumpCapable=false
    bCanJump=false
    GroundSpeed=200.0000000
    ControllerClass=Class'FHAIController'
    // Reference: CylinderComponent'Default__FHBot.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'UDKBase.Default__UDKPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=44.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__FHBot.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Sprite'
    // Archetype: SpriteComponent'UDKBase.Default__UDKPawn.Sprite'
    begin object name="Sprite"
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: ArrowComponent'Default__FHBot.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Arrow'
    // Archetype: ArrowComponent'UDKBase.Default__UDKPawn.Arrow'
    begin object name="Arrow"
        ReplacementPrimitive=none
    end object
    Components[2]=Arrow
    CollisionComponent=CollisionCylinder
}