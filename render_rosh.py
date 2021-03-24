from subprocess import run
from functools import partial
from multiprocessing.dummy import Pool
from pprint import pprint

openscad = '/home/yossi/3d\ printer/tools/OpenSCAD-2019.05-x86_64.AppImage'
commands = []

for f in ['tefilin_box_3.scad']:
    for half in ['top', 'bottom']:
        of = f.replace('.scad', f'_{half}.stl')

        commands.append([f'''{openscad} -o stl/{of} -D '$fs=0.4' -D 'half=\"{half}\"' {f}'''])


f = 'padding_template.scad'
of = f.replace('.scad', '.stl')
commands.append([f'{openscad} -o stl/{of} {f}'])

print(commands)

pool = Pool(2) # two concurrent commands at a time
for i, completedproc in enumerate(pool.imap(partial(run, shell=True), commands)):
    if completedproc.returncode != 0:
       print("%s command failed: %s" % (i, completedproc))