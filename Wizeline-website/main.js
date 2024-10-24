import { getAllTools } from './functions.js';


var data_V1 = [{
    "Program": "Text",
    "Percentage": 50,
    "Description": "AI models like GPT use data to generate convincing human-like text in various fields, from narrative to customer service and programming.",
    "Elements": ["PalM2", "Chirp", "AutoML", "Natural Language AI", "Speech-To-Text", "Translation AI", "Dialogflow", "Amazon Comprehend", "Amazon Kendra", "Amazon Textract", "Amazon Bedrock", "Amazon CodeWhisperer", "Azure AI Document Intelligence", "Azure Machine Learning", "Azure Cognitive Search", "Azure AI Bot Service", "Azure Databricks", "Azure OpenAI Service", "Quillbot", "Jenni", "LlamaIndex", "Octane", "Quickchat AI", "Quizgecko", "Quotify AI", "Perplexity.ai"]
}, {
    "Program": "Image",
    "Percentage": 50,
    "Description": "AI-driven image generation has transformed visuals by creating realistic and diverse images in various styles and themes using deep learning. Despite ethical concerns, AI-generated images inspire creativity, streamline design, and assist in scientific exploration, heralding a new era of visual innovation.",
    "Elements": ["Imagen", "Vision AI", "Amazon Rekognition", "Google Gemini"]
}, {
    "Program": "Data Simulation",
    "Percentage": 50,
    "Description": "AI-driven data simulation creates synthetic datasets that accurately mimic real-world scenarios, aiding research and development while addressing privacy concerns associated with real data.",
    "Elements": ["Amazon SageMaker", "AutoML", "Azure Databricks", "Azure Machine Learning", "Octane", "Vertex AI", "Vertex AI Workbench"]
}, {
    "Program": "Code Generator Review",
    "Percentage": 50,
    "Description": "AI Code Generator: revolutionizes software development with the rapid and customized creation of code using deep learning. The easy-to-use interface caters to all skill levels, allowing for rapid prototyping. It learns from vast code repositories for efficient solutions, saving time and effort.",
    "Elements": ["Vertex AI", "Codey", "Vertex AI Workbench", "Amazon SageMaker"]
}, {
    "Program": "Music & Sound",
    "Percentage": 50,
    "Description": "Artificial intelligence is reshaping musical and sound creation, allowing artists to design new melodies and rhythms by analyzing musical data. This sparks creativity and offers immersive audio experiences for various applications such as video games and cinema.",
    "Elements": ["Text-To-Speech", "Amazon Lex", "Krisp"]
}, {
    "Program": "Video",
    "Percentage": 50,
    "Description": "AI-driven video generation transforms storytelling with deep learning, creating dynamic sequences efficiently and captivating the audience effectively.",
    "Elements": ["Video AI", "Amazon Polly", "Synesthesia"]
}, {
    "Program": "Game & VR",
    "Percentage": 50,
    "Description": "Artificial intelligence in games and virtual reality create immersive experiences through advanced algorithms, realistic environments, and adaptive gameplay.",
    "Elements": ["Azure Kinect DK"]
}, {
    "Program": "Vector Database",
    "Percentage": 50,
    "Description": "AI-driven vector databases transform data storage and access, being essential in areas such as image recognition and language processing, streamlining analysis and extraction of valuable information.",
    "Elements": ["Chirp", "Imagen", "LlamaIndex", "PalM2", "Perplexity.ai", "Quotify AI", "Synesthesia"]
}, {
    "Program": "Text, Image & More",
    "Percentage": 50,
    "Description": "Artificial intelligence platforms revolutionize content creation by integrating text, images, video, and more. They automate tasks, optimize workflows, and foster innovation in various industries, offering comprehensive tools for communication and decision-making.",
    "Elements": ["AI Infrastructure", "Amazon EC2 Trn1", "Amazon EC2 Inf2", "Azure AI Services"]
}];

const elementData1 = await getAllTools();

console.log(elementData1);

var width = parseInt(d3.select('#pieChart').style('width'), 10);
var height = width;
var radius = (Math.min(width, height) - 15) / 2;

var type = function getObject(obj) {
    let types = [];
    for (var i = 0; i < obj.length; i++) {
        types.push(obj[i].Program);
    }
    return types;
};
var arcOver = d3.svg.arc()
    .outerRadius(radius + 10)
    .innerRadius(150);

var color = d3.scale.ordinal()
    .domain(type(data_V1))
    .range(["#7400b8", "#6930c3", "#5e60ce", "#5390d9", "#4ea8de", "#48bfe3", "#56cfe1", "#64dfdf", "#4cc9f0"]);



var arc = d3.svg.arc()
    .outerRadius(radius - 10)
    .innerRadius(150);

var pie = d3.layout.pie()
    .sort(null)
    .value(function(d) {
        return +d.Percentage;
    });

const change = function(d, i) {
    var angle = 90 - ((d.startAngle * (180 / Math.PI)) + ((d.endAngle - d.startAngle) * (180 / Math.PI) / 2))
    svg.transition()
    .duration(1000)
    .attr("transform", "translate(" + radius + "," + height / 2 + ") rotate(" + angle + ")")
    d3.selectAll("path")
    .transition()
    .attr("d", arc)
    d3.select(i)
    .transition()
    .duration(1000)
    .attr("d", arcOver)
};

var labelArc = d3.svg.arc()
    .outerRadius(radius - 40)
    .innerRadius(150);

var svg = d3.select("#pieChart").append("svg")
    .attr("width", '100%')
    .attr("height", '100%')
    .attr('viewBox', '0 0 ' + Math.min(width, height) + ' ' + Math.min(width, height))
    .attr('preserveAspectRatio', 'xMinYMin')
    .append("g")
    .attr("transform", "translate(" + radius + "," + height / 2 + ")");

// Crea los segmentos de la dona
var g = svg.selectAll("path")
    .data(pie(data_V1))
    .enter().append("path")
    .style("fill", function(d) {
        return color(d.data.Program);
    })
    .attr("d", arc)
    .style("fill", function(d) {
        return color(d.data.Program);
    })
    .on("click", function(d) {
    change(d, this);
    $('.text-container').hide();
    $('#segmentTitle').replaceWith('<h1 id="segmentTitle">' + d.data.Program + '</h1>');
    $('#segmentText').replaceWith('<p id="segmentText">' + d.data.Description + '</p>');
    
    // Crea un elemento de texto para cada elemento en la lista
    var elementsHtml = d.data.Elements.map(function(element) {
        return '<span class="element element-button" style="cursor: pointer;">' + element + '</span>';
    }).join(' ');
    $('#segmentElements').replaceWith('<p id="segmentElements">' + elementsHtml + '</p>');
    
    $('.text-container').fadeIn(400);
    
    // Agrega la clase 'hidden' a elementTitle, elementDescription, elementImage, elementWebsite y elementVideo
    $('#elementTitle').addClass('hidden');
    $('#elementDescription').addClass('hidden');
    $('#elementImage').addClass('hidden');
    $('#elementWebsite').addClass('hidden');
    $('#elementVideo').addClass('hidden');
    $('.card').addClass('hidden');

    // Agrega un controlador de eventos de clic a cada elemento
    $('.element').on('click', function() {
        var element = $(this).text();
        //console.log(elementData2);
        //console.log(element);
        var elementInfo = elementData1.find(function(info) {
            return info.toolName.trim() === element;
        });
        $('#elementTitle').replaceWith('<h2 id="elementTitle">' + element + '</h2>');
        console.log(elementInfo);
        $('#elementDescription').replaceWith('<p id="elementDescription">' + elementInfo.toolDescription + '</p>');
        console.log(elementInfo.referenceUrl);
        if(elementInfo.referenceUrl){
        $('#elementWebsite').replaceWith('<a id="elementWebsite" href="' + elementInfo.referenceUrl + '">Sitio web</a>').removeClass('hidden');
        } else {
        $('#elementWebsite').replaceWith('<a id="elementWebsite" href="' + '#' + '">Sitio web</a>').addClass('hidden');
        }
        if(elementInfo.freeVersionOption){
            $('#elementFree').replaceWith('<p id="elementFree">' + 'Version Option: ' +elementInfo.freeVersionOptionVersionOption + '</p>')
        } else if (elementInfo.paidVersionOption){
            $('#elementVersion').replaceWith('<p id="elementVersion">' + 'Version Option: ' + elementInfo.paidVersionOption + '</p>')
        }
        $('.card').removeClass('hidden'); // Muestra el div .card
    });
});

svg.selectAll("text")
    .data(pie(data_V1))
    .enter()
    .append("text")
    .attr("transform", function(d) {
        var pos = labelArc.centroid(d);
        // Ajusta la posición del texto para que no se salga del área de la pieChart
        var angle = Math.atan2(pos[1], pos[0]);
        var x = pos[0] + Math.cos(angle) * 10; // Ajusta la posición horizontal
        var y = pos[1] + Math.sin(angle) * 10; // Ajusta la posición vertical
        return "translate(" + x + "," + y + ")";
    })
    .attr("dy", ".35em")
    .text(function(d) {
        return d.data.Program;
    })
    .style("text-anchor", "middle")
    .style("fill", "white")
    .style("visibility", function(d) {
        // Oculta el texto si el ángulo del arco es muy pequeño (para evitar superposiciones)
        return (d.endAngle - d.startAngle) * (180 / Math.PI) > 10 ? "visible" : "hidden";
    });
