
import * as fs from 'fs';


const OBJ = 'prototypes/Edge Case 0.2.obj';
const OUT_FILE = "output/transformed.obj";

const board_width=60, 
    bay_width = 42, 
    height=77, 
    depth=30;

const start = -90

//Transforming for a 60mm board and 42mm/77 batteryholder
const transformations = [
    {
        dimension:0,
        insertion: 30 + start,
        add: board_width-34
    },
    {
        dimension:0,
        insertion: 5 + board_width + 6 + 5 + start,
        add:bay_width-34
    },
    {
        dimension:1,
        insertion: 40,
        add:height-50
    },

    {
        dimension:2,
        insertion: 10,
        add:depth-14
    },

]


var obj = fs.readFileSync(OBJ, 'utf-8');




transformations.forEach((transformation)=> {
    obj = transform(obj, transformation);
})


function transform(obj: string, transformation: any)
{
    var OUT = ""
    const lines = obj.split("\n")

    lines.forEach((line) => {
        if (line.startsWith("v"))
        {
            const cols = line.split(" ");
            const values = [0.0,0.0,0.0]
            values[0] = parseFloat(cols[1].trim())
            values[1] = parseFloat(cols[2].trim())
            values[2] = parseFloat(cols[3].trim())

            console.log(values)

            if(values[transformation.dimension] > transformation.insertion)
            {
                values[transformation.dimension] += transformation.add;
                line = `v ${values[0]}\t ${values[1]}\t ${values[2]}`;
            }
        }
        OUT +=line +"\n"
    })
    return OUT;
}

fs.writeFileSync(OUT_FILE, obj);
