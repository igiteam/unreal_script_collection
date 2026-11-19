//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeapon extends TMWeapon
	abstract
	native;

enum ECurrentFireModeType
{
	ECFMT_PRIMARY,
	ECFMT_SECONDARY,
};

var ECurrentFireModeType			CurrentFireModeType;
var bool							bTwoFireMode;
/*********************************************************************************************
 Ammo / Pickups / Inventory
********************************************************************************************* */

var float						ReloadTime[4];
var transient float				ReloadBulletTime;
var float                       AddBulletTime[2];

var int							BulletCount;

var int							AmmoBulletCount[2];
var int							ClipBulletCount[2];

var class<HDWeaponAttachment>	SecondAttachmentClass;

var name						ArmWeaponModeSwitchAnimations[2];
var float                       WeaponFireModeChangeTime[2];

struct native ReloadInfo
{
    var bool Finished;
    var int BulletCount;
};

var byte                        bReloadable[2];
var ReloadInfo					ReloadRepInfo[2];


// zoom variable
var EZoomState					ZoomState;
var EZoomState					LastZoomState;
var float                       ZoomTime;
var byte                        bZoomMode[2];
var float                       SceneZoomSpeed;

// reload variable
var name						ArmReloadAnimations[4];
var name						WeaponReloadAnimations[4];


/** Animation to play when the weapon is Put Down */
var(Animations) array<name>	    ArmsPutDownAnims;
/** Animation to play when the weapon is Equipped */
var(Animations) array<name>  	ArmsEquipAnims;
var(Animations) array<name>     ArmsQuickEquipAnims;
var(Animations) array<name>     ArmsQuickPutDownAnims;

var	transient bool				bShowHud;
var()	float 					max_scaling;
var()	float 					min_scaling;
var()   vector2d 				crosshair_range;
var()	vector2d 				crosshair_size;

var()	float 					max_angle;
var()	float 					min_angle;
var		float 					angle;
var     float                   angle_zoom;

var()	float 					crosshair_zoomin;
var()	float 					crosshair_zoomout;

// zoom: arm aim anation
var	name						ArmIdleToAim;
var name						ArmAimToIdle;

var float 						UnZoomObjectFOV;
var float 						ZoomObjectFOV;
var float                       SceneFOVDiff;
var transient float             CurrentSceneFOV;
var transient float				DesiredObjFOV;
var transient float				CurrentObjFOV;
var transient float             ObjFOVSpeed;

var float 						last_pitch;
var float 						last_yaw;
var float 						last_roll;

var vector						LastLocation;

var() vector 					joint1_location;
var() vector 					joint2_location;

var int							shots_fired;
var float						decrease_shots_fired;
var transient vector			punch_angle;
var int							direction;

var() float 					punch_damping;
var() float 					punch_spring_constant;
var vector						punch_angle_velocity;

var() float                     PoseSpeedMax;
var() float                     PoseSpeedMin;
var() float                     RollSpeedMax;

var() float                     RecoilRecovertime;
var() float						RecoilTime;
var() vector                    RecoilMax;
var() vector                    RecoilZoomMax;
var() vector                    RecoilPerShoot;
var() int                       RecoilRandSeed;

// sprint animation
var array<name>					ArmSprintLoops;
var array<name>					ArmSprintIns;
var array<name>					ArmSprintOuts;
var array<name>                 WeaponSprintLoops;
var array<name>                 WeaponSprintIns;
var array<name>                 WeaponSprintOuts;

var(Action) vector 				Amplitude;
var(Action) vector 				Phi;
var(Action) vector 				Omiga;
var(Action) vector              Amplitude_Zoom;
var(Action) vector              Phi_Zoom;
var(Action) vector              Omiga_Zoom;


var vector						vec_crouch_inv;
var vector						CrouchOffset;
var vector						ProneOffset;

// melee logic
var	name						ArmWeaponMelee;
var bool						bMeleeFinished;
var float						WeaponMeleeRange;
var float						MeleeTime;
var class<DamageType>			MeleeDamageTypes;
var float						MeleeDamage;
var name						MeleeAttackState;
var SoundCue					WeaponMeleeSnd;

// night vision animation
var array<name> 				ArmNVEquips;
var array<name>					ArmNVPutDowns;
var float                       NVEquipTime;
var float                       NVPutDownTime;

// time
var float                       SprintInOutTime;


// tracer
/** Determines which tracer type to use for this weapon **/
var const protected EWeaponTracerType	TracerType;
/** Controls size of the tracers for this weapon */
var() const protected vector			TracerScale;


// gas mask
var array<name>					ArmGMEquips;
var array<name>					ArmGMPutDowns;
var float                       GMEquipTime;
var float                       GMPutDownTime;

// weapon type
/** Holds the current "Fire" status for both firing modes */
enum EFireShotType
{
    EFST_ONE,
    EFST_TRI,
    EFST_MORE,
};
var	Array<EFireShotType>        ReFireFlag;
var transient int               TriFireCount;
var bool						bSniperWeapon;
var transient bool              bReloadingFire;

// Dummy weapon
var transient bool              bDummyWeapon;
var bool                        bSpread;

// UI Element
var() TextureCoordinates        IconTexCoord[2];

// hit location
var vector                      HitLoc;

/*********************************************************************************************
 Clip Bullet
********************************************************************************************* */

/** Holds the name of the socket to attach a muzzle flash too */
var name					ClipBulletSocket;

/** Muzzle flash PSC and Templates*/
var TMParticleSystemComponent	ClipBulletPSC;

/** Normal Fire and Alt Fire Templates */
var ParticleSystem			ClipBulletPSCTemplate;

/** Set this to true if you want the flash to loop (for a rapid fire weapon like a minigun) */
var bool					bClipBulletPSCLoops;

/** How long the Muzzle Flash should be there */
var() float					ClipBulletDuration;

/** Whether muzzleflash has been initialized */
var bool					bClipBulletAttached;

var() vector                ClipSize;

var transient bool          bWideScreen;

// aim adjust value
var() vector                AimAdsLocation;
var() rotator               AimAdsRotation;
var() rotator               AimWeaponRotation;

// sound play
var transient bool          bStopSoundPlay;

/*********************************************************************************************
 Fired  Sound
********************************************************************************************* */
/** Is the Weapon Fire One Time*/
var bool bFireOnetime;

/** TirPerson Fire Sound Cue */
var() SoundCue FireSoundCue;
var() SoundCue FireLoopSoundCue;
var() SoundCue FireLoopEndSoundCue;
var() SoundCue ReloadSoundCue;
var() SoundCue ShellSoundCue;
var AudioComponent RelodeSoundComp;

/** First person fire Sound Cue*/
var() SoundCue FireLoopPlayerCue;
var() SoundCue FireLoopEndPlayerCue;

/** Looping SoundCue for firing. */
var() AudioComponent FireLoopAC;



var() array<byte>           MakeNoiseFlags;

enum    EAttachPawnType
{
    EATTACH_RIFLE,
    EATTACH_LAUNCHER,
    EATTACH_PISTOL,
    EATTACH_NONE,
};
var EAttachPawnType             BackAttachType;


// weapon type:
// For MP Game weapon switch
enum    EHDWeaponType
{
    EWEAPON_LONG,
    EWEAPON_PISTOL,
    EWEAPON_LAUNCHER,
    EWEAPON_GRENADE,
    EWEAPON_SPECIAL,
};
var const   EHDWeaponType         HDWeaponType;


// pick up flag
var transient   bool                bNotPickAttaching; // while weapon picking up, do not attaching to pawn's attachment socket

// fps weapon socket name
var const   name                    WeaponSocketName;

// DOF Setting
var PostProcessSettings			    DOFSetting;

// weapon offset scale while colliding wall
var const   float                   WeaponOffsetScale;

// UI
var Texture2D                       CrosshairHitPawn;
var Int                             CrosshairHitPawnAlpha;
var float                           CrosshairHitPawnTime;
var float                           CrosshairHitPawnAlphaSpeed;
var transient   float               CrosshairHitPawnScale;

// flag : do not switch to the other weapon, specically for CommandSystem
var bool                            bConstHoldWeapon;

// bool flag
var bool                            bPendingReload;

replication
{
	if( Role == Role_Authority && bNetDirty )
		AmmoBulletCount, ClipBulletCount;
	if( bNetDirty )
	   /*ZoomState,*/ CurrentSceneFOV;
}

/*
simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'ReloadRepInfo')
	{
	    ClipBulletCount[CurrentFireModeType] = ReloadRepInfo[CurrentFireModeType].BulletCount;
		HandleFinishedReload();
	}
	else if ( VarName == 'AmmoBulletCount' )
	{
		if ( !HasAnyAmmo() )
		{
			WeaponEmpty();
		}
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
}
*/

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    //ReloadRepInfo[0].Finished = ( ClipBulletCount[0] != 0 );
    //ReloadRepInfo[1].Finished = ( ClipBulletCount[1] != 0 );

	CurrentObjFOV = 0;
	SetObjectDesiredObjFOV( UnZoomObjectFOV, 0 );
	AttachClipBullet();
}

simulated function StartFire(byte FireModeNum)
{
	if ( FireModeNum == 0 )
		FireModeNum = CurrentFireModeType == ECFMT_PRIMARY ? 0 : 1;
	Super.StartFire(FireModeNum);
}

simulated function StopFire(byte FireModeNum)
{
	if ( FireModeNum == 0 )
	{
		FireModeNum = CurrentFireModeType == ECFMT_PRIMARY ? 0 : 1;
	}

	Super.StopFire(FireModeNum);

//	StopLoopFireSound();
}

simulated function EndFire(Byte FireModeNum)
{
	ClearPendingFire(FireModeNum);
    if( ReFireFlag[CurrentFireMode] == EFST_MORE && TriFireCount == 1)
    {
        HDWeaponFirePlaySound (WeaponFireSnd[CurrentFireMode], FireSoundCue);
        TriFireCount = 0;
    }
    if(ReFireFlag[CurrentFireMode] == EFST_MORE)
    {
        StopLoopFireSound();
    }
}

simulated function SetAttachmentClass()
{
    local TMPawn   TMP;
    TMP = HDPawn(Instigator);
    // Spawn the 3rd Person Attachment
	if (Role == ROLE_Authority && TMP != None)
	{
		TMP.CurrentWeaponAttachmentClass = AttachmentClass;//CurrentFireModeType == ECFMT_PRIMARY ? AttachmentClass : SecondAttachmentClass;
		if (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone || (WorldInfo.NetMode == NM_Client && Instigator.IsLocallyControlled()))
		{
			TMP.WeaponAttachmentChanged();
		}
	}
}

simulated function SetCurrentFireModeType( ECurrentFireModeType type )
{
    ClientSetCurrentFireModeType(type);
}

reliable client function ClientSetCurrentFireModeType( ECurrentFireModeType type )
{
    SetCurrentFireModeTypeLocally(type);
    if ( Role < Role_Authority )
    {
        ServerSetCurrentFireModeType(type);
    }
}

reliable server function ServerSetCurrentFireModeType( ECurrentFireModeType type )
{
    SetCurrentFireModeTypeLocally(type);
}

simulated function SetCurrentFireModeTypeLocally( ECurrentFireModeType type )
{
	if ( bTwoFireMode == FALSE ) return;

    if ( type != CurrentFireModeType )
	{
        EndFire(CurrentFireModeType);
        CurrentFireModeType = type;

		if ( IsActiveWeapon() )
		{
            GotoState('WeaponFireModeChange');
        }
	}
}
/*********************************************************************************************
 * Ammunition / Inventory
 *********************************************************************************************/

/**
 * Consumes some of the ammo
 */
simulated function ConsumeAmmo( byte FireModeNum )
{
	// Subtract the Ammo
	AddBulletCount(-ShotCost[FireModeNum], FireModeNum );
}

/**
 * This function is used to add ammo back to a weapon.  It's called from the Inventory Manager
 */
simulated function int AddAmmo( int Amount )
{
	AmmoBulletCount[CurrentFireModeType] = Clamp(AmmoBulletCount[CurrentFireModeType] + Amount,0,default.AmmoBulletCount[CurrentFireModeType]);

	// check for infinite ammo
	if (AmmoBulletCount[CurrentFireModeType] <= 0 && (TMInventoryManager(InvManager) == None || TMInventoryManager(InvManager).bInfiniteAmmo))
	{
		AmmoBulletCount[CurrentFireModeType] = default.AmmoBulletCount[CurrentFireModeType];
	}

	bNetDirty = true;

	return AmmoBulletCount[CurrentFireModeType];
}

simulated function int AddAmmoCount( int Amount, byte FireModeNum )
{
	AmmoBulletCount[FireModeNum] = Clamp(AmmoBulletCount[FireModeNum] + Amount,0,default.AmmoBulletCount[FireModeNum]);
	// check for infinite ammo
	if (AmmoBulletCount[FireModeNum] <= 0 && (TMInventoryManager(InvManager) == None || TMInventoryManager(InvManager).bInfiniteAmmo))
	{
		AmmoBulletCount[FireModeNum] = default.AmmoBulletCount[FireModeNum];
	}

	//bNetDirty = true;

	return AmmoBulletCount[FireModeNum];
}

simulated function AddBulletCount( int Amount, byte FireModeNum )
{
    ClipBulletCount[FireModeNum] = Clamp( ClipBulletCount[FireModeNum] + Amount, 0, default.ClipBulletCount[FireModeNum] );
}

simulated function bool HasAmmo( byte FireModeNum, optional int Amount )
{
	if (Amount==0)
		return (AmmoBulletCount[FireModeNum] + ClipBulletCount[FireModeNum] >= ShotCost[FireModeNum]);
	else
		return ( AmmoBulletCount[FireModeNum] > 0 );
}


simulated function bool HasAnyAmmo()
{
	return ( AmmoBulletCount[0] + ClipBulletCount[0] > 0 || AmmoBulletCount[1] + ClipBulletCount[1] > 0 );
}


simulated function bool HasAnyCurrentAmmo()
{
    return ( AmmoBulletCount[CurrentFireModeType] + ClipBulletCount[CurrentFireModeType] > 0  );
}


simulated function int GetAmmoCount()
{
	return AmmoBulletCount[CurrentFireModeType];
}

/**
 * This function retuns how much of the clip is empty.
 */
simulated function float DesireAmmo(bool bDetour)
{
	return (1.f - float(AmmoBulletCount[0])/default.AmmoBulletCount[0]);
}

/**
 * Returns true if the current ammo count is less than the default ammo count
 */
simulated function bool NeedAmmo()
{
	return ( AmmoBulletCount[0] < Default.AmmoBulletCount[0] || AmmoBulletCount[1] < Default.AmmoBulletCount[1] );
}

/**
 * Cheat Help function the loads out the weapon
 *
 * @param 	bUseWeaponMax 	- [Optional] If true, this function will load out the weapon
 *							  with the actual maximum, not 999
 */
simulated function Loaded(optional bool bUseWeaponMax)
{
	if (bUseWeaponMax)
	{
		AmmoBulletCount[0] = default.AmmoBulletCount[0];
		if ( bTwoFireMode )
		{
			AmmoBulletCount[1] = default.AmmoBulletCount[1];
		}
	}
	else
	{
		AmmoBulletCount[0] = 999;
		if ( bTwoFireMode )
		{
			AmmoBulletCount[1] = 999;
		}
	}
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
	local HDDroppedPickup DP;
	local HDPickupObject OldDP;


	// By default, you can only carry a single item of a given class.
	if ( ItemClass == class )
	{
	    // if ammo max deny pick
        if ( AmmoBulletCount[0] >= default.AmmoBulletCount[0] && AmmoBulletCount[1] >= default.AmmoBulletCount[1] )
        {
         return true;
        }
        DP = HDDroppedPickup(Pickup);
        OldDP = HDPickupObject(Pickup);
		if (DP != None)
		{
			if ( DP.Instigator == Instigator )
			{
				// weapon was dropped by this player - disallow pickup
				return true;
			}
			// take the ammo that the dropped weapon has
			AddAmmoCount(HDWeapon(DP.Inventory).AmmoBulletCount[0], 0);
			AddAmmoCount(HDWeapon(DP.Inventory).AmmoBulletCount[1], 1);
	        if ( ClipBulletCount[CurrentFireModeType] == 0 )
	        {
		      ReloadWeapon();
		      //ReloadRepInfo[CurrentFireModeType].Finished = FALSE;
        	}
			if ( OldDP != None && OldDP.bInfinit )
            {
                ;
                OldDP.PickedUpBy(Instigator);
            }
			else
			{
                DP.PickedUpBy(Instigator);
            }
			AnnouncePickup(Instigator);
		}
		return true;
	}

	return false;
}

simulated function float GetWeaponRating()
{
    return 0.5;
}

simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
	local HDPawn p;
	local rotator r;
	local rotator ret;
	local vector t;
	local float a;

	p = HDPawn(Instigator);

	if(p == none || !bSpread)
		return super.GetAdjustedAim(StartFireLoc);

	a = angle;
	if (ZoomState == ZST_Zoomed || (ReFireFlag[CurrentFireModeType]== EFST_MORE && TriFireCount <= 2) )
		a = angle_zoom;

	t.x = FRand() * 2.0 * 3.1415926;
	t.y = cos(t.x);
	t.x = sin(t.x);
	t = t * FRand();
	ret = super.GetAdjustedAim(StartFireLoc);
	r.pitch = a * t.x / 360.0 * 65536.0;
	r.yaw = a * t.y / 360.0 * 65536.0;
	ret = ret + r;

	return ret;
}

simulated function InstantFire()
{
	local vector StartTrace, EndTrace;
	local Array<ImpactInfo>	ImpactList;
	local ImpactInfo RealImpact, NearImpact;
	local int i, FinalImpactIndex;

    local HDPawn HDP;
	local float t;
	local HDWeaponAttachment   HDWA;

    HDP = HDPawn(Instigator);
    HDWA = HDWeaponAttachment(HDP.CurrentWeaponAttachment);

    if ( HDP == none )//|| ReloadRepInfo[CurrentFireModeType].Finished == FALSE )
        return;

	if (ClipBulletCount[CurrentFireMode] >= 0)
	{
		t = (CrosshairScaling - min_scaling) / (max_scaling - min_scaling);
		t = t ** 0.5;
		angle = min_angle * (1 - t) + max_angle * t;
		CrosshairScaling = max_scaling;

    	// define range to use for CalcWeaponFire()
    	StartTrace = InstantFireStartTrace();
    	EndTrace = InstantFireEndTrace(StartTrace);
    	//DrawDebugLine( StartTrace, EndTrace, 0,255,0, True);

    	bUsingAimingHelp = false;
    	// Perform shot
    	RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
    	FinalImpactIndex = ImpactList.length - 1;

    	if (FinalImpactIndex >= 0 && (ImpactList[FinalImpactIndex].HitActor == None || !ImpactList[FinalImpactIndex].HitActor.bProjTarget))
    	{
    		// console aiming help
    		NearImpact = InstantAimHelp(StartTrace, EndTrace, RealImpact);
    		if ( NearImpact.HitActor != None )
    		{
    			bUsingAimingHelp = true;
    			ImpactList[FinalImpactIndex] = NearImpact;
    		}
    	}

    	for (i = 0; i < ImpactList.length; i++)
    	{
    		ProcessInstantHit(CurrentFireMode, ImpactList[i]);
    	}

        // play first person fire recoil locally
        if ( HDWA != None )
            HDWA.PlayFPFireEffect(Self);

    	if (Role == ROLE_Authority)
    	{
    		// Set flash location to trigger client side effects.
    		// if HitActor == None, then HitLocation represents the end of the trace (maxrange)
    		// Remote clients perform another trace to retrieve the remaining Hit Information (HitActor, HitNormal, HitInfo...)
    		// Here, The final impact is replicated. More complex bullet physics (bounce, penetration...)
    		// would probably have to run a full simulation on remote clients.
    		if ( NearImpact.HitActor != None )
    		{
    			SetFlashLocation(NearImpact.HitLocation);
    		}
    		else
    		{
    			SetFlashLocation(RealImpact.HitLocation);
    		}
			if (HDP.CurrentWeaponAttachment != none)
			{
				for (i = 1; i < ImpactList.length; i++)
				{
					if (ImpactList[i].HitLocation != Vect(0,0,0) && (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone) )
					{
						HDWeaponAttachment(HDP.CurrentWeaponAttachment).TPlayImpactEffects(ImpactList[i]);
					}
				}
			}
    	}

		shots_fired ++;
		CalculateRecoil();
	}

	if ( ClipBulletCount[CurrentFireModeType] == 0 )
	{
		SetTimer( FireInterval[CurrentFireModeType], false, 'ReloadWeapon' );
		//ReloadRepInfo[CurrentFireModeType].Finished = FALSE;
	}
	return;
}

function Drop()
{
    TerminateZoomMode();

    if (Instigator != None && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
	{
		PreloadTextures(false);
	}

	// Become inactive
	GotoState('Inactive');

	// Stop Firing
	ForceEndFire();
	// Detach weapon components from instigator
	DetachWeapon();

	// tell the super to DropFrom() which will
	// should remove the item from our inventory
	if( Instigator != none && Instigator.InvManager != none )
	{
		Instigator.InvManager.RemoveFromInventory(Self);
	}

	Instigator = None;
	InvManager = None;
	GotoState('');

	AIController = None;
}


simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
	local HDPawn TMP;
	local TGTurret TGT;

	if (SocketName == '')
		SocketName = WeaponSocketName;

	if ( bDebugWeapon && Instigator != none && Instigator.Controller != none && PlayerController(Instigator.Controller) != none )
	{
		;
	}

	TMP = HDPawn(Instigator);
	if(TMP != None)
	{
		// Attach 1st Person Muzzle Flashes, etc,
		if ( Instigator.IsFirstPerson() )
		{
			if ( bDeleteMe )
			{
			     ;
			     return;
			}
            TMP.ArmsMesh[0].AttachComponentToSocket(Mesh, SocketName);
			EnsureWeaponOverlayComponentLast();
			SetHidden(True);
			bPendingShow = TRUE;
			Mesh.SetLightEnvironment(TMP.LightEnvironment);
			if (GetHand() == HAND_Hidden)
			{
				TMP.ArmsMesh[0].SetHidden(true);
				TMP.ArmsMesh[1].SetHidden(true);
			}
		}
		else
		{
			TMP.ArmsMesh[0].AttachComponentToSocket(Mesh, SocketName);
			EnsureWeaponOverlayComponentLast();
			SetHidden(True);
			bPendingShow = TRUE;
			Mesh.SetLightEnvironment(TMP.LightEnvironment);
			TMP.ArmsMesh[0].SetHidden(true);
			TMP.ArmsMesh[1].SetHidden(true);
		}

		SetWeaponOverlayFlags(TMP);

		SetAttachmentClass();

		SetSkin(TMPawn(Instigator).ReplicatedBodyMaterial);

		//TMP.ServerUpdateAnimSets();

	}
	else
	{
		TGT = TGTurret(Instigator);
		if(TGT != None)
		{
			TMP = HDPawn(TGT.Driver);
			if (Role == ROLE_Authority && TMP != None)
			{
				TMP.CurrentWeaponAttachmentClass = AttachmentClass;
				if (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone || (WorldInfo.NetMode == NM_Client && Instigator.IsLocallyControlled()))
				{
					TMP.WeaponAttachmentChanged();
				}
			}
		}
	}

}

simulated function DetachWeapon()
{
	local HDPawn HDP;
	local SkeletalMeshComponent TMSke;

	HDP = HDPawn(Instigator);
	if ( HDP != None )
	{
    	if( Instigator.IsFirstPerson() )
    	{
    		TMSke = HDP.ArmsMesh[0];
    		TMSke.DetachComponent(Mesh);
            Mesh.SetHidden(true);
    	}

        DetachClipBullet();

        // for 3rd setting, clear back socket slot for attaching this weapon
        HDP.PawnPutdownWeaponEnd();
    }
    super.DetachWeapon();
}

// reload functions
reliable server function bool ServerIsInStateIsInState( name TestState, optional bool bTestStateStack )
{
    return IsInState(TestState);
}

simulated function Reload()
{
	if ( !bDeleteMe && Instigator != none && bReloadable[ CurrentFireModeType ] == 1 )
	{
		if( ClipBulletCount[ CurrentFireModeType ] < default.ClipBulletCount[ CurrentFireModeType ] &&
			HasAmmo( CurrentFireModeType, 1 ) )
		{
           	if ( IsInState('WeaponReload') || ServerIsInStateIsInState('WeaponReload') )
           	    return;
            SyncReload();
        }
	}
}

reliable sync function SyncReload()
{
    if(ReFireFlag[CurrentFireMode] == EFST_MORE)
    {
        StopLoopFireSound();
    }


    if( Role == Role_Authority || Instigator.IsLocallyControlled() )
	{
		SendToReloadState();
	}

	if( Instigator.IsLocallyControlled() )
    {
		// Play First-Person Animation.
        PlayReloadAnim();
        // Play TPS Animation
        HDPawn(Instigator).PlayReloadAnim();
	}
	else
	{
		// Play Third-Person Animation.
	  	HDPawn(Instigator).PlayReloadAnim();
	}
}


reliable sync function SyncReloadEnd()
{
    HDPawn(Instigator).EndReloadAnim();
}

simulated function PlayReloadAnim();

/*
simulated function ReloadInternal()
{
	if ( !bDeleteMe && Instigator != none && bReloadable[CurrentFireModeType] == 1 )
	{
		if (ClipBulletCount[CurrentFireModeType] < default.ClipBulletCount[CurrentFireModeType] && HasAmmo(CurrentFireModeType, 1))
           	SendToReloadState();
	}
}
*/

simulated function TimeWeaponPutDown()
{
	//SetTimer( 0.2, false, 'HiddenWeapon' );

	super.TimeWeaponPutDown();
}

simulated function SendToReloadState()
{
	GotoState('WeaponReload');
}

simulated function HandleFinishedReload()
{
    GotoState('Active');
}

// zoom functions
simulated function EZoomState GetZoomedState()
{
	return ZoomState;
}

simulated function SetZoomedState( EZoomState inVal )
{
    if ( ROLE < Role_Authority )
    {
        //debugbreak();
        ServerSetZoomedState(inVal);
    }
    SetLocalZoomedState(inVal);
}
simulated function SetLocalZoomedState( EZoomState inval )
{
    ZoomState = inval;
    //bNetDirty = True;
}
reliable server function ServerSetZoomedState( EZoomState inval )
{
    SetLocalZoomedState(inVal);
}

reliable sync function SyncSetCurrentSceneFOV( float value )
{
    CurrentSceneFOV = FClamp(value, 10, 90);
    bNetDirty = TRUE;
}

simulated function SetObjectDesiredObjFOV( float DesiredValue, float Speed )
{
	DesiredObjFOV = DesiredValue;
	ObjFOVSpeed = Speed;
}


simulated function AdjustObjFOV( float DeltaTime )
{
	if ( CurrentObjFOV != DesiredObjFOV )
	{
		CurrentObjFOV = FInterpTo( CurrentObjFOV, DesiredObjFOV, DeltaTime , ObjFOVSpeed );
		SetObjectFOV(CurrentObjFOV);
	}
}

simulated function SetObjectFOV( float value )
{
	local TMPawn TMP;
	local TMSkeletalMeshComponent TMSke;
	local TMSkeletalMeshComponent Gun;

    Gun = TMSkeletalMeshComponent(Mesh);
    Gun.SetFOV(value);

	TMP = TMPawn(Instigator);
	if(TMP == none)
	{
		return;
	}

	// Choose the right arm
	TMSke = TMP.ArmsMesh[0];
	TMske.SetFOV(value);
}

simulated function StartZoom(TMPlayerController PC)
{
	local HDPawn HDP;
	HDP = HDPawn(Instigator);
	if (HDP==none)
		return;

	;
	SetZoomedState(ZST_Zoomed);

	HDP.EnablePawnZoom( AimAdsLocation, AimAdsRotation, ZoomTime );

	if (!IsTimerActive('Gotozoom') && IsActiveWeapon() && HasAmmo(CurrentFireModeType) && Instigator.IsFirstPerson())
	{
		SetTimer(0.001, false, 'Gotozoom');
	}
	ToggleZoomPostProcess();


}

// Goto Zoom
simulated function Gotozoom()
{
	local TMPlayerController PC;
	PC = TMPlayerController(Instigator.Controller);
	if ( PC != None )
	{
		SyncSetCurrentSceneFOV(PC.DefaultFOV - SceneFOVDiff);
        PC.StartZoom( CurrentSceneFOV, SceneZoomSpeed );
	}
	SetObjectDesiredObjFOV( ZoomObjectFOV, Abs(CurrentObjFOV-ZoomObjectFOV)/ZoomTime );
}

// Stop Zoom
simulated function StopZoom()
{
	local TMPlayerController PC;

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		PC = TMPlayerController(Instigator.Controller);
		if (PC != None && LocalPlayer(PC.Player) != none)
		{
			PC.StopZoom();
		}
	}
}

// Leave Zoom
simulated function LeaveZoom( optional bool bFastLeave = False )
{
	local TMPlayerController PC;
	local HDPawn HDP;
	local float tmpZoomTime;

    if ( Instigator == None ) return;

	tmpZoomTime = (bFastLeave)? 0.1f : ZoomTime;

	HDP = HDPawn(Instigator);

	PC = TMPlayerController(Instigator.Controller);
	if (PC != none)
	{
		PC.EndZoom();
	}

	SetObjectDesiredObjFOV( UnZoomObjectFOV, Abs(CurrentObjFOV-UnZoomObjectFOV)/tmpZoomTime);

	SetZoomedState(ZST_NotZoomed);
	ToggleZoomPostProcess();

	if ( HDP != None )
	{
        HDP.DisablePawnZoom(tmpZoomTime);
    }
}


// terminate zoom mode
simulated function TerminateZoomMode()
{
    ClearTimer('GotoZoom');
	ClearTimer('StopZoom');
	LeaveZoom(True);
}


// End Zoom
simulated function EndZoom(TMPlayerController PC)
{
	//PlaySound(ZoomOutSound, true);
	if (IsTimerActive('Gotozoom'))
	{
		ClearTimer('Gotozoom');
	}
	LeaveZoom();
}

/**
 * We Override beginfire to add support for zooming.  Should only be called from BeginFire()
 *
 * @param	FireModeNum 	The current Firing Mode
 *
 * @returns true we should abort the BeginFire call
 */
simulated function bool CheckZoom(byte FireModeNum)
{
    return false;
}

// zoom postprcess
simulated function ToggleZoomPostProcess();

// Put Weapon Down
simulated function PutDownWeapon()
{
    StopLoopFireSound();
    TerminateZoomMode();
	super.PutDownWeapon();
}

// server goto active state
reliable server function ServerGotoActive()
{
    GotoState('Active');
}

// sprint logic
simulated	function WeaponSprintIn()
{
    // 1 out zoom
	if ( ZoomState == ZST_Zoomed )
    {
        TerminateZoomMode();
    }
	// 2 out reload state
	if ( GetStateName() == 'WeaponReload' )
	{
		// WARNNING: only switch animation, reload logic incorrect
		if ( Role < Role_Authority )
		{
		    ServerGotoActive();
		}
		GotoState('Active');
		StopWeaponAnimation();
		StopWeaponReloadSound();
	}

	// play sprint in logic
	if(ArmSprintIns.Length > CurrentFireModeType && ArmsAnimSet != none)
        PlayArmAnimation( ArmSprintIns[CurrentFireModeType], SprintInOutTime );
    if(WeaponSprintIns.Length > CurrentFireModeType )
    {
        PlayWeaponAnimation( WeaponSprintIns[CurrentFireModeType], SprintInOutTime );
    }
}

function StopWeaponReloadSound()
{
 if( RelodeSoundComp != none)
 {
    if(RelodeSoundComp.IsPlaying())
       RelodeSoundComp.Stop();
 }
}

simulated function WeaponSprintOut()
{
    if(ArmSprintOuts.Length > CurrentFireModeType && ArmsAnimSet != none)
        PlayArmAnimation( ArmSprintOuts[CurrentFireModeType], SprintInOutTime );
    if(WeaponSprintOuts.Length > CurrentFireModeType )
    {
        PlayWeaponAnimation( WeaponSprintOuts[CurrentFireModeType], SprintInOutTime );
    }
}

simulated function Notify_ClipEffect()
{
   // clip bullet
   CauseClipBullet();
}

simulated function Notify_ReloadSound()
{
   local Actor SoundOwner;
    if ( (RelodeSoundComp == None) || RelodeSoundComp.IsPendingKill() )
    {
        SoundOwner = (Owner == None) ? self : Owner;
    	RelodeSoundComp = SoundOwner.CreateAudioComponent(ReloadSoundCue, FALSE, TRUE);
    }
    if (RelodeSoundComp != None)
    {
    	RelodeSoundComp.bUseOwnerLocation = TRUE;
    	RelodeSoundComp.bAllowSpatialization = FALSE;
    	RelodeSoundComp.bAutoDestroy = TRUE;
    	RelodeSoundComp.Play();
    }
}


simulated function AddBullet();

reliable client function ClientSyncWeaponBullet( int FireType, int AmmoCounts, int ClipCount )
{
    if ( Role < Role_Authority )
    {
        AmmoBulletCount[FireType] = AmmoCounts;
        ClipBulletCount[FireType] = ClipCount;
        if ( FireType != CurrentFireModeType )
        {
            ;
            SetCurrentFireModeType(ECurrentFireModeType(FireType));
        }
    }
}

reliable client function ClientHandleFinishedReload()
{
    Global.HandleFinishedReload();
}

// Toggle Melee attack
simulated function ToggleMelee()
{
    if( Instigator == None || !Instigator.bNoWeaponFiring )
	{
		if( Role < Role_Authority )
		{
			// if we're a client, synchronize server
			ServerMeleeAttack();
		}

		// Start fire locally
		BeginMeleeAttack();
	}
}

simulated state WeaponReload
{
    ignores StartZoom, ToggleMelee;

    simulated function BeginFire( byte FireModeNum )
    {
  		if( !bDeleteMe && Instigator != None )
		{
			Global.BeginFire(FireModeNum);
			bReloadingFire = TRUE;
		}
    }

    simulated function EndFire( byte FireModeNum )
    {
		bReloadingFire = FALSE;
		Global.EndFire(FireModeNum);
    }

    simulated function StartFire( byte FireModeNum )
    {
        Super.StartFire(FireModeNum);
    }
	/**
	 * ReadyToFire() called by NPC firing weapon. bFinished should only be true if called from the Finished() function
 	 */
	simulated function bool ReadyToFire(bool bFinished)
	{
		return false;
	}

    simulated function AddBullet()
    {
		local int cnt;
        if ( Role < ROLE_Authority )  return;

		// if we have enough or more ammo than the weapon needs
		if(AmmoBulletCount[CurrentFireModeType] > 0)
		{
			// Set our bullet count back to default value
			cnt = Min(AmmoBulletCount[CurrentFireModeType] + ClipBulletCount[CurrentFireModeType], default.ClipBulletCount[CurrentFireModeType]);

			// subtrack the ammo from our inventory
			AmmoBulletCount[CurrentFireModeType] -= cnt - ClipBulletCount[CurrentFireModeType];

			ClipBulletCount[CurrentFireModeType] = cnt;
		    if ( !Instigator.IsLocallyControlled() )
		    {
		        ClientSyncWeaponBullet( CurrentFireModeType, AmmoBulletCount[CurrentFireModeType], ClipBulletCount[CurrentFireModeType] );
		    }
		}

    }

	simulated function HandleFinishedReload()
	{
		ClientHandleFinishedReload();
        global.HandleFinishedReload();
	}

    simulated function PlayReloadAnim()
    {
		local int		index;

		index = ( ClipBulletCount[CurrentFireModeType] == 0 ) ? 1 : 0;
		index += CurrentFireModeType == ECFMT_PRIMARY ? 0 : 2;

        HDPawn(Instigator).AdditiveBlendingNode.SetBlendTarget( 0.0f, 0.0f );

		PlayArmAnimation(ArmReloadAnimations[index], 0);

		PlayWeaponAnimation(WeaponReloadAnimations[index], 0);

		bShowHud = false;
    }

	simulated event BeginState( Name PreviousStateName )
	{
		local int		index;

		// not zoom
        TerminateZoomMode();

		// not sprint
		HDPawn(Instigator).LeaveSprint();

        // Hidden Knife
        HDPawn(Instigator).SetKnifeVisibility(False);

        if ( Role == Role_Authority )
        {
		    index = ( ClipBulletCount[ CurrentFireModeType ] == 0 ) ? 1 : 0;
		    index += CurrentFireModeType == ECFMT_PRIMARY ? 0 : 2;
		    ReloadBulletTime = ReloadTime[ index ];
	  	    SetTimer( AddBulletTime[ CurrentFireModeType ], false, 'AddBullet' );
		    SetTimer( ReloadBulletTime, false, 'HandleFinishedReload' );
		}
	}

	simulated event EndState( Name NextStateName )
	{
		//ReloadRepInfo[CurrentFireModeType].Finished = true;
		ClearTimer('HandleFinishedReload');
		if ( Role == Role_Authority )
    		SyncReloadEnd();
	}
}

simulated function ReloadWeapon()
{
	local HDPawn HDP;
	HDP = HDPawn(Instigator);

	if (HDP == none)
		return;

	if ( ClipBulletCount[CurrentFireModeType] == 0 )
	{
		if ( !HDP.bSprintTag )
			HDP.ReloadWeapon();
		else
			SetTimer(0.2, false, 'ReloadWeapon');
	}
}

simulated function ReFireChecking();

simulated state Active
{
	simulated function ReFireChecking()
	{
		local int i;
		// if either of the fire modes are pending, perform them
		for( i=0; i<GetPendingFireLength(); i++ )
		{
			if( PendingFire(i) && (ReFireFlag[i] == EFST_MORE || bReloadingFire) )
			{
				bReloadingFire=FALSE;
                BeginFire(i);
				break;
			}
		}
	}

	simulated event BeginState(Name PreviousStateName)
	{
        OnAnimEnd(none, 0.f, 0.f);

		if (bDebugWeapon)
		{
			;
		}

		if ( TMBot(Instigator.Controller) != None )
		{
			if ( PendingFire(0) )
			{
				StillFiring(0);
			}
			else if ( PendingFire(1) )
			{
				StillFiring(1);
			}
		}

        // Cache a reference to the AI controller
		if (Role == ROLE_Authority)
		{
			CacheAIController();
		}

		// Check to see if we need to go down
   		if( bWeaponPutDown )
		{
			PutDownWeapon();
		}
		else
		{
			ReFireChecking();
		}

		if (InvManager != none && InvManager.LastAttemptedSwitchToWeapon != none)
		{
			if (InvManager.LastAttemptedSwitchToWeapon != self)
			{
				InvManager.LastAttemptedSwitchToWeapon.ClientWeaponSet(true);
			}
			InvManager.LastAttemptedSwitchToWeapon = none;
		}


		if (bShowHud == false)
		{
			if (VSize(Instigator.Velocity) > 20.0)
				CrosshairScaling = max_scaling;
			else
				CrosshairScaling = min_scaling;

            ReFireChecking();
			bShowHud = true;
		}
	}

	simulated event EndState(Name NextStateName)
	{
		ClearTimer('ReloadWeapon');
		super.EndState(NextStateName);
	}

	simulated event OnAnimEnd(optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
	{
		local int IdleIndex;
		local HDPawn	HDP;
		local name	animName;

		HDP = HDPawn(Instigator);
		if ( HDP == none )
			return;

		if ( WorldInfo.NetMode != NM_DedicatedServer && WeaponIdleAnims.Length > 0 )
		{
			IdleIndex = CurrentFireModeType;
			if ( WeaponIdleAnims.Length > IdleIndex )
			{
                animName = ( (HDP.bSprintTag == true)&&(WeaponSprintLoops.Length>IdleIndex) )? WeaponSprintLoops[IdleIndex] : WeaponIdleAnims[IdleIndex];
                PlayWeaponAnimation(animName, 0.0, true);
            }
			if(ArmIdleAnims.Length > IdleIndex && ArmsAnimSet != none)
			{
				animName = ((HDP.bSprintTag == true)&&(ArmSprintLoops.Length>IdleIndex))? ArmSprintLoops[IdleIndex] : ArmIdleAnims[IdleIndex];
                PlayArmAnimation(animName, 0.0,, true);
			}
		}

		// local reload internal
        if ( HDP.IsLocallyControlled() )
            ReloadWeapon();
	}

	simulated function ChangeZoomFireMode()
	{
		local TMPlayerController PC;
		PC = TMPlayerController(Instigator.Controller);
		if ( WorldInfo.NetMode != NM_DedicatedServer && bZoomMode[CurrentFireModeType]==1 )
		{
			if (PC != None && LocalPlayer(PC.Player) != none )
			{
				(GetZoomedState() != ZST_NotZoomed) ?  EndZoom(PC) : StartZoom(PC);
			}
		}
	}


	simulated function BeginMeleeAttack()
	{
		if( !bDeleteMe && Instigator != None )
		{
			Global.BeginMeleeAttack();

			// in the active state, fire right away if we have the ammunition
			SendToMeleeingState();
		}
	}

	simulated function BeginFire(byte FireModeNum)
	{
        if ( !HasAmmo(FireModeNum) )
		{
			WeaponEmpty();
			return;
		}
		Super.BeginFire(FireModeNum);
	}
}


/*reliable sync function  SyncPawnPutdownWeapon()
{
	local HDPawn HDP;
	HDP = HDPawn(Instigator);
	if ( HDP != None )
	  HDP.PutdownWeaponAction();
}

reliable sync function SyncPawnPutdownWeaponEnd()
{
	local HDPawn HDP;
	HDP = HDPawn(Instigator);
	if ( HDP != None )
	  HDP.PutdownWeaponEndAction();
}
*/
simulated state WeaponPuttingDown
{
    ignores  WeaponSprintIn, WeaponSprintOut, Reload;
	simulated function StartFire( byte FireModeNum )
	{
	   ;
	}
    simulated function BeginState(Name PreviousStateName)
	{
        StopFire(CurrentFireModeType);
		super.BeginState(PreviousStateName);
        HDPawn(Instigator).PawnPutdownWeapon();
        //SyncPawnPutdownWeapon();
	}
	simulated event EndState(Name NextStateName)
	{
        Super.EndState(NextStateName);
        SetBackAttachmentClass();
	}
}


simulated function KickBack(float up_base, float lateral_base, float up_modifier, float lateral_modifier, float up_max, float lateral_max, int direction_change)
{
	local float kick_up;
	local float kick_lateral;

	if (shots_fired == 1)
	{
		kick_up = up_base;
		kick_lateral = lateral_base;
	}
	else
	{
		kick_up = up_base + shots_fired * up_modifier;
		kick_lateral = lateral_base + shots_fired * lateral_modifier;
	}

	punch_angle.x += kick_up;
	if (punch_angle.x > up_max)
		punch_angle.x = up_max;

	if (direction == 1)
	{
		punch_angle.y += kick_lateral;
		if (punch_angle.y > lateral_max)
		{
			punch_angle.y = lateral_max;
		}
	}
	else
	{
		punch_angle.y -= kick_lateral;
		if (punch_angle.y < -lateral_max)
		{
			punch_angle.y = -lateral_max;
		}
	}
	if (Rand(direction_change) == 0)
		direction = 1 - direction;
}

// Function 1: ZT
simulated function CalculateRecoil()
{
	if (ZoomState == ZST_Zoomed)
		KickBack(0.15f, 0.1f, 0.10f, 0.05f, 2.5f, 0.25f, 7);
	else
		KickBack(0.35f, 0.15f, 0.25f, 0.025f, 7.5f, 0.75f, 7);
}

// Function 2: WK
simulated function CalculateRecoilFuncTwo();

// Function 1: ZT
simulated function RecoverRecoil( float DeltaTime )
{
 	local float spring_force_magnitude;
	local float damping;

	if (VSize(punch_angle) > 0.0316f || VSize(punch_angle_velocity) > 0.0316f)
	{
		punch_angle += punch_angle_velocity * DeltaTime;
		damping = 1 - (punch_damping * DeltaTime);
		if (damping < 0)
			damping = 0;
		punch_angle_velocity *= damping;

		spring_force_magnitude = punch_spring_constant * DeltaTime;
		spring_force_magnitude = FClamp(spring_force_magnitude, 0, 2);
		punch_angle_velocity -= punch_angle * spring_force_magnitude;
		punch_angle.X = FClamp(punch_angle.x, 0, 89);
		punch_angle.Y = FClamp(punch_angle.y, -179, 179);
		punch_angle.Z = FClamp(punch_angle.z, -89, 89);
	}
}

simulated function float FWeaponInterpConstantTo( float Current, float Target, float DeltaTime, float InterpSpeed )
{
	local float Dist, Step;
    Dist = Target - Current;

	// If distance is too small, just set the desired location
	if( Abs(Dist) < 0.00001f )
	{
		return Target;
	}

	Step = InterpSpeed * DeltaTime;
	return Current + FClamp(Dist, -Step, Step);
}

// Function 2: WK
simulated function RecoverRecoilFuncTwo( float DeltaTime );

simulated function UpdatePunch(float DeltaTime)
{
	RecoverRecoil( DeltaTime );

    if (GetStateName() != 'WeaponFiring')
    {
    	if (shots_fired > 0)
    	{
    		decrease_shots_fired -= WorldInfo.DeltaSeconds;
    		if (decrease_shots_fired < 0)
    		{
    			decrease_shots_fired = default.decrease_shots_fired;
    			shots_fired --;
    		}
    	}
	}
}

// Set CameraPostion
simulated event SetPosition(TMPawn Holder)
{
	local vector DrawOffset, ViewOffset, FinalSmallWeaponsOffset;
	local EWeaponHand CurrentHand;
	local rotator NewRotation, FinalRotation;
	local PlayerController PC;
	local vector2D ViewportSize;
	local bool bIsWideScreen;
	local float yaw_delta;
	local float pitch_delta;
	local float roll_delta;
	local float follow_speed;
	local matrix mat_joint1, mat_joint1_inv;
	local matrix mat_joint2, mat_joint2_inv;
	local matrix mat_socket, mat_socket_inv;
	local matrix mat_local, mat;
	local rotator OutRotation;
	local vector OutLocation;
	local rotator zero_rotator;

	local vector tmp_vect;
	local Quat tmp_quat;
	local rotator tmp_rot;

	local matrix mat_crouch;

	local vector v;

    local HDPawn HDP;

    local vector local_Amplitude;
    local vector local_Omiga;
    local vector local_Phi;

    local float     DeltaTime;
    DeltaTime = WorldInfo.DeltaSeconds / WorldInfo.TimeDilation;

	if ( !Holder.IsFirstPerson() )
		return;

    HDP = HDPawn(Holder);

	// Hide the weapon if hidden
	CurrentHand = GetHand();
	if ( bForceHidden || CurrentHand == HAND_Hidden)
	{
		Mesh.SetHidden(True);
		Holder.ArmsMesh[0].SetHidden(true);
		NewRotation = Holder.GetViewRotation();
		SetLocation(Instigator.GetPawnViewLocation() + (HiddenWeaponsOffset >> NewRotation));
		SetRotation(NewRotation);
		SetBase(Instigator);
		bShowHud = FALSE;
		return;
	}

	if(bPendingShow)
	{
		SetHidden(False);
		bPendingShow = FALSE;
		Holder.ArmsMesh[0].SetHidden(FALSE);
	}

	Mesh.SetHidden(False);

	foreach LocalPlayerControllers(class'PlayerController', PC)
	{
		LocalPlayer(PC.Player).ViewportClient.GetViewportSize(ViewportSize);
		break;
	}
	bIsWideScreen = (ViewportSize.Y > 0.f) && (ViewportSize.X/ViewportSize.Y > 1.7);
    bWideScreen = bIsWideScreen;

	// Adjust for the current hand
	ViewOffset = PlayerViewOffset;
	FinalSmallWeaponsOffset = SmallWeaponsOffset;

	switch ( CurrentHand )
	{
	case HAND_Right:
		Mesh.SetScale3D(default.Mesh.Scale3D);
		Mesh.SetRotation(default.Mesh.Rotation);
		if (ArmsAnimSet != None)
		{
			Holder.ArmsMesh[0].SetScale3D(Holder.default.ArmsMesh[0].Scale3D);
		}
		break;
	default:
		break;
	}

	if ( bIsWideScreen )
	{
		ViewOffset += WideScreenOffsetScaling * FinalSmallWeaponsOffset;
		if ( bSmallWeapons )
		{
			ViewOffset += 0.7 * FinalSmallWeaponsOffset;
		}
	}
	else if ( bSmallWeapons )
	{
		ViewOffset += FinalSmallWeaponsOffset;
	}

	// Calculate the draw offset
	if ( Holder.Controller == None )
	{

	}
	else
	{
		DrawOffset.Z = Holder.GetEyeHeight();
		DrawOffset += Holder.WeaponBob(BobDamping, JumpDamping);

		if ( TMPlayerController(Holder.Controller) != None )
		{
			DrawOffset += TMPlayerController(Holder.Controller).ShakeOffset >> Holder.Controller.Rotation;
		}

		DrawOffset = DrawOffset + ( ViewOffset >> Holder.Controller.Rotation );
	}

	// Adjust it in the world
	SetBase(Holder);

	NewRotation = (Holder.Controller == None) ? Holder.GetBaseAimRotation() : Holder.Controller.Rotation;

	FinalRotation.Yaw = NewRotation.Yaw & 65535;
	FinalRotation.Pitch = NewRotation.Pitch & 65535;
	FinalRotation.Roll = NewRotation.Roll;

	yaw_delta = FinalRotation.Yaw - LastRotation.Yaw;
	if (yaw_delta > 32767)
		yaw_delta = yaw_delta - 65535;
	else if (yaw_delta < -32767)
		yaw_delta = yaw_delta + 65535;
	pitch_delta = FinalRotation.Pitch - LastRotation.Pitch;
	if (pitch_delta > 32767)
		pitch_delta = pitch_delta - 65535;
	else if (pitch_delta < -32767)
		pitch_delta = pitch_delta + 65535;
	//}
	v = Instigator.Velocity;
	v.z = 0.f;
	roll_delta = Min( VSize(v) * 3, RollSpeedMax );
	LastLocation = Holder.Location;

	LastRotation = FinalRotation;

	follow_speed = 0.2 / (DeltaTime * 60);
	if (ZoomState == ZST_Zoomed)
	{
		yaw_delta *= 0.15;
		pitch_delta *=0.2;
		roll_delta = 0;
		follow_speed *= 2.f;
	}

	if (ZoomState != LastZoomState)
	{
		last_roll = 0;
		last_pitch = 0;
		last_yaw = 0;
	}
	LastZoomState = ZoomState;

	if ( bIsWideScreen )
	{
		FinalRotation += WidescreenRotationOffset;
	}

	last_pitch = last_pitch * (1.0 - follow_speed) + pitch_delta * follow_speed;
	last_roll = last_roll * (1.0 - follow_speed) + roll_delta * follow_speed;
	last_yaw = last_yaw * (1.0 - follow_speed) + yaw_delta * follow_speed;

	Holder.ArmsMesh[0].GetSocketWorldLocationAndRotation('Weapon', OutLocation, OutRotation, 1);

	tmp_quat = QuatFromRotator(OutRotation);
	tmp_quat = QuatInvert(tmp_quat);
	//mat_joint1 = MakeRotationMatrix(QuatToRotator(tmp_quat)); //fixme: ??ut3?uc??MakeRotationMatrix
	mat_joint1 = MakeRotationTranslationMatrix(vect(0,0,0), QuatToRotator(tmp_quat));
	mat_joint2 = MakeRotationTranslationMatrix(-OutLocation, zero_rotator);
	mat_socket_inv = mat_joint2 * mat_joint1;

	mat_joint1_inv = MakeRotationTranslationMatrix(-default.joint1_location, zero_rotator);
	mat_joint2_inv = MakeRotationTranslationMatrix(-default.joint2_location, zero_rotator);

	tmp_rot.Yaw = last_yaw;
	tmp_rot.Pitch = last_roll;
	tmp_rot.Roll = 0;
	mat_joint2 = MakeRotationTranslationMatrix(default.joint2_location, tmp_rot);

	tmp_vect.x = 0;
	tmp_vect.y = 0;
	tmp_vect.z = last_roll / 65535.0 * 360.0 * 0.4;

	tmp_rot.Yaw = 0;
	tmp_rot.Pitch = last_pitch;
	tmp_rot.Roll = 0;
	mat_joint1 = MakeRotationTranslationMatrix(default.joint1_location - tmp_vect, tmp_rot);

	mat_socket = MakeRotationTranslationMatrix(OutLocation, OutRotation);

	local_Amplitude = (ZoomState == ZST_Zoomed)? Amplitude_Zoom : Amplitude;
	local_Omiga = (ZoomState == ZST_Zoomed)? Omiga_Zoom : Omiga;
	local_Phi = (ZoomState == ZST_Zoomed)? Phi_Zoom : Phi;

	FinalRotation.Pitch += local_Amplitude.x * Sin(WorldInfo.TimeSeconds * local_Omiga.x + local_Phi.x) / 360.0 * 65535.0;
	FinalRotation.Yaw += local_Amplitude.y * Sin(WorldInfo.TimeSeconds * local_Omiga.y + local_Phi.y) / 360.0 * 65535.0;
	FinalRotation.Pitch += (punch_angle.X) / 360.0 * 65535.0;
	FinalRotation.Yaw += (punch_angle.Y) / 360.0 * 65535.0;

    // prone moving: can not Pitch
	if ( (Holder.bIsProne || Holder.bWantsToProne) && VSize(V)>10 )
	{
		if (ZoomState==ZST_Zoomed && !HDP.bProneZoomStop )
		{
			EndZoom(TMPlayerController(Holder.Controller));
		}
		if ( HDP.PoseBlendNode != NONE )
		   HDP.PoseBlendNode.SetSkelControlStrength( 1, 0.3 );
        bShowHud = FALSE;
		mat_local = MakeRotationTranslationMatrix(DrawOffset, FinalRotation);

		if (ArmsAnimSet != None)
		{
			Holder.ArmsMesh[0].SetTranslation(MatrixGetOrigin(mat_local));
			Holder.ArmsMesh[0].SetRotation(MatrixGetRotator(mat_local));
		}
		return;
	}
	else
	{
	    if ( HDP.PoseBlendNode != NONE )
           HDP.PoseBlendNode.SetSkelControlStrength( 0, 0.15 );
         bShowHud = TRUE;
	}


	mat_local = MakeRotationTranslationMatrix(DrawOffset, FinalRotation);

	if ( (Holder.bIsCrouched||Holder.bIsProne) && ZoomState == ZST_NotZoomed )
	{
        vec_crouch_inv = VInterpTo( vec_crouch_inv, (Holder.bIsCrouched)? CrouchOffset : ProneOffset, DeltaTime, PoseSpeedMin );
	}
	else
	{
		vec_crouch_inv = VInterpTo( vec_crouch_inv, Vect(0,0,0), DeltaTime,((ZoomState == ZST_NotZoomed) ? PoseSpeedMin : PoseSpeedMax ) );
	}


	mat_crouch = MakeRotationTranslationMatrix(vec_crouch_inv, rot(0,0,0) );

	mat = mat_socket_inv * mat_joint1_inv * mat_joint2_inv * mat_joint2 * mat_joint1 * mat_socket * mat_crouch * mat_local;

	if (ArmsAnimSet != None)
	{
		if ( Abs(mat.ZPlane.W) != 0.0 || mat.ZPlane.W != mat.ZPlane.W )
		  ;
        Holder.ArmsMesh[0].SetTranslation(MatrixGetOrigin(mat));
		Holder.ArmsMesh[0].SetRotation(MatrixGetRotator(mat));
	}
}

simulated function DrawWeaponCrosshair( Hud HUD )
{
	local vector2d CrosshairSize;
	local float x,y,PickupScale, ScreenX, ScreenY;
	local TMHUD	H;
	local vector2d sz;
	local HDPawn tmp;
	local float target_scaling, scaling_speed;
	local rotator r;
	local float alpha, t;
	local vector2d hotpoint;
	local vector2d tilesize;
    local Color DrawCrossColor;

	DrawWeaponHitPawn(HUD);

 	if (!bShowHud || ZoomState == ZST_Zoomed )
 	  return;

   	H = TMHUD(HUD);
	if ( H == None )
		return;

	tmp = HDPawn(Instigator);

	max_scaling = default.max_scaling;
	min_scaling = default.min_scaling;
	if ( tmp != none )
	{
		if ( tmp.bIsCrouched )
		{
			max_scaling *=  0.7;
			min_scaling *=  0.7;
		}
		else if ( tmp.bIsProne )
		{
			max_scaling *= 0.5;
			min_scaling *= 0.5;
		}
	}
	// Apply pickup scaling
	if ( H.LastPickupTime > WorldInfo.TimeSeconds - 0.3 )
	{
		if ( H.LastPickupTime > WorldInfo.TimeSeconds - 0.15 )
		{
			PickupScale = (1 + 5 * (WorldInfo.TimeSeconds - H.LastPickupTime));
		}
		else
		{
			PickupScale = (1 + 5 * (H.LastPickupTime + 0.3 - WorldInfo.TimeSeconds));
		}
	}
	else
	{
		PickupScale = 1.0;
	}

	hotpoint.X = 3;
	hotpoint.Y = 7;

	tilesize.X = 8;
	tilesize.Y = 8;

	if (max_scaling == min_scaling)
		t = 0.0;
	else
		t = (CrosshairScaling - min_scaling) / (max_scaling - min_scaling);
	angle = min_angle * (1 - t) + max_angle * t;

 	CrosshairSize.Y = H.ConfiguredCrosshairScaling * CrosshairScaling * crosshair_range.Y * PickupScale * H.Canvas.ClipY/720;
  	CrosshairSize.X = CrosshairSize.Y * (crosshair_range.X / crosshair_range.Y);

	X = H.Canvas.ClipX * 0.5;
	Y = H.Canvas.ClipY * 0.5;
	ScreenX = X - (CrosshairSize.X * 0.5);
	ScreenY = Y - (CrosshairSize.Y * 0.5);

	if (max_scaling == min_scaling)
		alpha = 1.0;
	else
		alpha = 1.0 - (CrosshairScaling - min_scaling) / (max_scaling - min_scaling);
	alpha = 255 * alpha + 180 * (1 - alpha);

	sz.X = crosshair_size.X;
	sz.Y = crosshair_size.Y;

    DrawCrossColor.R = (tmp.bFireState==2)? 128 : 255;
    DrawCrossColor.G = (tmp.bFireState==1)? 64 : 255;
    DrawCrossColor.B = (tmp.bFireState==0)? 255 : 64;


	H.Canvas.SetDrawColor(DrawCrossColor.R, DrawCrossColor.G, DrawCrossColor.B, alpha);

	// left
	H.Canvas.SetPos(ScreenX - sz.x * hotpoint.x / (tilesize.x - 1), Y - sz.y * (hotpoint.y / (tilesize.y - 1)));
	r.yaw = 270.0 / 360.0 * 65536.0;
	H.Canvas.DrawRotatedTile(CrosshairImage, r, sz.X, sz.Y, 0, 0, CrosshairImage.GetSurfaceWidth(), CrosshairImage.GetSurfaceHeight(), hotpoint.x / (tilesize.x - 1), hotpoint.y / (tilesize.y - 1));

	// right
	H.Canvas.SetPos(X + (X - ScreenX) - sz.x * (hotpoint.x / (tilesize.x - 1)), Y - sz.y * hotpoint.y / (tilesize.y - 1));
	r.yaw = 90.0 / 360.0 * 65536.0;
	H.Canvas.DrawRotatedTile(CrosshairImage, r, sz.X, sz.Y, 0, 0, CrosshairImage.GetSurfaceWidth(), CrosshairImage.GetSurfaceHeight(), hotpoint.x / (tilesize.x - 1), hotpoint.y / (tilesize.y - 1));

	// top
	H.Canvas.SetPos(X - sz.X * hotpoint.X / (tilesize.X - 1), ScreenY - sz.Y * hotpoint.Y / (tilesize.Y - 1));
	r.yaw = 0.0 / 360.0 * 65536.0;
	H.Canvas.DrawRotatedTile(CrosshairImage, r, sz.X, sz.Y, 0, 0, CrosshairImage.GetSurfaceWidth(), CrosshairImage.GetSurfaceHeight(), hotpoint.x / (tilesize.x - 1), hotpoint.y / (tilesize.y - 1));

	// bottom
	H.Canvas.SetPos(X - sz.X * hotpoint.X / (tilesize.X - 1), Y + (Y - ScreenY) - sz.y * (hotpoint.y / (tilesize.y - 1)));
	r.yaw = 180.0 / 360.0 * 65536.0;
	H.Canvas.DrawRotatedTile(CrosshairImage, r, sz.X, sz.Y, 0, 0, CrosshairImage.GetSurfaceWidth(), CrosshairImage.GetSurfaceHeight(), hotpoint.x / (tilesize.x - 1), hotpoint.y / (tilesize.y - 1));

	if (tmp != none)
	{
		if (VSize(tmp.Velocity) > 50.0)
		{
			target_scaling = max_scaling;
			scaling_speed = (max_scaling - min_scaling) / crosshair_zoomout;
			CrosshairScaling = CrosshairScaling + scaling_speed * WorldInfo.DeltaSeconds;
			if (CrosshairScaling > target_scaling)
				CrosshairScaling = target_scaling;
		}
		else
		{
			target_scaling = min_scaling;
			scaling_speed = -(max_scaling - min_scaling) / crosshair_zoomin;
			CrosshairScaling = CrosshairScaling + scaling_speed * WorldInfo.DeltaSeconds;
			if (CrosshairScaling < target_scaling)
				CrosshairScaling = target_scaling;
		}
	}
}

// Play arm animation using animtree
simulated function PlayArmAnimation( Name Sequence, float fDesiredDuration, optional bool OffHand, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
	local HDPawn HDP;
	local SkeletalMeshComponent ArmMeshComp;
	local TMAnimNodeSequence PlayNode;
	//local AnimNodeSequence WeapNode;
	local float DesiredRate;

	// do not play on a dedicated server or if they aren't being seen
	if( WorldInfo.NetMode == NM_DedicatedServer || Instigator == None || !Instigator.IsFirstPerson() )
	{
		return;
	}
	HDP = HDPawn(Instigator);
	if(HDP == none)
	{
		return;
	}
	if(HDP.bArmsAttached)
	{
		// Choose the right arm
		if(!OffHand)
		{
			ArmMeshComp = HDP.ArmsMesh[0];
		}
		else
		{
			ArmMeshComp = HDP.ArmsMesh[1];
		}

		// Check we have access to mesh and animations
		if( ArmMeshComp == None || ArmsAnimSet == none  )
		{
			return;
		}

		if ( HDP.BaseNode == None )
		{
			HDP.BaseNode = TMAnimNodeSequence(ArmMeshComp.FindAnimNode('BaseNode'));
		}
		PlayNode =  HDP.BaseNode;
        if ( PlayNode == None )
            return;

		// If we are not specifying a duration, use the default play rate.
		if(fDesiredDuration > 0.0)
		{
			// @todo - this should call GetWeaponAnimNodeSeq, move 'duration' code into AnimNodeSequence and use that.
			//ArmMeshComp.PlayAnim(Sequence, fDesiredDuration, bLoop);
			if (PlayNode.AnimSeq != None && PlayNode.AnimSeq.SequenceName == Sequence)
			{
				DesiredRate = (fDesiredDuration > 0.0) ? (PlayNode.AnimSeq.SequenceLength / fDesiredDuration) : 1.0;
				if (true || !PlayNode.bPlaying)
				{
					PlayNode.PlayAnim(bLoop, DesiredRate);
				}
				else
				{
					PlayNode.Rate = DesiredRate;
					PlayNode.bLooping = bLoop;
				}
			}
			else
			{
				PlayNode.SetAnim(Sequence);
				if (PlayNode.AnimSeq != None)
				{
					DesiredRate = (fDesiredDuration > 0.0) ? (PlayNode.AnimSeq.SequenceLength / fDesiredDuration) : 1.0;
					PlayNode.PlayAnim(bLoop, DesiredRate);
				}
			}
		}
		else
		{
			//BaseNode = AnimNodeSequence(ArmMeshComp.Animations);
			PlayNode.SetAnim(Sequence);
			PlayNode.PlayAnim(bLoop, DefaultAnimSpeed);
		}
	}
}

/**
 * Check if current fire mode can/should keep on firing.
 * This is called from a firing state after each shot is fired
 * to decide if the weapon should fire again, or stop and go to the active state.
 * The default behavior, implemented here, is keep on firing while player presses fire
 * and there is enough ammo. (Auto Fire).
 *
 * @return	true to fire again, false to stop firing and return to Active State.
 */
simulated function bool ShouldRefire()
{
	// if doesn't have ammo to keep on firing, then stop
	if( !HasAmmo( CurrentFireMode ) )
	{
		return false;
	}

    if(ClipBulletCount[CurrentFireMode] == 0)
    {
        return false;
    }

    // Tri-Shoot
    if ( ReFireFlag[CurrentFireMode] == EFST_TRI )
    {
        //return (--TriFireCount != 0 );
        return TriFireCount < 3;
    }
	// refire if owner is still willing to fire
	return ( StillFiring( CurrentFireMode ) && ReFireFlag[CurrentFireMode] == EFST_MORE );
}



simulated function FireAmmunition()
{
    ++TriFireCount;
    if (CurrentFireMode >= bZoomedFireMode.Length || bZoomedFireMode[CurrentFireMode] == 0)
	{

	    if ( MakeNoiseFlags[CurrentFireMode] == 1 )
	    {
            if(Instigator != none)
		        Instigator.MakeNoise(1.0);
	        else
	            MakeNoise(1.0);
        }

        if(WorldInfo.TimeDilation < 1.f)
        {
           HDWeaponFirePlaySound (WeaponFireSnd[CurrentFireMode], FireSoundCue);
        }
        else
        {
            // if this is the local player, play the firing effects
            if( (ReFireFlag[CurrentFireMode] == EFST_ONE) ||
                (ClipBulletCount[CurrentFireMode] == 1 && (TriFireCount == 1))
              )
            {
               HDWeaponFirePlaySound (WeaponFireSnd[CurrentFireMode], FireSoundCue);
            }
            else if(!bFireOnetime)
            {
                if(ReFireFlag[CurrentFireMode] == EFST_TRI )
                {
                    if(TriFireCount == 1)
                    {
                       HDWeaponFirePlaySound (FireLoopPlayerCue, FireLoopSoundCue);
                    }
                }
                else
                {
                    if (FireLoopAC == None && TriFireCount >= 2)
                    {
                       FireLoopAC = HDWeaponFirePlaySoundEx(FireLoopPlayerCue, FireLoopSoundCue, FireLoopAC);
    		        }
    		        else if (FireLoopAC != None && (TriFireCount >= 2) && (!FireLoopAC.IsPlaying()))
    		        {
    		            FireLoopAC.Play();
                    }
                }
            }
        }

		Super.FireAmmunition();
        if(ShellSoundCue != none)
        {
           PlaySound(ShellSoundCue, , TRUE);
        }

		if (TMPawn(Instigator) != None)
		{
			TMPawn(Instigator).DeactivateSpawnProtection();
		}

		TMInventoryManager(InvManager).OwnerEvent('FiredWeapon');
	}
}

simulated function StopLoopFireSound ()
{
//	if( ReFireFlag[CurrentFireMode] == EFST_ONE )
//	{
//		return;
//	}
//
//   	if( TriFireCount == 1 )
//    {
//        PlaySound( WeaponFireSnd[CurrentFireMode],, true );
//    }
//    else if( TriFireCount > 1 )
//    {
//        if( FireLoopAC != none && FireLoopAC.IsPlaying() )
//        {
//            FireLoopAC.FadeOut(0.1, 0);
//        }
//
//        PlaySound( FireLoopEndPlayerCue,, true );
//    }

        //Play End sound Effect

    if(WorldInfo.TimeDilation == 1.f)
    {
//        if( ReFireFlag[CurrentFireMode] > EFST_ONE && TriFireCount == 1)
//        {
//            HDWeaponFirePlaySound (WeaponFireSnd[CurrentFireMode], FireSoundCue);
//        }
//        else
//        {
        if(ReFireFlag[CurrentFireMode] == EFST_TRI &&
        TriFireCount == 3)
        {
            HDWeaponFirePlaySound (FireLoopEndPlayerCue, FireLoopEndSoundCue);
        }
        else
        {
            if ( !bFireOneTime )
            {
                //if(TriFireCount >= 2) // Weapon Refired
                //{
                    if ( (FireLoopAC != None) && FireLoopAC.IsPlaying() )
                    {
                        FireLoopAC.FadeOut(0.1, 0);
                        HDWeaponFirePlaySound (FireLoopEndPlayerCue, FireLoopEndSoundCue);
	                }
                //}
            }
        }
        //}
    }
}

/** Do a little clean up.  Audio Components to none!.  **/
simulated event Destroyed()
{
	if( FireLoopAC != none )
	{
	    if (FireLoopAC.IsPlaying() )
	    {
	    	FireLoopAC.FadeOut( 0.1f, 0.0f );
        }
		FireLoopAC = None;
	}
	// terminate zoom state
	TerminateZoomMode();
	Super.Destroyed();
}

simulated event Tick( float DeltaTime )
{
	local Actor SoundOwner;
	local name StateName;

	SoundOwner = (Owner == None) ? self : Owner;

    if( !bFireOneTime )
    {
		if( SoundOwner != None && FireLoopAC != None )
		{
			FireLoopAC.Location = SoundOwner.Location;
		}
    }

    if( FireLoopAC != None && FireLoopAC.CurrentVolume == 0.0f )
    {
      	FireLoopAC.Stop();
    }

	super.Tick(DeltaTime);
	StateName = GetStatename();
	if ( StateName != 'Inactive' && StateName != 'PendingClientWeaponSet' )
	{
	     AdjustObjFOV(DeltaTime);
    }
}

simulated state WeaponFiring
{
	ignores WeaponSprintOut, WeaponSprintIn;

    simulated function RefireCheckTimer()
	{
		// if switching to another weapon, abort firing and put down right away
		if( bWeaponPutDown )
		{
			;
			PutDownWeapon();
			return;
		}

		// If weapon should keep on firing, then do not leave state and fire again.
		if( ShouldRefire() )
		{
			FireAmmunition();
			return;
		}

		// Otherwise we're done firing
		HandleFinishedFiring();
	}

	simulated function BeginState(Name PrevStateName)
	{
		TriFireCount = 0;
        FireAmmunition();
        TimeWeaponFiring( CurrentFireMode );
        if ( ROLE == ROLE_Authority )
        {
            HDPawn(Instigator).SetFiringFlag(True);
        }
	}

	simulated event EndState( Name NextStateName )
	{
		if (shots_fired > 15)
			shots_fired = 15;
		decrease_shots_fired += 0.1f;
		ClearFlashCount();
		ClearFlashLocation();
		ClearTimer('RefireCheckTimer');
        if ( ROLE == ROLE_Authority )
        {
            HDPawn(Instigator).SetFiringFlag(False);
        }
	}

	simulated event ReplicatedEvent(name VarName)
	{
		if ( VarName == 'AmmoBulletCount' && !HasAnyAmmo() )
		{
			return;
		}

		Global.ReplicatedEvent(VarName);
	}
}

simulated function HandleFinishedFiring()
{
    //TriFireCount = 0;
    StopLoopFireSound();
	Super.HandleFinishedFiring();
}


//---------------------------------------------------------
// play weapon fire sound
//---------------------------------------------------------
simulated function protected HDWeaponFirePlaySound( SoundCue FirstPersonSound, SoundCue ThirdPersonSound )
{
   local HDPawn HDP;
   local TGPawn TGP;
   local Vehicle VPawn;

   VPawn =  Vehicle(Instigator);

    /**
    * HDP != none Player Controll the Weapon, play first person fire sound
    * TGP != none AI  Controll the Weapon, play thrid person fire sound
    * The weapon  is just like: HDWeap_89MachineGun
    */
   if (VPawn != none)
   {
		HDP = HDPawn(VPawn.Driver);
		TGP = TGPawn(VPawn.Driver);
		if(HDP != none && Instigator.IsLocallyControlled() && FirstPersonSound != None)
		{
		  PlaySound(FirstPersonSound, ,TRUE);
		}
		else
		{
		  if(TGP != none && ThirdPersonSound !=  None)
		  {
		     PlaySound(ThirdPersonSound, , TRUE);
		  }
		}
   }
   else
   {
       if(Instigator.IsLocallyControlled() && FirstPersonSound != None)
       {
           PlaySound(FirstPersonSound, ,TRUE);
       }
       else
       {
           return ;
       }
   }

}

//---------------------------------------------------------
// play weapon fire sound
//---------------------------------------------------------
simulated function protected AudioComponent HDWeaponFirePlaySoundEx( SoundCue FirstPersonSound, SoundCue ThirdPersonSound, AudioComponent AC)
{
   local HDPawn HDP;
   local TGPawn TGP;
   local Vehicle VPawn;
   local Actor SoundOwner;

   // handles dummyfire, where instgator & owner are none
   SoundOwner = (Owner == None) ? self : Owner;
   VPawn =  Vehicle(Instigator);

   HDP = HDPawn(VPawn.Driver);
   TGP = TGPawn(VPawn.Driver);

   /**
    * HDP != none Player Controll the Weapon, play first person fire sound
    * TGP != none AI  Controll the Weapon, play thrid person fire sound
    * The weapon  is just like: HDWeap_89MachineGun
    */
   if ( VPawn != none)
   {
       if(HDP != none && Instigator.IsLocallyControlled() && FirstPersonSound != None)
       {
          if ( (FirstPersonSound != None) && (Instigator != None) )
    	  {
    			// play LocalSound non-spatialized
    			if ( (AC == None) || AC.IsPendingKill() )
    			{
    				AC = SoundOwner.CreateAudioComponent(FirstPersonSound, FALSE, TRUE);
    			}
    			if (AC != None)
    			{
    				AC.bUseOwnerLocation = TRUE;
    				AC.bAllowSpatialization = FALSE;
    				AC.bAutoDestroy = TRUE;
    				AC.Play();

    				return AC;
    			}
     	  }
       }
       else
       {
          if(TGP != none )
          {
             if ( (ThirdPersonSound != None) && (Instigator != None) )
    	     {
    			// play LocalSound non-spatialized
    			if ( (AC == None) || AC.IsPendingKill() )
    			{
    				AC = SoundOwner.CreateAudioComponent(ThirdPersonSound, FALSE, TRUE);
    			}
    			if (AC != None)
    			{
    				AC.bUseOwnerLocation = TRUE;
    				AC.bAllowSpatialization = TRUE;
    				AC.bAutoDestroy = TRUE;
    				AC.Play();

    				return AC;
    			}
     	     }
          }
       }

   }
   else
   {
        if( Instigator.IsLocallyControlled() )
        {
        	  if ( (FirstPersonSound != None) && (Instigator != None) )
        	  {
        			// play LocalSound non-spatialized
        			if ( (AC == None) || AC.IsPendingKill() )
        			{
        				AC = SoundOwner.CreateAudioComponent(FirstPersonSound, FALSE, TRUE);
        			}
        			if (AC != None)
        			{
        				AC.bUseOwnerLocation = TRUE;
        				AC.bAllowSpatialization = FALSE;
        				AC.bAutoDestroy = TRUE;
        				AC.Play();

        				return AC;
        			}
         	  }
    	}
   }

   return AC;
}

// weapon meleeing state

reliable sync function SyncPlayMeleeAction()
{
	if( Instigator.IsLocallyControlled() )
    {
		// Play First-Person Animation.
        PlayMeleeAction();
        // Play TPS Animation
        HDPawn(Instigator).PlayMeleeAction();
	}
	else
	{
		// Play Third-Person Animation.
	  	HDPawn(Instigator).PlayMeleeAction();
	}
}

reliable sync function SyncEndMeleeAction()
{
    HDPawn(Instigator).EndMeleeAction();
}

simulated function PlayMeleeAction()
{
	local HDPawn HDP;
	HDP = HDPawn(Instigator);
    if ( HDP != None && ArmWeaponMelee != '' && ArmsAnimSet != none )
	{
		PlayArmAnimation(ArmWeaponMelee, MeleeTime);
		TMSkeletalMeshComponent(HDP.MeleeWeapon).SetFOV(UnZoomObjectFOV);
		HDP.SetKnifeVisibility(True);
        HDP.AdditiveBlendingNode.SetBlendTarget( 0.0f, 0.0f );
	}
}

reliable server function ServerMeleeAttack()
{
	if( Instigator == None || !Instigator.bNoWeaponFiring )
	{
		BeginMeleeAttack();
	}
}

simulated function BeginMeleeAttack();

simulated function SendToMeleeingState()
{
	if ( MeleeAttackState == '' ){ return; }
	GotoState(MeleeAttackState);
}

simulated function PlayMeleeingAttackSound()
{
    // play weapon fire sound
	if ( WeaponMeleeSnd != None && !bStopSoundPlay )
	{
		//MakeNoise(1.0);
		WeaponPlaySound( WeaponMeleeSnd );
	}
}

simulated function MeleeingAttack()
{
	PlayMeleeingAttackSound();

	CustomFire();

	TMInventoryManager(InvManager).OwnerEvent('MeleeingAttack');
}

simulated state WeaponMeleeing
{
	ignores WeaponSprintOut, WeaponSprintIn, ToggleMelee, Reload;
	simulated function BeginState(Name PrevStateName)
	{
		local HDPawn HDP;
		HDP = HDPawn(Instigator);

		// leave zoom first
        TerminateZoomMode();

		if ( HDP == none || HDP.MeleeWeapon == none )
		{
			FinishMeleeState();
            return;
		}


		MeleeingAttack();

		SetTimer( MeleeTime, false, 'FinishMelee');
        if ( ROLE == ROLE_Authority )
        {
            SyncPlayMeleeAction();
            HDPawn(Instigator).SetFiringFlag(True);
        }
	}

    simulated function Rotator GetAdjustedAim( vector StartFireLoc )
    {
        return Super.GetAdjustedAim( StartFireLoc );
    }

    simulated event float GetTraceRange()
    {
        local float RangeScale;
        local HDPawn HDP;
        HDP = HDPawn(Instigator);
        RangeScale = ((HDP==None || !HDP.bIsSprint )? 1.0 : 1.5);
        return WeaponMeleeRange * RangeScale;
    }

    simulated function vector KnifeAttackEndTrace( vector StartTrace, rotator Offset )
    {
        return StartTrace + vector(GetAdjustedAim(StartTrace)+Offset) * GetTraceRange();
    }

	simulated function CustomFire()
	{
		local vector StartTrace, EndTrace, Extent;
		local Array<ImpactInfo>	ImpactList;
		local int i;

	 	Extent = vect(0,0,0);
	 	// define range to use for CalcWeaponFire()
	 	StartTrace = InstantFireStartTrace();

	 	EndTrace = KnifeAttackEndTrace(StartTrace, rot(0,0,0) );
        //DrawDebugLine(StartTrace, EndTrace, 255,0,0, true );
	 	CalcWeaponFire( StartTrace, EndTrace, ImpactList, Extent );

        EndTrace = KnifeAttackEndTrace(StartTrace, rot(0,4000,0) );
        //DrawDebugLine(StartTrace, EndTrace, 255,255,0, true );
        CalcWeaponFire( StartTrace, EndTrace, ImpactList, Extent );

        EndTrace = KnifeAttackEndTrace(StartTrace, rot(0,8000,0) );
        //DrawDebugLine(StartTrace, EndTrace, 0,255,0, true );
        CalcWeaponFire( StartTrace, EndTrace, ImpactList, Extent );

    	EndTrace = KnifeAttackEndTrace(StartTrace, rot(0,-4000,0) );
        //DrawDebugLine(StartTrace, EndTrace, 0,255,255, true );
        CalcWeaponFire( StartTrace, EndTrace, ImpactList, Extent );

		EndTrace = KnifeAttackEndTrace(StartTrace, rot(0,-8000,0) );
        //DrawDebugLine(StartTrace, EndTrace, 0,0,255, true );
        CalcWeaponFire( StartTrace, EndTrace, ImpactList, Extent );

        for (i = 0; i < ImpactList.length; i++)
		{
			ProcessMeleeHit(CurrentFireMode, ImpactList[i]);
		}
	}

	simulated function ProcessMeleeHit( byte FiringMode, ImpactInfo Impact, optional int NumHits )
	{
		local HDBasePawn P;
		local float Damage;
		local class<TMEmitCameraEffect> CameraEffect;
		local class<TMDamageType> TMDT;
		local TMPlayerController PC;

		if ( Role == Role_Authority )
		{
			if ( Impact.HitActor != None && Instigator != None && Instigator.Health > 0 )
			{
				P = HDBasePawn(Impact.HitActor);
				if ( P == none || P.Health <= 0 )
					return;

				if ( FiringMode == CurrentFireMode )
				{
					Damage = MeleeDamage;
					if ( P != none && P != Instigator )
					{
						//if( VSize(Impact.HitLocation - Instigator.GetWeaponStartTraceLocation()) > WeaponMeleeRange )
						//{
						//	Damage = 0;
						//}

						P.TakeDamage( Damage, Instigator.Controller, Impact.HitLocation, Impact.RayDir, MeleeDamageTypes, Impact.HitInfo, self );

						PC = TMPlayerController(Instigator.Controller);
						if ( P.Health <= 0 && PC != none )
						{
							if ( !class'TMGame'.Static.UseLowGore(WorldInfo) )
							{
								TMDT = class<TMDamageType>(MeleeDamageTypes);
								if (TMDT != None)
								{
									CameraEffect = TMDT.static.GetDeathCameraEffectInstigator(P);
									if (CameraEffect != None)
									{
										TMPlayerController(Instigator.Controller).ClientSpawnCameraEffect(CameraEffect);
									}
								}
							}
						}
					}
				}
			}
		}
	}

	simulated function FinishMeleeState()
	{
	   GotoState('Active');
	}
    simulated function FinishMelee()
	{
		HDPawn(Instigator).SetKnifeVisibility(False);
		PlayArmAnimation(ArmsQuickEquipAnims[CurrentFireModeType], 0.35);
		SetTimer( 0.35, false, 'FinishMeleeState' );
	}

	simulated event EndState( Name NextStateName )
	{
		Instigator.StopFire(CurrentFireMode);
		ClearTimer('FinishMelee');
		ClearTimer('FinishMeleeState');

		HDPawn(Instigator).SetKnifeVisibility(False);
        if ( ROLE == ROLE_Authority )
        {
            SyncEndMeleeAction();
            HDPawn(Instigator).SetFiringFlag(False);
        }
	}
}


// Update camera breath
simulated function UpdateCameraBreath( out rotator out_CamRot ){}

// weapon calc camera
simulated function WeaponCalcCamera(float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot)
{
	local HDPawn HDP;
	local vector tmpLoc;
	local rotator tmpRot;

	HDP = HDPawn(Instigator);

	if ( HDP == none )
		return;

	if ( HDP.ArmsMesh[0] == none )
		return;

	HDP.ArmsMesh[0].GetSocketWorldLocationAndRotation('Camera', tmpLoc, tmpRot, 1);

	out_CamLoc += tmpLoc;
	out_CamRot += tmpRot;

    UpdateCameraBreath( out_CamRot );

	out_CamRot.Pitch += (punch_angle.X) / 360.0 * 65535.0;
	out_CamRot.Yaw += (punch_angle.Y) / 360.0 * 65535.0;

	UpdatePunch(fDeltaTime);
}

//---------------------------------------------------------
// night vision
//---------------------------------------------------------
simulated  function bool ToggleNightVision( bool bIsNightVision )
{
	local name stateName;

	if ( !IsInState('Active') && !IsInState('InActive') )
		return false;

	stateName = (bIsNightVision)? 'WeaponNVEquip' : 'WeaponNVPutDown';

	GotoState(stateName);

	return true;
}

//---------------------------------------------------------
// Gas Mask
//---------------------------------------------------------
simulated  function bool ToggleGasMask( bool bIsEquip )
{
	local name stateName;

	if ( !IsInState('Active') && !IsInState('InActive') )
		return false;

	stateName = (bIsEquip)? 'WeaponGMEquip' : 'WeaponGMPutDown';

	GotoState(stateName);

	return true;
}




//---------------------------------------------------------
// state
//---------------------------------------------------------
simulated state WeaponNVEquip
{
	ignores WeaponSprintIn, Reload, StartFire, PutDownWeapon, Activate, ToggleGasMask;
	simulated function BeginState(Name PrevStateName)
	{
		local HDPawn HDP;
		HDP = HDPawn(Instigator);
		if ( HDP != none && HDP.NightVision != none )
		{
			// out zoom
			if ( ZoomState == ZST_Zoomed )
			{
                TerminateZoomMode();
			}

			PlayArmAnimation( ArmNVEquips[CurrentFireModeType], NVEquipTime );
			SetTimer( 0.5, false, 'ChangeNVHUD' );
			SetTimer( 0.95, false, 'OpenEye' );
			SetTimer( 2.0, false, 'EquipNightVision' );
			HDP.SetNVVisibility(True);
		}
		else
		{
			GotoState('Active');
		}
	}

	simulated function EquipNightVision()
	{
        local HDPawn HDP;
		HDP = HDPawn(Instigator);
		if ( HDP != none && HDP.NightVision != none )
		{
			HDP.SetNVVisibility(False);
		}
        GotoState('Active');
	}

	simulated function ChangeNVHUD()
	{
        local HDPawn HDP;
        HDP = HDPawn(Instigator);
        if ( HDP != none )
        {
           HDP.NVEffectInstance.SetScalarParameterValue('Brintness', 0.0 );
           HDP.NVEffect.bShowInGame = true;
           HDP.SetNVVisibility(False);
        }
	}

	simulated function OpenEye()
	{
        local HDPawn HDP;
        HDP = HDPawn(Instigator);
        if ( HDP != none )
        {
           HDP.NVEffectInstance.SetScalarParameterValue('Brintness', 5.0 );
		   HDP.CachedSetting.Bloom_Scale =  WorldInfo.DefaultPostProcessSettings.Bloom_Scale;
		   HDP.CachedSetting.WKShader_GlobalMeshEmissive = WorldInfo.DefaultPostProcessSettings.WKShader_GlobalMeshEmissive;
		   //HDP.CachedSetting.Scene_HighLights = WorldInfo.DefaultPostProcessSettings.Scene_HighLights;
           WorldInfo.DefaultPostProcessSettings.Bloom_Scale = 32;
           //WorldInfo.DefaultPostProcessSettings.Scene_HighLights *= 0.3;
		   WorldInfo.DefaultPostProcessSettings.WKShader_GlobalMeshEmissive = 4.0;

		   WorldInfo.GlobalPPSetting.bOverride_EnableBloom = True;
           WorldInfo.GlobalPPSetting.bOverride_Bloom_Scale = True;
		   WorldInfo.GlobalPPSetting.bOverride_WKShader_GlobalMeshEmissive = True;
		   HDP.SetNVVisibility(False);
        }
	}

}
simulated state WeaponNVPutDown
{
	ignores WeaponSprintIn, Reload, StartFire, PutDownWeapon, Activate, ToggleGasMask;
	simulated function BeginState(Name PrevStateName)
	{
		local HDPawn HDP;
		HDP = HDPawn(Instigator);

		if ( HDP != none && HDP.NightVision != none )
		{
			// out zoom
			if ( ZoomState == ZST_Zoomed )
			{
                TerminateZoomMode();
			}

			PlayArmAnimation( ArmNVPutDowns[CurrentFireModeType], NVPutDownTime );
			SetTimer( 0.3, false, 'CloseEye' );
			SetTimer( 0.65, false, 'NVShow' );
			SetTimer( 1.8, false, 'PutDownNightVision' );
			//HDP.NightVision.SetHidden(true);
			HDP.SetNVVisibility(False);
		}
		else
		{
			GotoState('Active');
		}

	}

    simulated function CloseEye()
	{
        local HDPawn HDP;
        HDP = HDPawn(Instigator);
        if ( HDP != none )
        {
           HDP.NVEffectInstance.SetScalarParameterValue('Brintness', 0.0 );
           HDP.ClientResetBloom();
		   HDP.SetNVVisibility(False);
        }
	}

    simulated function NVShow()
    {
        local HDPawn HDP;
        HDP = HDPawn(Instigator);
        if ( HDP != none )
        {
            HDP.NVEffect.bShowInGame = false;
			HDP.SetNVVisibility(True);
        }
    }
	simulated function PutDownNightVision()
	{
		local HDPawn HDP;
		HDP = HDPawn(Instigator);
		if ( HDP != none && HDP.NightVision != none )
		{
			//HDP.NightVision.SetHidden(true);
			HDP.SetNVVisibility(False);
		}
		GotoState('Active');
	}

	simulated function EndState( Name NextStateName )
	{
	   ClearTimer('CloseEye');
	   ClearTimer('NVShow');
	   ClearTimer('PutDownNightVision');
	   CloseEye();
       Super.EndState(NextStateName);
	}
}



simulated state WeaponGMEquip
{
	ignores WeaponSprintIn, Reload, StartFire, PutDownWeapon, Activate, ToggleNightVision;
	simulated function BeginState(Name PrevStateName)
	{
		local HDPawn HDP;
		HDP = HDPawn(Instigator);

		if ( HDP != none && HDP.GasMask != none )
		{
			// out zoom
			if ( ZoomState == ZST_Zoomed )
			{
                TerminateZoomMode();
			}

			PlayArmAnimation( ArmGMEquips[CurrentFireModeType], GMEquipTime );
			SetTimer( 0.5, false, 'ChangeGMHUD' );
			SetTimer( 1.1, false, 'OpenEye' );
			SetTimer( 1.733, false, 'EquipGasMask' );
			//HDP.GasMask.SetHidden(false);
			HDP.SetGMVisibility(True);
		}
		else
		{
			GotoState('Active');
		}
	}

	simulated function EquipGasMask()
	{
		local HDPawn HDP;
		HDP = HDPawn(Instigator);
		if ( HDP != none && HDP.GasMask != none )
		{
			//HDP.GasMask.SetHidden(true);
			HDP.SetGMVisibility(False);
		}
        GotoState('Active');
	}

	simulated function ChangeGMHUD()
	{
        local HDPawn HDP;
        HDP = HDPawn(Instigator);
        if ( HDP != none )
        {
           HDP.GMEffectInstance.SetScalarParameterValue('Brintness', 0.0 );
           HDP.GMEffect.bShowInGame = true;
		   //HDP.GasMask.SetHidden(true);
		   HDP.SetGMVisibility(False);
        }
	}

	simulated function OpenEye()
	{
        local HDPawn HDP;
        HDP = HDPawn(Instigator);
        if ( HDP != none )
        {
           HDP.GMEffectInstance.SetScalarParameterValue('Brintness', 1.0 );
		   //HDP.GasMask.SetHidden(true);
		   HDP.SetGMVisibility(False);
        }
	}

}
simulated state WeaponGMPutDown
{
	ignores WeaponSprintIn, Reload, StartFire, PutDownWeapon, Activate,ToggleNightVision;
	simulated function BeginState(Name PrevStateName)
	{
		local HDPawn HDP;
		HDP = HDPawn(Instigator);

		if ( HDP != none && HDP.GasMask != none )
		{
			// out zoom
			if ( ZoomState == ZST_Zoomed )
			{
                TerminateZoomMode();
			}

			PlayArmAnimation( ArmGMPutDowns[CurrentFireModeType], GMPutDownTime );
			SetTimer( 0.3, false, 'CloseEye' );
			SetTimer( 1.0, false, 'GMShow' );
			SetTimer( 1.9, false, 'PutDownGasMask' );
			//HDP.GasMask.SetHidden(true);
			HDP.SetGMVisibility(False);
		}
		else
		{
			GotoState('Active');
		}

	}

    simulated function CloseEye()
	{
        local HDPawn HDP;
        HDP = HDPawn(Instigator);
        if ( HDP != none )
        {
           HDP.GMEffectInstance.SetScalarParameterValue('Brintness', 0.0 );
		   //HDP.GasMask.SetHidden(true);
		   HDP.SetGMVisibility(False);
        }

	}

    simulated function GMShow()
    {
        local HDPawn HDP;
        HDP = HDPawn(Instigator);
        if ( HDP != none )
        {
            HDP.GMEffect.bShowInGame = false;
			//HDP.GasMask.SetHidden(false);
			HDP.SetGMVisibility(True);
        }

    }
	simulated function PutDownGasMask()
	{
		local HDPawn HDP;
		HDP = HDPawn(Instigator);
		if ( HDP != none && HDP.GasMask != none )
		{
			//HDP.GasMask.SetHidden(true);
			HDP.SetGMVisibility(False);
		}
		GotoState('Active');
	}
}


// Hidden Weapon
simulated state WeaponHidden
{
    ignores WeaponSprintIn, Reload, StartFire, PutDownWeapon, Activate, ToggleNightVision, ToggleGasMask;
    simulated function BeginState(Name PrevStateName)
	{
		// out zoom
		if ( ZoomState == ZST_Zoomed )
		{
            TerminateZoomMode();
        }

		PlayArmAnimation( ArmsQuickPutDownAnims[CurrentFireModeType], 0.3 );
		SetTimer(0.25, false, 'HiddenArms');
	}
    simulated function HiddenArms()
    {
        bForceHidden = TRUE;
    }
    simulated event EndState( Name NextStateName )
	{
        bForceHidden = FALSE;
        bPendingShow = TRUE;
	}
}


// Play Fire Effect
simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	// Play Weapon fire animation
    local float time, weapontime;

    // shake view first
	ShakeView();

    time = GetFireInterval(FireModeNum);
    weapontime = ReFireFlag[FireModeNum]==EFST_ONE? 0.0 : time;
	if ( FireModeNum < WeaponFireAnim.Length && WeaponFireAnim[FireModeNum] != '' )
		PlayWeaponAnimation( WeaponFireAnim[FireModeNum], weapontime );
	if ( FireModeNum < ArmFireAnim.Length && ArmFireAnim[FireModeNum] != '' && ArmsAnimSet != none)
		PlayArmAnimation( ArmFireAnim[FireModeNum], time );

    if ( bForceHidden )
        return;



	// Start muzzle flash effect
	CauseMuzzleFlash();

	// Play fire effects for owned player
	if (WorldInfo.Netmode != NM_Client || (Instigator != None && Instigator.IsLocallyControlled()) )
	{
		//PlayOwnedFireEffects( FireModeNum, HitLocation );
	}

	// clip bullet
	CauseClipBullet();
}

simulated function StopFireEffects(byte FireModeNum)
{
	Super.StopFireEffects(FireModeNum);
	StopClipBullet();
}

//---------------------------------------------------------
// Fire effect
//---------------------------------------------------------
/**
 * Turns the MuzzleFlashlight off
 */
simulated event ClipBulletTimer()
{
	if (ClipBulletPSC != none && (!bClipBulletPSCLoops) )
	{
		ClipBulletPSC.DeactivateSystem();
	}
}

/**
 * Allows a child to setup custom parameters on the muzzle flash
 */

simulated function SetClipBulletParams(ParticleSystemComponent PSC)
{
	//PSC.SetColorParameter('MuzzleFlashColor', MuzzleFlashColor);
	PSC.SetVectorParameter('Size',ClipSize);
}

/**
 * Called on a client, this function Attaches the WeaponAttachment
 * to the Mesh.
 */
simulated function AttachClipBullet()
{
	local SkeletalMeshComponent SKMesh;

	// Attach the Muzzle Flash
	bClipBulletAttached = true;
	SKMesh = SkeletalMeshComponent(Mesh);
	if (  SKMesh != none )
	{
		if ( ClipBulletPSC != none && !SKMesh.IsComponentAttached(ClipBulletPSC))
		{
			SKMesh.AttachComponentToSocket(ClipBulletPSC, ClipBulletSocket);
		}
	}
}

/**
 * Remove/Detach the muzzle flash components
 */
simulated function DetachClipBullet()
{
	local SkeletalMeshComponent SKMesh;

	bClipBulletAttached = false;
	SKMesh = SkeletalMeshComponent(Mesh);
	if (  SKMesh != none )
	{
		if (ClipBulletPSC != none)
			SKMesh.DetachComponent( ClipBulletPSC );
	}
	//ClipBulletPSC = None;
}

/**
 * Causes the muzzle flash to turn on and setup a time to
 * turn it back off again.
 */
simulated event CauseClipBullet()
{
	local HDPawn P;

	if ( WorldInfo.NetMode != NM_Client )
	{
		P = HDPawn(Instigator);
		if ( (P == None) || !P.bUpdateEyeHeight )
		{
			return;
		}
	}

	if ( GetHand() != HAND_Hidden )
	{
		if ( !bClipBulletAttached )
		{
			AttachClipBullet();
		}
		if (ClipBulletPSC != None)
		{
			if (!bClipBulletPSCLoops || (!ClipBulletPSC.bIsActive || ClipBulletPSC.bWasDeactivated))
			{
				ClipBulletPSC.ActivateSystem();
			}
		}

		// Set when to turn it off.
		SetTimer(ClipBulletDuration,false,'ClipBulletTimer');
	}
}

simulated event StopClipBullet()
{
	ClearTimer('ClipBulletTimer');
	ClipBulletTimer();

	if ( ClipBulletPSC != none )
	{
		ClipBulletPSC.DeactivateSystem();
	}
}


// Play Owned Fire Effects
simulated function PlayOwnedFireEffects(byte FireModeNum, vector HitLocation)
{
	// if we should spawn a tracer effect for the local player, let's do so
	if( WorldInfo.NetMode != NM_DedicatedServer &&
		!IsZero(HitLocation)
		)
	{
		if (Instigator != None)
		{
			SpawnTracerEffect( HitLocation, VSize(HitLocation - Instigator.Location) );
		}
		else
		{
			// if no instigator (some system is manipulating weapons by hand), measure from fire start location
			SpawnTracerEffect( HitLocation, VSize(HitLocation - GetMuzzleLoc()) );
		}
	}
}

simulated function TGProj_BulletTracer GetTracer( vector SpawnLocation, rotator SpawnRotation )
{
	return TGGRI(WorldInfo.GRI).GOP.GetTracer( TracerType, 0, SpawnLocation, SpawnRotation );
}
/**
 * Spawn tracer effect for instant hit shots.
 * Network: All Clients
 *
 * @param HitLocation	Location instant trace did hit
 & @param HitDistance	Distance to the hit location
 */

simulated function TGProj_BulletTracer SpawnTracerEffect( vector HitLocation, float HitDistance )
{
	local vector	SpawnLoc;
	local rotator	SpawnRot;
	local TGProj_BulletTracer	SpawnedProjectile;
	local vector	FinalTracerScale;

	if ( HitDistance > 128 )
	{
		SpawnLoc = GetMuzzleLoc();
		SpawnedProjectile = GetTracer( SpawnLoc, SpawnRot );

		if ( (SpawnedProjectile != none ) && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Instigator = Instigator;

			// set tracer scale
			FinalTracerScale = TracerScale;
			SpawnedProjectile.SetDrawScale3D(FinalTracerScale);
			//`log("scaled tracer"@FinalTracerScale);

			// init!
			SpawnedProjectile.InitTracer(SpawnLoc, HitLocation);

		}
	}

	return SpawnedProjectile;
}

/*reliable sync function SyncPawnEquipWeapon()
{
    local HDPawn HDP;
    HDP = HDPawn(Instigator);
    if ( HDP != None )
    {
        HDP.UpdatePawnAnimSets();
        HDP.EquipWeaponAction();
    }
}

reliable sync function SyncPawnEquipWeaponEnd()
{
    local HDPawn HDP;
    HDP = HDPawn(Instigator);
    if ( HDP != None )
        HDP.EquipWeaponEndAction();
}
*/

simulated state WeaponEquipping
{
    ignores  WeaponSprintIn, WeaponSprintOut, Reload;
    simulated event BeginState(Name PreviousStateName)
    {
        bNotPickAttaching = FALSE; // clear this flag while equipping
        Super.BeginState(PreviousStateName);
        HDPawn(Instigator).PawnEquipWeapon();
        //SyncPawnEquipWeapon();
    }

    simulated event EndState(Name NextStateName)
    {
        Super.EndState(NextStateName);
        //SyncPawnEquipWeaponEnd();
        HDPawn(Instigator).PawnEquipWeaponEnd();
        HDInventoryManager(InvManager).bStopPickUp = FALSE;
    }
    simulated function StartFire( byte FireModeNum )
	{
	   ;
	}
}

// dummy fire , from HDSeqAct_DummyWeaponFire
simulated function DummyWeaponFire( float interval );

// change zoom function
simulated function ChangeZoomFunction( bool bUp );

simulated function WeaponStable( bool bFlag );

simulated function ChangeZoomFireMode();
simulated function ZoomFireMode()
{
	if( Instigator == None || !Instigator.bNoWeaponFiring )
	{
//		if( Role < Role_Authority )
//		{
//			// if we're a client, synchronize server
//			ServerZoomFireMode();
//		}

		// Start fire locally
        ChangeZoomFireMode();
	}
}

reliable server function ServerZoomFireMode()
{
	if( Instigator == None || !Instigator.bNoWeaponFiring )
	{
       ChangeZoomFireMode();
	}
}


simulated state WeaponFireModeChange
{
	ignores WeaponSprintIn, WeaponSprintOut, Reload, StartFire, PutDownWeapon, Activate, ToggleNightVision, ToggleGasMask, StartZoom, SetCurrentFireModeTypeLocally;
    simulated event BeginState(Name PreviousStateName)
	{
		// leave zoom first
        TerminateZoomMode();
        StopLoopFireSound();
        TriFireCount = 0;

		PlayArmAnimation(ArmWeaponModeSwitchAnimations[CurrentFireModeType], WeaponFireModeChangeTime[CurrentFireModeType] );
		PlayWeaponAnimation(WeaponIdleAnims[CurrentFireModeType], 0);
        SetTimer( WeaponFireModeChangeTime[CurrentFireModeType], false, 'ExitState' );

	}

	simulated function ExitState()
	{
		GotoState('Active');
	}
	simulated event EndState(Name NextStateName)
	{
		;
	}
}


simulated function ResetWeapon()
{
	// leave zoom first
	bStopSoundPlay = TRUE;
    TerminateZoomMode();
    ForceEndFire();
	OnAnimEnd(none, 0.f, 0.f);
	GotoState('InActive');
	GotoState('Active');
//	Activate();
	bStopSoundPlay = FALSE;
}


/**
 * Show the weapon being put away
 */
simulated function PlayWeaponPutDown()
{
	PlayWeaponAnimation( WeaponPutDownAnim, PutDownTime );
    // Play the animation for the weapon being put down
	if ( ArmsPutDownAnims[CurrentFireModeType] != '' && ArmsAnimSet != none)
	{
		PlayArmAnimation( ArmsPutDownAnims[CurrentFireModeType], PutDownTime );
	}

	// play any associated sound
	if ( WeaponPutDownSnd != None && !bStopSoundPlay && !HDBaseGame(WorldInfo.Game).bPendingMatch )
		WeaponPlaySound( WeaponPutDownSnd );
}

/**
 * Show the weapon begin equipped
 */
simulated function PlayWeaponEquip()
{
	PlayWeaponAnimation( WeaponEquipAnim, EquipTime );
    // Play the animation for the weapon being put down

	if ( ArmsEquipAnims[CurrentFireModeType] != '' && ArmsAnimSet != none)
	{
		PlayArmAnimation(ArmsEquipAnims[CurrentFireModeType], EquipTime);
	}

	// play any assoicated sound
	if ( WeaponEquipSnd != None && !bStopSoundPlay && !HDBaseGame(WorldInfo.Game).bPendingMatch )
		WeaponPlaySound( WeaponEquipSnd );
}

simulated state WeaponAbortEquip
{
	simulated function BeginState(name PrevStateName)
	{
		local AnimNodeSequence AnimNode;
		local float Rate;

		if (bDebugWeapon)
		{
			;
		}


		// Time the abort
		SetTimer(FMax(SwitchAbortTime, 0.01),, 'WeaponEquipAborted');

		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			// play anim
			if(ArmsPutDownAnims[CurrentFireModeType] != '' && ArmsAnimSet != none && Instigator != none /* && Instigator.IsLocallyControlled() && Instigator.IsHumanControlled() */)
			{
				AnimNode = GetArmAnimNodeSeq();
				if (AnimNode != None && AnimNode.AnimSeq != None)
				{
					AnimNode.SetAnim(ArmsPutDownAnims[CurrentFireModeType]);
					Rate = AnimNode.AnimSeq.SequenceLength/PutDownTime;
					AnimNode.PlayAnim(false, Rate, AnimNode.AnimSeq.SequenceLength - SwitchAbortTime * Rate);
				}
			}
		}
	}


	simulated function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
		SetBackAttachmentClass();     // cancle weapon attaching
	}
}


simulated function DrawWeaponHitPawn( HUD H )
{
	local float x,y, ScreenX, ScreenY, ScaleValue;

    ScaleValue = (H.Canvas.ClipX >= H.Canvas.ClipY)? H.Canvas.ClipY/1024.0 : H.Canvas.ClipX/1024.0;
	X = H.Canvas.ClipX * 0.5;
	Y = H.Canvas.ClipY * 0.5;
	ScreenX = X - (64 * 0.5 * ScaleValue);
	ScreenY = Y - (64 * 0.5 * ScaleValue);
	if ( CrosshairHitPawn != none )
	{
        CrosshairHitPawnAlpha = CrosshairHitPawnAlpha - CrosshairHitPawnScale * WorldInfo.DeltaSeconds;
        CrosshairHitPawnAlpha = Clamp( CrosshairHitPawnAlpha, 0, 255 );
        H.Canvas.SetDrawColor(255, 255, 255, CrosshairHitPawnAlpha);
		H.Canvas.SetPos(ScreenX, ScreenY);
		H.Canvas.DrawTile(CrosshairHitPawn,64*ScaleValue, 64*ScaleValue, 0, 0, 64,64);
	}
}

simulated function BlendOutCrosshair()
{
    CrosshairHitPawnScale = CrosshairHitPawnAlphaSpeed;
}

reliable client function ClientSetDrawHitPawn()
{
    CrosshairHitPawnAlpha = 255;
    CrosshairHitPawnScale = 0.f;
    ClearTimer('BlendOutCrosshair');
    SetTimer( CrosshairHitPawnTime, false, 'BlendOutCrosshair' );
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
    local TGPawn_EnemyBase P;
    local HDBasePawn HDBP;
    //local vector TestLoc;

    Super.ProcessInstantHit(FiringMode, Impact, NumHits);

   	//Notify sth
	if(/*Role == ROLE_Authority*/WorldInfo.NetMode == NM_Standalone && Impact.HitActor != none && TGPawn(Impact.HitActor) == none && Instigator != none && Instigator.IsLocallyControlled())
	{
        foreach WorldInfo.AllPawns(class'TGPawn_EnemyBase', P, Impact.HitLocation, 125)  //2.5m
        {
            //if(VSizeSq(Impact.HitLocation - P.Location) > 15625) //2.5m
            //{
              //  TestLoc = P.Mesh.GetBoneLocation('head');
//                if( VSizeSq(Impact.HitLocation - TestLoc) > 10000 )  //2m
//                    continue;
           // }

            P.OnFiredAround(Instigator.Controller);
        }
    }

    HDBP = HDBasePawn(Impact.HitActor);
    if ( HDBP != None )
        ClientSetDrawHitPawn();
}

/**
 * Tells the weapon to play a firing sound (uses CurrentFireMode)
 */
simulated function PlayFiringSound()
{
	if (CurrentFireMode<WeaponFireSnd.Length)
	{
		// play weapon fire sound
		if ( WeaponFireSnd[CurrentFireMode] != None )
		{
		    if ( MakeNoiseFlags[CurrentFireMode] == 1 )
		    {
                if(Instigator != none)
			        Instigator.MakeNoise(1.0);
		        else
		            MakeNoise(1.0);
            }
			WeaponPlaySound( WeaponFireSnd[CurrentFireMode] );
		}
	}
}


//---------------------------------------------------------
// Drop weapon and create dropped item
//---------------------------------------------------------
function DropFrom(vector StartLocation, vector StartVelocity)
{
    TerminateZoomMode();
    InvManager = None;
	Super.DropFrom(StartLocation, StartVelocity);
}

simulated function HDDroppedPickup DropAndCreateItem( vector loation, vector vel )
{
	local HDDroppedPickup P;
    TerminateZoomMode();

	if (Instigator != None && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
	{
		PreloadTextures(false);
	}
	// Become inactive
	GotoState('Inactive');

	// Stop Firing
	ForceEndFire();
	// Detach weapon components from instigator
	DetachWeapon();


	if( Instigator != None && Instigator.InvManager != None )
	{
		Instigator.InvManager.RemoveFromInventory(Self);
	}

    InvManager = None;

	// if cannot spawn a pickup, then destroy and quit
	if( DroppedPickupClass == None || DroppedPickupMesh == None )
	{
		Destroy();
		return None;
	}

	P = HDDroppedPickup(Spawn(DroppedPickupClass,,, loation));
	if( P == None )
	{
		Destroy();
		return None;
	}

    SetCurrentFireModeType(ECFMT_PRIMARY);

	P.SetPhysics(PHYS_Falling);
	P.Inventory	= self;
	P.InventoryClass = class;
	P.Velocity = vel;
	P.Instigator = none;
	P.SetPickupMesh(DroppedPickupMesh);
	if ( BackAttachType == EATTACH_PISTOL )
	   P.SetCollisionSize( 5, 20 );

	Instigator = None;
	GotoState('');
    return P;
}


/**
 * This function is called from the pawn when the visibility of the weapon changes
 */

simulated function ChangeVisibility(bool bIsVisible)
{
    Super.ChangeVisibility(bIsVisible);
    if ( Mesh != None )
        Mesh.SetHidden(!bIsVisible);
}


simulated function SetupArmsAnim()
{
	local HDPawn HDP;
	local TMAnimNodeSequence PlayNode;
	HDP = HDPawn(Instigator);
	if (HDP != None)
	{
		PlayNode = HDP.BaseNode;
		if ( PlayNode != None )
		{
		  PlayNode.StopAnim();
		  PlayNode.SetAnim('');
		}
		if (ArmsAnimSet != None)
		{
			HDP.ArmsMesh[0].AnimSets[1] = ArmsAnimSet;
			HDP.ArmsMesh[0].SetHidden(false);
			HDP.ArmsMesh[0].SetLightEnvironment(HDP.LightEnvironment);
		}
		else
		{
			HDP.ArmsMesh[0].SetHidden(true);
			HDP.ArmsMesh[1].SetHidden(true);
		}
	}
}


//---------------------------------------------------------
// 3rd bakc weapon attach
//---------------------------------------------------------
simulated function  WeaponEquipToBack()
{
    if( !IsInState('Inactive') || bNotPickAttaching ) return;
    AttachWeaponToBack();
}

simulated function AttachWeaponToBack()
{
    // attach to 3rd mode
    SetBackAttachmentClass();
}


simulated function  SetBackAttachmentClass()
{
    local HDPawn   HDP;
	local TGPawn TGP;
    local int      Index;

    // if next weapon is grenade, do not attach current weapon to back or leg slot
    if ( HDWeap_Grenade(InvManager.PendingWeapon) != None )
        return;

    HDP = HDPawn(Instigator);
    // Spawn the 3rd Person Attachment
	if (Role == ROLE_Authority && HDP != None && BackAttachType != EATTACH_NONE )
	{
		index = HDP.SetBackAttachmentWeapon( AttachmentClass, BackAttachType );
		if ( index != -1 && (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone || (WorldInfo.NetMode == NM_Client && Instigator.IsLocallyControlled())))
		{
			HDP.WeaponBackAttachmentChanged(index);
		}
	}

	TGP = TGPawn(Instigator);
	if (TGP != none)
	{
		TGP.WeaponBackAttachmentChanged(AttachmentClass);
	}
}

//---------------------------------------------------------
// Pick up
//---------------------------------------------------------
/* AnnouncePickup
	This inventory item was just picked up (from a DroppedPickup or PickupFactory)
*/
function AnnouncePickup(Pawn Other)
{
    // do not attaching to pawn's attachment socket
    bNotPickAttaching = TRUE;
    Super.AnnouncePickup(Other);
}


/**
 * Called when the weapon runs out of ammo during firing
 */
simulated function WeaponEmpty()
{
    local HDPawn HDP;

	if (bDebugWeapon)
	{
		;
		ScriptTrace();
	}


	// If we were firing, stop
	if ( IsFiring() )
	{
		GotoState('Active');
	}

	HDP = HDPawn(Instigator);
	if ( HDP != None )
	   HDP.CurrentWeaponEmptyNotify();

    if ( Instigator != none && Instigator.InvManager != None )
	{
		Instigator.InvManager.SwitchToBestWeapon( true );
	}


}

reliable client function ClientWeaponThrown()
{
    TerminateZoomMode();
	Super.ClientWeaponThrown();
}

State PendingClientWeaponSet
{
	simulated function PendingWeaponSetTimer()
	{
		// When variables are replicated, ClientWeaponSet, will send weapon to another state.
		// Therefore aborting this timer.
		// Using bDoNotActivate to create inventory
		ClientWeaponSet(bWasOptionalSet, False);
	}

	/** Event called when weapon enters this state */
	simulated event BeginState(Name PreviousStateName)
	{
		// Set a timer to keep checking for replicated variables.
		SetTimer(0.03f, TRUE, nameof(PendingWeaponSetTimer) );
	}

	/** Event called when weapon leaves this state */
	simulated event EndState(Name NextStateName)
	{
		ClearTimer( nameof(PendingWeaponSetTimer) );
	}
}

simulated state ClientPendingWeaponReload
{
    ignores WeaponSprintIn, WeaponSprintOut, Reload, StartFire, PutDownWeapon, Activate, ToggleNightVision, ToggleGasMask, StartZoom, SetCurrentFireModeTypeLocally;
    simulated event BeginState(name PreviousStateName)
    {
    }

    simulated event EndState(Name NextStateName)
    {
    }
}

