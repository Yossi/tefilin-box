data = {
    'rashi_rosh': {
        "nusach": "rashi",
        "location": "head",
        "name": ["יוסף יצחק", "בן", "זלמן שמואל"],
        "top": [44.6, 41.7, 43.9], # include thickness of shins
        "base": [56.9, 77.0, 20.2],
        "offset": [6.4, 7.0],
        "strap_width": 15.3,
    },
    'rashi_yad': {
        "nusach": "rashi",
        "location": "arm",
        "hand": "left",
        "name": ["יוסף יצחק", "בן", "זלמן שמואל"],
        "top": [44.8, 44.6, 45.9], # size of outside of inner box
        "base": [55.7, 78.1, 16.3],
        "offset": [5.42, 5.69], # measure with inner box in place
        "strap_width": 15,
        "cutout": [8, 12.5], # x and y coords for how deep to cut the knot hole (x) and how far to the hinge from the midway point of top.y (y)
    },
    'rashi_inner': {
        'standalone': False, # set True if only making an inner box
        'location': 'inner',
        "hand": "left",
        "top": [40.7, 40.8, 43.2],
        "casecut": [19.5, 18], # y and z coords for the smallest dimentions of the outer case cut. top front point of the knot lip on the inner box. default is top.y/2, top.z/2
    },

    'rt_inner': {
        'standalone': False,
        'location': 'inner',
        "hand": "left",
        "top": [41.1, 41.2, 44.7],
        "casecut": [19.5, 18],
    },
}

from subprocess import run
from functools import partial
from multiprocessing.dummy import Pool
from pprint import pprint, pformat
from textwrap import dedent

openscad = '/home/yossi/3d\ printer/tools/OpenSCAD-2019.05-x86_64.AppImage' # change this to whatever the command is on your machine
commands = {}
make_stl = False
make_stl = True

actives = [
    'rashi_inner.stl',
    'rashi_inner_template.stl',

    'rashi_rosh_bottom.stl',
    'rashi_rosh_top.stl',
    'rashi_rosh_template.stl',

    'rashi_yad_bottom.stl',
    'rashi_yad_top.stl',

    'rt_inner.stl',
    'rt_inner_template.stl',
]

for title, part in data.items():
    location = part['location']
    if location == 'head':
        top = part['top']
        base = part['base']
        offset = part['offset']
        for half in ('top', 'bottom'):
            name = str(part["name"]).replace("'", '"')
            strap_width = part['strap_width']
            nusach = part['nusach']

            input_file = 'tefilin_box_3.scad'
            output_file = f'{title}_{half}.stl'
            output = ''
            if make_stl:
                output = f"-D '$fs=0.4' -o output/{output_file}"
            commands[output_file] = [f'''\
            {openscad}
            -D 'your_name={name}'
            -D 'half=\"{half}\"'
            -D 'location=\"{location}\"'
            -D 'nusach=\"{nusach}\"'
            -D 'strap_width={strap_width}'
            -D 'top={top}'
            -D 'base_raw={base}'
            -D 'offset_raw={offset}'
            {input_file}
            {output}'''.replace('\n', '')]

        #template
        input_file = 'padding_template.scad'
        output_file = f'{title}_template.stl'
        output = ''
        if make_stl:
            output = f"-o output/{output_file}"
        commands[output_file] = [f'''{openscad}
        -D '$fs=0.4'
        -D 'top={top}'
        -D 'base_raw={base}'
        -D 'offset_raw={offset}'
        {input_file}
        {output}'''.replace('\n', '')]

    if location == 'arm':
        top = part['top']
        base = part['base']
        offset = part['offset']
        for half in ('top', 'bottom'):
            name = str(part["name"]).replace("'", '"')
            strap_width = part['strap_width']
            nusach = part['nusach']
            hand = part['hand']
            cutout = part['cutout']

            input_file = 'tefilin_box_3.scad'
            output_file = f'{title}_{half}.stl'
            output = ''
            if make_stl:
                output = f"-D '$fs=0.4' -o output/{output_file}"
            commands[output_file] = [f'''{openscad}
            -D 'your_name={name}'
            -D 'half=\"{half}\"'
            -D 'location=\"{location}\"'
            -D 'nusach=\"{nusach}\"'
            -D 'hand=\"{hand}\"'
            -D 'strap_width={strap_width}'
            -D 'top={top}'
            -D 'base_raw={base}'
            -D 'offset_raw={offset}'
            -D 'cutout={cutout}'
            {input_file}
            {output}'''.replace('\n', '')]

    if location == 'inner':
        top = part['top']
        case_cut_y, case_cut_z = part['casecut']
        case_cut = f"-D 'case_cut_y={case_cut_y}' -D 'case_cut_x={case_cut_z}'" if part['standalone'] else ''
        hand = part['hand']

        input_file = 'inside_yad_case.scad'
        output_file = f'{title}.stl'
        output = ''
        if make_stl:
            output = f"-o output/{output_file}"
        commands[output_file] = [f'''{openscad}
        -D '$fs=0.4'
        -D 'top={top}'
        -D 'hand=\"{hand}\"'
        {case_cut}
        {input_file}
        {output}'''.replace('\n', '')]


        output_file = f'{title}_template.stl'
        output = ''
        if make_stl:
            output = f"-o output/{output_file}"
        commands[output_file] = [f'''{openscad}
        -D '$fs=0.4'
        -D 'top={top}'
        -D 'hand=\"{hand}\"'
        -D 'template=true'
        {input_file}
        {output}'''.replace('\n', '')]


keys = list(commands.keys())
for command in keys:
    if command not in actives:
        del commands[command]

inv_commands = {}
for k, v in commands.items():
    inv_commands[v[0]] = k
    print(f'{k}:')
    print(v[0])

pool = Pool(3) # number of concurrent commands
for i, completedproc in enumerate(pool.imap(partial(run, shell=True), commands.values())):
    if completedproc.returncode != 0:
       print(f"{inv_commands[completedproc.args[0]]} command failed:\n {completedproc}")