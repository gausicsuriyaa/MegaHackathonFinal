using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Vz.MegaHack.Entities
{
    public class AgentKPIScore
    {
        public string KPIName { get; set; }
        public List<KPIScoreInfo> ScoreDetails { get; set; }
    }
}
