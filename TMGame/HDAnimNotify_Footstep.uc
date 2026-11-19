class HDAnimNotify_Footstep extends AnimNotify_Footstep
      native(HDSequence);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

event PlayFootStep(TMPawn TMP)
{
  if ( !TMP.IsFirstPerson() )
  {
       TMP.PlayFootStepSound(0);
  }
}
