/**
 * SeqAct_GearAchievementUnlock - Kismet action that allows achievements to be unlocked
 * by events that occur in levels.  This action will attempt to unlock the achievement
 * for all players.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_GearAchievementUnlock extends SequenceAction
	native(Sequence);

cpptext
{
	virtual void Activated();
}

/** Enum of the achievements to be unlocked by events that occur in levels */
enum EGearLevelAchievements
{
	eGLACHIEVE_None,
	eGLACHIEVE_MARCUSITSYOURFATHER,		 
	eGLACHIEVE_SWIMMININGLOWIEGRAVY,		 
	eGLACHIEVE_WESTRUCKGOLD,				 
	eGLACHIEVE_WELCOMETOCOUGARTOWN,		 
	eGLACHIEVE_BIGASSHEADSHOT,				 
	eGLACHIEVE_SUPPOSEDTOKNOWWHERETHATIS,   
	eGLACHIEVE_FLOODTHEMOUTTHEIRTUNNELS,	 
	eGLACHIEVE_THANKSFORFLYINGGASBAGAIRWAYS,
	eGLACHIEVE_THEBITCHISBACK,				 
	eGLACHIEVE_GOODDRIVERDISCOUNT,			 
	eGLACHIEVE_BROTHERSTOTHEEND,			 
	eGLACHIEVE_WELCOMETOGRIFFINTOWER,		 
	eGLACHIEVE_BAIRDSFAVORITEKINDOFTOY,	 
	eGLACHIEVE_THATLOOKSLIKETHEFRONTDOOR,	 
	eGLACHIEVE_LOOKATTHATINSTANTSUMMER,	 
	eGLACHIEVE_OKFAITHYEAHGOTIT,			 
	eGLACHIEVE_WEVEFINALLYGOTATOMORROW,     
};

/**
 * Mapping of achievements that can be unlocked via this kismet action to the real achievements types
 * that the achievement system recognizes them as (EGearLevelAchievements -> EGearAchievement)
*/
var array<EGearAchievement> AchievementMap;

/** The achievement you'd like to unlock */
var() EGearLevelAchievements Achievement;

defaultproperties
{
	ObjName="Achievement Unlock"
	ObjCategory="Gear"

	InputLinks(0)=(LinkDesc="Unlock")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target",PropertyName=Targets,bHidden=TRUE)

	AchievementMap(eGLACHIEVE_None)=eGA_Invalid
	AchievementMap(eGLACHIEVE_MARCUSITSYOURFATHER)=eGA_MARCUSITSYOURFATHER	 
	AchievementMap(eGLACHIEVE_SWIMMININGLOWIEGRAVY)=eGA_SWIMMININGLOWIEGRAVY		  
	AchievementMap(eGLACHIEVE_WESTRUCKGOLD)=eGA_WESTRUCKGOLD				 
	AchievementMap(eGLACHIEVE_WELCOMETOCOUGARTOWN)=eGA_WELCOMETOCOUGARTOWN		 
	AchievementMap(eGLACHIEVE_BIGASSHEADSHOT)=eGA_BIGASSHEADSHOT				  
	AchievementMap(eGLACHIEVE_SUPPOSEDTOKNOWWHERETHATIS)=eGA_SUPPOSEDTOKNOWWHERETHATIS   
	AchievementMap(eGLACHIEVE_FLOODTHEMOUTTHEIRTUNNELS)=eGA_FLOODTHEMOUTTHEIRTUNNELS	  
	AchievementMap(eGLACHIEVE_THANKSFORFLYINGGASBAGAIRWAYS)=eGA_THANKSFORFLYINGGASBAGAIRWAYS
	AchievementMap(eGLACHIEVE_THEBITCHISBACK)=eGA_THEBITCHISBACK				  
	AchievementMap(eGLACHIEVE_GOODDRIVERDISCOUNT)=eGA_GOODDRIVERDISCOUNT			  
	AchievementMap(eGLACHIEVE_BROTHERSTOTHEEND)=eGA_BROTHERSTOTHEEND			 
	AchievementMap(eGLACHIEVE_WELCOMETOGRIFFINTOWER)=eGA_WELCOMETOGRIFFINTOWER		  
	AchievementMap(eGLACHIEVE_BAIRDSFAVORITEKINDOFTOY)=eGA_BAIRDSFAVORITEKINDOFTOY	 
	AchievementMap(eGLACHIEVE_THATLOOKSLIKETHEFRONTDOOR)=eGA_THATLOOKSLIKETHEFRONTDOOR	  
	AchievementMap(eGLACHIEVE_LOOKATTHATINSTANTSUMMER)=eGA_LOOKATTHATINSTANTSUMMER	 
	AchievementMap(eGLACHIEVE_OKFAITHYEAHGOTIT)=eGA_OKFAITHYEAHGOTIT			  
	AchievementMap(eGLACHIEVE_WEVEFINALLYGOTATOMORROW)=eGA_WEVEFINALLYGOTATOMORROW     
}
