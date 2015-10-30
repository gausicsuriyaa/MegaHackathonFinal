using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Vz.MegaHack.Entities
{
    public class AgentKPIInfo
    {
        public string AgentId { get; set; }
        public string KpiId { get; set; }
        public int KpiValue { get; set; }
        public DateTime Date { get; set; }
        public bool HadTraining { get; set; }
        public bool IsAwarded { get; set; }
        public string Description { get; set; }
    }
}
