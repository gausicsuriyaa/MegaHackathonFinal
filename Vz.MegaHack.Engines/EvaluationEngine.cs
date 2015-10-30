using Vz.MegaHack.Entities;
using Vz.MegaHack.Data;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Vz.MegaHack.Engines
{
    public static class EvaluationEngine {

        public static List<LeaderBoardItem> GetLeaderBoard(string centerId) {
            List<LeaderBoardItem> leaderBoard = new List<LeaderBoardItem>();
            List<AgentInfo> agents = AgentReader.GetAgentItems(centerId);

            int rank = 0;
            foreach (AgentInfo agent in agents.OrderByDescending(a => a.Points)) {
                leaderBoard.Add(new LeaderBoardItem() {
                    Name = agent.AgentName,
                    TotalPoints = agent.Points,
                    PhotoFileName = agent.PhotoFileName,
                    Rank = ++rank
                });

                if (rank >= 10) {
                    break;
                }
            }

            return leaderBoard;
        }

        public static List<KPIItem> GetCenterKPI(string centerId) {
            List<KPIItem> items = new List<KPIItem>();
            List<AgentKPIInfo> allKPIs = KPIReader.GetAgentKPI();
            List<KPIInfo> kpiNames = KPIReader.GetKPI();

            List<SupervisorInfo> supervisors = AgentReader.GetSupervisorsForCenter(centerId);
            foreach (var supervisor in supervisors) {
                List<KPIItem> supervisorKPI = GetSupervisorKPI(supervisor.SupervisorId);

                if (supervisorKPI.Count > 0) {
                    List<AgentInfo> agents = AgentReader.GetAgentsForSupervisor(supervisor.SupervisorId);
                    var agentKPIs = from allK in allKPIs
                                    join a in agents on allK.AgentId equals a.AgentId
                                    group allK by allK.KpiId into g
                                    select new { KpiId = g.First().KpiId, KpiTotal = g.Average(a => a.KpiValue) };

                    string topKpiString = string.Empty;
                    string bottomKpiString = string.Empty;

                    var topKPI = agentKPIs.OrderByDescending(a => a.KpiTotal).Take(2);
                    foreach (var row in topKPI) {
                        string kpiName = kpiNames.Where(k => k.KpiId.Equals(row.KpiId)).FirstOrDefault().KpiName;
                        topKpiString += string.Format("{0}: {1};", kpiName, row.KpiTotal);
                    }

                    var bottomKPI = agentKPIs.OrderBy(a => a.KpiTotal).Take(2);
                    foreach (var row in bottomKPI) {
                        string kpiName = kpiNames.Where(k => k.KpiId.Equals(row.KpiId)).FirstOrDefault().KpiName;
                        bottomKpiString += string.Format("{0}: {1};", kpiName, row.KpiTotal);
                    }

                    double avgScore = supervisorKPI.Average(a => a.Score);

                    items.Add(new KPIItem() {
                        AgentId = supervisor.SupervisorId,
                        AgentName = supervisor.SupervisorName,
                        Score = Convert.ToInt32(avgScore),
                        TopKPI = topKpiString,
                        BottomKPI = bottomKpiString
                    });
                }
            }

            return items;
        }

        public static List<KPIItem> GetSupervisorKPI(string supervisorId) {
            List<KPIItem> items = new List<KPIItem>();

            List<KPIInfo> kpis = KPIReader.GetKPI();
            List<AgentKPIInfo> agentKpis = KPIReader.GetAgentKPI();
            List<AgentInfo> agents = AgentReader.GetAgentsForSupervisor(supervisorId);

            var result = from k in kpis
                         join ak in agentKpis on k.KpiId equals ak.KpiId
                         join a in agents on ak.AgentId equals a.AgentId
                         orderby a.AgentName, ak.KpiValue ascending
                         select new { a.AgentName, k.KpiName, ak.KpiValue };

            var agentGroups = result.GroupBy(a => a.AgentName).Select(g => g.FirstOrDefault());

            foreach (var agentGroup in agentGroups) {

                var agentRows = result.Where(a => a.AgentName.Equals(agentGroup.AgentName));
                double avgKpi = agentRows.Average(a => a.KpiValue);
                string topKpiString = string.Empty;
                string bottomKpiString = string.Empty;

                var topKPI = agentRows.OrderByDescending(a => a.KpiValue).Take(2);
                foreach (var row in topKPI) {
                    topKpiString += string.Format("{0}: {1};", row.KpiName, row.KpiValue);
                }

                var bottomKPI = agentRows.OrderBy(a => a.KpiValue).Take(2);
                foreach (var row in bottomKPI) {
                    bottomKpiString += string.Format("{0}: {1};", row.KpiName, row.KpiValue);
                }

                items.Add(new KPIItem() {
                    AgentName = agentGroup.AgentName,
                    Score = Convert.ToInt32(avgKpi),
                    TopKPI = topKpiString,
                    BottomKPI = bottomKpiString
                });
            }

            return items.OrderByDescending(i => i.Score).ToList();
        }

        public static List<HeatMapItem> GetHeatMap(string supervisorId) {
            List<HeatMapItem> items = new List<HeatMapItem>();

            List<KPIInfo> kpis = KPIReader.GetKPI();
            List<AgentKPIInfo> agentKpis = KPIReader.GetAgentKPI();
            List<AgentInfo> agents = AgentReader.GetAgentsForSupervisor(supervisorId);

            var result = from k in kpis
                         join ak in agentKpis on k.KpiId equals ak.KpiId
                         join a in agents on ak.AgentId equals a.AgentId
                         orderby a.AgentName, k.KpiName
                         select new { a.AgentId, a.AgentName, k.KpiId, k.KpiName, ak.KpiValue };

            foreach (var row in result) {

                items.Add(new HeatMapItem() {
                    AgentId = row.AgentId,
                    AgentName = row.AgentName,
                    KpiId = row.KpiId,
                    KpiName = row.KpiName,
                    KpiScore = row.KpiValue
                });
            }

            return items;
        }

        public static List<AgentKPIScore> GetAgentDashboard(string agentId)
        {
            List<AgentKPIScore> items = new List<AgentKPIScore>();

            List<KPIInfo> kpis = KPIReader.GetKPI();
            List<AgentKPIInfo> agentKpis = KPIReader.GetAgentKPI();
            AgentInfo agentInfo = AgentReader.GetAgentInfo(agentId);

            var result = from k in kpis
                         join ak in agentKpis on k.KpiId equals ak.KpiId
                         where ak.AgentId == agentId
                         orderby k.KpiName
                         select new { k.KpiId, k.KpiName, ak.Date, ak.KpiValue, ak.HadTraining, ak.IsAwarded, ak.Description };

            var kpiGroups = result.GroupBy(k => k.KpiName).Select(g => g.FirstOrDefault());

            foreach (var kpiGroup in kpiGroups)
            {
                var kpiRows = result.Where(k => k.KpiName.Equals(kpiGroup.KpiName));

                List<KPIScoreInfo> scoreList = new List<KPIScoreInfo>();
                foreach (var row in kpiRows)
                {
                    scoreList.Add(new KPIScoreInfo()
                    {
                        Date = row.Date,
                        Score = row.KpiValue.ToString(),
                        HadTraining = row.HadTraining,
                        IsAwarded = row.IsAwarded,
                        Description = row.Description
                    });
                }

                items.Add(new AgentKPIScore()
                {
                    KPIName = kpiGroup.KpiName,
                    ScoreDetails = scoreList
                });
            }

            return items;
        }
    }

}
