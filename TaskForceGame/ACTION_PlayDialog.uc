class ACTION_PlayDialog extends ACTION_PlayBlendedAnim;

var(Action) Sound				DialogSnd;
var(Action) localized string	Subtitle;
var(Action) int					SubtitleTime;
var(Action) class<LocalMessage> MessageClass;
var(Action) bool				bForceSubtitle;
var(Action) bool				PlayInHead;
var(Action) bool				bClearMessages;

function string GetActionString()
{
	return ActionString@Animation@DialogSnd;
}

function bool InitActionFor(ScriptedController C)
{
	local PlayerController pc;
	
	if ( bClearMessages ) {
	
		ForEach C.DynamicActors(class'PlayerController', pc) {
		
			pc.myHud.ClearMessages();
		}
	}

	Super.InitActionFor(C);

	PawnPlayDialogSnd(C);
	return false;	
}

function PawnPlayDialogSnd(ScriptedController C)
{
	if(DialogSnd != None)
	{
		if(PlayInHead)
		{
			C.PlaySound(DialogSnd,SLOT_Interface);
		}
		else
		{
			if(C.Pawn != None)
			{			
				C.Pawn.PlaySound(DialogSnd);
			}
			else
			{
				C.PlaySound(DialogSnd);
			}
		}
	}

	if(Subtitle != "")
	{
		C.Level.Game.BroadcastLocalized( C, MessageClass,, None, None, self );
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    SubtitleTime=3
    MessageClass=Class'ZombieGuideMessage'
    AnimationChannel=15
    BlendBone="Head"
    BlendAlpha=0.7500000
    ActionString="play dialog"
}