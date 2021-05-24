// TODO: Add prettier on save to project.

const COUNTER = "COUNTER";


var app = Elm.Main.init({
    node: document.getElementById("elm")
});


app.ports.sendCounter.subscribe((message) => {
    localStorage.setItem(COUNTER, message);
});
// localStorage.setItem(COUNTER, 0);


// window.addEventListener('storage', (event) => {
console.log(JSON.parse(localStorage.getItem(COUNTER)));
app.ports.receiveCounter.send(localStorage.getItem(COUNTER))
// });