
import * as fs from 'fs';

//const OBJ = 'prototypes/Edge Case 0.5 Front.obj';
const OBJ = 'prototypes/Edge Case 0.5 House.obj';
const SVG = 'prototypes/Edge Case 0.5 Front.svg';

const OUT_FILE_OBJ = "output/transformed.obj";
const OUT_FILE_SVG = "output/transformed.svg";

// Firebeetle
var A = 62,
    B = 16, 
    C = 21,  
    D = 30;

    /*
// nano
A = 60,
B = 8, 
C = 21,  
D = 30;  
*/

//Transforming for a 60mm board and 42mm/77 batteryholder
const transformations = [
    {
        dimension: 0,
        insertion: 30,
        add: B-24
    },
    {
        dimension: 0,
        insertion: 5 + 10 + B + 6 + 9,
        add: C-24
    },
    {
        dimension: 1,
        insertion: 40,
        add: A-50
    },

    {
        dimension: 2,
        insertion: 16.5,
        add: D-14
    },

]


var obj = fs.readFileSync(OBJ, 'utf-8');
var svg = fs.readFileSync(SVG, 'utf-8');


transformations.forEach((transformation)=> {
    obj = transform_obj(obj, transformation);
})

transformations.forEach((transformation)=> {
    svg = transform_svg(svg, transformation);
})


function transform_svg(svg: string, transformation: any)
{
    var OUT = "";
    const mins = get_mins_svg(svg);


    const lines = svg.split("\n");
    lines.forEach((line) => {
        if (line.startsWith("<path d="))
        {
            var path = line.substring(9)
            const remainder = path.substring(path.indexOf("\""))

            path = path.substring(0, path.indexOf("\""))

            var tokens = path.split(" ")
            tokens = tokens.map((token, index) => {
                if(index %3 == 1 && transformation.dimension == 0 && parseFloat(token) - mins[0] > transformation.insertion)
                {
                    return parseFloat(token) + transformation.add
                }
                else if(index %3 == 2 && transformation.dimension == 1 && parseFloat(token) - mins[1] > transformation.insertion)
                {
                    return parseFloat(token) + transformation.add;
                }
                else {
                    return token;
                }

            })
            line = "<path d=\"" + tokens.join(" ")+remainder;

            console.log(line);
            console.log()

        }

        OUT += line +"\n";
    })
    return OUT;
}

function transform_obj(obj: string, transformation: any)
{
    var OUT = ""
    const lines = obj.split("\n")
    const mins = get_mins_obj(obj);

    lines.forEach((line) => {
        if (line.startsWith("v"))
        {
            const cols = line.split(" ");
            const values = [0.0,0.0,0.0]
            values[0] = parseFloat(cols[1].trim())
            values[1] = parseFloat(cols[2].trim())
            values[2] = parseFloat(cols[3].trim())

            console.log(values)

            if(values[transformation.dimension] - mins[transformation.dimension] > transformation.insertion)
            {
                values[transformation.dimension] += transformation.add;
                line = `v ${values[0]}\t ${values[1]}\t ${values[2]}`;
            }
        }
        OUT +=line +"\n"
    })
    return OUT;
}

function get_mins_svg(svg: string)
{
    const mins = [1000000,1000000];

    const lines = svg.split("\n");
    lines.forEach((line) => {
        if (line.startsWith("<path d="))
        {
            var path = line.substring(9)
            const remainder = path.substring(path.indexOf("\""))

            path = path.substring(0, path.indexOf("\""))

            var tokens = path.split(" ")
            tokens.map((token, index) => {
                if(index %3 == 1)
                {
                    var f = parseFloat(token);
                    if(f < mins[0]) mins[0] = f;
                }
                else if(index %3 == 2)
                {
                    var f = parseFloat(token);
                    if(f < mins[1]) mins[1] = f;
                }
    
            })            
        }
    })
    console.log(mins)
    return mins;

}


function get_mins_obj(obj: string)
{
    const lines = obj.split("\n")
    const mins = [1000000,1000000,1000000];

    lines.forEach((line) => {
        if (line.startsWith("v"))
        {
            const cols = line.split(" ");
            const values = [0.0,0.0,0.0]
            values[0] = parseFloat(cols[1].trim())
            values[1] = parseFloat(cols[2].trim())
            values[2] = parseFloat(cols[3].trim())

            console.log(values)

            if(values[0] < mins[0])
                mins[0] = values[0]
            if(values[1] < mins[1])
                mins[1] = values[1]
            if(values[2] < mins[2])
                mins[2] = values[2]
        }
    })
    return mins;
}



fs.writeFileSync(OUT_FILE_OBJ, obj);
fs.writeFileSync(OUT_FILE_SVG, svg);
