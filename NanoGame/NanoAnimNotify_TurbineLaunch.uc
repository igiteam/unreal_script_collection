class NanoAnimNotify_TurbineLaunch extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() 
	{
		return FString::Printf( TEXT("LAUNCH_%d_%s_%s"), BladeIdx, bTopLaunch ? TEXT("TOP") : TEXT("BOT"), bReverseSpinDir ? TEXT("REV") : TEXT("FWD") );
	}
	virtual FColor GetEditorColor() 
	{ 
		if( bTopLaunch )
		{
			return bReverseSpinDir ? FColor(255,255,0) : FColor(0,0,255); 
		}
		else
		{
			return bReverseSpinDir ? FColor(255,0,0) : FColor(0,255,0); 
		}
	}
}

var() int   BladeIdx;
var() bool  bReverseSpinDir;
var() bool  bTopLaunch;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local NanoTurbineBase Turbine;
	
	Turbine = NanoTurbineBase(Owner);
	if( Turbine != None )
	{
		Turbine.LaunchUser( BladeIdx, bTopLaunch, bReverseSpinDir );
	}
}