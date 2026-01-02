/*
###########################################
Basic Modifications
###########################################
*/
Godmode()
{
    self.godmode = isDefined(self.godmode) ? undefined : true;
 
    if(isDefined(self.godmode))
    {
        self endon("disconnect");
 
        while(isDefined(self.godmode)) 
        {
            self EnableInvulnerability();
            wait 0.1;
        }
    }
    else
        self DisableInvulnerability();
}

NoclipToggle1(player)
{
    player.Noclip = isDefined(player.Noclip) ? undefined : true;
    
    if(isDefined(player.Noclip))
    {
        player endon("disconnect");
        self S("Noclip ^2Enabled");
        if(player hasMenu() && player isInMenu())
            player closeMenu1();
        player DisableWeapons();
        player DisableOffHandWeapons();
        player.nocliplinker = spawnSM(player.origin, "tag_origin");
        player PlayerLinkTo(player.nocliplinker, "tag_origin");
        
        while(isDefined(player.Noclip) && isAlive(player))
        {
            if(player AttackButtonPressed())
                player.nocliplinker.origin = (player.nocliplinker.origin + (AnglesToForward(player GetPlayerAngles()) * 60));
            else if(player AdsButtonPressed())
                player.nocliplinker.origin = (player.nocliplinker.origin - (AnglesToForward(player GetPlayerAngles()) * 60));
            if(player MeleeButtonPressed())
                break;
            
            wait 0.01;
        }

        if(isDefined(player.Noclip))
            player NoclipToggle1(player);
    }
    else
    {
        player Unlink();
        player.nocliplinker delete();
        player EnableWeapons();
        player EnableOffHandWeapons();
        self S("Noclip ^1Disabled");
    }
}


UnlimitedAmmo()
{
    self.UnlimitedAmmo = isDefined(self.UnlimitedAmmo) ? undefined : true;
    if(isDefined(self.UnlimitedAmmo))
    {
        while(isDefined(self.UnlimitedAmmo))
        {
            self GiveMaxAmmo(self GetCurrentWeapon());
            self SetWeaponAmmoClip(self GetCurrentWeapon(), self GetCurrentWeapon().clipsize);
            wait .05;
        }
    }
}

ClientOpts(func, player)
{
    switch(func)
    {
        case 0: break;
        case 1: break;
    }
}

TestOption()
{
    self iPrintLn("Test");
}

S(Message)
{
    self iPrintLn(Message);
}
UnlimitedGameTime()
{
    level.unlimitedGame = isDefined(level.unlimitedGame) ? undefined : true;
    if(isDefined(level.unlimitedGame)){
        self thread globallogic_utils::pausetimer();
    }
    else{
        self thread globallogic_utils::resumetimer();
    }
}
BO4Level55(player)
{
   player addrankxpvalue(#"kill",25160000);
   //player stats::function_bb7eedf0(#"rank",54);
   //player stats::function_bb7eedf0(#"rankxp",0);
   //player stats::function_bb7eedf0(#"plevel",10);
   //player.pers["rank"] = 54;player.pers["rankxp"]=15470000;player.pers["plevel"] = 10;
    //player AddRankXpValue("kill", newXP);
    player stats::set_stat(#"playerstatslist","rank","statValue",1);
    //player stats::set_stat(#"playerstatslist",#"plevel","statValue",10);
    player stats::set_stat(#"playerstatslist","rankxp","statValue",0);
    player rank::updaterank();
    wait .1;
    player persistence::upload_stats_soon();
    player iPrintLnBold("^2Rank And XP Set");
}

MP_UnlockAll(player)//Unlocks 84% of all Challenges, still WIP
{
    if(isDefined(player.UnlockAll))
        return;
    player.UnlockAll = true;

    player endon("disconnect");
    player iPrintLnBold("Unlock All ^2Started");
    if(player != self)
        self iPrintLnBold(player getName() + ": Unlock All ^2Started");
    //player thread UnlockAchievs();
    idx=0;
    for(z=1;z<6;z++)
    {
        if(z == 6) z++; //StatMileStones6.csv is empty, so we skip it.
        switch(z)
        {
            case 1:
                start=1;
                end=256;
                break;
            case 2:
                start=256;
                end=512;
                break;
            case 3:
                start = 512;
                end = 748;
                break;
            case 4:
                start = 768;
                end = 1024;
                break;
            case 5: 
                start = 1024;
                end = 1369;
                break;
            default:
                start=0;
                end=0;
                break;
        }
        for(value=start;value<end;value++)
        {
            stat         = SpawnStruct();
            stat.value   = Int(TableLookup("gamedata/stats/mp/statsmilestones" + z + ".csv", 0, value, 2));
            stat.type    = TableLookup("gamedata/stats/mp/statsmilestones" + z + ".csv", 0, value, 3);
            stat.name    = TableLookup("gamedata/stats/mp/statsmilestones" + z + ".csv", 0, value, 4);            
            switch(stat.type)
            {
                case "global":
                    idx++;
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: "+stat.type);
                    player stats::set_stat(#"PlayerStatsList", stat.name, #"StatValue", stat.value);
                    player stats::set_stat(#"PlayerStatsList", stat.name, #"Challengevalue", stat.value);
                    break;
                case "killsteak":
                    idx++;
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: "+stat.type);
                    player stats::function_d40764f3(stat.name,stat.value);
                    //todo
                    break;
                case "attachment":
                    idx++;
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: "+stat.type);
                    player stats::function_dad108fa(stat.name,stat.value);
                    break; //TODO
                 case "gamemode":
                    idx++;
                    player stats::function_d40764f3(stat.name,stat.value);
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: "+stat.type);
                    //todo
                    break;
                case "group":
                    idx++;
                    groups = Array(#"weapon_pistol", #"weapon_smg", #"weapon_assault", #"weapon_lmg", #"weapon_cqb", #"weapon_sniper", #"weapon_tactical", #"weapon_launcher", #"weapon_cqb", #"weapon_knife", #"weapon_special");
                    foreach(group in groups)
                    {
                        player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: "+stat.type);
                        //player stats::function_eec52333(getweapon(group),stat.name,stat.value * 2,undefined,undefined,undefined);
                        player stats::set_stat(#"GroupStats", group, #"stats", stat.name, #"StatValue", stat.value);
                        player stats::set_stat(#"GroupStats", group, #"stats", stat.name, #"Challengevalue", stat.value);
                        wait 0.01;
                    }
                    break;
                default:
                    for(x=0;x<level._AllWeaps.size;x++)
                    {
                        idx++;
                        weap = getweapon(level._AllWeaps[x]);
                        if(!isDefined(weap) || stat.name == "") continue;//check for blank stats, so we don't set incorrect data here
                        //these are questionable, pulled from StatMilestones3.csv. Should be weapon Camos, untested.
                        player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Camo Challenges");
                        player addweaponstat(weap, stat.name, 5000);
                        player addrankxp(#"kill",weap,undefined,undefined,1,5000);
                        player addweaponstat(weap, #"kills", 5000);
                        player addweaponstat(weap, #"headshots", 5000);
                        player addweaponstat(weap, #"longshot_kill", 5000);
                        player addweaponstat(weap, #"hash_72add9adadcd524b", 2500);
                        player addweaponstat(weap, #"hash_48fa9e0371c0697a", 2500);
                        player addweaponstat(weap, #"multikill_2", 2500);
                        player addweaponstat(weap, #"killstreak_5", 2500);
                        player addweaponstat(weap, #"revenge_kill", 2500);
                        player addweaponstat(weap, #"backstabber_kill", 2500);
                        player addweaponstat(weap, #"hash_6d1ab256c84ca772", 2500);
                        wait .1;
                    }
                    break;
            }
            wait 0.1;
            UploadStats(player);
        }
    }
    player iPrintLnBold("^5Unlock All ^2Complete");
}


bo4_AddBotsToGame() 
{
    AddTestClient();
}

unfair_aimbot()
{
    self.unfairAimbot = isDefined(self.unfairAimbot) ? undefined : true;

    if(isDefined(self.unfairAimbot))
    {
        self endon("disconnect");
 
        while(isdefined(self.unfairAimbot)) 
        {
            self waittill(#"weapon_fired");

            start = self geteye();
            end = start + anglestoforward(self getplayerangles()) * 1000000;
            trace = bullettrace(start, end, false, self)["position"];
            foreach(player in level.players)
            {   
                if(player != self && player.pers["team"] != self.pers["team"])
                {
                    wait .1;
                    player dodamage(player.health + 100, player.origin, self, self, "head", "MOD_RIFLE_BULLET", 2, self getCurrentWeapon());
                }
            }
        }

    }
}