<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DetailView.aspx.cs" Inherits="Vz.MegaHack.Web.DetailView" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Content/Scripts/Libs/jquery-1.10.2.min.js"></script>
    <script src="Content/Scripts/Libs/jquery.layout.js"></script>
    <script src="Content/Scripts/Libs/jquery-ui.min.js"></script>
    <script src="Content/Scripts/Libs/jquery-ui-slider-pips.js"></script>

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

        
        $('.highcharts-xaxis-labels text').on('click', function () {
            console.log($(this).text());
            alert($(this).text());
        });


        var timeoutVar = null;
        $(function () {

            $("#rainbow-slider ")
				.slider({
				    min: -3,
				    max: 3,
				    range: true,
				    step: 0.5,
				    values: [-3, 3],
				    slide: function (event, ui) {
				        console.log(ui.values);
				    },
				    change: function (event, ui) {
				        console.log("stop=" + ui.value);
				        clearTimeout(timeoutVar);
				        timeoutVar = setTimeout(function () {
				            recalculateWithSD(ui.values[0], ui.values[1]);
				        }, 100);
				    }
				}).slider("pips", {
				    rest: "label"
				});
            setTimeout(function () {
                recalculateWithSD(-3, 3);
            }, 200);
        });
        function outputUpdate(vol) {
            document.querySelector('#tolerenceOutput').value = vol;
            clearTimeout(timeoutVar);
            timeoutVar = setTimeout(function () {
                recalculateWithSD(vol);
            }, 100);
        }
        function rgb(p, color) {
            //console.log("p=>" + p);
            if (color == 'r') {
                r = 255;
                g = (1 - p) * 255;
            } else {
                g = 255;
                r = (1 - p) * 255;
            }

            b = (1 - p) * 255;
            return 'rgb(' + Math.round(r) + ',' + Math.round(g) + ',' + Math.round(b) + ')';
        }

        function recalculateWithSD(min, max) {
            var $rows = $("#tableOutput .attr");
            $rows.each(function () {
                var $row = $(this);
                var avg = parseFloat($row.find("td.avg").text());
                var sd = parseFloat($row.attr("data-sd")).toFixed(2);
                $row.children("td.val").each(function () {
                    var v = parseFloat($(this).text());
                    var zscore = (v - avg) / sd;
                    if (zscore > min && zscore < max) {
                        console.log("zscore=" + zscore);
                        if (zscore <= 0) {
                            $(this).css("background", rgb(((-1) * zscore / 3), "g"));
                        } else {
                            $(this).css("background", rgb((zscore / 3), "r"));
                        }
                    } else {
                        $(this).css("background-color", "#000");
                    }
                    if (min > 0) {
                        //$(this).css("background",rgb(zscore * threshold));
                    } else {
                        //$(this).css("background","white");
                    }
                });

            });
        }

        function recalculate(threshold) {
            var $rows = $("#tableOutput .attr");
            $rows.each(function () {
                var $row = $(this);
                var avg = parseInt($row.find("td.avg").text());
                $row.children("td.val").each(function () {
                    var v = parseInt($(this).text());
                    var per = 0;
                    if (v > avg) {
                        per = ((v - avg) * 100) / avg
                        console.log(per);
                    }
                    if (threshold > 0 && per >= threshold) {
                        $(this).css("background", "red")
                    } else {
                        $(this).css("background", "white")
                    }
                });

            });
        }

    </script>
    <style type="text/css">
        .active {
            border-style: solid;
            border-width: 2px;
            border-color: red;
        }
        body
        {
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



        #upleft {
            width: 99%;
            height: 100%;
            float: left;
            /*border-style: solid;
            border-width: 1px;
            border-right: solid;
            border-right-color: gray;*/
        }


        #below {
            height: 290px;
            width: 99%;
            /*border-style: solid;*/
            border-width: 1px;
            border-top: solid;
            border-top-color: gray;
            clear: both;
        }


       .ui-layout-resizer-east
       {
           right : 40% !important;
       }

       .table-header-rotated {
            border-collapse: collapse;
        }

        .csstransforms .table-header-rotated td {
            width: 30px;
        }

        .no-csstransforms .table-header-rotated th {
            padding: 5px 10px;
        }

        .table-header-rotated td {
            text-align: center;
            padding: 10px 5px;
            border: 1px solid #ccc;
        }

        .csstransforms .table-header-rotated th.rotate {
            height: 140px;
            white-space: nowrap;
        }

            .csstransforms .table-header-rotated th.rotate > div {
                -webkit-transform: translate(25px, 51px) rotate(315deg);
                -ms-transform: translate(25px, 51px) rotate(315deg);
                transform: translate(25px, 51px) rotate(315deg);
                width: 30px;
            }

                .csstransforms .table-header-rotated th.rotate > div > span {
                    border-bottom: 1px solid #ccc;
                    padding: 5px 10px;
                }

        .table-header-rotated th.row-header {
            padding: 0 10px;
            border-bottom: 1px solid #ccc;
            border-left: 1px solid #ccc;
        }


        #rainbow-slider {
            background: linear-gradient(to right, #00FF00 0,#FFFFFF 50%, #ff0000 100%) no-repeat;
            background-size: cover;
            border-radius: 30px;
            border: none;
            box-shadow: inset 0 0 0 1px rgba(0,0,0,.18);
            height: 10px;
        }

            #rainbow-slider.ui-slider-horizontal .ui-slider-range {
                background: transparent;
            }

            #rainbow-slider .ui-slider-handle {
                background: rgba(255, 255, 255, 0.21);
                border-color: rgba(0, 0, 0, 0.56);
                box-shadow: inset 0 0 2px 2px rgba(255, 255, 255, 0.89);
                border-radius: 20px;
                top: -8px;
            }

                #rainbow-slider .ui-slider-handle.ui-state-hover,
                #rainbow-slider .ui-slider-handle:hover,
                #rainbow-slider .ui-slider-handle.ui-state-focus,
                #rainbow-slider .ui-slider-handle:focus,
                #rainbow-slider .ui-slider-handle.ui-state-active {
                    background: rgba(255, 255, 255, 0.21);
                }

            #rainbow-slider .ui-slider-pip .ui-slider-label {
                width: 6em;
                margin-left: -3em;
            }

        #rainbow1-slider.ui-slider .ui-slider-range {
            background: linear-gradient(to right, #00FF00 0,#FFFFFF 50%, #ff0000 100%) no-repeat;
            border: 1px solid rgba(67, 77, 90, 0.5);
            top: -1px;
            transition: all 0.2s ease-out;
        }

        #rainbow-slider .ui-slider-pip .ui-slider-label {
            color: #000000;
        }


        #rainbow-slider .ui-slider-pip .ui-slider-line {
            top: 1px;
        }

        #rainbow-slider .ui-slider-pip:nth-of-type(odd) {
            top: auto;
            bottom: 32px;
        }

            #rainbow-slider .ui-slider-pip:nth-of-type(odd) .ui-slider-line {
                top: 21px;
            }

        #scale-slider.ui-slider {
            border-radius: 0px;
            background: #c7cdd5;
            border: none;
            height: 2px;
            margin: 1em 4em 4em;
        }

            #scale-slider.ui-slider .ui-slider-range {
                background: linear-gradient(to right, #434d5a 0%, #00c7d7 50%, #434d5a 100%) border: 1px solid rgba(67, 77, 90, 0.5);
                height: 4px;
                top: -1px;
                transition: all 0.2s ease-out;
            }

        #scale-slider .ui-slider-handle {
            border-radius: 2px;
            height: 20px;
            width: 12px;
            top: -26px;
            border: none;
        }

            #scale-slider .ui-slider-handle:nth-of-type(n+1) {
                transform: rotateZ(-10deg);
                margin-left: -9px;
            }

            #scale-slider .ui-slider-handle:nth-of-type(n+2) {
                transform: rotateZ(10deg);
                margin-left: -3px;
            }

            #scale-slider .ui-slider-handle:after {
                content: "";
                border: 6px solid transparent;
                width: 0;
                height: 0;
                position: absolute;
                bottom: -11px;
                border-top-color: #434d5a;
            }

            #scale-slider .ui-slider-handle.ui-slider-handle.ui-state-focus:after,
            #scale-slider .ui-slider-handle.ui-slider-handle.ui-state-hover:after,
            #scale-slider .ui-slider-handle.ui-slider-handle.ui-state-active:after {
                border-top-color: #00c7d7;
            }

        #scale-slider .ui-slider-pip {
            top: 2px;
        }

            #scale-slider .ui-slider-pip .ui-slider-label {
                display: none;
                background: rgba(67, 77, 90, 0);
                color: #434d5a;
                border-radius: 4px;
                padding: 0.3em 0;
                width: 2.4em;
                margin-left: -1.2em;
                transition: all 0.2s ease-out;
            }

            #scale-slider .ui-slider-pip .ui-slider-line {
                height: 4px;
            }

            #scale-slider .ui-slider-pip:nth-of-type(5n+3) .ui-slider-line {
                height: 8px;
            }

            #scale-slider .ui-slider-pip:nth-of-type(10n+3) .ui-slider-line {
                height: 12px;
            }

            #scale-slider .ui-slider-pip:nth-of-type(10n+3) .ui-slider-label {
                top: 16px;
                display: block;
            }

            #scale-slider .ui-slider-pip.ui-slider-pip-last .ui-slider-line {
                margin-left: -1px;
            }

            #scale-slider .ui-slider-pip.ui-slider-pip-selected .ui-slider-label,
            #scale-slider .ui-slider-pip.ui-slider-pip-selected-first .ui-slider-label,
            #scale-slider .ui-slider-pip.ui-slider-pip-selected-second .ui-slider-label {
                background: rgba(67, 77, 90, 0.7);
                color: #fffaf7;
            }


        /* End*/

        .ui-state-hover, .ui-state-focus {
            border: 0px;
        }


    </style>
<link href="Content/Styles/jquery-ui-slider-pips.css" rel="stylesheet" />
<link href="Content/Styles/jquery-ui.min.css" rel="stylesheet" />
    <style>
        #rainbow-slider {
            background: linear-gradient(to right, #00FF00 0, #FFFFFF 50%, #ff0000 100%) no-repeat;
            background-size: cover;
            border-radius: 30px;
            border:none;
            box-shadow: inset 0 0 0 1px rgba(0,0,0,.18);
            height:10px;
        }

        #rainbow-slider.ui-slider-horizontal .ui-slider-range{
            background: transparent;
        }

        #rainbow-slider .ui-slider-handle{
            background: rgba(255,255,255,0.21);
            border-color: rgba(0, 0, 0, 0.56);
            box-shadow: inset 0 0 2px 2px rgba(255, 255, 255, 0.89);
            border-radius: 20px;
            top: -8px;
        }

        #rainbow-slider .ui-slider-handle.ui-state-hover,
        #rainbow-slider .ui-slider-handle:hover,
        #rainbow-slider .ui-slider-handle.ui-state-focus,
        #rainbow-slider .ui-slider-handle:focus,
        #rainbow-slider .ui-slider-handle.ui-state-active{
            background: rgba(255,255,255,0.21);
        }


        #rainbow-slider .ui-slider-pip .ui-slider-label{
            width: 6em;
            margin-left: -3em;
        }

        #rainbow-slider .ui-slider-pip .ui-slider-label {
            color: #000000;
        }

        #rainbow-slider .ui-slider-pip .ui-slider-line {
            top: 1px;
        }

        #rainbow-slider .ui-slider-pip:nth-of-type(odd){
            top: auto;
            bottom: 32px;
        }

        #rainbow-slider .ui-slider-pip:nth-of-type(odd) .ui-slider-line{
            top: 21px;
        }




    </style>
</head>
<body>
    <form id="form1" runat="server">
         <div class="ui-layout-center leftpane">
        <div id="upleft">
            <div style="float:right">
                <a style="cursor:pointer; color: darkblue; text-decoration-line: underline" onclick="goback()">Back</a>
            </div>
            <div>
                <div id="rainbow-slider" style="margin: 30px auto 0px auto"></div>
                <table class="table table-header-rotated" style="margin: 57px auto 0px auto">
                    <thead>
                    <tr>
                        <th>Behaviour Attribute</th>
                        <th class="rotate"><div><span>Center Avg</span></div></th>
                        <th class="rotate"><div><span>Agent 1</span></div></th>
                        <th class="rotate"><div><span>Agent 2</span></div></th>
                        <th class="rotate"><div><span>Agent 3</span></div></th>
                        <th class="rotate"><div><span>Agent 4</span></div></th>
                        <th class="rotate"><div><span>Agent 5</span></div></th>
                        <th class="rotate"><div><span>Agent 6</span></div></th>
                        <th class="rotate"><div><span>Agent 7</span></div></th>
                        <th class="rotate"><div><span>Agent 8</span></div></th>
                        <th class="rotate"><div><span>Agent 9</span></div></th>
                        <th class="rotate"><div><span>Agent 10</span></div></th>
                        <th class="rotate"><div><span>Agent 11</span></div></th>
                        <th class="rotate"><div><span>Agent 12</span></div></th>
                    </tr>
                        </thead>
                    <tbody>
                        <tr class="attr" data-sd="171">
                            <th class="row-header"></th>
                            <th class="row-header">Total Calls</th>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="avg"></td>
                        </tr>
                         <tr class="attr" data-sd="171">
                            <th class="row-header"></th>
                            <th class="row-header"># Hold in Call > 2</th>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="avg"></td>
                        </tr>
                         <tr class="attr" data-sd="171">
                            <th class="row-header"></th>
                            <th class="row-header">ACS Rating < 5</th>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="avg"></td>
                        </tr>
                         <tr class="attr" data-sd="171">
                            <th class="row-header"></th>
                            <th class="row-header">Hold Duration > 3 mins</th>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="avg"></td>
                        </tr>
                         <tr class="attr" data-sd="171">
                            <th class="row-header"></th>
                            <th class="row-header">Silent Time > 3 mins</th>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="avg"></td>
                        </tr>
                         <tr class="attr" data-sd="171">
                            <th class="row-header"></th>
                            <th class="row-header">Cross talk time > 0 Calls</th>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="avg"></td>
                        </tr>
                         
                        <tr class="attr" data-sd="171">
                            <th rowspan="2" class="row-header">Speech Analytics</th>
                            <th class="row-header">Escated to Supervisor</th>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="avg"></td>
                        </tr>
                        <tr class="attr" data-sd="171">
                            <th class="row-header">Negative Attitude</th>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="avg"></td>
                        </tr>
                        <tr class="attr" data-sd="171">
                            <th></th>
                            <th class="row-header">FiOS TV Close Rate</th>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="val"></td>
                            <td class="avg"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        
    </div>
    <div class="ui-layout-north topheader">Call Center Gamfication

        <div style="float:right; color: yellow" id="divSupName"></div>
        <div style="float:right">Supervisor Name: &nbsp;&nbsp; </div>
    </div>
    
    

    </form>
</body>
</html>