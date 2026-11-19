class MuzzleFlashAttachment extends InventoryAttachment;

var int TickCount;	// How long to display it

var(MuzzleFlash) ELightType FlashLightType;
var(MuzzleFlash) ELightEffect FlashLightEffect;

simulated event Timer()
{
	bHidden=true;
}

simulated function Flash()
{
//	bAlwaysRelevant=true;
	GotoState('Visible');
}

simulated state Visible
{
	simulated event Tick(float Delta)
	{
		if (TickCount>2)
			gotoState('');
			
		TickCount++;
	}
	
	simulated function EndState()
	{
		bHidden=true;
		LightEffect=LE_None;
		LightType=LT_None;
	//	bAlwaysRelevant=false;
	}
	
	simulated function BeginState()
	{
		local Rotator R;
		local vector V;
	
		TickCount=0;
		R = RelativeRotation;
		R.Pitch = Rand(65535);
		SetRelativeRotation(R);
	
		V=Default.DrawScale3D;
//		V.Z += frand() - 0.5;
		V.X += frand() - 0.5;
		V.Y += frand() - 0.5;
	
		SetDrawScale3D(v);
		bHidden=false;
		
		LightEffect=FlashLightEffect;
		LightType=FlashLightType;
	}
		
}		
		


// Decompiled with UE Explorer.
defaultproperties
{
    bHidden=true
    bAcceptsProjectors=false
    bAlwaysRelevant=true
}