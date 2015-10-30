<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgentView.aspx.cs" Inherits="Vz.MegaHack.Web.AgentView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Content/Scripts/Libs/jquery-1.10.2.min.js"></script>
    <script src="Content/Scripts/Libs/jquery.layout.js"></script>
    <a href="AgentView.aspx">AgentView.aspx</a>
    <script src="Content/Scripts/Libs/customEvents.js"></script>
    <script src="https://code.highcharts.com/stock/highstock.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script type="text/javascript">
        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        function goback() {
            window.location.href = "SupView.aspx?cid=" + getParameterByName('cid') + "&sid=" + getParameterByName('sid');
        }

        $(document).ready(function () {
            $('body').layout({ applyDefaultStyles: true });

            var centerid = getParameterByName('cid');
        });

        function onChartLoad() {
            var radius,
                label,
                left,
                right,
                renderer;

            if (this.chartWidth < 530) {
                return;
            }

            // Prepare mouseover
            renderer = this.renderer;
            if (renderer.defs) { // is SVG
                $.each(this.get('employees').points, function () {
                    var point = this,
                        pattern;
                    if (point.image) {
                        pattern = renderer.createElement('pattern').attr({
                            id: 'pattern-' + point.image,
                            patternUnits: 'userSpaceOnUse',
                            width: 400,
                            height: 400
                        }).add(renderer.defs);

                        Highcharts.addEvent(point, 'mouseOver', function () {
                            empImage
                                .attr({
                                    fill: 'url(#pattern-' + point.image + ')'
                                })
                                .animate({ opacity: 1 }, { duration: 500 });
                        });
                        Highcharts.addEvent(point, 'mouseOut', function () {
                            empImage.animate({ opacity: 0 }, { duration: 500 });
                        });
                    }
                });
            }
        }

        $(function () {
            Highcharts.setOptions({
                chart: {
                    events: {
                        load: onChartLoad
                    }
                },
                exporting: {
                    enabled: false
                },
                credits: {
                    enabled: false
                },
                tooltip: {
                    style: {
                        width: '250px'
                    }
                },

                plotOptions: {
                    series: {
                        marker: {
                            enabled: false,
                            symbol: 'circle',
                            radius: 2
                        },
                        fillOpacity: 0.5
                    },
                    flags: {
                        tooltip: {
                            xDateFormat: '%B %e, %Y'
                        }
                    }
                }
            });

            var options = {
                xAxis: {
                    type: 'datetime',
                    minTickInterval: 30 * 24 * 36e5,
                    labels: {
                        align: 'left'
                    },
                    plotBands: [{
                        from: Date.UTC(2015, 0, 1),
                        to: Date.UTC(2015, 2, 31),
                        color: '#EFFFFF',
                        label: {
                            text: '<em>Quarter1</em>',
                            style: {
                                color: '#999999'
                            },
                            y: 10
                        }
                    }, {
                        from: Date.UTC(2015, 3, 1),
                        to: Date.UTC(2015, 5, 30),
                        color: '#FFFFEF',
                        label: {
                            text: '<em>Quarter2</em>',
                            style: {
                                color: '#999999'
                            },
                            y: 10
                        }
                    }, {
                        from: Date.UTC(2015, 6, 1),
                        to: Date.UTC(2015, 8, 30),
                        color: '#FFEFFF',
                        label: {
                            text: '<em>Quarter3</em>',
                            style: {
                                color: '#999999'
                            },
                            y: 10
                        }
                    }]

                },
                yAxis: [{
                    max: 10,
                    allowDecimals: false,
                    labels: {
                        style: {
                            color: Highcharts.getOptions().colors[2]
                        },
                        enabled: true
                    },
                    title: {
                        text: 'Performance Points',
                        style: {
                            color: Highcharts.getOptions().colors[2]
                        }
                    },
                    gridLineColor: 'rgba(0, 0, 0, 0.07)',
                    opposite: true,
                    gridLineWidth: 0
                }]
            };

            var kpichart1Options = {
                chart: {
                    renderTo: 'chart_Container_KPI1'
                },
                title:{
                    text : '<%= agentScores[0].KPIName.ToString() %>'
                },
                series: [{
                    yAxis: 0,
                    name: 'Center Average',
                    id: 'revenue',
                    type: 'area',
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 1, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 2, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 3, 1), y: 9, name: '9' },
                        { x: Date.UTC(2015, 4, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 5, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 6, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 7, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 8, 1), y: 8, name: '8' },
                        { x: Date.UTC(2015, 9, 1), y: 7, name: '7' }
                    ],
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        valueSuffix: ' %'
                    }

                }, {
                    yAxis: 0,
                    name: 'Agent Performance',
                    id: 'employees',
                    type: 'area',
                    step: 'left',
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        //pointFormat: '{point.name}<br><b>{point.y}</b>',
                        valueSuffix: ' %'
                    },
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 1, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 2, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 3, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 4, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 5, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 6, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 7, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 8, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 9, 1), y: 4, name: '4' }
                    ]

                }]
            };
            if (Highcharts.seriesTypes.flags) {
                kpichart1Options.series.push({
                    type: 'flags',
                    name: 'Training',
                    color: '#333333',
                    fillColor: 'rgba(255,255,255,0.8)',
                    data: [
                        { x: Date.UTC(2015, 3, 26), text: 'Undertook training', title: 'Training 1' },
                        { x: Date.UTC(2015, 5, 25), text: 'Undertook Training', title: 'Training 2' },
                        { x: Date.UTC(2015, 6, 27), text: 'Undertook Training', title: 'Training 3' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
                kpichart1Options.series.push({
                    type: 'flags',
                    name: 'Awards',
                    color: '#333333',
                    fillColor: 'green',
                    data: [
                        { x: Date.UTC(2015, 2, 13), text: 'Awarded Best Employee', title: 'Award 1' },
                        { x: Date.UTC(2015, 7, 13), text: 'Spotlight Award', title: 'Award 2' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
            }
            kpichart1Options = jQuery.extend(true, {}, options, kpichart1Options);
            var kpiChart1 = new Highcharts.Chart(kpichart1Options);

            var kpichart2Options = {
                chart: {
                    renderTo: 'chart_Container_KPI2'
                },
                title: {
                    text: '<%= agentScores[1].KPIName.ToString() %>'
                },
                series: [{
                    yAxis: 0,
                    name: 'Center Average',
                    id: 'revenue',
                    type: 'area',
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 1, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 2, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 3, 1), y: 9, name: '9' },
                        { x: Date.UTC(2015, 4, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 5, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 6, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 7, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 8, 1), y: 8, name: '8' },
                        { x: Date.UTC(2015, 9, 1), y: 7, name: '7' }
                    ],
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        valueSuffix: ' %'
                    }

                }, {
                    yAxis: 0,
                    name: 'Agent Performance',
                    id: 'employees',
                    type: 'area',
                    step: 'left',
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        //pointFormat: '{point.name}<br><b>{point.y}</b>',
                        valueSuffix: ' %'
                    },
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 1, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 2, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 3, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 4, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 5, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 6, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 7, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 8, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 9, 1), y: 4, name: '4' }
                    ]

                }]
            };
            if (Highcharts.seriesTypes.flags) {
                kpichart2Options.series.push({
                    type: 'flags',
                    name: 'Training',
                    color: '#333333',
                    fillColor: 'rgba(255,255,255,0.8)',
                    data: [
                        { x: Date.UTC(2015, 3, 26), text: 'Undertook training', title: 'Training 1' },
                        { x: Date.UTC(2015, 5, 25), text: 'Undertook Training', title: 'Training 2' },
                        { x: Date.UTC(2015, 6, 27), text: 'Undertook Training', title: 'Training 3' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
                kpichart2Options.series.push({
                    type: 'flags',
                    name: 'Awards',
                    color: '#333333',
                    fillColor: 'green',
                    data: [
                        { x: Date.UTC(2015, 2, 13), text: 'Awarded Best Employee', title: 'Award 1' },
                        { x: Date.UTC(2015, 7, 13), text: 'Spotlight Award', title: 'Award 2' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
            }
            kpichart2Options = jQuery.extend(true, {}, options, kpichart2Options);
            var kpiChart2 = new Highcharts.Chart(kpichart2Options);

            var kpichart3Options = {
                chart: {
                    renderTo: 'chart_Container_KPI3'
                },
                title: {
                    text: '<%= agentScores[2].KPIName.ToString() %>'
                },
                series: [{
                    yAxis: 0,
                    name: 'Center Average',
                    id: 'revenue',
                    type: 'area',
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 1, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 2, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 3, 1), y: 9, name: '9' },
                        { x: Date.UTC(2015, 4, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 5, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 6, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 7, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 8, 1), y: 8, name: '8' },
                        { x: Date.UTC(2015, 9, 1), y: 7, name: '7' }
                    ],
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        valueSuffix: ' %'
                    }

                }, {
                    yAxis: 0,
                    name: 'Agent Performance',
                    id: 'employees',
                    type: 'area',
                    step: 'left',
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        //pointFormat: '{point.name}<br><b>{point.y}</b>',
                        valueSuffix: ' %'
                    },
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 1, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 2, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 3, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 4, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 5, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 6, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 7, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 8, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 9, 1), y: 4, name: '4' }
                    ]

                }]
            };
            if (Highcharts.seriesTypes.flags) {
                kpichart3Options.series.push({
                    type: 'flags',
                    name: 'Training',
                    color: '#333333',
                    fillColor: 'rgba(255,255,255,0.8)',
                    data: [
                        { x: Date.UTC(2015, 3, 26), text: 'Undertook training', title: 'Training 1' },
                        { x: Date.UTC(2015, 5, 25), text: 'Undertook Training', title: 'Training 2' },
                        { x: Date.UTC(2015, 6, 27), text: 'Undertook Training', title: 'Training 3' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
                kpichart3Options.series.push({
                    type: 'flags',
                    name: 'Awards',
                    color: '#333333',
                    fillColor: 'green',
                    data: [
                        { x: Date.UTC(2015, 2, 13), text: 'Awarded Best Employee', title: 'Award 1' },
                        { x: Date.UTC(2015, 7, 13), text: 'Spotlight Award', title: 'Award 2' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
            }
            kpichart3Options = jQuery.extend(true, {}, options, kpichart3Options);
            var kpiChart3 = new Highcharts.Chart(kpichart3Options);

            var kpichart4Options = {
                chart: {
                    renderTo: 'chart_Container_KPI4'
                },
                title: {
                    text: '<%= agentScores[3].KPIName.ToString() %>'
                },
                series: [{
                    yAxis: 0,
                    name: 'Center Average',
                    id: 'revenue',
                    type: 'area',
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 1, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 2, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 3, 1), y: 9, name: '9' },
                        { x: Date.UTC(2015, 4, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 5, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 6, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 7, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 8, 1), y: 8, name: '8' },
                        { x: Date.UTC(2015, 9, 1), y: 7, name: '7' }
                    ],
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        valueSuffix: ' %'
                    }

                }, {
                    yAxis: 0,
                    name: 'Agent Performance',
                    id: 'employees',
                    type: 'area',
                    step: 'left',
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        //pointFormat: '{point.name}<br><b>{point.y}</b>',
                        valueSuffix: ' %'
                    },
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 1, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 2, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 3, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 4, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 5, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 6, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 7, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 8, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 9, 1), y: 4, name: '4' }
                    ]

                }]
            };
            if (Highcharts.seriesTypes.flags) {
                kpichart4Options.series.push({
                    type: 'flags',
                    name: 'Training',
                    color: '#333333',
                    fillColor: 'rgba(255,255,255,0.8)',
                    data: [
                        { x: Date.UTC(2015, 3, 26), text: 'Undertook training', title: 'Training 1' },
                        { x: Date.UTC(2015, 5, 25), text: 'Undertook Training', title: 'Training 2' },
                        { x: Date.UTC(2015, 6, 27), text: 'Undertook Training', title: 'Training 3' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
                kpichart4Options.series.push({
                    type: 'flags',
                    name: 'Awards',
                    color: '#333333',
                    fillColor: 'green',
                    data: [
                        { x: Date.UTC(2015, 2, 13), text: 'Awarded Best Employee', title: 'Award 1' },
                        { x: Date.UTC(2015, 7, 13), text: 'Spotlight Award', title: 'Award 2' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
            }
            kpichart4Options = jQuery.extend(true, {}, options, kpichart4Options);
            var kpiChart4 = new Highcharts.Chart(kpichart4Options);

            var kpichart5Options = {
                chart: {
                    renderTo: 'chart_Container_KPI5'
                },
                title: {
                    text: '<%= agentScores[4].KPIName.ToString() %>'
                },
                series: [{
                    yAxis: 0,
                    name: 'Center Average',
                    id: 'revenue',
                    type: 'area',
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 1, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 2, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 3, 1), y: 9, name: '9' },
                        { x: Date.UTC(2015, 4, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 5, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 6, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 7, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 8, 1), y: 8, name: '8' },
                        { x: Date.UTC(2015, 9, 1), y: 7, name: '7' }
                    ],
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        valueSuffix: ' %'
                    }

                }, {
                    yAxis: 0,
                    name: 'Agent Performance',
                    id: 'employees',
                    type: 'area',
                    step: 'left',
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        //pointFormat: '{point.name}<br><b>{point.y}</b>',
                        valueSuffix: ' %'
                    },
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 1, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 2, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 3, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 4, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 5, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 6, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 7, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 8, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 9, 1), y: 4, name: '4' }
                    ]

                }]
            };
            if (Highcharts.seriesTypes.flags) {
                kpichart5Options.series.push({
                    type: 'flags',
                    name: 'Training',
                    color: '#333333',
                    fillColor: 'rgba(255,255,255,0.8)',
                    data: [
                        { x: Date.UTC(2015, 3, 26), text: 'Undertook training', title: 'Training 1' },
                        { x: Date.UTC(2015, 5, 25), text: 'Undertook Training', title: 'Training 2' },
                        { x: Date.UTC(2015, 6, 27), text: 'Undertook Training', title: 'Training 3' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
                kpichart5Options.series.push({
                    type: 'flags',
                    name: 'Awards',
                    color: '#333333',
                    fillColor: 'green',
                    data: [
                        { x: Date.UTC(2015, 2, 13), text: 'Awarded Best Employee', title: 'Award 1' },
                        { x: Date.UTC(2015, 7, 13), text: 'Spotlight Award', title: 'Award 2' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
            }
            kpichart5Options = jQuery.extend(true, {}, options, kpichart5Options);
            var kpiChart5 = new Highcharts.Chart(kpichart5Options);

            var kpichart6Options = {
                chart: {
                    renderTo: 'chart_Container_KPI6'
                },
                title: {
                    text: '<%= agentScores[5].KPIName.ToString() %>'
                },
                series: [{
                    yAxis: 0,
                    name: 'Center Average',
                    id: 'revenue',
                    type: 'area',
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 1, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 2, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 3, 1), y: 9, name: '9' },
                        { x: Date.UTC(2015, 4, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 5, 1), y: 2, name: '2' },
                        { x: Date.UTC(2015, 6, 1), y: 3, name: '3' },
                        { x: Date.UTC(2015, 7, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 8, 1), y: 8, name: '8' },
                        { x: Date.UTC(2015, 9, 1), y: 7, name: '7' }
                    ],
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        valueSuffix: ' %'
                    }

                }, {
                    yAxis: 0,
                    name: 'Agent Performance',
                    id: 'employees',
                    type: 'area',
                    step: 'left',
                    tooltip: {
                        headerFormat: '<span style="font-size: 11px;color:#666">{point.x:%B %e, %Y}</span><br>',
                        //pointFormat: '{point.name}<br><b>{point.y}</b>',
                        valueSuffix: ' %'
                    },
                    data: [
                        { x: Date.UTC(2015, 0, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 1, 1), y: 4, name: '4' },
                        { x: Date.UTC(2015, 2, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 3, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 4, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 5, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 6, 1), y: 5, name: '5' },
                        { x: Date.UTC(2015, 7, 1), y: 7, name: '7' },
                        { x: Date.UTC(2015, 8, 1), y: 6, name: '6' },
                        { x: Date.UTC(2015, 9, 1), y: 4, name: '4' }
                    ]

                }]
            };
            if (Highcharts.seriesTypes.flags) {
                kpichart6Options.series.push({
                    type: 'flags',
                    name: 'Training',
                    color: '#333333',
                    fillColor: 'rgba(255,255,255,0.8)',
                    data: [
                        { x: Date.UTC(2015, 3, 26), text: 'Undertook training', title: 'Training 1' },
                        { x: Date.UTC(2015, 5, 25), text: 'Undertook Training', title: 'Training 2' },
                        { x: Date.UTC(2015, 6, 27), text: 'Undertook Training', title: 'Training 3' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
                kpichart6Options.series.push({
                    type: 'flags',
                    name: 'Awards',
                    color: '#333333',
                    fillColor: 'green',
                    data: [
                        { x: Date.UTC(2015, 2, 13), text: 'Awarded Best Employee', title: 'Award 1' },
                        { x: Date.UTC(2015, 7, 13), text: 'Spotlight Award', title: 'Award 2' }
                    ],
                    onSeries: 'employees',
                    showInLegend: false
                });
            }
            kpichart6Options = jQuery.extend(true, {}, options, kpichart6Options);
            var kpiChart6 = new Highcharts.Chart(kpichart6Options);

        });
    </script>

    <style type="text/css">
        .active {
            border-style: solid;
            border-width: 2px;
            border-color: red;
        }

        body {
            font-family: Arial;
        }

        .topheader {
            background-color: #FF3333 !important;
            font-weight: bold;
            color: white;
        }

        .leftpane {
            background-color: #FFFFFF !important;
        }

        .rightpane {
            background-color: #363636 !important;
        }

        .rcorners {
            border-radius: 25px;
            background: #8AC007;
            padding: 20px;
            width: 118px;
            height: 110px;
        }


        #upleft {
            width: 79%;
            height: 100%;
            float: left;
            /*border-style: solid;
            border-width: 1px;
            border-right: solid;
            border-right-color: gray;*/
        }

        /*#upright {
            width: 40%;
            height: 100%;
            float: left;
        }*/

        #below {
            height: 290px;
            width: 99%;
            /*border-style: solid;*/
            border-width: 1px;
            border-top: solid;
            border-top-color: gray;
            clear: both;
        }

        .curvedimage {
            border-top-right-radius: 50% 10%;
            border-top-left-radius: 50% 10%;
            border-bottom-right-radius: 50% 10%;
            border-bottom-left-radius: 50% 10%;
            width: 130px;
            height: 130px;
        }

        .ui-layout-resizer-east {
            right: 40% !important;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <div class="ui-layout-center leftpane">
            <div id="upleft">
                <table class="table-responsive" id="upleft">
                    <tr>
                        <td id="chart_Container_KPI1" style="min-width: 310px; max-width: 400px; height: 300px; margin: 1em auto"></td>
                        <td id="chart_Container_KPI2" style="min-width: 310px; max-width: 400px; height: 300px; margin: 1em auto"></td>
                        <td id="chart_Container_KPI3" style="min-width: 310px; max-width: 400px; height: 300px; margin: 1em auto"></td>
                    </tr>
                    <tr>
                        <td id="chart_Container_KPI4" style="min-width: 310px; max-width: 400px; height: 300px; margin: 1em auto"></td>
                        <td id="chart_Container_KPI5" style="min-width: 310px; max-width: 400px; height: 300px; margin: 1em auto"></td>
                        <td id="chart_Container_KPI6" style="min-width: 310px; max-width: 400px; height: 300px; margin: 1em auto"></td>
                    </tr>
                </table>
            </div>


        </div>
        <div class="ui-layout-north topheader">
            Call Center Gamfication

        <div style="float: right; color: yellow" id="divAgentName"></div>
            <div style="float: right">Agent Name: <%= Request.QueryString["aid"] %> </div>
        </div>


    </form>
</body>
</html>
