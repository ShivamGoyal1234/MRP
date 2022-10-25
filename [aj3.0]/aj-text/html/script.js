let direction = null;

const drawText = async (textData,r,g,b,aa,type,top) => {
    const t = type
    const text = document.getElementById("text"+t);
    let {position} = textData;
    switch (textData.position) {
        case "left":
            addClass(text, position);
            direction = "left";
            break;
        case "top":
            addClass(text, position);
            direction = "top";
            break;
        case "right":
            addClass(text, position);
            direction = "right";
            break;
        default:
            addClass(text, "left");
            direction = "left";
            break;
    }

    text.innerHTML = textData.text;
    document.getElementById("container"+t).style.display = "block";
    document.getElementById("text"+t).style.background = 'rgba('+[r,g,b,aa].join(',')+')';
    document.getElementById("text"+t).style.top = top+'%';
    await sleep(100);
    addClass(text, "show");

};

const changeText = async (textData,r,g,b,aa,type,top) => {
    const t = type
    const text = document.getElementById("text"+t);
    let {position} = textData;

    // removeClass(text, "show");
    // addClass(text, "pressed");
    // addClass(text, "hide");

    await sleep(500);
    // removeClass(text, "left");
    // removeClass(text, "right");
    // removeClass(text, "top");
    // removeClass(text, "bottom");
    // removeClass(text, "hide");
    // removeClass(text, "pressed");

    switch (textData.position) {
        case "left":
            addClass(text, position);
            direction = "left";
            break;
        case "top":
            addClass(text, position);
            direction = "top";
            break;
        case "right":
            addClass(text, position);
            direction = "right";
            break;
        default:
            addClass(text, "left");
            direction = "left";
            break;
    }
    document.getElementById("text"+t).style.background = 'rgba('+[r,g,b,aa].join(',')+')';
    document.getElementById("text"+t).style.top = top+'%';
    text.innerHTML = textData.text;

    await sleep(100);
    text.classList.add("show");
};

const hideText = async (type) => {
    const t = type
    const text = document.getElementById("text"+t);
    removeClass(text, "show");
    addClass(text, "hide");
    setTimeout(() => {
        removeClass(text, "left");
        removeClass(text, "right");
        removeClass(text, "top");
        removeClass(text, "bottom");
        removeClass(text, "hide");
        removeClass(text, "pressed");
        document.getElementById("container"+t).style.display = "none";
    }, 1000);
};

const keyPressed = async () => {
    const text = document.getElementById("text");
    addClass(text, "pressed");
    await sleep(500);
    removeClass(text, "pressed");
};

window.addEventListener("message", (event) => {
    const data = event.data;
    const action = data.action;
    const textData = data.data;
    const r = data.r
    const g = data.g
    const b = data.b
    const a = data.a
    const top = data.top
    switch (action) {
        case "DRAW_TEXT":
            const type = data.type
            return drawText(textData,r,g,b,a,type,top);
        case "CHANGE_TEXT":
            const type3 = data.type
            return changeText(textData,r,g,b,a,type3,top);
        case "HIDE_TEXT":
            const type2 = data.type
            return hideText(type2);
        case "KEY_PRESSED":
            return keyPressed();
        default:
            return;
    }
});

const sleep = (ms) => {
    return new Promise((resolve) => setTimeout(resolve, ms));
};

const removeClass = (element, name) => {
    if (element.classList.contains(name)) {
        element.classList.remove(name);
    }
};

const addClass = (element, name) => {
    if (!element.classList.contains(name)) {
        element.classList.add(name);
    }
};
