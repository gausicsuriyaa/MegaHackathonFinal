using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Vz.MegaHack.Entities;
using Vz.MegaHack.Engines;

namespace Vz.MegaHack.Web
{
    public partial class AgentView : System.Web.UI.Page
    {
        public List<AgentKPIScore> agentScores = new List<AgentKPIScore>();
        public List<string> kpiScores = new List<string>();
        protected void Page_Load(object sender, EventArgs e)
        {
            string agentID = Request.QueryString["aid"];
            agentScores = EvaluationEngine.GetAgentDashboard(agentID);
            foreach (AgentKPIScore kpiscore in agentScores)
            {
                string tempkpival = String.Format("{ x: Date.UTC({0}, {1}, {2}), y: {3}, name: '{4}' },",date);
                kpiScores.Add(tempkpival);
            }
        }
    }
}