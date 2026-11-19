class AdvAICmd_Base_Mummy extends EvilAICmd_Base_Combat within AdvAI_AztecMummy;

function Pushed()
{
    super.Pushed();
    GotoState('InCombat');
    //return;    
}

state InCombat
{Begin:

    // End:0x43
    if(!Outer.HasValidEnemy())
    {
        Outer.AutoAcquireEnemy();
    }
    Outer.Focus = Outer.Enemy;
    // End:0x27D
    if(((Outer.HasValidEnemy() && !Outer.MyEvilPawn.bOnLightInfluenceFromFlashLight || Outer.MyEvilPawn.HasShield()) && int(Outer.MyEvilPawn.PawnAction) != 55) || (Outer.CoverFromLightStartTime >= 0.0000000) && (Outer.CoverFromLightStartTime + Outer.CoverFromLightTime) < Outer.WorldInfo.TimeSeconds)
    {
        Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Melee * 0.6000000, true,,,,, int(Outer.MyEvilPawn.SupremeMoveMode) <= int(1));        
    }
    else
    {
        Outer.Sleep(0.1000000);
    }
    goto 'Begin';
    stop;                
}
