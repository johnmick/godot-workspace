// var trace1 = {
//   x: [1, 2, 3, 4],
//   y: [10, 15, 13, 17],
//   type: 'scatter'
// };
// 
// var trace2 = {
//   x: [1, 2, 3, 4],
//   y: [16, 5, 11, 9],
//   type: 'scatter'
// };
// 
// var data = [trace1, trace2];
// 
// Plotly.plot('graph', data);

// connect to websocket
var ws = new WebSocket('ws://' + location.host + '/ws');

// when a new message has been received
var plot_ref       = document.getElementById("graph");
var position_x     = [];
var position_y     = [];
var velocity_x     = [];
var velocity_y     = [];
var acceleration_x = [];
var acceleration_y = [];
var time           = [];

var msgs_since_update = 0;
var plot_update_msg_rate = 50;
ws.onmessage = function(event){
   msgs_since_update += 1;
   var data = JSON.parse(event.data);
   time.push(data.time);
   position_x.push(data.position_x);
   position_y.push(data.position_y);
   velocity_x.push(data.velocity_x);
   velocity_y.push(data.velocity_y);
   acceleration_x.push(data.acceleration_x);
   acceleration_y.push(data.acceleration_y);

   if (time.length > 2000) {
     position_x.shift();
     position_y.shift();
     velocity_x.shift();
     velocity_y.shift();
     acceleration_x.shift();
     acceleration_y.shift();
     time.shift();
   }

	 if (msgs_since_update >= plot_update_msg_rate) {
     msgs_since_update = 0;
		 Plotly.newPlot(plot_ref, [
				{
					 x: time,
					 y: acceleration_x,
					 type: "scatter",
           name: "x acceleration",
           showlegend: true,
					 xaxis: "x", yaxis: "y"
				},
				{
					 x: time,
					 y: acceleration_y,
					 type: "scatter",
           showlegend: true,
           name: "y acceleration",
					 xaxis: "x2", yaxis: "y2"
				},
				{
					 x: time,
					 y: velocity_x,
					 type: "scatter",
           name: "x velocity",
           showlegend: true,
					 xaxis: "x3", yaxis: "y3"
				},
				{
					 x: time,
					 y: velocity_y,
					 type: "scatter",
           showlegend: true,
           name: "y velocity",
					 xaxis: "x4", yaxis: "y4"
				},
				{
					 x: time,
					 y: position_x,
					 type: "scatter",
           name: "x position",
           showlegend: true,
					 xaxis: "x5", yaxis: "y5"
				},
				{
					 x: time,
					 y: position_y,
					 type: "scatter",
           showlegend: true,
           name: "y position",
					 xaxis: "x6", yaxis: "y6"
				}
			],
				{
					grid: {
						rows: 3, columns: 2, pattern: 'independent'
},
				}
      );
	 }



}
