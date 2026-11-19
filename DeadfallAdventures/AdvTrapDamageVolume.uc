class AdvTrapDamageVolume extends AdvDamageVolume
    hidecategories(Navigation,Object,Movement,Display);

var AdvPlayerControllerMP TrapInstigator;

function CausePainTo(Actor Other)
{
    local AdvPlayerControllerMP VictimPC;
    local AdvAIController VictimAI;

    VictimPC = AdvPlayerControllerMP(Pawn(Other).Controller);
    VictimAI = AdvAIController(Pawn(Other).Controller);
    // End:0x415
    if(EvilPawn(Other).IsAliveAndWell())
    {
        // End:0x415
        if((DamageBehaviour.PlayerDamagePerSec > 0) || DamageBehaviour.EnemyDamagePerSec > 0)
        {
            // End:0xF7
            if(DamageInstigator == none)
            {                
            }
            else
            {
                // End:0x2D3
                if(((VictimPC != none) && VictimPC.bIsPlayer) && DamageBehaviour.PlayerDamagePerSec > VictimPC.Pawn.Health)
                {
                    // End:0x1A2
                    if(VictimPC == DamageInstigator)
                    {
                        DamageInstigator = none;
                    }
                    // End:0x27E
                    if((int(VictimPC.Pawn.GetTeamNum()) != int(DamageInstigator.Pawn.GetTeamNum())) && VictimPC.AssistingPlayers.Find(DamageInstigator) == )
                    {                        
                        VictimPC.AssistingPlayers.AddItem(AdvPlayerControllerMP(DamageInstigator));                        
                    }
                    VictimPC.bKilledByTrap = true;
                    VictimPC.TrapKiller = AdvPlayerControllerMP(DamageInstigator);                    
                }
                else
                {
                    // End:0x415
                    if((VictimAI != none) && DamageBehaviour.EnemyDamagePerSec > VictimAI.Pawn.Health)
                    {
                        // End:0x35A
                        if(VictimAI == DamageInstigator)
                        {
                            DamageInstigator = none;
                        }
                        // End:0x3C3
                        if(VictimAI.AssistingPlayers.Find(DamageInstigator) == )
                        {                            
                            VictimAI.AssistingPlayers.AddItem(AdvPlayerControllerMP(DamageInstigator));                            
                        }
                        VictimAI.bKilledByTrap = true;
                        VictimAI.TrapKiller = AdvPlayerControllerMP(DamageInstigator);
                    }
                }
            }
        }
    }
    super.CausePainTo(Other);
    //return;    
}

defaultproperties
{
    DamageType=Class'AdvDmgType_Trap_Base'
    // Reference: BrushComponent'Default__AdvTrapDamageVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}