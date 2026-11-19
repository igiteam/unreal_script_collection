/**
 * This is the class for our NanoGoreEffect Archetype
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoDBNOAudio extends Object
	hidecategories(Object)
	placeable; // needed to show up in the Actor Classes list


var(DBNOState) SoundCue EnterDBNO;

var(DBNOState) SoundCue BreathingGenericGuyNotBeingInterrogated;

var(DBNOState) SoundCue BreathingLevel1;
var(DBNOState) SoundCue BreathingLevel2;
var(DBNOState) SoundCue BreathingLevel3;

var(DBNOState) SoundCue EndViaBleedOut;


var(DBNOState) SoundCue EndComment_Success;
var(DBNOState) SoundCue EndComment_Failure;

/** Light pain effort; punch impact **/
var(InterrogateHits) SoundCue Impact_Level1;
/** Medium pain effort, spit out blood/teeth; wet hit, punch impact **/
var(InterrogateHits) SoundCue Impact_Level2;
/** High pain effort, blood in mouth, hard breathing; very messy hit, breaking bones sounds **/
var(InterrogateHits) SoundCue Impact_Level3;
/** Death croak, drowning on blood; very messy hit, blood and broken bones **/
var(InterrogateHits) SoundCue Impact_Fatal;



var(Drag) SoundCue DragBegin;
var(Drag) SoundCue DragLoop;
var(Drag) SoundCue DragStop;



//("Nothing personal, but you're gonna talk.","I'm going to keep hitting 'til I get want I want.", "This is gonna hurt, ya know.")
var(Interrogate) SoundCue Interrogate_Normal_Level1;
var(Interrogate) SoundCue Interrogate_Normal_Level2;
var(Interrogate) SoundCue Interrogate_Normal_Level3;

//("Talk, asshole!","I'll keep going until you're fucking dead, so talk!","Think you're tough?  Let's see how you like what's next.") 
var(Interrogate) SoundCue Interrogate_Threaten_Level1;
var(Interrogate) SoundCue Interrogate_Threaten_Level2;
var(Interrogate) SoundCue Interrogate_Threaten_Level3;

//("You and I don't want this, do we?  Talk.", "Listen, I don't wanna have to hurt you.","It doesn't have to end like this- just talk.")
var(Interrogate) SoundCue Interrogate_Nice_Level1;
var(Interrogate) SoundCue Interrogate_Nice_Level2;
var(Interrogate) SoundCue Interrogate_Nice_Level3;




//("Goddammit!","owww, just let me go!","You can't get away with this!")
var(InterrogateReaction) SoundCue InterrogateReaction_Normal_Level1;
var(InterrogateReaction) SoundCue InterrogateReaction_Normal_Level2;
var(InterrogateReaction) SoundCue InterrogateReaction_Normal_Level3;

//("you're crazy!" "what the hell are you doing!?" "ahh! I don't want to die!")
var(InterrogateReaction) SoundCue InterrogateReaction_Threaten_Level1;
var(InterrogateReaction) SoundCue InterrogateReaction_Threaten_Level2;
var(InterrogateReaction) SoundCue InterrogateReaction_Threaten_Level3;

//("Fuck you, asshole", "You'll have to do better, bitch" "God fucking dammit, that hurts")
var(InterrogateReaction) SoundCue InterrogateReaction_Angry_Level1;
var(InterrogateReaction) SoundCue InterrogateReaction_Angry_Level2;
var(InterrogateReaction) SoundCue InterrogateReaction_Angry_Level3;


//That's enough... please... I'll tell you what you want
var(InterrogateInterrupt) SoundCue InterrogateInterrupt_Normal;
//OK OK, just stop!  Please!  I'll tell you!
var(InterrogateInterrupt) SoundCue InterrogateInterrupt_Threaten;
//Wait, goddam it, hold it... I'll talk!
var(InterrogateInterrupt) SoundCue InterrogateInterrupt_Angry;


//("Here's the information you want.")
var(InterrogateConfession) SoundCue InterrogateConfession_Normal;
//("Here's what you want... just don't touch me!")
var(InterrogateConfession) SoundCue InterrogateConfession_Threaten;
//("Here's what you want... I'm a dead man either way.")
var(InterrogateConfession) SoundCue InterrogateConfession_Angry;








defaultproperties
{






}
