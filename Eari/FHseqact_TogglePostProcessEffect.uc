class FHseqact_TogglePostProcessEffect extends SequenceAction;
var(PostProcessing) name PostProcessEffectName;

event Activated()
{
	local PostProcessEffect effect;
	local SeqVar_Object linkedInstigators;

	local Pawn theInstigator;
	local PlayerController theInstigatorController;
	local LocalPlayer theLocalPlayer;

	foreach LinkedVariables(class'SeqVar_Object',linkedInstigators,"Instigator")
		{
			theInstigator = Pawn(linkedInstigators.GetObjectValue());

			if(theInstigator == none)
				continue;

			theInstigatorController = PlayerController(theInstigator.Controller);

			if(theInstigatorController == none)
				continue;

			theLocalPlayer = LocalPlayer(theInstigatorController.Player);

			if(theLocalPlayer == none)
				continue;
	
			effect = theLocalPlayer.PlayerPostProcess.FindPostProcessEffect(PostProcessEffectName);
			if(effect != none)
			{
				if(InputLinks[0].bHasImpulse)
					effect.bShowInGame = true;
				else if(InputLinks[1].bHasImpulse)
					effect.bShowInGame = false;
				else
					effect.bShowInGame = !effect.bShowInGame;
			}
		}
}


// Decompiled with UE Explorer.
defaultproperties
{
    InputLinks[0]=(LinkDesc="Turn On",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Turn Off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Toggle Postprocess Effect"
    ObjCategory="Forever Hunted"
}