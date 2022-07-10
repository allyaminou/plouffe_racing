const translateVehicle = {
    boat: 'Bateau',
    automobile: 'Voiture',
    bike: 'Moto',
    plane: 'Avion'
}

var visibles = {}

var CreatorActive = false;
var RaceActive = false;
var tabActive = false;

var lastRaceClicked = 0
var boostClicked = 0
var cachedBoosts = {}

var miniGameData = {}
var refreshing = false

$(document).ready(function(){
    window.addEventListener('message', function(event){   
        let data = event.data

        if (data.type == "tab") {
            UpdateTab(data)
        } else if (data.type == "creator") {
            UpdateCreator(data)
        } else if (data.type == "race") {
            UpdateRaceUi(data)
        } else if (data.type == "updateBestTime") {
            SetNewBestTime(data);
        } else if (data.type === "hacking") {
            if (data.new) {
                NewMiniGame(data);
            } else if (data.cancel) {
                CloseMiniGame()
            } else if (data.time) {
                document.getElementById(`hacking-timer`).innerHTML = data.time;
            }
        } else if (data.type === "wanted") {
            if (data.remove) {
                RemoveWanted(data.remove);
            }
        };
    });

    document.onkeyup = function (data) {
        if (data.which == 27) {
            Close()
        }
    };
});

async function showOrHide(elem, time) {
    if (visibles[elem]) {
        $(elem).fadeOut(time || 500);
        visibles[elem] = null;
        return true;
    };

    $(elem).fadeIn(time || 500);
    visibles[elem] = true;
    return false;
};

async function show(elem, time) {
    $(elem).fadeIn(time || 500);
    visibles[elem] = true;
    return false;
};

async function hide(elem, time) {
    $(elem).fadeOut(time || 500);
    visibles[elem] = null;
    return true;
};

async function hideAll(){
    Object.keys(visibles).forEach(key => {
        $(key).fadeOut(500);
    });

    visibles = {};

    ClearBoosts()
    return true
};

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function UpdateCreator(data) {
    if (data.active === false) {
        return $(".creator-ui").fadeOut(1000);
    } else if (data.active === true) {
        $(".creator-ui").fadeIn(1000);
    };
    
    if (data.name) {
        $("#editor-racename").html(data.name);
    };

    if (data.checkpoints) {
        $("#editor-checkpoints").html(data.checkpoints);
    };

    if (data.checkpoints) {
        $("#editor-tiredistance").html(data.tireDistance);
    };

    if (data.checkpoints) {
        $("#editor-tiredistance").html(data.tireDistance);
    };
};

function UpdateRaceUi(data) {
    if (data.active === false) {
        return hide(".racing-ui", 1000);
    } else if (data.active === true) {
        show(".racing-ui", 1000);
    };
    
    if (data.name) {
        $("#race-racename").html(data.name);
    };

    if (data.position) {
        $("#race-position").html(data.position);
    };

    if (data.position) {
        $("#race-position").html(data.position);
    };

    if (data.currentCheckpoint) {
        $("#race-checkpoints").html(data.currentCheckpoint + '/' + data.totalCheckpoints);
    };
    
    if (data.currentLap) {
        $("#race-lap").html(data.currentLap + '/' + data.totalLaps);
    };

    if (data.time) {
        $("#race-time").html(data.time);
    };

    if (data.bestLap) {
        $("#race-besttime").html(data.bestLap);
    };

    if (data.totalTime) {
        $("#race-totaltime").html(data.totalTime);
    };            
};

function UpdateTab(data) {
    let tab = document.getElementById("tablet");

    if (data.addActive) {
        CreateActiveRace(data.addActive)
    } else if (data.removeActive) {
        RemoveActiveRace(data.removeActive)
    };

    if (data.profile) {
        document.getElementById(`top-bar-profile`).innerHTML = `<b>Nom:</b> ${data.profile?.name || 'Aucun'} <b>Rp:</b> ${data.profile?.rp || "0"}`;
    };

    if (data.show) {
        $(".tablet").fadeIn(1000);
    } else if (data.show == false) {
        Close()
    };
};

function Close() {
    $(".tablet").fadeOut(1000);
    $.post('https://plouffe_racing/close');
};

function OnProfile() {
    showOrHide('.input-racer-name')
};

async function ConfirmRacerName() {
    let input = document.getElementById("racer-name-input").value;
    if (input.length < 3 ) return;

    let profile = await new Promise((resolve, reject) => {$.post('https://plouffe_racing/setRacerName', JSON.stringify({name: input}), resolve)});
    if (!profile) return;
    
    hide('.input-racer-name')

    document.getElementById(`top-bar-profile`).innerHTML = `<b>Nom:</b> ${profile?.name || 'Aucun'} <b>Rp:</b> ${profile?.rp || "0"}`;
};

function RemoveWanted(id) {
    let element = document.getElementById(`wanted_${id}`);
    if (element) element.remove();
}

function CloseWanted() {
    hide('.app-wanted')
}

async function ShowWantedList() {
    let data = await new Promise((resolve, reject) => {$.post('https://plouffe_racing/getActiveWanteds', JSON.stringify({}), resolve)});
    show('.app-wanted')
    for (let i = 0; i < data.length; i++) {
        CreateWantedData(data[i]);
    };
};

function CreateWantedData(data) {
    let element = document.getElementById(`wanted_${data.id}`);
    if (element) element.remove();

    let $content = ''
        $content += (`<div><b> Model:</b> ${data.label} </div>`);
        $content += (`<div><b> Valeur:</b> ${data.value} RP</div>`);

    let $class = $(document.createElement('div'));
        $class.addClass('app-wanted-info');
        $class.attr('id', `wanted_${data.id}`);
        $class.html($content);

    $('.app-wanted-container').prepend($class);
};

async function RefreshBoostList() {
    if (refreshing) return;
    refreshing = true
    hide(".app-boost-confirm-container", 1000);
    boostClicked = 0;

    document.getElementById(`app-boost-refresh-container`).style.display = "none";
    document.getElementById(`app-boost-refresh-text`).innerHTML = "5";

    let data = await new Promise((resolve, reject) => {$.post('https://plouffe_racing/refreshBoosts', JSON.stringify({}), resolve)});

    for await (const [key, value] of Object.entries(cachedBoosts)) {
        hide(`.boost_${cachedBoosts[key].id}`)
        await sleep(250);
        let element = document.getElementById(`boost_${cachedBoosts[key].id}`);
        if (element) element.remove();
    }

    for await (const [key, value] of Object.entries(data)) {
        await sleep(500);
        CreatBoostData(data[key]);
    }
    
    document.getElementById(`app-boost-refresh-container`).style.display = "flex";
    
    for (let i = 0; i < 10; i++) {
        document.getElementById(`app-boost-refresh-text`).innerHTML = (10 - i);
        await sleep(1000);
    };

    document.getElementById(`app-boost-refresh-text`).innerHTML = "Rafraishir";
    refreshing = false;
}

async function OnBoost() {
    refreshing = true;
    hideAll();

    let data = await new Promise((resolve, reject) => {$.post('https://plouffe_racing/getBoosts', JSON.stringify({}), resolve)});

    show(".app-boost", 1000);

    cachedBoosts = data;

    for await (const [key, value] of Object.entries(data)) {
        await sleep(500);
        CreatBoostData(data[key]);
    }

    refreshing = false;
};

function CreatBoostData(data) {
    let $content = ''
        $content += (`<div><b> Classe:</b> ${data.class} </div>`);
        $content += (`<div><b> Model:</b> ${data.label} </div>`);
        $content += (`<div><b> Prix du boost:</b> ${data.boostPrice} RP</div>`);
        $content += (`<div><b> Prix du scratch:</b> ${data.scratchPrice} RP</div>`);
        $content += (`<div><b> Valeur:</b> ${data.value} RP</div>`);

    let $info = $(document.createElement('div'));
        $info.addClass('app-boost-info');
        $info.html($content);

    let $class = $(document.createElement('div'));
        $class.addClass('app-boost-info-container');
        $class.html(`<div class="app-boost-huge-letter"> ${data.class} </div>`);
        $class.attr('id', `boost_${data.id}`);
        $class.prepend($info);

    $('.app-boost-container').prepend($class);

    document.getElementById(`boost_${data.id}`).onclick = function() {
        if (boostClicked == data.id) {
            let element = document.getElementById(`boost_${boostClicked}`);
            if (element) element.classList.remove('app-boost-clicked-boost');
            hide(".app-boost-confirm-container", 1000);
            boostClicked = 0
            return
        };

        if (boostClicked != 0) {
            let element = document.getElementById(`boost_${boostClicked}`);
            if (element) element.classList.remove('app-boost-clicked-boost');
        };

        $class.addClass('app-boost-clicked-boost');
        boostClicked = data.id;

        show(".app-boost-confirm-container", 1000);
    };
};

function ClearBoosts() {
    Object.keys(cachedBoosts).forEach(key => {
        let element = document.getElementById(`boost_${cachedBoosts[key].id}`);
        if (element) element.remove();
    });
    boostClicked = 0;
};

function CloseBoost() {
    ClearBoosts();
    hide(".app-boost", 500);
};

function StartBoost() {
    if (boostClicked === 0) return;
    $.post('https://plouffe_racing/startBoost', JSON.stringify({id: boostClicked}), function(isStarted) {
        if (!isStarted) return;
        let element = document.getElementById(`boost_${boostClicked}`);
        if (element) element.remove();
    })
};

function StartScratch() {
    if (boostClicked === 0) return;
    $.post('https://plouffe_racing/startScratch', JSON.stringify({id: boostClicked}), function(isStarted) {
        if (!isStarted) return;
        let element = document.getElementById(`boost_${boostClicked}`);
        if (element) element.remove();
    })
};

function SetBoostGps() {
    $.post('https://plouffe_racing/setBoostGps', JSON.stringify({}))
    close();
}

function OnRaceMenu() {
    let wasVisible = visibles['.races-main-menu'] === true;
    
    hideAll();

    if (wasVisible) {
        return;
    };

    show('.races-main-menu', 1000)
};

function OnLeaveRace() {
    hide('.races-main-menu', 1000)
    $.post('https://plouffe_racing/leaveRace')
};

function OnCreator() {
    hide('.races-main-menu', 1000)
    showOrHide('.creator-name');
};

function OpenCreator() {
    hide('.creator-name')
    let input = document.getElementById("creator-name-input").value;

    $.post('https://plouffe_racing/raceCreator',JSON.stringify({
        name: input
    }))

    Close();
};

function OnRace() {
    hide('.races-main-menu', 1000)
    if (showOrHide('.races-list', 1000) === true) return hide('.races-start-menu', 1000);
    hide('.races-start-menu', 1000);

    $.post('https://plouffe_racing/getRaces', JSON.stringify({}), function(races){
        for (let i = 0; i < races.length; i++) {
            CreateRace(races[i])
        }
    })
};

function OnJoinRace() {
    hide('.races-main-menu', 1000)
    show('.active-races-list');
};

function CreateActiveRace(data) {
    let $element = $(document.createElement('div'));
    let $content = (`<div class="race-style"><b> Nom: </b> ${data.name} </div>`);
    $content += (`<div class="race-style"><b> Vehicule: </b> ${translateVehicle[data.vehicle]} </div>`);
    $content += (`<div class="race-style"><b> Laps: </b> ${data.laps} </div>`);
    $content += (`<div class="race-style"><b> Checkpoints: </b> ${data.checkpoints.length} </div>`);
    $content += (`<div class="race-style"><b> Pénalité: </b> ${data.penality} </div>`);
    $content += (`<div class="race-style"><b> Type: </b> ${data.type} </div>`);
    $content += (`<div class="race-style"><b> Phasing: </b> ${data.phasing} </div>`);

    $element.addClass('race-container');
    $element.attr('id', `active_race_${data.id}`);

    $element.html($content);
    $element.fadeIn();

    $('.active-races-list').prepend($element);

    document.getElementById(`active_race_${data.id}`).onclick = function() {JoinRace(data.id)};
};

function CreateRace(data) {
    let element = document.getElementById("race_"+data.id)
    if (element) return;

    let $element = $(document.createElement('div'));

    let $content = (`<div class="race-style"><b> Nom: </b> ${data.name} </div>`);
    $content += (`<div class="race-style"><b> Vehicule: </b> ${translateVehicle[data.vehicle]} </div>`);
    $content += (`<div class="race-style"><b> Checkpoints: </b> ${data.checkpoints.length} </div>`);
    $content += (`<div id="race_best_time_${data.id}" class="race-style"><b> Meilleur temp: </b> ${data.bestTime?.timeString || 'n/a'} </div>`);
    $content += (`<div id="race_best_name_${data.id}" class="race-style"><b> Réussi par: </b> ${ data.bestTime?.name || 'n/a'} </div>`);

    $element.addClass('race-container');
    $element.attr('id', `race_${data.id}`);

    $element.html($content);
    $element.fadeIn();

    $('.races-list').prepend($element);
    document.getElementById(`race_${data.id}`).onclick = function() {OnRaceClick(data.id)};
};

function SetNewBestTime(data) {
    let time = document.getElementById(`race_best_time_${data.id}`);
    let name = document.getElementById(`race_best_name_${data.id}`);

    time.innerHTML = `<b> Meilleur temp: </b> ${data.timeString}`;
    name.innerHTML = `<b> Réussi par: </b> ${data.name}`;
};

function OnRaceClick(id) {
    lastRaceClicked = id

    hide('.races-list', 1000);
    show('.races-start-menu', 1000);
};

function RacingGoBack() {
    show('.races-list', 1000);
    hide('.races-start-menu', 1000);
};

function StartRace() {
    let laps = document.getElementById("race-options-laps-input").value;
    let type = document.getElementById("race-options-type-input").value;
    let penality = document.getElementById("race-options-penality-input").value;
    let startDelay = document.getElementById("race-options-startDelay-input").value;
    let phasing = document.getElementById("race-options-phasing-checkbox").checked;

    hideAll()

    $.post('https://plouffe_racing/startRace', JSON.stringify({
        id: lastRaceClicked,
        laps: laps,
        type: type,
        penality: penality,
        startDelay: startDelay,
        phasing: phasing
    }), function(valid){
        if (valid) OnJoinRace();
    })

};

function RemoveActiveRace(id) {
    let element = document.getElementById(`active_race_${id}`)
    if (element) element.remove();
};

function CreateActiveRace(data) {
    let $element = $(document.createElement('div'));
    let $content = (`<div class="race-style"><b> Nom: </b> ${data.name} </div>`);
    $content += (`<div class="race-style"><b> Vehicule: </b> ${translateVehicle[data.vehicle]} </div>`);
    $content += (`<div class="race-style"><b> Laps: </b> ${data.laps} </div>`);
    $content += (`<div class="race-style"><b> Checkpoints: </b> ${data.checkpoints.length} </div>`);
    $content += (`<div class="race-style"><b> Pénalité: </b> ${data.penality} </div>`);
    $content += (`<div class="race-style"><b> Type: </b> ${data.type} </div>`);
    $content += (`<div class="race-style"><b> Phasing: </b> ${data.phasing} </div>`);

    $element.addClass('race-container');
    $element.attr('id', `active_race_${data.id}`);

    $element.html($content);
    $element.fadeIn();

    $('.active-races-list').prepend($element);

    document.getElementById(`active_race_${data.id}`).onclick = function() {JoinRace(data.id)};
};

function JoinRace(id) {
    $.post('https://plouffe_racing/joinRace', JSON.stringify({
        id: id,
    }))

    hideAll()
    Close()
};

function shuffle(originalArray) {
    var array = [].concat(originalArray);
    var currentIndex = array.length, temporaryValue, randomIndex;

    while (0 !== currentIndex) {
        randomIndex = Math.floor(Math.random() * currentIndex);
        currentIndex -= 1;

        temporaryValue = array[currentIndex];
        array[currentIndex] = array[randomIndex];
        array[randomIndex] = temporaryValue;
    }
  
    return array;
};

function CloseMiniGame() {
    miniGameData = null
    document.getElementById(`hacking-container`).style.display = "none";
    document.getElementById(`hacking-container`).style.opacity = 0
    $.post('https://plouffe_racing/minigameClose');
}

async function NewMiniGame(data) {
    let opacity = 0;
    miniGameData = data;
    
    data.possibilities = shuffle(data.possibilities);
    
    for (let i = 0; i < data.possibilities.length; i++) {
        let element = document.getElementById(`hacking_${i}`);
        if (element) element.remove();
        let $element = $(document.createElement('div'));
        $element.addClass('hacking-combinaison');
        $element.attr('id', `hacking_${i}`);
        $element.html(data.possibilities[i]);
        $element.fadeIn();
        $('.hacking-combinaison-container').prepend($element);
        document.getElementById(`hacking_${i}`).onclick = function() {MiniGameClicked(data.possibilities[i])};
    }

    document.getElementById(`hacking-solution`).innerHTML = data.solution;
    document.getElementById(`hacking-timer`).innerHTML = data.time;
    document.getElementById(`hacking-container`).style.display = "flex";

    while (opacity < 1) {
        opacity += 0.1;
        await sleep(100);
        document.getElementById(`hacking-container`).style.opacity = opacity;
    };
    
    await sleep(500);
    ShuffleMinigame(data.possibilities, data.update);
}

function MiniGameClicked(id) {
    $.post('https://plouffe_racing/minigameClicked', JSON.stringify({clicked: id}));
    miniGameData = null;
    document.getElementById(`hacking-container`).style.display = "none";
    document.getElementById(`hacking-container`).style.opacity = 0
}

async function ShuffleMinigame(data, update) {
    var tempUpdate = 0

    while (miniGameData != null) {
        tempUpdate -= 1
            
        if (tempUpdate <= 0) {
            tempUpdate = update

            data = shuffle(data);

            for (let i = 0; i < data.length; i++) {
                var element = document.getElementById(`hacking_${i}`);

                if (element) {
                    element.remove();
                };

                await sleep(100);
                
                var $element = $(document.createElement('div'));
        
                $element.addClass('hacking-combinaison');
                $element.attr('id', `hacking_${i}`);
        
                $element.html(data[i]);
                $element.fadeIn();
        
                $('.hacking-combinaison-container').prepend($element);
        
                document.getElementById(`hacking_${i}`).onclick = function() {MiniGameClicked(data[i])};
            };
        } 

        await sleep(1000);
    };

    for (let i = 0; i < data.length; i++) {
        var element = document.getElementById(`hacking_${i}`)
        if (element) {
            element.remove();
        };
    };
};