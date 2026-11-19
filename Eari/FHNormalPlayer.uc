// Description of purpose of this class - Please flesh out
// Adding Author
// Date Added

class FHNormalPlayer extends FHPlayer
    notplaceable;

var SoundCue       CuePlayerSprinting;
var AudioComponent AudioPlayerSprinting;
var FHDieMenu	DieMenuMovie;
var AnimNodeBlend sprint;
var SkeletalMesh liandri;
var SkeletalMesh clarke;
var float timeSinceFiringStopped;
var bool firing;
var bool sprayingEnabled;
var float timeSinceSlideStopped;

var AnimNodeBlend currentAnimation;
var float animationPlayTime;
var float animationMaxPlayTime;

var FHPlayerController fhController;

//////////////////////////////////////////////////////////////////////////////
// Sprinting - Robert Lamb 
// 4/4/11

    var float    SprintSpeedModifier;                   // How many times faster is sprinting than walking?
	var float    SprintMinSpeed;                        // you have to be going at least this fast to start sprinting
    var float    SprintStopFiringSpeedModifier;         // Speed at which you are moving too fast to be spraying paint
    var float    SprintMaxStamina;                      // Players max stamina (eg, 18) in stamina units
    var float    SprintMinStamina;                      // Players min stamina (eg,  1)
    var float    SprintCurrentStamina;                  // Players current stamina, [min, max]
    var float    SprintStaminaDepletionRatePerSecond;   // How much stamina is depleted per second while sprinting
    var float    SprintStaminaRestorationRatePerSecond; // How much stamina is replenished per second while not sprinting
    var float    SprintTickTimeInSeconds;               // How long between sprint restore/deplete recalculations (eg, 0.2 seconds)
	var float    CurrentSpeed;
	var bool    bIsSliding;							// True if player is sliding, false if player is out of a slide.
	var bool	  slidePrep;							// Variable to make sure the player can only enter a slide from a standing position.
	var float	  SlideDistance;						// The stamina amount you get to use through a slide.

	var PersistantData pdata;

//////////////////////////////////////////////////////////////////////////////
// Floor Camera - Robert Lamb
// 9/27/11
// Pressing 'z' will toggle to a floor camera useful for debugging the player height

	var bool  bUseFloorCamera;      // if true, camera is moved to near the floor
	var bool  bMovingFloorCamera;
	var bool  bYawingFloorCamera;
	var bool  bPitchingFlyCam;
	var float bFloorCameraAmount;   // working var for Moving and Yawing
	var float FloorCameraAdjustZ;   // moves the floor camera up or down slightly
	var float FloorCameraDistance;  // how far away from the player the camera is located
	var float FloorCameraAngle;      // 0 looks forward, 180 looks backwards
	var float FloorCameraMovementSpeed;
	var float FloorCameraYawSpeed;
	var float FlyCameraPanSpeed;
	var float FlyCameraPitchSpeed;
	var float FlyCameraMinDistance; // camera is always at least this distance from player

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// Player Overrides
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

    function InitializePlayer()
        {
        LogInternal("FHNormalPlayer.PlayerInitialize() --");
        Super.InitializePlayer ();
		// Hack to get player to paint on first shot
        StartFire(1);
		StopFiring();
        AudioPlayerSprinting   = CreateAudioComponent (CuePlayerSprinting);
        }

    function PlayerTick (float deltaSeconds)
        {
        Super.PlayerTick (deltaSeconds);
		if (bUseFloorCamera)
			{
			if (bMovingFloorCamera)      FloorCameraAdjustZ += bFloorCameraAmount;
			else if (bYawingFloorCamera) FloorCameraAngle   += bFloorCameraAmount;
			}
			timeSinceFiringStopped += deltaSeconds;
			timeSinceSlideStopped += deltaSeconds;
			animationPlayTime += deltaSeconds;
			FHPlayerController(Controller).SetBehindView(!firing &&
				timeSinceFiringStopped > FHWeap_SprayPaintCan(Weapon).armAnimationTime);
			if(firing && bIsCrouched && VSizeSq(Velocity) > 0)
				StopFiring();
	
			if(animationPlayTime > animationMaxPlayTime && currentAnimation != none)
			{
				currentAnimation.SetBlendTarget(0.0, 1.0);
				currentAnimation = none;
			}
        }

    function PlayerBumped (Actor Other)
        {
        local FHMonster lMonster;

        Super.PlayerBumped (Other);
	    LogInternal("FHNormalPlayer.Bump() -- Bumped into by " $ Other);

        if (bInvulnerable) return;

        lMonster = FHMonster(Other);
        if (lMonster != none && !bIsSliding) 
            {
				//SetCollisionSize(0,0);
				LogInternal("FHNormalPlayer.Bump() -- Player is brutally shredded by the Monster!!!!");
				//TakeDamage (999999, lMonster.Controller, self.Location, vect(0, 0, 0), class'DmgType_Crushed');
				//GotoState('IsDying');
				// This will triger the FHPlayerDeath event in the level.
				TriggerPlayerDeath();
            }
        }

	function TriggerPlayerDeath()
	{
		local array<SequenceObject> out_array;
		local Sequence GameSeq;
		local int i;
 
		GameSeq = WorldInfo.GetGameSequence();
 
		if(GameSeq != None)
		{
			GameSeq.FindSeqObjectsByClass(class'FHPlayerDeathEvent', true, out_array);

			for (i = 0; i < out_array.Length; i++)
			{
				FHPlayerDeathEvent(out_array[i]).CheckActivate(self, self, false);
			}
		}
	}

	function Suicide()
	{
		TriggerPlayerDeath();
	}

	function saveStats()
	{
		pdata = new(none) class 'PersistantData';
		pdata.saveRoundOverStats(SurvivalTimeInSeconds);
	}

    function PlayerDied ()
        {
        Super.PlayerDied ();
        LogInternal("FHNormalPlayer.Died() -- bye bye");
        }

    function PlayerWon ()
        {
        Super.PlayerWon ();
        }

    function float GetPlayerScore ()
        {
        return PlayerScore;
        }

	state() IsDying
		{
			ignores Bump, Touch;

		Begin:
		Sleep(2.5);
		saveStats();
		//BringUpPlayerDiedMenu();
		//Sleep(3);
		//UTPlayerController(Controller).RestartLevel();

		//WorldInfo.Reset();
		//WorldInfo.ConsoleCommand("restartlevel");
		}

//////////////////////////////////////////////////////////////////////////////
// Sprinting - Robert Lamb 
// 4/4/11

	state() IsStandingAndSprinting
		{
		event BeginState (Name previousStateName)
			{
			LogInternal("IsStandingAndSprinting");
			CurrentSpeed = VSize(Velocity);
			if (CurrentSpeed < SprintMinSpeed)
				{
				SprintFXOff();
				}
			}

		event EndState (Name nextStateName)
			{
			CurrentSpeed = VSize(Velocity);
			if (CurrentSpeed > SprintMinSpeed)
				{
				SprintFXOn();
				}
			}

		Begin:
			CurrentSpeed = VSize(Velocity);
			if (CurrentSpeed >= SprintMinSpeed) GotoState ('IsSprinting');
            Sleep (SprintTickTimeInSeconds);
			if (SprintCurrentStamina < SprintMaxStamina) RestoreStamina();
            goto ('Begin');
		}

    state() IsSprinting
        {
		event BeginState (Name previousStateName)
			{
			LogInternal("IsSprinting");
			}

        Begin:
			CurrentSpeed = VSize(Velocity);
			if (CurrentSpeed <  SprintMinSpeed) GotoState('IsStandingAndSprinting');
            Sleep (SprintTickTimeInSeconds);
            SprintCurrentStamina -= SprintStaminaDepletionRatePerSecond * SprintTickTimeInSeconds;
            if (SprintCurrentStamina <= SprintMinStamina)
                {
                LogInternal("FHNormalPlayer -- State:IsSprinting -- Stamina Depleted, stopping sprinting");
                SprintCurrentStamina = SprintMinStamina;
                StopSprinting ();
                }
				
			if (!bIsCrouched) slidePrep = true;
			
			if (bIsCrouched && !bIsSliding && slidePrep)
			{			
				GroundSpeed = Default.GroundSpeed * SprintSpeedModifier * 5;
				SprintCurrentStamina = SlideDistance;
				bIsSliding = true;
				slidePrep = false;
	            StopFiring ();  // Can't slide and spray paint!
				LogInternal("Sliding!!!");
			}
				
			if (!bIsCrouched && bIsSliding)
			{
				SprintCurrentStamina = 0.0;
				if(bIsSliding)
					timeSinceSlideStopped = 0.0;
				bIsSliding = false;
				LogInternal("Done Sliding!!!");
			}
				
            goto ('Begin');
        }

    auto state() IsRestoring
        {
		event BeginState (Name previousStateName)
			{
			LogInternal("IsRestoring");
			}

        Begin:
            Sleep (SprintTickTimeInSeconds);
			if (RestoreStamina()) GotoState ('');
            goto ('Begin');
        }

function bool RestoreStamina ()
	{
    SprintCurrentStamina += SprintStaminaRestorationRatePerSecond * SprintTickTimeInSeconds;
    if (SprintCurrentStamina >= SprintMaxStamina)
        {
        LogInternal("FHNormalPlayer -- State:IsRestoring -- Stamina Restored");
        SprintCurrentStamina = SprintMaxStamina;
		return true;
        }
	return false;
	}
	
function SprintFXOff()
{	
	local LocalPlayer lPlayer;
	AudioPlayerSprinting.Stop();
	lPlayer = LocalPlayer(PlayerController(Controller).Player);
	if(lPlayer != none)
	{
		lPlayer.RemoveAllPostProcessingChains();
		lPlayer.InsertPostProcessingChain(PostProcessChain'FH_post_processing.FHPostProcessingChain', INDEX_NONE, true);
		//lPlayer.RebuildPlayerPostProcessChain();
		stopSprint();
	}
}

function SprintFXOn()
{
	local LocalPlayer lPlayer;
	AudioPlayerSprinting.Play();
	lPlayer = LocalPlayer(PlayerController(Controller).Player);
	if(lPlayer != none)
	{
		lPlayer.RemoveAllPostProcessingChains();
		lPlayer.InsertPostProcessingChain(PostProcessChain'FH_post_processing.FHSprintPostChain', INDEX_NONE, true);
		//lPlayer.RebuildPlayerPostProcessChain();
		playSprint();
	}
}

exec function StartSprinting()
{
	local float speed;

	if( bIsCrouched == true )
		return;

	speed = VSize (Velocity);
	if (speed < SprintMinSpeed) GotoState ('IsStandingAndSprinting');
	LogInternal("FHNormalPlayer.StartSprinting()----");
	GroundSpeed = Default.GroundSpeed * SprintSpeedModifier;
	SprintFXOn();
	GotoState ('IsSprinting');
}


exec function StopSprinting()
{
    LogInternal("FHNormalPlayer.StopSprinting()----");
    GroundSpeed = Default.GroundSpeed;
	if(bIsSliding)
	    timeSinceSlideStopped = 0.0;
	bIsSliding = false;
	slidePrep = false;
    SprintFXOff();
    GotoState ('IsRestoring');
    }

	
	
////////////////////////////////////////////////////////////////////////////////
////// New Fall Damage

simulated event Landed(vector HitNormal, Actor FloorActor)
	{
		local vector BounceDir;

		if ( Velocity.Z < -500 )
		{
			BounceDir = 0.5 * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
		}

		if( Velocity.Z < -2000 )
		{
			TakeDamage( (999999), Controller, Location, BounceDir, class'DmgType_Crushed');
		}
	}


//////////////////////////////////////////////////////////////////////////////

function BringUpPlayerDiedMenu ()
    {
	DieMenuMovie = new class'FHDieMenu';
	DieMenuMovie.SetTimingMode(TM_Real);
	
    DieMenuMovie.SurvivalTimeInSeconds = SurvivalTimeInSeconds;
    DieMenuMovie.PlayerScore = PlayerScore;
	DieMenuMovie.Init();
    }

	simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
	local rotator bitBucket;
	local Vector slideHack;
	local float   x;
	local float   y;

	EyeHeight = bIsCrouched ? CrouchHeight : 100.0;

	GetActorEyesViewPoint( out_CamLoc, out_CamRot );
	Mesh.GetSocketWorldLocationAndRotation('HeadShotGoreSocket', out_CamLoc, bitBucket, 0);

	if (bUseFloorCamera)
		{
		x  = FloorCameraDistance * Cos ( ((FloorCameraAngle / 360.0) + Rotation.Yaw / 65536.0) * Pi * 2);
		y  = FloorCameraDistance * Sin ( ((FloorCameraAngle / 360.0) + Rotation.Yaw / 65536.0) * Pi * 2);
		//`Log ("("$x $", " $y $")");

		out_CamLoc      = Location;
		out_CamLoc.X   -= x;
		out_CamLoc.Y   -= y;
		out_CamLoc.Z   += FloorCameraAdjustZ;
		out_CamRot.Yaw += FloorCameraAngle * 65536 / 360.0;
		}
		else if(bIsSliding || timeSinceSlideStopped < 2)
		{
 			slideHack = Vector(bitBucket);
			slideHack *= 15;
			out_CamLoc += slideHack;
		}
		else if(bIsCrouched)
		{
			// Slide camera backwards (hacking to line up arm)
 			slideHack = Vector(bitBucket);
			slideHack *= 45;
			out_CamLoc += slideHack;
		}
	return true;
}

simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
{
	liandri = Info.default.CharacterMesh;
}

simulated function SetCharacterMeshInfo(SkeletalMesh SkelMesh, MaterialInterface HeadMaterial, MaterialInterface BodyMaterial)
{
}


simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
		super.PostInitAnimTree( SkelComp );

		if(SkelComp == Mesh)
		{
			//punch = AnimNodePlayCustomAnim(Mesh.FindAnimNode('punch'));
			sprint = AnimNodeBlend(Mesh.FindAnimNode('IsSprinting'));
			//shieldAnim = AnimNodeBlend(Mesh.FindAnimNode('shield'));
		}
}

exec function playSprint()
{
	
	//punch.PlayAnim(false, 1, 0);
	sprint.SetBlendTarget(1.0, 1.0);
	//shieldAnim.SetBlendTarget(1.0, 1.0);
}

exec function stopSprint()
{
	//punch.StopAnim();
	sprint.SetBlendTarget(0.0, 1.0);
}

simulated function StartFire(byte FireModeNum)
{
	if(bIsSliding || (bIsCrouched && VSizeSq(Velocity) > 0) || !sprayingEnabled)
		return;
	Super.StartFire(FireModeNum);
	firing = true;
	FHPlayerController(Controller).SetBehindView(false);
}


exec function FHDuck()
{
	local Vector temp;
		temp = Mesh.Translation;
		temp.Z = -60;
		Mesh.SetTranslation(temp);
	FHPlayerController(Controller).Duck();
}

exec function FHUnDuck()
{
	local Vector temp;

	FHPlayerController(Controller).UnDuck();
		temp = Mesh.Translation;
		temp.Z = -87;
		Mesh.SetTranslation(temp);
}


simulated function bool StopWeaponFiring()
{
	firing = false;
	timeSinceFiringStopped = 0.0;
	return super.StopWeaponFiring();
}

simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
	firing = false;
	timeSinceFiringStopped = 0.0;
	super.WeaponStoppedFiring(InWeapon, bViaReplication);
}

exec function FlyCam(bool enabled)
    {
	local Color  msgColor;
	local Vector msgPos;
	local Font   msgFont;

	bUseFloorCamera = enabled;
	if (bUseFloorCamera)
		{
		LogInternal("FHNormalPlayer Floor Camera ON----");
		msgColor = MakeColor(255, 255, 255, 255);
		msgPos.X = 0.02;
		msgPos.Y = 0.02;
		msgPos.Z = 0;
		msgFont  = class'Engine'.static.GetLargeFont();
		FHPlayerController(Controller).DrawGameMessage ("Use MouseWheel to move in/out", 6, msgColor, msgPos, msgFont);
		FHPlayerController(Controller).DrawGameMessage ("Use J and K to move up/down",   6, msgColor, msgPos, msgFont);
		FHPlayerController(Controller).DrawGameMessage ("Use T and Y to rotate camera",  6, msgColor, msgPos, msgFont);
		}
	else LogInternal("FHNormalPlayer Floor Camera Off OFF OFF----");
    }

exec function MoveFloorCameraUp()
    {
	if (!bUseFloorCamera) return;
	bMovingFloorCamera = true;
	bFloorCameraAmount = FloorCameraMovementSpeed;
    }

exec function MoveFloorCameraDown()
    {
	if (!bUseFloorCamera) return;
	bMovingFloorCamera = true;
	bFloorCameraAmount = -FloorCameraMovementSpeed;
    }

exec function StopMovingFloorCamera()
    {
	//if (!bUseFloorCamera)
	//	{
	//	ToggleYAxis();
	//	return;
	//	}
	bMovingFloorCamera = false;
	bYawingFloorCamera = false;
	bPitchingFlyCam    = false;
    }

exec function RotateFloorCameraCW()
    {
	if (!bUseFloorCamera) return;
	bYawingFloorCamera =  true;
	bFloorCameraAmount = FloorCameraYawSpeed;
    }

exec function RotateFloorCameraCCW()
    {
	//if (!bUseFloorCamera)
	//	{
	//	ToggleYAxis();
	//	return;
	//	}
	if (!bUseFloorCamera) return;
	bYawingFloorCamera =  true;
	bFloorCameraAmount = -FloorCameraYawSpeed;
    }

exec function ToggleYAxis()
	{
	FHPlayerController(Controller).PlayerInput.bInvertMouse = !FHPlayerController(Controller).PlayerInput.bInvertMouse;
	}

exec function MoveFlyCamIn()
    {
	if (!bUseFloorCamera) return;
	FloorCameraDistance -= FlyCameraPanSpeed;
	if (FloorCameraDistance < FlyCameraMinDistance) FloorCameraDistance = FlyCameraMinDistance;
    }

exec function MoveFlyCamOut()
    {
	if (!bUseFloorCamera) return;
	FloorCameraDistance += FlyCameraPanSpeed;
    }

function playAnimation(name nodeName, float animationLength)
{
	if(currentAnimation != none)
	{
		currentAnimation.SetBlendTarget(0.0, 1.0);
	}
	currentAnimation = AnimNodeBlend(Mesh.FindAnimNode(nodeName));
	if(currentAnimation == none)
		return;
	currentAnimation.SetBlendTarget(1.0, 0.0);
	animationMaxPlayTime = animationLength;
	animationPlayTime = 0.0;
}


simulated function vector WeaponBob(float BobDamping, float JumpDamping)
{
	Local Vector WBob;

	WBob.X = 0;
	WBob.Y = 0;
	WBob.Z = 0;
	//WBob = BobDamping * WalkBob;
	//WBob.Z = (0.45 + 0.55 * BobDamping)*WalkBob.Z;
	//if ( !bWeaponBob )
	//{
	//	WBob *= 2.5;
	//}
	//WBob.Z += JumpDamping *(LandBob - JumpBob);
	return WBob;
}

	function float getPlayerCameraHeight()
	{
		local rotator bitBucket;
		local Vector out_CamLoc;
		local float ret;
		Mesh.GetSocketWorldLocationAndRotation('HeadShotGoreSocket', out_CamLoc, bitBucket, 0);
		
		ret = Abs(Location.Z - out_CamLoc.Z);
		return ret;
	}


// Decompiled with UE Explorer.
defaultproperties
{
    CuePlayerSprinting=SoundCue'FH_Sounds.A_yourmomsheavybreathing_Que'
    timeSinceFiringStopped=10000000000.0000000
    sprayingEnabled=true
    SprintSpeedModifier=1.7500000
    SprintMinSpeed=1.0000000
    SprintStopFiringSpeedModifier=1.2500000
    SprintMaxStamina=18.0000000
    SprintMinStamina=1.0000000
    SprintCurrentStamina=90000.0000000
    SprintStaminaDepletionRatePerSecond=2.0000000
    SprintStaminaRestorationRatePerSecond=10000000.0000000
    SprintTickTimeInSeconds=0.2000000
    SlideDistance=2.5000000
    FloorCameraAdjustZ=100.0000000
    FloorCameraMovementSpeed=0.5000000
    FloorCameraYawSpeed=0.5000000
    FlyCameraPanSpeed=5.0000000
    FlyCameraPitchSpeed=1.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__FHNormalPlayer.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__FHPlayer.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__FHNormalPlayer.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__FHPlayer.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    SpawnSound=none
    bEnableFootPlacement=false
    // Reference: UTAmbientSoundComponent'Default__FHNormalPlayer.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__FHPlayer.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__FHNormalPlayer.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__FHPlayer.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__FHNormalPlayer.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__FHPlayer.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__FHNormalPlayer.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__FHPlayer.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__FHNormalPlayer.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__FHPlayer.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__FHNormalPlayer.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__FHPlayer.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__FHNormalPlayer.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__FHPlayer.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    CrouchHeight=62.0000000
    CrouchRadius=44.0000000
    // Reference: SkeletalMeshComponent'Default__FHNormalPlayer.moo'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'moo'
    begin object name="moo" class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'ClarkePackage.Clarke56'
        AnimTreeTemplate=AnimTree'ClarkePackage.ClarkeAnimTree'
        AnimSets[0]=AnimSet'ClarkePackage.Anims'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__FHNormalPlayer.MyLightEnvironment'
        CastShadow=false
        bCastDynamicShadow=false
        BlockRigidBody=true
        Translation=(X=0.0000000,Y=0.0000000,Z=-40.0000000)
    end object
    Mesh=moo
    // Reference: CylinderComponent'Default__FHNormalPlayer.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__FHPlayer.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=86.0000000
        CollisionRadius=44.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    ViewPitchMin=-10400.0000000
    ViewPitchMax=11500.0000000
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__FHNormalPlayer.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Arrow'
    // Archetype: ArrowComponent'Default__FHPlayer.Arrow'
    begin object name="Arrow"
        ReplacementPrimitive=none
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    // Reference: SkeletalMeshComponent'Default__FHNormalPlayer.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__FHPlayer.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__FHNormalPlayer.MyLightEnvironment'
    end object
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=moo
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}