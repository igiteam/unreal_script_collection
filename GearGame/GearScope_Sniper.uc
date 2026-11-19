/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearScope_Sniper extends Actor
	config(Weapon);

/** How far off the camera the scope should be positioned */
var config vector ScopeOffset;

/** Reference to the mesh of the scope */
var MeshComponent Mesh;

/** Where to start the scope's initial lerp in */
var config vector ScopeInitialOffset;

/** How long the initial lerp should take */
var config float ScopeInitTime;

/** When the scope was turned on */
var transient float ScopeEnableTime;

/** Reference to the scope effect in the post process chain */
var transient MaterialEffect ScopePostProcessEffect;

/** MIC to control the scope effect in the post process chain */
var transient MaterialInstanceConstant PostProcessMIC;

/** Name of the post process to enable */
var name PostProcessName;

/** Move the scope in front of the camera */
simulated function PositionScope()
{
	local GearWeapon GW;
	local GearPC PC;
	local vector CamLoc;
	local rotator CamRot;
	local vector ScopeCurrentOffset;

	GW = GearWeapon(Owner);
	if (GW != None)
	{
		PC = GearPC(GW.GetWeaponController());
		if (PC != None)
		{			
			if (`TimeSince(ScopeEnableTime) < ScopeInitTime)
			{
				ScopeCurrentOffset = VLerp(ScopeInitialOffset, ScopeOffset, `TimeSince(ScopeEnableTime) / ScopeInitTime);
				
				if (PostProcessMIC != None)
				{
					PostProcessMIC.SetScalarParameterValue('Opacity', Lerp(0, 1, `TimeSince(ScopeEnableTime) / ScopeInitTime));
				}
			}
			else
			{
				ScopeCurrentOffset = ScopeOffset;

				if (PostProcessMIC != None)
				{
					PostProcessMIC.SetScalarParameterValue('Opacity', 1.0f);
				}
			}

			PC.GetPlayerViewPoint(CamLoc, CamRot);
			SetLocation(CamLoc + (ScopeCurrentOffset >> CamRot));
			SetRotation(CamRot);

			// Kick deferred transform in the face
			DetachComponent(Mesh);
			AttachComponent(Mesh);
		}
	}
}

/**
 * Position the scope
 * 
 * @param DeltaTime - the length of the last frame
 */
simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	
	if (bHidden)
	{
		return;
	}

	PositionScope();
}

/** Turn on the scope */
simulated function EnableScope()
{
	local GearWeapon GW;
	local GearPC PC;
	local GearPawn GP;
	local Vector2D ViewportSize;

	ScopeEnableTime = WorldInfo.TimeSeconds;

	if (PostProcessName != '')
	{
		GW = GearWeapon(Owner);
		if (GW != None)
		{
			PC = GearPC(GW.GetWeaponController());
			if (PC != None)
			{
				GP = GearPawn(PC.Pawn);
				if (GP != None && GP.bIsMirrored)
				{
					Mesh.SetScale3D(vect(-1,1,1));
				}
				else
				{
					Mesh.SetScale3D(vect(1,1,1));
				}
			}
		}

		if (ScopePostProcessEffect == None || PostProcessMIC == None)
		{
			if (PC != None && LocalPlayer(PC.Player) != None)
			{
				ScopePostProcessEffect = MaterialEffect(LocalPlayer(PC.Player).PlayerPostProcess.FindPostProcessEffect(PostProcessName));
				if (ScopePostProcessEffect != None)
				{
					if (ScopePostProcessEffect.Material.GetPackageName() != 'Transient')
					{
						PostProcessMIC = new(ScopePostProcessEffect) class'MaterialInstanceConstant';
						PostProcessMIC.SetParent(ScopePostProcessEffect.Material);
						ScopePostProcessEffect.Material = PostProcessMIC;
					}
					else
					{
						PostProcessMIC = MaterialInstanceConstant(ScopePostProcessEffect.Material);
					}
				}
			}
		}

		if (ScopePostProcessEffect != None)
		{
			ScopePostProcessEffect.bShowInGame = true;
		}

		if (PostProcessMIC != None)
		{
			LocalPlayer(PC.Player).ViewportClient.GetViewportSize(ViewportSize);

			if ((ViewportSize.Y > 0.f) && (ViewportSize.X/ViewportSize.Y > 1.7))
			{
				PostProcessMIC.SetScalarParameterValue('WideScreen', 1.0f);
			}
			else
			{
				PostProcessMIC.SetScalarParameterValue('WideScreen', 0.0f);
			}

			if (class'Engine'.static.IsSplitScreen())
			{
				PostProcessMIC.SetScalarParameterValue('Splitscreen', 1.0f);
			}
			else
			{
				PostProcessMIC.SetScalarParameterValue('Splitscreen', 0.0f);
			}

			PostProcessMIC.SetScalarParameterValue('Opacity', 0.0f);

			if (PC != None && PC.GetTeamNum() == 1)
			{
				PostProcessMIC.SetScalarParameterValue('Locust', 1.0f);
			}
			else
			{
				PostProcessMIC.SetScalarParameterValue('Locust', 0.0f);
			}
		}
	}

	SetHidden(false);
	PositionScope();
}

/** Turn off the scope */
simulated function DisableScope()
{
	SetHidden(TRUE);

	// Think the hidden call might be getting deferred, just go hardcore and detach the component.
	DetachComponent(Mesh);

	if (ScopePostProcessEffect != None)
	{
		ScopePostProcessEffect.bShowInGame = false;
	}

	if (PostProcessMIC != None)
	{
		PostProcessMIC.SetScalarParameterValue('Opacity', 0.0f);
	}
}

/** Turn off the scope if destroyed */
simulated function Destroyed()
{
	Super.Destroyed();

	DisableScope();
}

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		StaticMesh=StaticMesh'COG_SniperRifle.Mesh.COG_Sniper_Scope_Zoom'
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		bDisableAllRigidBody=true
		bAllowAmbientOcclusion=false
		DepthPriorityGroup=SDPG_Foreground
		Rotation=(Yaw=16384)
		bOnlyOwnerSee=true
	End Object
	Mesh=StaticMeshComponent0

	PostProcessName="SniperScope"

	TickGroup=TG_PostUpdateWork

	bHidden=true
	bStatic=false
	bNoDelete=false
	bGameRelevant=true
}
