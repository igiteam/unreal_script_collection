class SeqAct_GlowableElementVariableChanger extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var AdvFlashlight_GlowableElement_base GlowableElement;
var() float BaseLightPowerThreshold;
var() float ModifiedLightPowerThreshold;
var() float BaseLightPowerScalingFactor;
var() float ModifiedLightPowerScalingFactor;
var() float BaseLightGainer;
var() float BaseLightWaster;
var() float Modifier;
var int NumberOfPlayers;

event Activated()
{
    local SeqVar_Player PlayerVar;
    local SeqVar_Object ObjVar;
    local AdvPlayerPawn P;
    local AdvPlayerController PC;
    local int I;

    PublishLinkedVariableValues();
    NumberOfPlayers = 0;
    // End:0x290
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        PlayerVar = SeqVar_Player(ObjVar);
        // End:0x6C
        if(PlayerVar == none)
        {
            continue;            
        }
        PlayerVar.UpdatePlayersList();
        I = 0;
        J0x96:

        // End:0x28F [Loop If]
        if(I < PlayerVar.Players.Length)
        {
            // End:0x198
            if(PlayerVar.bAllPlayers)
            {
                // End:0x15A
                if(AdvPlayerController(PlayerVar.Players[I]) != none)
                {
                    PC = AdvPlayerController(PlayerVar.Players[I]);                    
                }
                else
                {
                    P = AdvPlayerPawn(PlayerVar.Players[I]);
                }                
            }
            else
            {
                // End:0x1FB
                if(AdvPlayerController(PlayerVar.GetObjectValue()) != none)
                {
                    PC = AdvPlayerController(PlayerVar.GetObjectValue());                    
                }
                else
                {
                    P = AdvPlayerPawn(PlayerVar.GetObjectValue());
                }
                I = PlayerVar.Players.Length;
            }
            // End:0x281
            if((P != none) || PC != none)
            {
                ++NumberOfPlayers;
            }
            ++I;
            // [Loop Continue]
            goto J0x96;
        }        
    }    
    // End:0x3CC
    if(GlowableElement != none)
    {
        // End:0x3C2
        if(InputLinks[0].bHasImpulse)
        {
            GlowableElement.LightPowerThreshold = BaseLightPowerThreshold + (ModifiedLightPowerThreshold * float(NumberOfPlayers));
            GlowableElement.LightPowerScalingFactor = BaseLightPowerScalingFactor + (ModifiedLightPowerScalingFactor * float(NumberOfPlayers));
            GlowableElement.LightGainer = BaseLightGainer + (float(NumberOfPlayers) * Modifier);
            GlowableElement.LightWaster = BaseLightWaster + (float(NumberOfPlayers) * Modifier);
        }
        PopulateLinkedVariableValues();
    }
    //return;    
}

defaultproperties
{
    BaseLightPowerThreshold=20.0000000
    ModifiedLightPowerThreshold=5.0000000
    BaseLightPowerScalingFactor=4.0000000
    BaseLightGainer=4.0000000
    BaseLightWaster=4.0000000
    Modifier=0.5000000
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="GlowableElement",LinkVar="None",PropertyName="GlowableElement",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Survival Glowable Variable Changer"
}