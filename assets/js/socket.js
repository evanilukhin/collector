import {Socket} from "phoenix"
let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()
let channel = socket.channel("herd_of_gophers:lobby", {})

var ctx = $('.herd_of_gophers')[0].getContext('2d')
var chart = new Chart(ctx, {
    // The type of chart we want to create
    type: 'line',

    // The data for our dataset
    data: {
        labels: [],
        datasets: [{
            label: "Herd Of Gophers",
            borderColor: 'rgb(255, 99, 132)',
            data: [],
        }]
    },

    // Configuration options go here
    options: {}
});

channel.on("update_graph", payload => {
  let x_labels = payload.body.map(x => x.item)
  let values = payload.body.map(x => x.created_to_bus)
  chart.data.labels = x_labels
  chart.data.datasets[0].data = values
  chart.update()
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
