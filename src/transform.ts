
import * as fs from 'fs';


const OBJ = 'prototypes/Edge Case 0.4 House.obj';
const OUT_FILE = "output/transformed.obj";

const A=25.4, 
    B = 31, 
    C=60, 
    D=30;



//Transforming for a 60mm board and 42mm/77 batteryholder
const transformations = [
    {
        dimension:0,
        insertion: 30,
        add: A-34
    },
    {
        dimension:0,
        insertion: 5 + A + 6 + 9,
        add:B-34
    },
    {
        dimension:1,
        insertion: 40,
        add:C-50
    },

    {
        dimension:2,
        insertion: 10,
        add:D-14
    },

]


var obj = fs.readFileSync(OBJ, 'utf-8');


transformations.forEach((transformation)=> {
    obj = transform_obj(obj, transformation);
})


function transform_obj(obj: string, transformation: any)
{
    var OUT = ""
    const lines = obj.split("\n")
    const mins = get_mins(obj);

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


function get_mins(obj: string)
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



fs.writeFileSync(OUT_FILE, obj);
