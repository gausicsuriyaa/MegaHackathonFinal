using Vz.MegaHack.Core;
using Vz.MegaHack.Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Vz.MegaHack.Data
{
    public static class AgentReader {
        static string agentInfoFileName = "AgentInfo.xml";
        static string supervisorInfoFileName = "SupervisorInfo.xml";

        public static List<AgentInfo> GetAgentItems(string centerId) {
            List<AgentInfo> AgentItems = new List<AgentInfo>();

            XDocument doc = XDocument.Load(Path.Combine(PathManager.DataPath, agentInfoFileName));

            var items = doc.Root.Elements("Agent").Where(i => i.Attribute("centerId").Value.Equals(centerId));

            foreach (var item in items) {
                AgentItems.Add(new AgentInfo() {
                    AgentId = Convert.ToString(item.Attribute("id").Value),
                    AgentName = Convert.ToString(item.Attribute("name").Value),
                    Date = Convert.ToDateTime(item.Attribute("date").Value),
                    Points = Convert.ToInt32(item.Attribute("points").Value),
                    PhotoFileName = Convert.ToString(item.Attribute("photoFileName").Value),
                });
            }

            return AgentItems;
        }

        public static List<AgentInfo> GetAgentsForSupervisor(string supervisorId) {
            List<AgentInfo> agentItems = new List<AgentInfo>();
            XDocument doc = XDocument.Load(Path.Combine(PathManager.DataPath, agentInfoFileName));

            var items = doc.Root.Elements("Agent").Where(i => i.Attribute("supervisorId").Value.Equals(supervisorId));

            foreach (var item in items) {
                agentItems.Add(new AgentInfo() {
                    AgentId = Convert.ToString(item.Attribute("id").Value),
                    AgentName = Convert.ToString(item.Attribute("name").Value),
                    Date = Convert.ToDateTime(item.Attribute("date").Value),
                    Points = Convert.ToInt32(item.Attribute("points").Value),
                    PhotoFileName = Convert.ToString(item.Attribute("photoFileName").Value),
                });
            }

            return agentItems;
        }
        public static List<SupervisorInfo> GetSupervisorsForCenter(string centerId) {
            List<SupervisorInfo> supervisorItems = new List<SupervisorInfo>();
            XDocument doc = XDocument.Load(Path.Combine(PathManager.DataPath, supervisorInfoFileName));

            var items = doc.Root.Elements("Supervisor").Where(i => i.Attribute("centerId").Value.Equals(centerId));

            foreach (var item in items) {
                supervisorItems.Add(new SupervisorInfo() {
                    SupervisorId = Convert.ToString(item.Attribute("id").Value),
                    SupervisorName = Convert.ToString(item.Attribute("name").Value),
                    CenterId = Convert.ToString(item.Attribute("centerId").Value)
                });
            }

            return supervisorItems;
        }

        public static AgentInfo GetAgentInfo(string agentId)
        {
            XDocument doc = XDocument.Load(Path.Combine(PathManager.DataPath, agentInfoFileName));
            var items = doc.Root.Elements("Agent").Where(i => i.Attribute("id").Value.Equals(agentId));
            if (items.Count() > 0)
            {
                var item = items.FirstOrDefault();
                return new AgentInfo()
                {
                    AgentId = Convert.ToString(item.Attribute("id").Value),
                    AgentName = Convert.ToString(item.Attribute("name").Value),
                    Date = Convert.ToDateTime(item.Attribute("date").Value),
                    Points = Convert.ToInt32(item.Attribute("points").Value),
                    PhotoFileName = Convert.ToString(item.Attribute("photoFileName").Value)
                };
            }
            return null;
        }
    }
}
