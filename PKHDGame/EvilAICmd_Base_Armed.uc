class EvilAICmd_Base_Armed extends EvilAICmd_Base_Combat within EvilAIController;

function Pushed()
{
    super.Pushed();
    GotoState('InCombat');
    //return;    
}

state InCombat
{Begin:

    // End:0x75
    if(Outer.HasValidEnemy())
    {
        Outer.SetFocalPoint(Outer.Enemy.Location);
    }
    Outer.Sleep(1.0000000);
    goto 'Begin';
    stop;                
}
