class DynamicSOFLAMAttachment extends StaticMeshActor notplaceable
native;

enum SLAMMessageState
{
	SMSGS_ARM,
	SMSGS_DISARM,
	SMSGS_NONE
};
enum SLAMMessageVisibilityState
{
	SMSGVS_NOCHANGE,
	SMSGVS_VISIBLE,
	SMSGVS_INVISIBLE
};
var bool bShowMessage;
var		SLAMMessageState SMSGState;

var()	Material ActiveMaterial; 
var()	Material DeactivatedMaterial; 
var Pawn placer;
var Pawn lastPlacer; //hack. :(
var Sound PlunkSound;
var class<Projectile> SpawnProjectileClass;
var class<DynamicSOFLAMMessage> MessageClass;
var class<DynamicSOFLAMMessage> DisarmMessageClass;
var (Tweaks) array<vector> PossibleOffsets;
var (Tweaks) array<rotator> OffsetRotations;
var (Tweaks) float maxDistToPlacer;
var int counter;
var Material RedLightTexture;
var Material GreenLightTexture;
var bool bAlwaysVisible;
var bool bStartPlacingOnTouch;
var bool bManualDetonate;
var bool bDestroyOwnerOnExplode;
var bool bCanDisarm;
var bool bDestroyAfterDisarm;
var bool bRenderedLastFrame;
var bool LoggingEnabled;
var bool bUseLastPlacerForClosestOffset;
var string defaultMeshName;
var(Events)	name	EventOnArmed;
var(Events)	name	EventOnDisarmed;
var(Events)	name	EventOnStartArming;
var(Events)	name	EventOnAbortArming;
var(Events)	name	EventOnStartDisarming;
var(Events)	name	EventOnAbortDisarming;
var localized string armMessage;
var localized string disarmMessage;

struct native ArmingTick
{
	var float PauseTime;
	var Sound TickSound;
	var int toggleSkin;
	var bool setArmed;
};

var array<ArmingTick> ArmingTicks;

var array<ArmingTick> DisarmingTicks;


native function SetDestroyOwnerOnExplode(bool b);
native function SetDetonateMode(bool bManualDet);
native function SetChargeMesh(StaticMesh sm);
native function internalExplode();
native function SetSkinsActive(bool b);
native function SetSkinsArmed();
native function SetPossibleOffsets(array<vector> offsets,array<rotator> rotations);
native function SetOffsetToOrigin();
native function SetAlwaysVisible(bool b);
native function SetStartPlacingOnTouch(bool b);
native function SetMessages(String arm,String disarm);
native event ChangeMessage(SLAMMessageState newState,optional SLAMMessageVisibilityState visible);
native function SetHidden(bool bHide);
native function int CheckClosestOffset();
native function MakeSureWeaponIsDown();
native function bool DoArmingTick(int counter);
native function DoDisarmingTick(int counter);
native function GotoCorrectArmedState();
native event AbortArming();
native event AbortDisarming();
native event SetPlacer(Pawn newPlacer,bool bPlacing);
native event SOFLAMLog(optional coerce string s);
native event CheckTouching();

event StartPlacing(ZombiePlayerPawn placingPlr)
{
}
event UsedBy( Pawn other )
{
}
event UnUsedBy( Pawn other )
{
}
event PlaceSOFLAM()
{
}
//called by native code everytime messages are displayed
//it's a total hack, I know.
event ChangeDefaultMessages(String armMessage,string disarmMessage)
{
	//wrc 1/13/04 YES! this is the best hack EVAR.  
	MessageClass.default.message = armMessage;
	DisarmMessageClass.default.message = disarmMessage;
}

state DelayUntilInactive 
{
	event UsedBy(Pawn other)
	{
		if (other==None) return;

		SetPlacer(other,false);

		if (PossibleOffsets.length != 0)
			GotoState('PlacingWithOffsets');
		else
			GotoState('PlacingWithNoOffsets');
		
		//will call the PlacingState version
		UsedBy(other);
	}
begin:
	Sleep(0.1);
	GotoState('Inactive');
}
event Timer()
{
	if (placer==None)
	{
		CheckTouching();
	}
}
auto state Inactive
{
	event Touch(Actor other)
	{
		if(bStartPlacingOnTouch && other.IsA('ZombiePlayerPawn') && other!=Owner)
		{
			soflamlog (other);
			StartPlacing(ZombiePlayerPawn(Other));
						
		}
	}
	event BeginState()
	{
	//	local ZombiePlayerPawn p;
		SetTimer(0.2,true);
		 
		setSkinsActive(false);
		SetHidden(true); //may not actually hide soflam if "alwaysvisible" is on, but does other stuff too
		
		CheckTouching();		
		SetPlacer(None,false);

	}
	event EndState()
	{
		SetHidden(false);
	}
	
	event StartPlacing(ZombiePlayerPawn placingPlr)
	{
		if (placingPlr==None) return;

		SetPlacer(placingPlr,false);

		if (PossibleOffsets.length != 0)
			GotoState('PlacingWithOffsets');
		else
			GotoState('PlacingWithNoOffsets');
		
	}
}

state PlacingBase
{
	event BeginState()
	{
		local ZombiePlayerPawn p;
		setSkinsActive(false);
		soflamlog ();
		foreach TouchingActors(class'ZombiePlayerPawn',p)
		{
			if (p == placer)
				Touch(p);
		}
	}
	
	event Touch(actor other)
	{
		soflamlog (other);
		if (other.IsA('ZombiePlayerPawn') )
		{
			SetPlacer(Pawn(other),false);
			ChangeMessage(SMSGS_ARM);
		}
	}
	event UnTouch(actor other)
	{
		soflamlog (other);
		if(other==placer)
		{
			SetPlacer(None,false);
		}
	}
	
	event UsedBy( Pawn other )
	{
		if( other.Weapon != None && other.Weapon.IsInState('Reloading') )
			return;
		soflamlog (other);
		if (!bHidden && other == placer)
			PlaceSOFLAM();
	}
	event PlaceSOFLAM()
	{
		if (!bRenderedLastFrame) return;

		SetBase(Owner);
		soflamlog();
		GotoState('PlacerPuttingDownWeaponForArming');
		
	}
	
	function checkPlacerValidity()
	{
		local vector hitLocation,hitNormal,traceEnd;
		local actor a;
		soflamlog ();

		if (placer != None && placer.Health>0) 
		{
			traceEnd = Owner.Location;
			a = placer.Trace(hitLocation,hitNormal,traceEnd);
			if (a==Owner && vsize(hitLocation-placer.Location)<=300)
				return;
		}
		
		GotoState('DelayUntilInactive');
	}
}
 
state PlacingWithOffsets extends PlacingBase
{
	event BeginState()
	{
		Super.BeginState();
		SetTimer(0.2,true);
	}

	function Timer()
	{
		local int i;
		global.Timer();
		//debug feature.
		if (PossibleOffsets.length ==0) GotoState('PlacingWithNoOffsets');
		
		i=CheckClosestOffset();
		if (i==-1)
			SetHidden(true);
		else
		{
			SetHidden(false);
			SetLocation(Owner.Location+(PossibleOffsets[i]>>Owner.Rotation));
			SetRotation(OffsetRotations[i]+Owner.Rotation);
		}
	}
}

state PlacingWithNoOffsets extends PlacingBase
{
	function Tick(float deltaTime)
	{
		local vector traceStart,traceEnd;
		local vector hitLocation,hitNormal;
		local Actor a;

		traceStart = placer.Location+placer.BaseEyeHeight*vect(0,0,1);
		traceEnd = traceStart + vector(placer.Controller.Rotation)*300;
		a = placer.Trace(hitLocation,hitNormal,traceEnd,traceStart);
		
		if (a != Owner ) SetHidden(true);
		else if ((vector(placer.Rotation) dot (Owner.Location - placer.Location)) < 0.5) SetHidden(true);
		else if (vsize(hitLocation - traceStart) > 100) SetHidden(true);
		else SetHidden(false);
		
		if (!bHidden)
		{
			SetLocation(hitLocation);
			SetRotation(rotator(hitNormal));
		}

		checkPlacerValidity();		

	}
}
state PuttingDownWeapon_Arming_CommonEvents
{
	function BringWeaponBackUp()
	{
		if (placer.Weapon!=None)
		{
			placer.Weapon.bGoInactiveAfterDown=false;  // MAT 4/18/04
			placer.Weapon.BringUp();
		}
	}
	event UnUsedBy( Pawn other )
	{
		soflamlog (other);
		if (other == placer)
			AbortArming();
	}
	event UnTouch(Actor Other)
	{
		soflamlog (other);
		if (other == placer)
			AbortArming();
	}
}

state PlacerPuttingDownWeaponForArming extends PuttingDownWeapon_Arming_CommonEvents
{
	event AbortArming()
	{
		BringWeaponBackUp();
		Global.AbortArming();
	}
	
begin:
	if (placer.Weapon!=None)
	{
		while (!placer.Weapon.IsInState('DownAndInactive'))
		{
			if (bRenderedLastFrame) MakeSureWeaponIsDown();
			else AbortArming();

			Sleep(0.1);
		}
		Sleep(0.1);
	}
	
	
	GotoState('Arming');
}


state Arming extends PuttingDownWeapon_Arming_CommonEvents
{
	
	event BeginState()
	{
		if (EventOnStartArming != '')
			TriggerEvent(EventOnStartArming,self,placer);
		soflamlog ();
		bHidden=false;
		setSkinsActive(true);
		SetPlacer(placer,true);
		PlaySound(PlunkSound);
	
	}
	event EndState()
	{
		soflamlog ("start");
		BringWeaponBackUp();
		SetPlacer(placer,false);
		soflamlog ("end");
	}
begin:
	for(
		counter=0;
		counter<ArmingTicks.length;
		counter++)
	{
		MakeSureWeaponIsDown();
		soflamlog (counter@ArmingTicks[counter].toggleSkin);
		Sleep(ArmingTicks[counter].PauseTime);
		if (!bRenderedLastFrame) AbortArming();

		if (!DoArmingTick(counter))
			break;
	}
	soflamlog ("done: going to correct armedstate");
	//quick hacky check: if it wasn't rendered last frame, we probably aborted so don't do this.
	if (bRenderedLastFrame)
		GotoCorrectArmedState();
}

function StartArmed()
{
	if (bManualDetonate)
	{
		GotoState('ArmedAndWaitingForDetonate');
		return;
	}
	
	for(
		counter=0;
		counter<ArmingTicks.length;
		counter++)
	{
		if (ArmingTicks[counter].setArmed)
			break;
	}
	GotoState('Armed');
}

state Armed
{
	simulated function BeginState()
	{
		if(EventOnArmed!='')
			TriggerEvent(EventOnArmed,self,placer);
		ChangeMessage(SMSGS_NONE);
		SetSkinsArmed();
		SetPlacer(None,false);
	}
	
begin:
	for(
		counter+=1;
		counter<ArmingTicks.length;
		counter++)
	{
		soflamlog ("Armed: AT"$counter@ArmingTicks[counter].toggleSkin);
	
		Sleep(ArmingTicks[counter].PauseTime);
		DoArmingTick(counter);
	}
	internalExplode();
	Destroy();
	
}

function Detonate(){}
state ArmedAndWaitingForDetonate
{
	simulated function BeginState()
	{
		local ZombiePlayerPawn p;
		if(EventOnArmed!='')
			TriggerEvent(EventOnArmed,self,placer);

		SetSkinsArmed();
		if (bCanDisarm)
		{
			foreach TouchingActors(class'ZombiePlayerPawn',p)
			{
				Touch(p);
				return; //skip the ChangeMessage below
			}
		}

		ChangeMessage(SMSGS_NONE);
		SetPlacer(None,false);

	}
	event Touch(Actor other)
	{
		if (other.IsA('ZombiePlayerPawn'))
		{
			SetPlacer(Pawn(other),false);
			if (bCanDisarm)
				ChangeMessage(SMSGS_DISARM);
			else
				ChangeMessage(SMSGS_NONE);
		}
	}
	event UnTouch(Actor Other)
	{
		if (other==placer)
		{
			ChangeMessage(SMSGS_NONE);
		}
	}
	
	event UsedBy( Pawn other )
	{
		if( other.Weapon != None && other.Weapon.IsInState('Reloading') )
			return;
		soflamlog (other);
		if (bCanDisarm && other == placer)
		{
			SetPlacer(other,false);
			GotoState('PlacerPuttingDownWeaponForDisarming');
		}
	}

	function Detonate()
	{
		internalExplode();
		Destroy();
	}
}


state PuttingDownWeapon_Disarming_CommonEvents
{
	function BringWeaponBackUp()
	{
		if (placer.Weapon!=None)
		{
			placer.Weapon.bGoInactiveAfterDown=false;  // MAT 4/18/04
			placer.Weapon.BringUp();
		}
	}
	event UnUsedBy( Pawn other )
	{
		soflamlog (other);
		if (other == placer)
			AbortDisarming();
	}
	event UnTouch(Actor Other)
	{
		if (other == placer)
			AbortDisarming();
	}
}
state PlacerPuttingDownWeaponForDisarming extends PuttingDownWeapon_Disarming_CommonEvents
{
	event AbortDisarming()
	{
		BringWeaponBackUp();
		Global.AbortDisarming();
	}
	
begin:
	if (placer.Weapon!=None)
	{
		while (!placer.Weapon.IsInState('DownAndInactive'))
		{
			if (bRenderedLastFrame) MakeSureWeaponIsDown();
			else AbortDisarming();

			Sleep(0.1);
		}
		Sleep(0.1);
	}
	
	
	GotoState('Disarming');
}

state Disarming extends PuttingDownWeapon_Disarming_CommonEvents
{
	event BeginState()
	{
		if (EventOnStartDisarming != '')
			TriggerEvent(EventOnStartDisarming,self,placer);
		SetPlacer(placer,true);
			
	}
	event EndState()
	{
		BringWeaponBackUp();
		SetPlacer(placer,false);
	}
begin:
	for(
		counter=0;
		counter<DisarmingTicks.length;
		counter++)
	{
		Sleep(DisarmingTicks[counter].PauseTime);
		if (!bRenderedLastFrame) AbortDisarming();
		DoDisarmingTick(counter);
	}
	if (EventOnDisarmed!='')
		TriggerEvent(EventOnDisarmed,self,placer);
	if (bDestroyAfterDisarm) 
	{
		ChangeMessage(SMSGS_NONE);
		Destroy();
	}
	else 
		GotoState('DelayUntilInactive');
}

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
// (cpptext)

// Decompiled with UE Explorer.
defaultproperties
{
    bShowMessage=true
    DeactivatedMaterial=Texture'Engine.DefaultTexture'
    PlunkSound=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    SpawnProjectileClass=Class'SOFLAMExploder'
    MessageClass=Class'DynamicSOFLAMMessage'
    DisarmMessageClass=Class'DynamicSOFLAMDisarmMessage'
    maxDistToPlacer=20000.0000000
    RedLightTexture=Texture'Engine.DefaultTexture'
    GreenLightTexture=Texture'Engine.DefaultTexture'
    bAlwaysVisible=true
    defaultMeshName="DefaultMeshes.Box64"
    armMessage="Press and hold <action=use> to place C4 charge"
    disarmMessage="Press and hold <action=use> to disarm C4 charge"
    ArmingTicks[0]=(PauseTime=0.7500000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_arming',toggleSkin=2,setArmed=false)
    ArmingTicks[1]=(PauseTime=0.7500000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_arming',toggleSkin=3,setArmed=false)
    ArmingTicks[2]=(PauseTime=0.7500000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_arming',toggleSkin=4,setArmed=false)
    ArmingTicks[3]=(PauseTime=0.7500000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_arming',toggleSkin=5,setArmed=false)
    ArmingTicks[4]=(PauseTime=0.7500000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_armed',toggleSkin=6,setArmed=true)
    ArmingTicks[5]=(PauseTime=0.0000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_arming',toggleSkin=1,setArmed=false)
    ArmingTicks[6]=(PauseTime=0.4000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[7]=(PauseTime=0.4000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[8]=(PauseTime=0.4000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[9]=(PauseTime=0.3000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[10]=(PauseTime=0.3000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[11]=(PauseTime=0.3000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[12]=(PauseTime=0.3000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[13]=(PauseTime=0.2000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[14]=(PauseTime=0.2000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[15]=(PauseTime=0.2000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[16]=(PauseTime=0.2000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[17]=(PauseTime=0.2000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[18]=(PauseTime=0.2000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[19]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[20]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[21]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[22]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[23]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[24]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[25]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[26]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[27]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[28]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[29]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    ArmingTicks[30]=(PauseTime=0.1000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm',toggleSkin=1,setArmed=false)
    DisarmingTicks[0]=(PauseTime=0.0000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_arming',toggleSkin=6,setArmed=false)
    DisarmingTicks[1]=(PauseTime=0.7500000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_arming',toggleSkin=5,setArmed=false)
    DisarmingTicks[2]=(PauseTime=0.7500000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_arming',toggleSkin=4,setArmed=false)
    DisarmingTicks[3]=(PauseTime=0.7500000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_arming',toggleSkin=3,setArmed=false)
    DisarmingTicks[4]=(PauseTime=0.7500000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_armed',toggleSkin=2,setArmed=false)
    DisarmingTicks[5]=(PauseTime=0.0000000,TickSound=Sound'CBW_DYN_weapons.C4.C4_beep_arming',toggleSkin=-1,setArmed=false)
    bStatic=false
    bWorldGeometry=false
    bAcceptsProjectors=true
    Skins[0]=none
    Skins[1]=none
    Skins[2]=none
    Skins[3]=none
    Skins[4]=none
    Skins[5]=none
    Skins[6]=none
    bShadowCast=false
    CollisionRadius=75.0000000
    CollisionHeight=30.0000000
    bBlockActors=false
    bBlockPlayers=false
    bUseCylinderCollision=true
    bBlockKarma=false
}