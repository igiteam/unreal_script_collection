class EvilAICmd_Base_ZombieNavMesh extends EvilAICmd_Base_Combat within EvilAIController;

state InCombat
{Begin:

    Outer.Sleep(0.5000000);
    stop;            
}
