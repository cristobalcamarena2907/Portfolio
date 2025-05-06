
const getAllTools = async () => {
    const response = await fetch('http://localhost:3000/tools');

    if(response.ok){
        const jsonResponse = await response.json();
        return jsonResponse;

    }
    throw new Error('Request failed!');
};

const getAllM_STools = async () => {
    const response = await fetch('http://localhost:3000/m&sTools');

    if(response.ok){
        const jsonResponse = await response.json();
        return jsonResponse;

    }
    throw new Error('Request failed!');
};

const getAllCodeTools = async () => {
    const response = await fetch('http://localhost:3000/codeTools');

    if(response.ok){
        const jsonResponse = await response.json();
        return jsonResponse;

    }
    throw new Error('Request failed!');
};

const getAllSpeechTools = async () => {
    const response = await fetch('http://localhost:3000/speech&moreTools');

    if(response.ok){
        const jsonResponse = await response.json();
        return jsonResponse;

    }
    throw new Error('Request failed!');
};

const getAllGameTools = async () => {
    const response = await fetch('http://localhost:3000/game&VrTools');

    if(response.ok){
        const jsonResponse = await response.json();
        return jsonResponse;

    }
    throw new Error('Request failed!');
};

const getAllImageTools = async () => {
    const response = await fetch('http://localhost:3000/imageTools');

    if(response.ok){
        const jsonResponse = await response.json();
        return jsonResponse;

    }
    throw new Error('Request failed!');
};

const getAllD_STools = async () => {
    const response = await fetch('http://localhost:3000/d&sTools');

    if(response.ok){
        const jsonResponse = await response.json();
        return jsonResponse;

    }
    throw new Error('Request failed!');
};

const getAllVecDBTools = async () => {
    const response = await fetch('http://localhost:3000/vecDbTools');

    if(response.ok){
        const jsonResponse = await response.json();
        return jsonResponse;

    }
    throw new Error('Request failed!');
};

const getAllVideoTools = async () => {
    const response = await fetch('http://localhost:3000/videoTools');

    if(response.ok){
        const jsonResponse = await response.json();
        return jsonResponse;

    }
    throw new Error('Request failed!');
};

export {
    getAllTools,
};
