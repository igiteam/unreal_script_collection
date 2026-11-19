/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPickup_MoneySmall extends NanoPickup_MoneyBase
	placeable;

var     StaticMeshComponent     TopMesh1;
var     StaticMeshComponent     TopMesh2;

simulated function SetPickupHidden()
{
	Super.SetPickupHidden();

	TopMesh1.SetHidden(TRUE);
	TopMesh2.SetHidden(TRUE);
}

simulated function SetPickupVisible()
{
	Super.SetPickupVisible();

	TopMesh1.SetHidden(FALSE);
	TopMesh2.SetHidden(FALSE);
}

defaultproperties
{
	Components.Remove(Sprite)
	Components.Remove(Sprite2)
	Components.Remove(Arrow)
	GoodSprite=None
	BadSprite=None

    PickupSound=SoundCue'Nano_Proto_FX.Sounds.NanoCurrencyPickedUp'

	Begin Object Class=StaticMeshComponent Name=MyBaseMesh
		StaticMesh=StaticMesh'COG_AssaultRifle.Assault_Rifle_Magazine'
		Rotation=(Pitch=16384)
		Translation=(X=25.0)
		Scale=4.0
		Scale3D=(X=1.0,Y=1.5,Z=1.125)
		CollideActors=FALSE
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		MaxDrawDistance=7000
	End Object
	PickupMesh=MyBaseMesh
	Components.Add(MyBaseMesh);

	Begin Object Class=StaticMeshComponent Name=MyTopMesh1
		StaticMesh=StaticMesh'Nano_Proto_B.SM.Materials.S_GOW_Deco_SM_Solar_panel_PanelA_Dup'
		Rotation=(Roll=-16384,Yaw=-16384)
		Translation=(Z=67,Y=-16)
		Scale=0.15
		CollideActors=FALSE
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		MaxDrawDistance=7000
	End Object
	TopMesh1=MyTopMesh1
	Components.Add(MyTopMesh1)

	Begin Object Class=StaticMeshComponent Name=MyTopMesh2
		StaticMesh=StaticMesh'Nano_Proto_B.SM.Materials.S_GOW_Deco_SM_Solar_panel_PanelA_Dup'
		Rotation=(Roll=16384,Yaw=16384)
		Translation=(Z=67,Y=16)
		Scale=0.15
		CollideActors=FALSE
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		MaxDrawDistance=7000
	End Object
	TopMesh2=MyTopMesh2
	Components.Add(MyTopMesh2)

	Amount=50
}