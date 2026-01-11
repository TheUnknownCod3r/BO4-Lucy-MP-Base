init()
{
    level thread InitializeVarsPrecaches();
}

onPlayerSpawned()
{
    
    if(!isDefined(self.menuThreaded))
        self thread playerSetup();
}

InitializeVarsPrecaches()
{
    if(isDefined(level.InitializeVarsPrecaches))
        return;
    level.InitializeVarsPrecaches = true;
    level.menuName = "The Lucy Base";
    level.menuDeveloper = "MrFawkes1337 | CF499";
    level.AutoVerify = 0;
    level.MenuStatus = StrTok("None, Verified, VIP, Co-Host, Admin, Host, Developer", ",");
    level._AllWeaps = StrTok("ar_accurate_t8,ar_fastfire_t8,ar_damage_t8,ar_stealth_t8,ar_modular_t8,ar_mg1909_t8,ar_standard_t8,ar_galil_t8,ar_peacekeeper_t8,ar_doublebarrel_t8,ar_an94_t8,smg_standard_t8,smg_handling_t8,smg_fastfire_t8,smg_capacity_t8,smg_accurate_t8,smg_drum_pistol_t8,smg_fastburst_t8,smg_folding_t8,smg_vmp_t8,smg_minigun_t8,smg_mp40_t8,smg_thompson_t8,tr_powersemi_t8,tr_longburst_t8,tr_midburst_t8,tr_flechette_t8,tr_leveraction_t8,tr_damageburst_t8,lmg_heavy_t8,lmg_spray_t8,lmg_standard_t8,lmg_double_t8,lmg_stealth_t8,sniper_fastrechamber_t8,sniper_powerbolt_t8,sniper_powersemi_t8,sniper_quickscope_t8,sniper_mini14_t8,sniper_locus_t8,sniper_damagesemi_t8,pistol_burst_t8,pistol_revolver_t8,pistol_standard_t8,pistol_topbreak_t8,pistol_fullauto_t8,shotgun_pump_t8,shotgun_semiauto_t8,shotgun_trenchgun_t8,shotgun_fullauto_t8,shotgun_precision_t8,launcher_standard_t8,special_ballisticknife_t8_dw,special_crossbow_t8,knife_loadout,melee_secretsanta_t8,melee_slaybell_t8,melee_demohammer_t8,melee_coinbag_t8,melee_club_t8,melee_cutlass_t8,melee_stopsign_t8,melee_zombiearm_t8,melee_actionfigure_t8,melee_amuletfist_t8",",");
}

playerSetup()
{
    if(isDefined(self.menuThreaded))
        return;
    
    self defineVariables();
    if(!self IsHost())
    {
        if(!isDefined(self.playerSetting["verification"]))
            self.playerSetting["verification"] = level.MenuStatus[level.AutoVerify];
    }
    else {
        self.playerSetting["verification"] = level.MenuStatus[(level.MenuStatus.size - 2)];
    }
    if(self hasMenu())
    {
        wait 5;
        self iPrintln("^9Welcome To " + level.menuName);
        self iPrintLn("^1Developed By: ^2" + level.menuDeveloper);
        self iPrintln("^0Verification Status: " + self.playerSetting["verification"]);
    }
    
    self thread menuMonitor();
    self.menuThreaded = true;
}
 
defineVariables()
{
    if(isDefined(self.DefinedVariables))
        return;
    self.DefinedVariables = true;
    
    if(!isDefined(self.menu))
        self.menu = [];
    if(!isDefined(self.playerSetting))
        self.playerSetting = [];
    if(!isDefined(self.menu["curs"]))
        self.menu["curs"] = [];
    
    self.playerSetting["isInMenu"] = undefined;
    self.menu["currentMenu"] = "Main";
    self.menu["curs"][self.menu["currentMenu"]] = 0;
}


replaceChar(string, substring, replace)
{
    final = "";
    for(e=0;e<string.size;e++)
    {
        if(string[e] == substring)
            final += replace;
        else 
            final += string[e];
    }
    return final;
}

constructString(string)
{
    final = "";
    for(e=0;e<string.size;e++)
    {
        if(e == 0)
            final += toUpper(string[e]);
        else if(string[e-1] == " ")
            final += toUpper(string[e]);
        else 
            final += string[e];
    }
    return final;
}