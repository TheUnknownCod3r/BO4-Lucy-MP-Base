#include scripts\core_common\struct;
#include scripts\core_common\callbacks_shared;
#include scripts\core_common\clientfield_shared;
#include scripts\core_common\math_shared;
#include scripts\core_common\system_shared;
#include scripts\core_common\util_shared;
#include scripts\core_common\hud_util_shared;
#include scripts\core_common\hud_message_shared;
#include scripts\core_common\hud_shared;
#include scripts\core_common\array_shared;
#include scripts\core_common\flag_shared;
#include scripts\core_common\aat_shared.gsc;
#include scripts\mp_common\util.gsc;
#include scripts\core_common\rank_shared.gsc;
#include scripts\core_common\exploder_shared.gsc;
#include scripts\core_common\challenges_shared.gsc;
#include scripts\core_common\contracts_shared.gsc;
#include scripts\core_common\match_record.gsc;
#include scripts\core_common\player\player_stats.gsc;
#include scripts\mp_common\gametypes\globallogic_score.gsc;
#include scripts\mp_common\gametypes\globallogic.gsc;
#include scripts\mp_common\gametypes\globallogic_utils.gsc;
#include scripts\core_common\laststand_shared.gsc;
#include scripts\core_common\persistence_shared.gsc;

#namespace clientids_shared;

autoexec __init__sytem__()
{
	system::register("clientids_shared", &__init__, undefined, undefined);
    level.rankedmatch=true;
    level.onlinegame=true;
    level.nopersistence=false;
}

__init__()
{
    callback::on_start_gametype(&init);
    callback::on_spawned(&onPlayerSpawned);
}

/*event_handler[player_rankup] player_rankup( eventstruct ) 
{
    if(self.pers[#"rank"] != 54) self.pers[ #"rank" ] = 54;
    self.pers[#"plevel"] = 10;
    self stats::set_stat(#"playerstatslist",#"rank",#"statvalue",int(54));
    self stats::set_stat(#"playerstatslist",#"maxxp",#"statvalue",int(1));
    self stats::set_stat(#"playerstatslist",#"minxp",#"statvalue",int(0));
    self stats::set_stat(#"playerstatslist",#"rankxp",#"statvalue",int(21474837));
    uploadstats(self);
    self function_b552ffa9( #"rank_up", 3, 54, 11, 999 );
}*/
