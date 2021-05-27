// TODO: Add prettier on save to project.


var app = Elm.Main.init({
    node: document.getElementById("elm"),
    flags: {
        clientId1: "Testie"
    }
});


const COUNTER = "COUNTER";


if(localStorage.getItem(COUNTER)) {
    localStorage.setItem(COUNTER, "9876");
}


app.ports.sendCounter.subscribe((message) => {
    localStorage.setItem(COUNTER, message);
});


// window.addEventListener('storage', (event) => {
console.log(JSON.parse(localStorage.getItem(COUNTER)));
app.ports.receiveCounter.send(localStorage.getItem(COUNTER));
// });