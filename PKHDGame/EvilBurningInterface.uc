interface EvilBurningInterface extends Interface
    abstract;

simulated function Burn(float InTotalTime, float InDamageInterval, float InDamageAmount, optional bool bMaterialsBlackEffects = true, optional bool bMaterialsDotEffects = true, optional bool bResetActualBlackMaterialValue = true, optional bool bResetActualDotsMaterialValue = true)
{
    //return;    
}

function DoBurnDamageTimer()
{
    //return;    
}

function bool IsBurning()
{
    //return ReturnValue;    
}

function StopBurning()
{
    //return;    
}

function OnBurn(SeqAct_Burn Action)
{
    //return;    
}
