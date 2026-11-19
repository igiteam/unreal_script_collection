class R6FemaleCivilPawn extends R6CivilPawn
    native
    config(Character)
    hidecategories(lighting);

event bool DontPlayIdles()
{
    return true;
    return;
}

defaultproperties
{
    m_ThirdPersonAnimSets[0]=AnimSet'Anims_Civilians_Movement.FastWalk.Male'
    m_ThirdPersonAnimSets[1]=AnimSet'Anims_Civilians_Movement.Jog.Male'
    m_ThirdPersonAnimSets[2]=AnimSet'Anims_Civilians_Movement.Transition.Male'
    m_ThirdPersonAnimSets[3]=AnimSet'Anims_Civilians_Movement.Turn.Male'
    m_ThirdPersonAnimSets[4]=AnimSet'Anims_Civilians_Movement.Walk.Male'
    m_ThirdPersonAnimSets[5]=AnimSet'Anims_Civilians.Stances.Male'
    m_ThirdPersonAnimSets[6]=AnimSet'Anims_Civilians.Idles.Male'
    m_ThirdPersonAnimSets[7]=AnimSet'Anims_Civilians.Reactions.Male'
    m_ThirdPersonAnimSets[8]=AnimSet'Anims_Facial_Generic.Talking'
    m_ThirdPersonAnimSets[9]=AnimSet'Anims_Civilians_Movement.Crossover.female'
    m_ThirdPersonAnimSets[10]=AnimSet'Anims_Civilians_Movement.FastWalk.female'
    m_ThirdPersonAnimSets[11]=AnimSet'Anims_Civilians_Movement.Jog.female'
    m_ThirdPersonAnimSets[12]=AnimSet'Anims_Civilians_Movement.Step.female'
    m_ThirdPersonAnimSets[13]=AnimSet'Anims_Civilians_Movement.Transition.female'
    m_ThirdPersonAnimSets[14]=AnimSet'Anims_Civilians_Movement.Turn.female'
    m_ThirdPersonAnimSets[15]=AnimSet'Anims_Civilians_Movement.Walk.female'
    m_ThirdPersonAnimSets[16]=AnimSet'Anims_Civilians.Emotes.female'
    m_ThirdPersonAnimSets[17]=AnimSet'Anims_Civilians.Burning.female'
    m_ThirdPersonAnimSets[18]=AnimSet'Anims_Civilians.Stances.female'
    m_ThirdPersonAnimSets[19]=AnimSet'Anims_Civilians.Idles.female'
    m_ThirdPersonAnimSets[20]=AnimSet'Anims_Civilians.Reactions.female'
    m_ThirdPersonAnimSets[21]=AnimSet'Anims_Civilians.Movement.female'
    m_ThirdPersonAnimSets[22]=AnimSet'Anims_General_Hands.Death.female'
}