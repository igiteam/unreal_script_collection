// this functionality has been implemented in base unreal now [PETAR] April 27, 2006

class TPSkeletalMeshActor extends SkeletalMeshActor
    native
	placeable;
	

var SeqAct_PlayPerformance performanceAction;
var CylinderComponent   CylinderComponent;
var() ECrosshairIFF Team;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// Start ragdolling
final native function InitRagdoll();


function OnPlayPerformance(SeqAct_PlayPerformance action)
{
    local int i;
    local bool bAnimSetFound;
	
    if( SkeletalMeshComponent!=None)
	{       
        if(action.PerformanceAnimSet != none)
		{
            for(i=0; i<SkeletalMeshComponent.AnimSets.Length; i++)
		    {
                if(SkeletalMeshComponent.AnimSets[i] == action.PerformanceAnimSet)
		        {   
		            bAnimSetFound = true;
		            break;
		        }
		    }
		      
		    if(!bAnimSetFound)
		    {
                SkeletalMeshComponent.AnimSets.AddItem(action.PerformanceAnimSet);	  
		    }

        }
		
        SkeletalMeshComponent.SetAnimTreeTemplate( action.PerformanceAnimTree );

		performanceAction = action;

		SetPlaySceneOptions( action );
	}
}

function OnSetTeam(SeqAct_SetTeam action)
{
    Team = action.Team;
}

function OnEndPerformance(SeqAct_EndPerformance action)
{
    OnPerformanceEnd();
}

native function AnimTree GetDefaultAnimTree();

native function FinishPerformance();
// {
// 	//This activates the output on the sequence action
// 	// abort any previous latent moves
// 	ClearLatentAction(class'SeqAct_PlayPerformance');
// 
// 	if( SkeletalMeshComponent!=None )
// 	{
// 		//Set the Root motion mode back to ignore - should this be an option?
// 		SkeletalMeshComponent.RootMotionMode=RMM_Ignore;
// 
// 		//Set the Root rotation mode back to ignore - should this be an option?
// 		SkeletalMeshComponent.RootMotionRotationMode = RMRM_Ignore;
// 
// 		//Reset the animtree back to default
// 		SkeletalMeshComponent.SetAnimTreeTemplate( Default.SkeletalMeshComponent.AnimTreeTemplate );
// 
// 	}
// 
// }

//should this event be in actor?
native function  OnPerformanceEnd();
// {
//     FinishPerformance();
// }

function SetPlaySceneOptions( SeqAct_PlayScene action )
{
	local bool bSetActorCollision;
	local bool bNewCollideActors;
	local bool bNewBlockActors;

	bSetActorCollision = false;
	bNewCollideActors = bCollideActors;
	bNewBlockActors = bBlockActors;

	//Turn off physics... TP reinstated this for root rotation.
	SetPhysics(PHYS_None);

	if (action.m_bCollideWorld != ETO_LeaveAlone)
	{
		if (action.m_bCollideWorld == ETO_Enable)
		{
			bCollideWorld = true;
		}
		else
		{
			bCollideWorld = false;
		}
	}


	if (action.m_bCollideActors != ETO_LeaveAlone)
	{
		bSetActorCollision = true;
		if (action.m_bCollideActors == ETO_Enable)
		{
			bNewCollideActors = true;
		}
		else
		{
			bNewCollideActors = false;
		}
	}

	if (action.m_bBlockActors != ETO_LeaveAlone)
	{
		bSetActorCollision = true;
		if (action.m_bBlockActors == ETO_Enable)
		{
			bNewBlockActors = true;
		}
		else
		{
			bNewBlockActors = false;
		}
	}

	if (bSetActorCollision == true)
	{
		SetCollision(bNewCollideActors, bNewBlockActors);
	}

	if (action.m_bPathColliding != ETO_LeaveAlone)
	{
		if (action.m_bPathColliding == ETO_Enable)
		{
			bPathColliding = true;
		}
		else
		{
			bPathColliding = false;
		}
	}

	if (action.PhysicsInfo.m_bSetPhysics)
	{
		SetPhysics(action.PhysicsInfo.m_bOverridePhysics);
	}



	//Set the Root motion mode - should this be an option?
	SkeletalMeshComponent.RootMotionMode=RMM_Translate;

	//Set the Root rotation mode - should this be an option?
	SkeletalMeshComponent.RootMotionRotationMode = RMRM_RotateActor;
}

function OnSetRagdoll(SeqAct_SetRagdoll action)
{
    FinishPerformance();
    InitRagdoll();
    SetTimer(action.RagdollTimer,,'DestroyTPSkelMesh');
}

function DestroyTPSkelMesh()
{
    ClearLatentAction(class'SeqAct_SetRagdoll');
    Destroy();
}


