﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Vz.MegaHack.Entities {
    public class KPIItem {
        public string AgentId { get; set; }
        public string AgentName { get; set; }
        public int Score { get; set; }
        public string TopKPI { get; set; }
        public string BottomKPI { get; set; }

        public override string ToString() {
            return string.Format("Name:{0}, Score:{1}, TopKPI={2}, BottomKPI={3}", AgentName, Score, TopKPI, BottomKPI);
        }
    }
}
