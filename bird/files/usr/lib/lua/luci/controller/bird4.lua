-- Copyright (C) Eloi Carbó - 2014
-- GSoC 2014 - "BGP/Bird integration with OpenWRT and QMP"


module("luci.controller.bird4", package.seeall)


function index()

        entry({"admin","bird4"}, cbi("bird4/bird4"), "Bird", 0).dependent=false
        entry({"admin","bird4","overview"}, cbi("bird4/bird4"), "Overview", 1).dependent=false
        entry({"admin","bird4","basic"}, cbi("bird4/bird4"), "Basic Configuration", 2).dependent=false
        entry({"admin","bird4","proto_general"}, cbi("bird4/b_gen_proto"), "General protocols", 3).dependent=false
--      entry({"admin","bird4","proto_bgp"}, cbi("bird4/b_bgp_proto"), "BGP Protocol", 4).dependent=false

end

